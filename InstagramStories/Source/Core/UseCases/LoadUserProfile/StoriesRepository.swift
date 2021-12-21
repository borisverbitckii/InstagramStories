//
//  StoriesRepository.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Foundation
import Swiftagram

protocol StoriesRepositoryProtocol {
    func fetchStories(userID: String, secret: Secret, completion: @escaping (Result<[Story],Error>)->())
    func fetchStoryData(urlString: String, completion: @escaping (Result<Data, Error>)->())
    func stopLastOperation()
}

final class StoriesRepository{
    
    //MARK: - Private properties
    private let remoteDataSource: StoriesDataSourceProtocol
    
    //MARK: - Init
    init(remoteDataSource: StoriesDataSourceProtocol){
        self.remoteDataSource = remoteDataSource
    }
}

//MARK: - extension + StoriesRepositoryProtocol
extension StoriesRepository: StoriesRepositoryProtocol {
    func fetchStories(userID: String, secret: Secret, completion: @escaping (Result<[Story],Error>)->()) {
        remoteDataSource.fetchStories(userID: userID, secret: secret, completion: completion)
    }
    
    func fetchStoryData(urlString: String, completion: @escaping (Result<Data, Error>) -> ()) {
        remoteDataSource.fetchStoryData(urlString: urlString, completion: completion)
    }
    
    func stopLastOperation() {
        remoteDataSource.stopLastOperation()
    }
}
