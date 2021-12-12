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

protocol NetworkManagerProtocol: ManagerProtocol {
    func fetchInstagramUsers(searchingTitle: String,
                             secret: Secret,
                             completion: @escaping (Result<[InstagramUser], Error>)->())
    func fetchStoriesURLs(userID: String, secret: Secret, completion: @escaping (Result<[String],Error>)->())
    func fetchStoryData(urlString: String, completion: @escaping (Result<Data, Error>)->())
    func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>)->())
    func stopLastOperation()
}

final class NetworkManager {
    //MARK: - Private properties
    private let imageCacheManager: ImageCacheManagerProtocol
    private var bin: Set<AnyCancellable> = []
    
    //MARK: - Init
    init(imageCacheManager: ImageCacheManagerProtocol) {
        self.imageCacheManager = imageCacheManager
    }
}


//MARK: - extension + NetworkManagerProtocol
extension NetworkManager: NetworkManagerProtocol {
    
    //MARK: - Public methods
    func fetchInstagramUsers(searchingTitle: String,
                             secret: Secret,
                             completion: @escaping (Result<[InstagramUser], Error>)->()){
        bin.removeAll()
        Endpoint
            .users(matching: searchingTitle)
            .unlock(with: secret)
            .session(URLSession.instagram)
            .pages(.max)
            .sink {  response in
                print("fetching instagramUsers response", response)
            } receiveValue: { users in
                let queue = DispatchQueue(label: "queue", qos: .userInteractive, attributes: .concurrent)
                queue.async {
                    guard let usersArray = users.users else { return }
                    var instagramUsers = [InstagramUser]()
                    
                    let group = DispatchGroup()
                    
                    for user in usersArray {
                        group.enter()
                        let instagramUser = InstagramUser(name: user["fullName"].string() ?? "",
                                                          instagramUsername: user["username"].string() ?? "",
                                                          id: user["pk"].int() ?? 0,
                                                          userIconURL: user["profilePicUrl"].string() ?? "",
                                                          // TODO: Change this
                                                          posts: 100, // find info
                                                          subscribers: 100, // find info
                                                          subscriptions: 100, // find info
                                                          isPrivate: user["isPrivate"].bool() ?? false,
                                                          stories: nil)
                        instagramUsers.append(instagramUser)
                        group.leave()
                    }
                    group.notify(queue: DispatchQueue.main) {
                        completion(.success(instagramUsers))
                    }
                }
            }.store(in: &bin)
    }
    
    func fetchStoriesURLs(userID: String, secret: Secret, completion: @escaping (Result<[String],Error>)->()) {
        Endpoint.user(userID)
            .stories.unlock(with: secret)
            .session(URLSession.instagram)
            .sink { response in
            } receiveValue: { stories in
                guard let items = stories["reel"]["items"].array() else { return }
                
                var URLsStrings = [String]()
                
                for item in items {
                    if let videoVersions = item["videoVersions"].array() {
                        if let firstVideoVersion = videoVersions.first {
                            let url = firstVideoVersion["url"].description
                            URLsStrings.append(url)
                        }
                    } else {
                        let candidates = item["imageVersions2"]["candidates"].array()
                        guard let firstCandidate = candidates?.first else { return }
                        let url = firstCandidate["url"].description
                        URLsStrings.append(url)
                    }
                }
                DispatchQueue.main.async {
                    completion(.success(URLsStrings))
                }
            }.store(in: &bin)
    }
    
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
            
            guard let data = data  else {
                return }
            
            self?.imageCacheManager.saveImageToCache(imageData: data, response: response)
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }.resume()
    }
    
    func stopLastOperation() {
        bin.removeAll()
    }
}

