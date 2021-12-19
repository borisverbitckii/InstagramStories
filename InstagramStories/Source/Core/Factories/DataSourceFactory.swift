//
//  DataSourceFactory.swift
//  InstagramStories
//
//  Created by Борис on 18.12.2021.
//

import Foundation

protocol DataSourceFactoryProtocol {
    func getUserImageDataSourceProtocol() -> UserImageDataSourceProtocol
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
    func getUserImageDataSourceProtocol() -> UserImageDataSourceProtocol {
        return managerFactory.getNetworkManager() as! UserImageDataSourceProtocol
    }
}
