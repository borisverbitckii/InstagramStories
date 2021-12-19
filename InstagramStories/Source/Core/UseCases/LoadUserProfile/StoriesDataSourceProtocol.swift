//
//  StoriesDataSourceProtocol.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Foundation
import Swiftagram

protocol StoriesDataSourceProtocol {
    func fetchStoriesURLs(userID: String, secret: Secret, completion: @escaping (Result<[String],Error>)->())
    func fetchStoryData(urlString: String, completion: @escaping (Result<Data, Error>)->())
    func stopLastOperation()
}
