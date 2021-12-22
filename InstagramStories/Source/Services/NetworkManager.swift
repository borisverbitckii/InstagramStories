//
//  NetworkManager.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import Foundation
import SwiftagramCrypto
import UIKit.UIImage
import RealmSwift

protocol NetworkManagerProtocol: ManagerProtocol {}

final class NetworkManager {
    
    //MARK: - Private properties
    private var bin: Set<AnyCancellable> = []
    private let queueForUsers: OperationQueue = {
        $0.maxConcurrentOperationCount = 1
        return $0
    }(OperationQueue())
    private let imageCacheManager: ImageCacheManagerProtocol
    
    //MARK: - Init
    init(imageCacheManager: ImageCacheManagerProtocol) {
        self.imageCacheManager = imageCacheManager
    }
    
    //MARK: - Public methods
    func stopLastOperation() {
        bin.removeAll()
    }
    
    //MARK: - Private methods
    private func fetchUserProfile(id: Int,
                                  secret: Secret,
                                  completion: @escaping (InstagramUser) -> ()) {
        Endpoint
            .user(String(id))
            .unlock(with: secret)
            .session(URLSession.instagram)
            .sink { error in
                switch error {
                case .finished: break
                case .failure(_):
                    print(#file, #line, Errors.cantFetchUserProfile.error)
                }
            } receiveValue: { userInfo in
                let user = userInfo["user"]

                let instagramUser = InstagramUser(name: userInfo.user?.name ?? "",
                                                  profileDescription: userInfo.user?.biography ?? "",
                                                  instagramUsername: userInfo.user?.username ?? "",
                                                  id: id,
                                                  userIconURL: userInfo.user?.thumbnail?.absoluteString ?? "",
                                                  posts: userInfo.user?.counter?.posts ?? 0,
                                                  subscribers: userInfo.user?.counter?.followers ?? 0,
                                                  subscriptions: userInfo.user?.counter?.following ?? 0,
                                                  isPrivate: user["isPrivate"].bool() ?? false)
                completion(instagramUser)
            }.store(in: &bin)
    }
    
    private func timeFormatHandle(date: Int?) -> Int {
        let dateFormat = 1000000000000000
        var correctDate = 0
        if let date = date {
            correctDate = date
            if date < dateFormat {
                while correctDate / dateFormat < 1 {
                    correctDate = correctDate * 10
                }
            } else {
                while correctDate / dateFormat > 2 {
                    correctDate = correctDate / 10
                }
            }
        }
        return correctDate
    }
}

//MARK: - extension + NetworkManagerProtocol
extension NetworkManager: NetworkManagerProtocol {}

//MARK: - extension + UserImageDataSourceProtocol
extension NetworkManager: UserImageDataSourceProtocol {
    func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>)->()) {
        
        if let imageData = imageCacheManager.getCacheImage(stringURL: urlString) {
            completion(.success(imageData))
            return
        }
        
        guard let url = URL(string: urlString) else {
            print(#file, #line, Errors.urlNotValid.error)
            completion(.failure(Errors.urlNotValid.error))
            return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print(#file, #line, error)
                completion(.failure(error))
                return
            }
            
            guard let response = response,
                  let responseURL = response.url,
                  url.absoluteString == responseURL.absoluteString else {
                      print(#file, #line, Errors.urlNotValid.error)
                      completion(.failure(Errors.urlNotValid.error))
                      return }
            
            guard let data = data  else { return }
            
            self?.imageCacheManager.saveImageToCache(imageData: data, response: response)
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }.resume()
    }
}


//MARK: - extension + StoriesDataSourceProtocol
extension NetworkManager: StoriesDataSourceProtocol {
    
    func fetchStories(userID: String, secret: Secret, completion: @escaping (Result<[Story],Error>)->()) {
        Endpoint.user(userID)
            .stories.unlock(with: secret)
            .session(URLSession.instagram)
            .sink { response in
                
                switch response {
                case .finished:
                    break
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } receiveValue: { [weak self] stories in
                var storiesArray = [Story]()
                
                guard let items = stories["reel"]["items"].array() else {
                    DispatchQueue.main.async {
                        completion(.success(storiesArray))
                    }
                    return }
                
                for item in items {
                    
                    var type: StoryType!
                    var previewURLString = ""
                    var contentURLString = ""
                    
                    if let videoVersions = item["videoVersions"].array() {
                        if let firstVideoVersion = videoVersions.first {
                            let url = firstVideoVersion["url"].description
                            if let imageVersions = item["imageVersions2"]["candidates"].array() {
                                guard let firstImageVersion = imageVersions.first else { return }
                                let url = firstImageVersion["url"].description
                                previewURLString = url
                            }
                            contentURLString = url
                            type = .video
                        }
                    } else {
                        let candidates = item["imageVersions2"]["candidates"].array()
                        guard let firstCandidate = candidates?.first else { return }
                        let url = firstCandidate["url"].description
                        previewURLString = url
                        contentURLString = url
                        type = .photo
                    }
                    let date = item["deviceTimestamp"].int()
                    let correctDate = self?.timeFormatHandle(date: date)
                    
                    let story = Story(time: correctDate ?? 0, type: type, previewImageURL: previewURLString, contentURL: contentURLString)
                    storiesArray.append(story)
                }
                DispatchQueue.main.async {
                    storiesArray = storiesArray.sorted(by: { $0.time > $1.time})
                    completion(.success(storiesArray))
                }
            }.store(in: &bin)
    }
}

//MARK: - extension + SearchDataSourceProtocol
extension NetworkManager: SearchDataSourceProtocol {
    func fetchInstagramUsers(searchingTitle: String,
                             secret: Secret,
                             completion: @escaping (Result<[InstagramUser], Error>)->()){
        queueForUsers.cancelAllOperations()
        
        let blockOperation = BlockOperation { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.bin.removeAll()
            Endpoint
                .users(matching: searchingTitle)
                .unlock(with: secret)
                .session(URLSession.instagram)
                .pages(.max, delay: .milliseconds(5))
                .sink {  response in
                    switch response {
                    case .finished: break
                    case .failure(let error):
                        print(error)
                        print(#file, #line, Errors.cantFetchUsers.error)
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                } receiveValue: { users in
                    DispatchQueue.global().async {
                        guard let usersArray = users.users else { return }
                        var instagramUsers = [InstagramUser]()
                        let dispatchGroup = DispatchGroup()
                        for user in usersArray {
                            dispatchGroup.enter()
                            self?.fetchUserProfile(id: user["pk"].int() ?? 0, secret: secret, completion: { user in
                                instagramUsers.append(user)
                                dispatchGroup.leave()
                            })
                        }
                        
                        dispatchGroup.notify(queue: .main) {
                            instagramUsers = instagramUsers.sorted { $0.subscribers > $1.subscribers}
                            completion(.success(instagramUsers))
                        }
                    }
                }.store(in: &strongSelf.bin)
        }
        
        let timer = Timer.init(timeInterval: 0.3, repeats: false) { [weak self] timer in
            // divide requests to prevent account block
            self?.queueForUsers.addOperation(blockOperation)
            timer.invalidate()
        }
        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: .common)
    }
}

extension NetworkManager: StoryDataSourceProtocol {
    
    func fetchStoryData(urlString: String, completion: @escaping (Result<Data, Error>)->()) {
        if let data = imageCacheManager.getCacheImage(stringURL: urlString) {
            completion(.success(data))
            return
        } else {
            return
        }
        print(#file, #line, Errors.cantDownloadStory.error)
        completion(.failure(Errors.cantDownloadStory.error))
    }
}

