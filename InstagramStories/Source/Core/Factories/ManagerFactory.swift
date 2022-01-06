//
//  ManagerFactory.swift
//  InstagramStories
//
//  Created by Борис on 08.12.2021.
//

protocol ManagerProtocol {
    
}

protocol ManagerFactoryProtocol {
    func getNetworkManager() -> NetworkManagerProtocol
    func getDataBaseManager() -> DataBaseManagerProtocol
    func getAuthManager() -> AuthManagerProtocol
    func getImageCacheManager() -> ImageCacheManagerProtocol
    func getVideoCacheManager() -> VideoCacheManagerProtocol
}

final class ManagerFactory: ManagerFactoryProtocol {
    func getNetworkManager() -> NetworkManagerProtocol {
        return NetworkManager(imageCacheManager: getImageCacheManager(),
                              videoCacheManager: getVideoCacheManager())
    }
    
    func getDataBaseManager() -> DataBaseManagerProtocol {
        return DataBaseManager()
    }
    
    func getAuthManager() -> AuthManagerProtocol {
        return AuthManager()
    }
    
    func getImageCacheManager() -> ImageCacheManagerProtocol {
        return ImageCacheManager()
    }
    
    func getVideoCacheManager() -> VideoCacheManagerProtocol {
        return VideoCacheManager()
    }
    
}
