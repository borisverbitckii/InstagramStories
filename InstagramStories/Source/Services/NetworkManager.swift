//
//  NetworkManager.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import Foundation
import SwiftagramCrypto
import UIKit.UIImage

protocol NetworkManagerProtocol: ManagerProtocol {}

final class NetworkManager {
    
    //MARK: - Private properties
    private var bin: Set<AnyCancellable> = []
    private let imageCacheManager: ImageCacheManagerProtocol
    private var dataTaskForStory: URLSessionDataTask?
    private let fileManager = FileManager.default
    private lazy var mainDirectoryUrl: URL = {
        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsUrl
    }()
    
    
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
            }.store(in: &self.bin)
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
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            if let imageData = self.imageCacheManager.getCacheImage(stringURL: urlString) {
                DispatchQueue.main.async {
                    completion(.success(imageData))
                }
                return
            }
            
            guard let url = URL(string: urlString) else {
                print(#file, #line, Errors.urlNotValid.error)
                DispatchQueue.main.async {
                    completion(.failure(Errors.urlNotValid.error))
                }
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
                          DispatchQueue.main.async {
                              completion(.failure(Errors.urlNotValid.error))
                          }
                          return }
                
                guard let data = data  else { return }
                
                self?.imageCacheManager.saveImageToCache(imageData: data, response: response)
                
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            }.resume()
        }
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
        bin.removeAll()
        
        Endpoint
            .users(matching: searchingTitle)
            .unlock(with: secret)
            .session(URLSession.instagram)
            .pages(.max, delay: 0.5)
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
                DispatchQueue.global().async { [weak self] in
                    guard let usersArray = users.users else { return }
                    var instagramUsers = [InstagramUser]()
                    let dispatchGroup = DispatchGroup()
                    let dispatchSemaphore = DispatchSemaphore(value: 3)
                    for user in usersArray {
                        dispatchGroup.enter()
                        dispatchSemaphore.wait()
                        self?.fetchUserProfile(id: user["pk"].int() ?? 0, secret: secret, completion: { user in
                            instagramUsers.append(user)
                            dispatchGroup.leave()
                            dispatchSemaphore.signal()
                        })
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        instagramUsers = instagramUsers.sorted { $0.subscribers > $1.subscribers}
                        completion(.success(instagramUsers))
                    }
                }
            }.store(in: &bin)
    }
}

extension NetworkManager: StoriesVideoSourceProtocol {
    func downloadCurrentStoryVideo(urlString: String, completion: @escaping (URL) -> ()) {
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let video = self.directoryFor(stringUrl: urlString)
            
            guard !self.fileManager.fileExists(atPath: video.path) else {
                DispatchQueue.main.async {
                    completion(video)
                }
                return
            }
            
            if self.dataTaskForStory != nil { // check was previous story downloading started
                self.dataTaskForStory?.cancel()
            }
            
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                self.dataTaskForStory = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard error == nil else { return }
                    do {
                        try data?.write(to: video, options: .atomic)
                        DispatchQueue.main.async {
                            completion(video)
                        }
                    } catch {
                        print(error) // fix to NSError
                    }
                }
                self.dataTaskForStory?.resume()
            } else {
                return
            }
        }
        
    }
    
    private func directoryFor(stringUrl: String) -> URL {
        guard let url = URL(string: stringUrl) else { return URL(fileReferenceLiteralResourceName: "")}
        let fileURL = url.lastPathComponent
        let file = self.mainDirectoryUrl.appendingPathComponent(fileURL)
        return file
    }
}

