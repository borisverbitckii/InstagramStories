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
    func getStoriesRepository() -> StoriesPreviewRepositoryProtocol
    func getFavoritesUsersRepository() -> FavoritesRepositoryProtocol
    func getRecentUsersRepository() -> RecentUsersRepositoryProtocol
    func getPreferencesRepository() -> PreferencesRepositoryProtocol
    func getStoryRepository() -> StoryRepositoryProtocol
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
    
    func getStoriesRepository() -> StoriesPreviewRepositoryProtocol {
        return StoriesPreviewRepository(remoteDataSource: dataSourceFactory.getStoriesDataSource())
    }
    
    func getFavoritesUsersRepository() -> FavoritesRepositoryProtocol {
        return FavoritesRepository(localDataSource: dataSourceFactory.getFavoritesDataSource())
    }
    
    func getRecentUsersRepository() -> RecentUsersRepositoryProtocol {
        return RecentUsersRepository(localDataSource: dataSourceFactory.getRecentUsersDataSource())
    }
    
    func getPreferencesRepository() -> PreferencesRepositoryProtocol {
        return PreferencesRepository(localDataSource: dataSourceFactory.getPreferencesDataSource())
    }
    
    func getStoryRepository() -> StoryRepositoryProtocol {
        return StoryRepository(remoteDataSource: dataSourceFactory.getStoryDataSource())
    }
}
