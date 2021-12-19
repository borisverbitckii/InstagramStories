//
//  RepositoryFactory.swift
//  InstagramStories
//
//  Created by Борис on 18.12.2021.
//

import Foundation

protocol RepositoryFactoryProtocol {
    func getAuthRepository() -> AuthRepositoryProtocol
    func getUserImageRepository() -> UserImageRepositoryProtocol
    func getSearchUserRepository() -> SearchUserRepositoryProtocol
    func getStoriesRepository() -> StoriesRepositoryProtocol
    func getFavoritesUsersRepository() -> FavoritesRepositoryProtocol
    func getRecentUsersRepository() -> RecentUsersRepositoryProtocol
    func getPreferencesRepository() -> PreferencesRepositoryProtocol
}

final class RepositoryFactory {
    //MARK: - Private properties
    private let dataSourceFactory: DataSourceFactoryProtocol
    
    //MARK: - Init
    init(dataSourceFactory: DataSourceFactoryProtocol) {
        self.dataSourceFactory = dataSourceFactory
    }
    
}

//MARK: - extension + RepositoryFactoryProtocol
extension RepositoryFactory: RepositoryFactoryProtocol {
    //MARK: - Public methods
    func getAuthRepository() -> AuthRepositoryProtocol {
        return AuthRepository(authDataSource: dataSourceFactory.getAuthDataSource())
    }
    
    func getUserImageRepository() -> UserImageRepositoryProtocol {
        return UserImageRepository(remoteDataSource: dataSourceFactory.getUserImageDataSource())
    }
    
    func getSearchUserRepository() -> SearchUserRepositoryProtocol {
        return SearchUserRepository(remoteDataSource: dataSourceFactory.getSearchDataSource())
    }
    
    func getStoriesRepository() -> StoriesRepositoryProtocol {
        return StoriesRepository(remoteDataSource: dataSourceFactory.getStoriesDataSource())
    }
    
    func getFavoritesUsersRepository() -> FavoritesRepositoryProtocol {
        return FavoritesRepository(localDataSource: dataSourceFactory.getFavoritesDataSource())
    }
    
    func getRecentUsersRepository() -> RecentUsersRepositoryProtocol {
        return RecentUsersRepository(localDataSource: dataSourceFactory.getRecentUsersDataSource())
    }
    
    func getPreferencesRepository() -> PreferencesRepositoryProtocol {
        return PreferencesRepository(preferencesDataSource: dataSourceFactory.getPreferencesDataSource())
    }
}
