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
    private let localDataSource: PreferencesDataSourceProtocol
    
    //MARK: - Init
    init(localDataSource: PreferencesDataSourceProtocol) {
        self.localDataSource = localDataSource
    }
}

//MARK: - extension + PreferencesRepositoryProtocol
extension PreferencesRepository: PreferencesRepositoryProtocol {
    func getMenuItems(completion: @escaping (Result<[Setting], Error>) -> ()) {
        localDataSource.getMenuItems(completion: completion)
    }
}
