//
//  AuthRepository.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Swiftagram
import Foundation

protocol AuthRepositoryProtocol {
    func authInInstagram(completion: @escaping(Result<Secret, Error>) -> Void)
}

enum CredentialsType {
    case firebase, property
}

final class AuthRepository {

    // MARK: - Private properties
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

// MARK: - extension + AuthRepositoryProtocol
extension AuthRepository: AuthRepositoryProtocol {

    // MARK: - Public methods
    func authInInstagram(completion: @escaping(Result<Secret, Error>) -> Void) {
        authDataSource.checkAuthorization { [weak self] secret in
            guard let self = self else { return }
            if let secret = secret {
                completion(.success(secret))
                return
            }
            if !self.credentials.isEmpty {
                self.tryToAuthWithCredentials(credentials: self.credentials,
                                              completion: completion)
            } else {
                self.credentialsDataSource.fetchCredentials { credentials in
                    self.tryToAuthWithCredentials(type: .firebase,
                                                  credentials: credentials,
                                                  completion: completion)
                }
            }
        }
    }

    // MARK: - Private methods
    private func tryToAuthWithCredentials(type: CredentialsType? = nil,
                                          credentials: [String: String],
                                          completion: @escaping(Result<Secret, Error>) -> Void) {
        switch type {
        case .firebase: self.credentials = credentials
        default: break
        }
        
        guard let usernameAndPassword = credentials.first else {
            completion(.failure(Errors.noCredentials.error))
            return
        }
        let username = usernameAndPassword.key
        let password = usernameAndPassword.value
        
        self.authDataSource.authInInstagram(username: username,
                                            password: password) { [weak self] result in
            switch result {
            case .success(let secret):
                completion(.success(secret))
            case .failure(let error):
                if (error as NSError).code == -1200 {
                    completion(.failure(error))
                    break
                }
                self?.credentialsDataSource.removeCredentials(pathString: username)
                self?.credentials.removeValue(forKey: username)
                if self?.tryCounter ?? 0 > credentials.count {
                    completion(.failure(error))
                    break
                }
                self?.authInInstagram(completion: completion)
                self?.tryCounter += 1
            }
        }
    }
}
