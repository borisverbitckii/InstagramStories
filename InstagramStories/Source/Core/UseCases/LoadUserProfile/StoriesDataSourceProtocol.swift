//
//  StoriesDataSourceProtocol.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Foundation
import Swiftagram

protocol StoriesDataSourceProtocol {
    func fetchStories(userID: String, secret: Secret, completion: @escaping (Result<[Story],Error>)->())
    func stopLastOperation()
}

final class StoriesDataSource {
    //MARK: - Private properties
    private let networkManager: NetworkManagerProtocol
    
    //MARK: - Init
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}

//MARK: - extension + StoriesDataSourceProtocol
extension StoriesDataSource: StoriesDataSourceProtocol {
    func fetchStories(userID: String, secret: Secret, completion: @escaping (Result<[Story], Error>) -> ()) {
        networkManager.fetchStories(userID: userID, secret: secret, completion: completion)
    }
    
    func stopLastOperation() {
        networkManager.stopLastOperation()
    }
}
