//
//  NetworkManager.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import Foundation
import SwiftagramCrypto
import UIKit.UIImage

protocol NetworkManagerProtocol {
    func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
    func stopLastOperation()
    func fetchInstagramUsers(searchingTitle: String,
                             secret: Secret,
                             completion: @escaping (Result <[InstagramUser], Error>) -> Void)
    func fetchUserProfile(id: Int,
                          secret: Secret,
                          completion: @escaping (Result<AdditionalUserDetails, Error>) -> Void)
    func fetchStories(userID: String, secret: Secret, completion: @escaping (Result<[Story], Error>) -> Void)
    func downloadCurrentStoryVideo(urlString: String, completion: @escaping (URL) -> Void)
}

final class NetworkManager {

    // MARK: - Private properties
    private var bin: Set<AnyCancellable> = []
    private let imageCacheManager: ImageCacheManagerProtocol
    private let videoCacheManager: VideoCacheManagerProtocol
    private var dataTaskForStory: URLSessionDataTask?

    // MARK: - Init
    init(imageCacheManager: ImageCacheManagerProtocol,
         videoCacheManager: VideoCacheManagerProtocol) {
        self.imageCacheManager = imageCacheManager
        self.videoCacheManager = videoCacheManager
    }

    // MARK: - Public methods
    func stopLastOperation() {
        bin.removeAll()
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

// MARK: - extension + NetworkManagerProtocol
extension NetworkManager: NetworkManagerProtocol {

    func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {

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
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
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

    func fetchUserProfile(id: Int,
                          secret: Secret,
                          completion: @escaping (Result<AdditionalUserDetails, Error>) -> Void) {

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
                let profileDescription = userInfo.user?.biography ?? ""
                let posts = userInfo.user?.counter?.posts ?? 0
                let subscribers = userInfo.user?.counter?.followers ?? 0
                let subscriptions = userInfo.user?.counter?.following ?? 0

                let additionalUserDetails = AdditionalUserDetails(description: profileDescription,
                                                                  subscription: subscriptions,
                                                                  subscribers: subscribers,
                                                                  posts: posts)
                DispatchQueue.main.async {
                    completion(.success(additionalUserDetails))
                }
            }.store(in: &self.bin)
    }

    func fetchInstagramUsers(searchingTitle: String,
                             secret: Secret,
                             completion: @escaping (Result <[InstagramUser], Error>) -> Void) {
        bin.removeAll()

        Endpoint
            .users(matching: searchingTitle)
            .unlock(with: secret)
            .session(URLSession.instagram)
            .pages(.max)
            .sink {  response in
                switch response {
                case .finished: break
                case .failure(let error):
                    print(#file, #line, Errors.cantFetchUsers.error)
                    if (error as NSError).code == -1200 {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                        break
                    }
                    DispatchQueue.main.async {
                        completion(.failure(Errors.accountBlocked.error))
                    }
                }
            } receiveValue: { users in
                DispatchQueue.global().async {
                    guard let usersArray = users.users else { return }
                    var instagramUsers = [InstagramUser]()
                    for user in usersArray {

                        let name = user.name ?? ""
                        let profileDescription = user.biography ?? ""
                        let instagramUsername = user.username ?? ""
                        let id = Int(user.identifier) ?? 0
                        let userIconURL = user.thumbnail?.absoluteString ?? ""
                        let posts = user.counter?.posts ?? 0
                        let subscribers = user.counter?.followers ?? 0
                        let subscriptions = user.counter?.following ?? 0
                        let isPrivate = user["isPrivate"].bool() ?? false
                        let isOnFavorite = false
                        let isRecent = false

                        let instagramUser = InstagramUser(name: name,
                                                          profileDescription: profileDescription,
                                                          instagramUsername: instagramUsername,
                                                          id: id,
                                                          userIconURL: userIconURL,
                                                          posts: posts,
                                                          subscribers: subscribers,
                                                          subscription: subscriptions,
                                                          isPrivate: isPrivate,
                                                          isOnFavorite: isOnFavorite,
                                                          isRecent: isRecent)

                        instagramUsers.append(instagramUser)
                    }

                    DispatchQueue.main.async {
                        completion(.success(instagramUsers))
                    }
                }
            }.store(in: &bin)
    }

    func fetchStories(userID: String, secret: Secret, completion: @escaping (Result<[Story], Error>) -> Void) {
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
                        }
                    } else {
                        let candidates = item["imageVersions2"]["candidates"].array()
                        guard let firstCandidate = candidates?.first else { return }
                        let url = firstCandidate["url"].description
                        previewURLString = url
                        contentURLString = url
                    }
                    let date = item["deviceTimestamp"].int()
                    let correctDate = self?.timeFormatHandle(date: date)

                    let story = Story(time: correctDate ?? 0, previewImageURL: previewURLString, contentURL: contentURLString)
                    storiesArray.append(story)
                }
                DispatchQueue.main.async {
                    storiesArray = storiesArray.sorted(by: { $0.time > $1.time})
                    completion(.success(storiesArray))
                }
            }.store(in: &bin)
    }

    func downloadCurrentStoryVideo(urlString: String, completion: @escaping (URL) -> Void) {

        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let video = self.videoCacheManager.directoryFor(stringUrl: urlString)

            guard !self.videoCacheManager.fileExists(atPath: video.path) else {
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
                        print(error)
                    }
                }
                self.dataTaskForStory?.resume()
            } else {
                return
            }
        }
    }
}
