//
//  ServicesFacade.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import Foundation

enum FetchType {
    case recentUsers
    case search(String)
    case favorites
}

protocol DataServicesFacadeProtocol {
    func fetchData(type: FetchType, completion: @escaping (Result <[InstagramUser], Error>)->())
}

final class DataServicesFacade {
    
    //MARK: - Private properties
    private let reachabilityManager: ReachabilityManagerProtocol
    private let networkManager: NetworkManagerProtocol
    private let dataBaseManager: DataBaseManagerProtocol
    
    //MARK: - Init
    init(reachabilityManager: ReachabilityManagerProtocol,
         networkManager: NetworkManagerProtocol,
         dataBaseManager: DataBaseManagerProtocol){
        self.networkManager = networkManager
        self.reachabilityManager = reachabilityManager
        self.dataBaseManager = dataBaseManager
    }
}

//MARK: - DataServicesFacadeProtocol

extension DataServicesFacade: DataServicesFacadeProtocol {
    func fetchData(type: FetchType, completion: @escaping (Result <[InstagramUser], Error>)->()) {
        
        switch type {
        case .recentUsers:
            dataBaseManager.fetchInstagramUsers { result in
                switch result{
                case .success(let users):
                    completion(.success(users))
                case .failure(let error):
                    print(#file, #line, error)
                    completion(.failure(error))
                }
            }
        case .search(let username):
            guard reachabilityManager.isNetworkAvailable else {
                completion(.failure(NSError(domain: "Network is not available", code: 0)))
                return
            }
            
            networkManager.fetchInstagramUsers(username: username) { [weak self] (result: Result<[InstagramUser],Error>) in
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
        case .favorites:
            break
        }
    }
}
