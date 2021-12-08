//
//  ServicesFacade.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import Foundation.NSError

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
    private let managerFactory: ManagerFactoryProtocol
    
    //MARK: - Init
    init(managerFactory: ManagerFactoryProtocol){
        self.managerFactory = managerFactory
    }
}

//MARK: - DataServicesFacadeProtocol

extension DataServicesFacade: DataServicesFacadeProtocol {
    func fetchData(type: FetchType, completion: @escaping (Result <[InstagramUser], Error>)->()) {
        
        switch type {
        case .recentUsers:
            managerFactory.getDataBaseManager().fetchInstagramUsers { result in
                switch result{
                case .success(let users):
                    completion(.success(users))
                case .failure(let error):
                    print(#file, #line, error)
                    completion(.failure(error))
                }
            }
        case .search(let username):
            guard managerFactory.getReachabilityManager().isNetworkAvailable else {
                completion(.failure(NSError(domain: "Network is not available", code: 0)))
                return
            }
            
            managerFactory.getNetworkManager().fetchInstagramUsers(username: username) { [weak self] (result: Result<[InstagramUser],Error>) in
                    switch result {
                    case .success(let users):
                        DispatchQueue.main.async {
                            completion(.success(users))
                        }
                        self?.managerFactory.getDataBaseManager().saveDataToDB(users)
                    case .failure(let error):
                        print(#file, #line, error)
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
        case .favorites:
            
            //TODO: Fix this
            managerFactory.getDataBaseManager().fetchInstagramUsers { result in
                switch result{
                case .success(let users):
                    completion(.success(users))
                case .failure(let error):
                    print(#file, #line, error)
                    completion(.failure(error))
                }
            }
        }
    }
}
