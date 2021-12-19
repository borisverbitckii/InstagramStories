//
//  ShowFavoritesUseCase.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Foundation

protocol ShowFavoritesUseCaseProtocol {
    func showFavoritesUsers(completion: @escaping (Result<[InstagramUser], Error>)->())
}

final class ShowFavoritesUseCase: UseCase {
   
    //MARK: - Private properties
    private let favoritesRepository: FavoritesRepositoryProtocol
    
    //MARK: - Init
    init(favoritesRepository: FavoritesRepositoryProtocol) {
        self.favoritesRepository = favoritesRepository
    }
    
}

//MARK: - extension + ShowFavoritesUseCaseProtocol
extension ShowFavoritesUseCase: ShowFavoritesUseCaseProtocol {
    func showFavoritesUsers(completion: @escaping (Result<[InstagramUser], Error>)->()) {
        favoritesRepository.showFavoritesUsers(completion: completion)
    }
}
