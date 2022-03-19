//
//  RepositoryFactory.swift
//  InstagramStories
//
//  Created by Борис on 18.12.2021.
//

protocol RepositoryFactoryProtocol {
    func getAuthRepository() -> AuthRepositoryProtocol
    func getUserImageRepository() -> UserImageRepositoryProtocol
    func getSearchUserRepository() -> SearchUserRepositoryProtocol
    func getStoriesRepository() -> StoriesPreviewRepositoryProtocol
    func getUsersRepository() -> UsersRepositoryProtocol
    func getStoryRepository() -> StoryRepositoryProtocol
}

final class RepositoryFactory {
    // MARK: - Private properties
    private let dataSourceFactory: DataSourceFactoryProtocol

    // MARK: - Init
    init(dataSourceFactory: DataSourceFactoryProtocol) {
        self.dataSourceFactory = dataSourceFactory
    }

}

// MARK: - extension + RepositoryFactoryProtocol
extension RepositoryFactory: RepositoryFactoryProtocol {
    // MARK: - Public methods
    func getAuthRepository() -> AuthRepositoryProtocol {
        return AuthRepository(authDataSource: dataSourceFactory.getAuthDataSource(),
                              credentialsDataSource: dataSourceFactory.getCredentialsDataSource())
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

    func getUsersRepository() -> UsersRepositoryProtocol {
        return UsersRepository(localDataSource: dataSourceFactory.getRecentUsersDataSource())
    }

    func getStoryRepository() -> StoryRepositoryProtocol {
        return StoryRepository(remoteDataSource: dataSourceFactory.getStoryDataSource())
    }
}
