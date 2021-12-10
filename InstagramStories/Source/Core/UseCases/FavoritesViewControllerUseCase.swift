//
//  FavoritesUseCase.swift
//  InstagramStories
//
//  Created by Борис on 08.12.2021.
//

import Foundation

protocol FavoritesUseCaseProtocol {
    func fetchFavoritesUsersFromBD(completion: @escaping (Result <[InstagramUser], Error>)->())
}

final class FavoritesViewControllerUseCase: UseCase, FavoritesUseCaseProtocol {
    
    //MARK: - Private properties
    private let dataBaseManager: DataBaseManagerProtocol
    
    //MARK: - Init
    init(dataBaseManager: DataBaseManagerProtocol) {
        self.dataBaseManager = dataBaseManager
    }
    
    //MARK: - Public methods
    func fetchFavoritesUsersFromBD(completion: @escaping (Result <[InstagramUser], Error>)->()) {
        //TODO: Fix this
        dataBaseManager.fetchInstagramUsers { result in
            switch result{
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                print(#file, #line, error)
                completion(.failure(error))
            }
        }
    }
}
