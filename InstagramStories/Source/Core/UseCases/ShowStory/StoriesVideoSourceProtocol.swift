//
//  StoryDataSourceProtocol.swift
//  InstagramStories
//
//  Created by Борис on 21.12.2021.
//

import Foundation

protocol StoriesVideoSourceProtocol {
    func downloadCurrentStoryVideo(urlString: String, completion: @escaping (URL)->())
}
