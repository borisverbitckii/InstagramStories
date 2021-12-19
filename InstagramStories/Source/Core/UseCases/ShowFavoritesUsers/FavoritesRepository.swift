//
//  FavoritesRepository.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Foundation

protocol FavoritesRepositoryProtocol {
    func showFavoritesUsers(completion: @escaping (Result<[InstagramUser], Error>)->())
}

final class FavoritesRepository {
    
    //MARK: - Private properties
    private let localDataSource: FavoritesDataSourceProtocol
    
    //MARK: - Init
    init(localDataSource: FavoritesDataSourceProtocol) {
        self.localDataSource = localDataSource
    }
    
}

//MARK: - extension + FavoritesRepositoryProtocol
extension FavoritesRepository: FavoritesRepositoryProtocol {
    func showFavoritesUsers(completion: @escaping (Result<[InstagramUser], Error>)->()) {
        localDataSource.getInstagramUsers(completion: completion)
    }
}
