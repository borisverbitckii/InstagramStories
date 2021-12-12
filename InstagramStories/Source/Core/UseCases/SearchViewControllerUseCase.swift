//
//  SearchViewControllerUseCase.swift
//  InstagramStories
//
//  Created by Борис on 08.12.2021.
//

import UIKit.UIImage
import Swiftagram

protocol SearchUseCaseProtocol {
    func fetchRecentUsersFromBD(completion: @escaping (Result <[InstagramUser], Error>)->())
    func fetchInstagramUsersFromNetwork(searchingTitle: String,
                                        secret: Secret,
                                        completion: @escaping (Result <[InstagramUser], Error>)->())
    func saveUserToRecents(user: InstagramUser)
    func fetchImage(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> ())
    func stopLastOperation() 
}

final class SearchViewControllerUseCase: UseCase, SearchUseCaseProtocol {
    
    //MARK: - Private properties
    private let dataBaseManager: DataBaseManagerProtocol
    private let networkManager: NetworkManagerProtocol
    private let reachabilityManager: ReachabilityManagerProtocol
    
    //MARK: - Init
    init(dataBaseManager: DataBaseManagerProtocol,
         networkManager: NetworkManagerProtocol,
         reachabilityManager: ReachabilityManagerProtocol) {
        self.dataBaseManager = dataBaseManager
        self.networkManager = networkManager
        self.reachabilityManager = reachabilityManager
    }
    
    //MARK: - Public methods
    func fetchRecentUsersFromBD(completion: @escaping (Result <[InstagramUser], Error>)->()) {
        dataBaseManager.fetchInstagramUsers { result in
            switch result{
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                print(#file, #line, error)
                completion(.failure(error))
            }
        }
    }
    
    func saveUserToRecents(user: InstagramUser) {
        let _ = RealmInstagramUser(instagramUser: user)
        
    }
    
    func fetchInstagramUsersFromNetwork(searchingTitle: String,
                                        secret: Secret,
                                        completion: @escaping (Result <[InstagramUser], Error>)->()) {
        reachabilityManager.checkIsNetworkIsAvailable(completion: { [weak self] in
            self?.networkManager.fetchInstagramUsers(searchingTitle: searchingTitle,
                                                     secret: secret,
                                                     completion: { result in
                switch result {
                case .success(let instagramUsers):
                    completion(.success(instagramUsers))
                case .failure(let error):
                    print(#file, #line, error)
                    completion(.failure(error))
                }
            })
        })
    }
    
    func fetchUserStories(userID: String, secret: Secret, completion: @escaping (Result<[Story], Error>)->()) {
        reachabilityManager.checkIsNetworkIsAvailable { [weak self] in
            self?.networkManager.fetchStoriesURLs(userID: userID, secret: secret) { result in
                switch result {
                case .success(let urlStrings):
                    var stories = [Story]()
                    for urlString in urlStrings {
                        self?.networkManager.fetchStoryData(urlString: urlString) { result in
                            switch result {
                            case .success(let data):
                                //TODO: FIX data
                                let story = Story(time: 100, content: data) // find time
                                stories.append(story)
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                case .failure(let error):
                    print(#file, #line, error)
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchImage(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        reachabilityManager.checkIsNetworkIsAvailable { [weak self] in
            self?.networkManager.fetchImageData(urlString: stringURL, completion: { result in
                switch result {
                case .success(let imageData):
                    guard let image = UIImage(data: imageData) else { return }
                    completion(.success(image))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
    }
    
    func stopLastOperation() {
        networkManager.stopLastOperation()
    }
}
