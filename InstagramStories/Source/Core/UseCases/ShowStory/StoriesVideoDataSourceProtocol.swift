//
//  StoryDataSourceProtocol.swift
//  InstagramStories
//
//  Created by Борис on 21.12.2021.
//

import Foundation

protocol StoriesVideoDataSourceProtocol {
    func downloadCurrentStoryVideo(urlString: String, completion: @escaping (URL)->())
}

final class StoriesVideoDataSource {
    //MARK: - Private properties
    private let networkManager: NetworkManagerProtocol
    
    //MARK: - Init
    init(networkManager: NetworkManagerProtocol){
        self.networkManager = networkManager
    }
}

extension StoriesVideoDataSource: StoriesVideoDataSourceProtocol {
    func downloadCurrentStoryVideo(urlString: String, completion: @escaping (URL) -> ()) {
        networkManager.downloadCurrentStoryVideo(urlString: urlString, completion: completion)
    }
}
