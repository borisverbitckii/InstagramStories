//
//  SearchDataSourceProtocol.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Swiftagram

protocol SearchDataSourceProtocol {
    func fetchInstagramUsers(searchingTitle: String,
                             secret: Secret,
                             completion: @escaping (Result <[InstagramUser], Error>) -> Void)
    func fetchUserProfile(id: Int,
                          secret: Secret,
                          completion: @escaping (Result<AdditionalUserDetails, Error>) -> Void)
    func stopLastOperation()
}

final class SearchDataSource {
    // MARK: - Private properties
    private let networkManager: NetworkManagerProtocol

    // MARK: - Init
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

}

// MARK: - extension +
extension SearchDataSource: SearchDataSourceProtocol {
    func fetchInstagramUsers(searchingTitle: String, secret: Secret, completion: @escaping (Result<[InstagramUser], Error>) -> Void) {
        networkManager.fetchInstagramUsers(searchingTitle: searchingTitle, secret: secret, completion: completion)
    }

    func fetchUserProfile(id: Int, secret: Secret, completion: @escaping (Result<AdditionalUserDetails, Error>) -> Void) {
        networkManager.fetchUserProfile(id: id, secret: secret, completion: completion)
    }

    func stopLastOperation() {
        networkManager.stopLastOperation()
    }
}
