//
//  DataSourceFactory.swift
//  InstagramStories
//
//  Created by Борис on 18.12.2021.
//

protocol DataSourceFactoryProtocol {
    func getUserImageDataSource() -> UserImageDataSourceProtocol
    func getSearchDataSource() -> SearchDataSourceProtocol
    func getAuthDataSource() -> AuthDataSourceProtocol
    func getStoriesDataSource() -> StoriesDataSourceProtocol
    func getRecentUsersDataSource() -> UsersDataSourceProtocol
    func getStoryDataSource() -> StoriesVideoDataSourceProtocol
    func getCredentialsDataSource() -> CredentialsDataSourceProtocol
}

final class DataSourceFactory {
    // MARK: - Private properties
    private let managerFactory: ManagerFactoryProtocol

    // MARK: - Init
    init(managerFactory: ManagerFactoryProtocol) {
        self.managerFactory = managerFactory
    }
}

// MARK: - extension + DataSourceFactoryProtocol
extension DataSourceFactory: DataSourceFactoryProtocol {
    func getSearchDataSource() -> SearchDataSourceProtocol {
        return SearchDataSource(networkManager: managerFactory.getNetworkManager())
    }

    func getUserImageDataSource() -> UserImageDataSourceProtocol {
        return UserImageDataSource(networkManager: managerFactory.getNetworkManager())
    }

    func getAuthDataSource() -> AuthDataSourceProtocol {
        return AuthDataSource(authManager: managerFactory.getAuthManager())
    }

    func getStoriesDataSource() -> StoriesDataSourceProtocol {
        return StoriesDataSource(networkManager: managerFactory.getNetworkManager())
    }

    func getRecentUsersDataSource() -> UsersDataSourceProtocol {
        return UsersDataSource(dataBaseManager: managerFactory.getDataBaseManager())
    }

    func getStoryDataSource() -> StoriesVideoDataSourceProtocol {
        return StoriesVideoDataSource(networkManager: managerFactory.getNetworkManager())
    }

    func getCredentialsDataSource() -> CredentialsDataSourceProtocol {
        return CredentialsDataSource(fireBaseManager: managerFactory.getFirebaseManager())
    }
}
