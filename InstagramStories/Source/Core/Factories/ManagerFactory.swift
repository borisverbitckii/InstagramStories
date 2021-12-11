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
    func getAuthManager() -> AuthManagerProtocol
    func getImageCacheManager() -> ImageCacheManagerProtocol
}

final class ManagerFactory: ManagerFactoryProtocol {
    func getNetworkManager() -> NetworkManagerProtocol {
        return NetworkManager(imageCacheManager: getImageCacheManager())
    }
    
    func getReachabilityManager() -> ReachabilityManagerProtocol {
        return ReachabilityManager()
    }
    
    func getDataBaseManager() -> DataBaseManagerProtocol {
        return DataBaseManager()
    }
    
    func getAuthManager() -> AuthManagerProtocol {
        return AuthManager()
    }
    
    func getImageCacheManager() -> ImageCacheManagerProtocol{
        return ImageCacheManager()
    }
    
}
