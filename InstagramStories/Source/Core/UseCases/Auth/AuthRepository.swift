//
//  AuthRepository.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Swiftagram

protocol AuthRepositoryProtocol {
    func authInInstagram(completion: @escaping(Result<Secret,Error>) -> ())
}

final class AuthRepository {
    
    //MARK: - Private properties
    private let authDataSource: AuthDataSourceProtocol
    
    init(authDataSource: AuthDataSourceProtocol) {
        self.authDataSource = authDataSource
    }
}

//MARK: - extension + AuthRepositoryProtocol
extension AuthRepository: AuthRepositoryProtocol {
    
    //MARK: - Public methods
    func authInInstagram(completion: @escaping(Result<Secret,Error>) -> ()) {
        authDataSource.checkAuthorization { [weak self] secret in
            guard let secret = secret else {
                let username = Constants.credentialsUsername
                let password = Constants.credentialsPassword
                self?.authDataSource.authInInstagram(username: username,
                                                  password: password, completion: completion)
                return
            }
            completion(.success(secret))
        }
    }
}
