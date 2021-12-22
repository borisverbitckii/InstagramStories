//
//  StoryRepository.swift
//  InstagramStories
//
//  Created by Борис on 21.12.2021.
//

import Foundation

protocol StoryRepositoryProtocol {
    
}

final class StoryRepository {
    
    //MARK: - Private properties
    private let remoteDataSource: StoryDataSourceProtocol
    
    //MARK: - Init
    init(remoteDataSource: StoryDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
}

//MARK: - extension + StoryRepositoryProtocol
extension StoryRepository: StoryRepositoryProtocol {
    
}
