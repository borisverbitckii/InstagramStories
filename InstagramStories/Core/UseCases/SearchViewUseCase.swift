//
//  SearchViewControllerUseCase.swift
//  InstagramStories
//
//  Created by Борис on 08.12.2021.
//

import Foundation

protocol SearchUseCaseProtocol {
    func fetchRecentUsersFromBD(completion: @escaping (Result <[InstagramUser], Error>)->())
    func fetchInstagramUsersFromNetwork(searchingTitle: String,
                                        completion: @escaping (Result <[InstagramUser], Error>)->())
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
    
    func fetchInstagramUsersFromNetwork(searchingTitle: String,
                                        completion: @escaping (Result <[InstagramUser], Error>)->()) {
        guard reachabilityManager.isNetworkAvailable else {
            completion(.failure(NSError(domain: "Network is not available", code: 0)))
            return
        }
        
        networkManager.fetchInstagramUsers(searchingTitle: searchingTitle) { [weak self] (result: Result<[InstagramUser],Error>) in
            switch result {
            case .success(let users):
                DispatchQueue.main.async {
                    completion(.success(users))
                }
                self?.dataBaseManager.saveDataToDB(users)
            case .failure(let error):
                print(#file, #line, error)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
