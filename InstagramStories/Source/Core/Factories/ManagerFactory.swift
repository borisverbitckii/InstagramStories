//
//  ManagerFactory.swift
//  InstagramStories
//
//  Created by Борис on 08.12.2021.
//

protocol ManagerFactoryProtocol {
    func getNetworkManager() -> NetworkManagerProtocol
    func getDataBaseManager() -> DataBaseManagerProtocol
    func getAuthManager() -> AuthManagerProtocol
    func getImageCacheManager() -> ImageCacheManagerProtocol
    func getVideoCacheManager() -> VideoCacheManagerProtocol
    func getFirebaseManager() -> FireBaseManagerProtocol
}

final class ManagerFactory: ManagerFactoryProtocol {
    func getNetworkManager() -> NetworkManagerProtocol {
        NetworkManager(imageCacheManager: getImageCacheManager(),
                       videoCacheManager: getVideoCacheManager())
    }

    func getDataBaseManager() -> DataBaseManagerProtocol {
        DataBaseManager()
    }

    func getAuthManager() -> AuthManagerProtocol {
        AuthManager()
    }

    func getImageCacheManager() -> ImageCacheManagerProtocol {
        ImageCacheManager()
    }

    func getVideoCacheManager() -> VideoCacheManagerProtocol {
        VideoCacheManager()
    }

    func getFirebaseManager() -> FireBaseManagerProtocol {
        FireBaseManager()
    }
}
