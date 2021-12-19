//
//  PreferencesViewControllerUseCase.swift
//  InstagramStories
//
//  Created by Борис on 08.12.2021.
//

import Foundation

protocol ShowPreferencesUseCaseProtocol {
    func getMenuItems(completion: @escaping (Result<[Setting], Error>) -> ())
}

final class ShowPreferencesUseCase: UseCase {
    
    //MARK: - Private properties
    private let preferencesRepository: PreferencesRepositoryProtocol
    
    //MARK: - Init
    init(preferencesRepository: PreferencesRepositoryProtocol) {
        self.preferencesRepository = preferencesRepository
    }
}

//MARK: - extension + ShowPreferencesUseCaseProtocol
extension ShowPreferencesUseCase: ShowPreferencesUseCaseProtocol {
    
    func getMenuItems(completion: @escaping (Result<[Setting], Error>) -> ()) {
        preferencesRepository.getMenuItems(completion: completion)
    }
    
}
