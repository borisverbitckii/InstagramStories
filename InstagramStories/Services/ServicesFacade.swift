//
//  ServicesFacade.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

final class ServicesFacade {
    
    //MARK: - Private properties
    private let reachabilityManager: ReachabilityManagerProtocol
    private let networkManager: NetworkManagerProtocol
    private let dataBaseManager: DataBaseManagerProtocol
    
    //MARK: - Init
    init(networkManager: NetworkManagerProtocol,
         dataBaseManager: DataBaseManagerProtocol,
         reachabilityManager: ReachabilityManagerProtocol) {
        self.networkManager = networkManager
        self.dataBaseManager = dataBaseManager
        self.reachabilityManager = reachabilityManager
    }
    
    func fetchData(completion: @escaping ([InstagramUser])->()) {
        if reachabilityManager.isNetworkAvailable {
            networkManager.fetchInstagramUsers { [weak self] result in
                switch result {
                case .success(let users):
                    completion(users)
                    self?.dataBaseManager.saveDataToDB(users)
                case .failure(let error):
                    print(#file, #line, error)
                }
            }
        } else {
            dataBaseManager.fetchInstagramUsers { result in
                switch result{
                case .success(let users):
                    completion(users)
                case .failure(let error):
                    print(#file, #line, error)
                }
            }
        }
    }
}
