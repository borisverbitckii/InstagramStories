//
//  DataSourceFactory.swift
//  InstagramStories
//
//  Created by Борис on 18.12.2021.
//

import Foundation

protocol DataSourceFactoryProtocol {
    func getUserImageDataSource() -> UserImageDataSourceProtocol
    func getSearchDataSource() -> SearchDataSourceProtocol
    func getAuthDataSource() -> AuthDataSourceProtocol
    func getStoriesDataSource() -> StoriesDataSourceProtocol
    func getRecentUsersDataSource() -> UsersDataSourceProtocol
    func getPreferencesDataSource() -> PreferencesDataSourceProtocol
    func getStoryDataSource() -> StoriesVideoSourceProtocol
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
        return managerFactory.getNetworkManager() as! SearchDataSourceProtocol
    }
    
    func getUserImageDataSource() -> UserImageDataSourceProtocol {
        return managerFactory.getNetworkManager() as! UserImageDataSourceProtocol
    }
    
    func getAuthDataSource() -> AuthDataSourceProtocol {
        return managerFactory.getAuthManager() as! AuthDataSourceProtocol
    }
    
    func getStoriesDataSource() -> StoriesDataSourceProtocol {
        return managerFactory.getNetworkManager() as! StoriesDataSourceProtocol
    }
    
    func getRecentUsersDataSource() -> UsersDataSourceProtocol {
        return UsersDataSource(dataBaseManager: managerFactory.getDataBaseManager()) as UsersDataSourceProtocol
    }
    
    func getPreferencesDataSource() -> PreferencesDataSourceProtocol {
        return Preferences() as PreferencesDataSourceProtocol
    }
    
    func getStoryDataSource() -> StoriesVideoSourceProtocol {
        return managerFactory.getNetworkManager() as! StoriesVideoSourceProtocol
    }
}
