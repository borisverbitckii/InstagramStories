//
//  SearchUserRepository.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Foundation
import Swiftagram
import RealmSwift

protocol SearchUserRepositoryProtocol {
    func fetchInstagramUsersFromNetwork(searchingTitle: String,
                                        secret: Secret,
                                        completion: @escaping (Result <[InstagramUser], Error>)->())
    func fetchInstagramUserProfileFromNetwork(userID: Int,
                                              secret: Secret,
                                              completion: @escaping (Result<AdditionalUserDetails, Error>) -> ())
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
    func fetchInstagramUserProfileFromNetwork(userID: Int, secret: Secret, completion: @escaping (Result<AdditionalUserDetails, Error>) -> ()) {
        
        remoteDataSource.fetchUserProfile(id: userID,
                                          secret: secret,
                                          completion: completion)
    }
    
    func fetchInstagramUsersFromNetwork(searchingTitle: String,
                                        secret: Secret,
                                        completion: @escaping (Result <[InstagramUser], Error>)->()) {
        remoteDataSource.fetchInstagramUsers(searchingTitle: searchingTitle,
                                             secret: secret,
                                             completion: completion)
    }
    
    func stopLastOperation() {
        remoteDataSource.stopLastOperation()
    }
}
