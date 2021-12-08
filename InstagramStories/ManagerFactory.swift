//
//  ManagerFactory.swift
//  InstagramStories
//
//  Created by Борис on 08.12.2021.
//

import Foundation

protocol ManagerProtocol {
    
}

protocol ManagerFactoryProtocol {
    func getNetworkManager() -> NetworkManagerProtocol
    func getReachabilityManager() -> ReachabilityManagerProtocol
    func getDataBaseManager() -> DataBaseManagerProtocol
}

final class ManagerFactory: ManagerFactoryProtocol {
    func getNetworkManager() -> NetworkManagerProtocol {
        return NetworkManager()
    }
    
    func getReachabilityManager() -> ReachabilityManagerProtocol {
        return ReachabilityManager()
    }
    
    func getDataBaseManager() -> DataBaseManagerProtocol {
        return DataBaseManager()
    }
}
