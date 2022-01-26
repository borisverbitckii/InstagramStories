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
}

final class DataSourceFactory {
    //MARK: - Private properties
    private let managerFactory: ManagerFactoryProtocol
    
    //MARK: - Init
    init(managerFactory: ManagerFactoryProtocol) {
        self.managerFactory = managerFactory
    }
}

//MARK: - extension + DataSourceFactoryProtocol
extension DataSourceFactory: DataSourceFactoryProtocol {
    func getSearchDataSource() -> SearchDataSourceProtocol {
        return SearchDataSource(networkManager: managerFactory.getNetworkManager()) as SearchDataSourceProtocol
    }
    
    func getUserImageDataSource() -> UserImageDataSourceProtocol {
        return UserImageDataSource(networkManager: managerFactory.getNetworkManager()) as UserImageDataSourceProtocol
    }
    
    func getAuthDataSource() -> AuthDataSourceProtocol {
        return AuthDataSource(authManager: managerFactory.getAuthManager()) as AuthDataSourceProtocol
    }
    
    func getStoriesDataSource() -> StoriesDataSourceProtocol {
        return StoriesDataSource(networkManager: managerFactory.getNetworkManager()) as StoriesDataSourceProtocol
    }
    
    func getRecentUsersDataSource() -> UsersDataSourceProtocol {
        return UsersDataSource(dataBaseManager: managerFactory.getDataBaseManager()) as UsersDataSourceProtocol
    }
    
    func getStoryDataSource() -> StoriesVideoDataSourceProtocol {
        return StoriesVideoDataSource(networkManager: managerFactory.getNetworkManager()) as StoriesVideoDataSource
    }
}
