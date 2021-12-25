//
//  StoryRepository.swift
//  InstagramStories
//
//  Created by Борис on 21.12.2021.
//

import Foundation

protocol StoryRepositoryProtocol {
    func downloadCurrentStoryVideo(urlString: String, completion: @escaping (URL)->())
}

final class StoryRepository {
    
    //MARK: - Private properties
    private let remoteDataSource: StoriesVideoSourceProtocol
    
    //MARK: - Init
    init(remoteDataSource: StoriesVideoSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
}

//MARK: - extension + StoryRepositoryProtocol
extension StoryRepository: StoryRepositoryProtocol {
    func downloadCurrentStoryVideo(urlString: String, completion: @escaping (URL)->()) {
        remoteDataSource.downloadCurrentStoryVideo(urlString: urlString, completion: completion)
    }
}