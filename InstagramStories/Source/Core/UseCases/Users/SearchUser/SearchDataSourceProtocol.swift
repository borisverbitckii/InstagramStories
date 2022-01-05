//
//  SearchDataSourceProtocol.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Swiftagram // fix import

protocol SearchDataSourceProtocol {
    func fetchInstagramUsers(searchingTitle: String,
                             secret: Secret,
                             completion: @escaping (Result <[InstagramUser], Error>)->())
    func fetchUserProfile(id: Int,
                          secret: Secret,
                          completion: @escaping (Result<AdditionalUserDetails, Error>) -> ())
    func stopLastOperation()
}

final class SearchDataSource {
    //MARK: - Private properties
    private let networkManager: NetworkManagerProtocol
    
    //MARK: - Init
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
}

//MARK: - extension +
extension SearchDataSource: SearchDataSourceProtocol {
    func fetchInstagramUsers(searchingTitle: String, secret: Secret, completion: @escaping (Result<[InstagramUser], Error>) -> ()) {
        networkManager.fetchInstagramUsers(searchingTitle: searchingTitle, secret: secret, completion: completion)
    }
    
    func fetchUserProfile(id: Int, secret: Secret, completion: @escaping (Result<AdditionalUserDetails, Error>) -> ()) {
        networkManager.fetchUserProfile(id: id, secret: secret, completion: completion)
    }
    
    func stopLastOperation() {
        networkManager.stopLastOperation()
    }
}
