//
//  PreferencesRepository.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Foundation

protocol PreferencesRepositoryProtocol {
    func getMenuItems(completion: @escaping (Result<[Setting], Error>) -> ())
}

final class PreferencesRepository {
    //MARK: - Private properties
    private let preferencesDataSource: PreferencesDataSourceProtocol
    
    //MARK: - Init
    init(preferencesDataSource: PreferencesDataSourceProtocol) {
        self.preferencesDataSource = preferencesDataSource
    }
}

//MARK: - extension + PreferencesRepositoryProtocol
extension PreferencesRepository: PreferencesRepositoryProtocol {
    func getMenuItems(completion: @escaping (Result<[Setting], Error>) -> ()) {
        preferencesDataSource.getMenuItems(completion: completion)
    }
}
