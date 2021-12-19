//
//  RepositoryFactory.swift
//  InstagramStories
//
//  Created by Борис on 18.12.2021.
//

import Foundation

protocol RepositoryFactoryProtocol {
    func getUserImageRepository() -> UserImageRepositoryProtocol
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
    func getUserImageRepository() -> UserImageRepositoryProtocol {
        return UserImageRepository(dataSource: dataSourceFactory.getUserImageDataSourceProtocol())
    }
}
