//
//  SearchUserRepository.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Foundation
import Swiftagram

protocol SearchUserRepositoryProtocol {
    func fetchInstagramUsersFromNetwork(searchingTitle: String,
                                        secret: Secret,
                                        completion: @escaping (Result <[InstagramUser], Error>)->())
    func stopLastOperation()
}

final class SearchUserRepository {
    
    //MARK: - Private properties
    private let remoteDataSource: SearchDataSourceProtocol
    
    //MARK: - Init
    init(remoteDataSource: SearchDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
}

//MARK: - extension + SearchUserRepositoryProtocol
extension SearchUserRepository: SearchUserRepositoryProtocol {
    func fetchInstagramUsersFromNetwork(searchingTitle: String, secret: Secret, completion: @escaping (Result<[InstagramUser], Error>) -> ()) {
        remoteDataSource.fetchInstagramUsers(searchingTitle: searchingTitle, secret: secret, completion: completion)
    }
    
    func stopLastOperation() {
        remoteDataSource.stopLastOperation()
    }
}
