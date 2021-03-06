//
//  AuthDataSourceProtocol.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Swiftagram

protocol AuthDataSourceProtocol {
    func authInInstagram(username: String, password: String, completion: @escaping (Result<Secret, Error>) -> Void)
    func checkAuthorization(completion: @escaping(Secret?) -> Void)
}

final class AuthDataSource {
    // MARK: - Private properties
    private let authManager: AuthManagerProtocol

    // MARK: - Init
    init(authManager: AuthManagerProtocol) {
        self.authManager = authManager
    }

}

// MARK: - extension + AuthDataSourceProtocol
extension AuthDataSource: AuthDataSourceProtocol {
    func authInInstagram(username: String, password: String, completion: @escaping (Result<Secret, Error>) -> Void) {
        authManager.authInInstagram(username: username, password: password, completion: completion)
    }

    func checkAuthorization(completion: @escaping (Secret?) -> Void) {
        authManager.checkAuthorization(completion: completion)
    }
}
