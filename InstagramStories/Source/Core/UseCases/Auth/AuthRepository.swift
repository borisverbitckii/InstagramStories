//
//  AuthRepository.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Swiftagram
import Foundation

protocol AuthRepositoryProtocol {
    func authInInstagram(completion: @escaping(Result<Secret,Error>) -> ())
}

enum CredentialsType {
    case firebase, property
}

final class AuthRepository {
    
    //MARK: - Private properties
    private let authDataSource: AuthDataSourceProtocol
    private let credentialsDataSource: CredentialsDataSourceProtocol
    
    private var tryCounter = 0
    private var credentials = [String: String]()
    
    init(authDataSource: AuthDataSourceProtocol,
         credentialsDataSource: CredentialsDataSourceProtocol) {
        self.authDataSource = authDataSource
        self.credentialsDataSource = credentialsDataSource
    }
}

//MARK: - extension + AuthRepositoryProtocol
extension AuthRepository: AuthRepositoryProtocol {
    
    //MARK: - Public methods
    func authInInstagram(completion: @escaping(Result<Secret,Error>) -> ()) {
        authDataSource.checkAuthorization { [weak self] secret in
            guard let self = self else { return }
            if let secret = secret {
                completion(.success(secret))
                return
            }
            if !self.credentials.isEmpty {
                self.tryToAuthWithCredentials(type: .property,
                                              credentials: self.credentials,
                                              completion: completion)
            } else {
                self.credentialsDataSource.fetchCredentials { credentials in
                    self.tryToAuthWithCredentials(type: .firebase,
                                                  credentials: self.credentials,
                                                  completion: completion)
                }
            }
        }
    }
    
    //MARK: - Private methods
    private func tryToAuthWithCredentials(type: CredentialsType,
                                          credentials: [String: String],
                                          completion: @escaping(Result<Secret,Error>) -> ()) {
        self.credentialsDataSource.fetchCredentials { credentials in
            
            switch type {
            case .firebase: self.credentials = credentials
            default: break
            }
            
            guard let usernameAndPassword = credentials.first else { return }
            let username = usernameAndPassword.key
            let password = usernameAndPassword.value
            
            self.tryCounter += 1
            
            self.authDataSource.authInInstagram(username: username,
                                                password: password) { result in
                switch result {
                case .success(let secret):
                    completion(.success(secret))
                case .failure(let error):
                    self.credentialsDataSource.removeCredentials(pathString: username)
                    self.credentials.removeValue(forKey: username)
                    if self.tryCounter >= credentials.count {
                        completion(.failure(error))
                        break
                    }
                    self.authInInstagram(completion: completion)
                }
            }
        }
    }
}
