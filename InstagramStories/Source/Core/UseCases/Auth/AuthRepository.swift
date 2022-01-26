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
                
                var indexOfCredentialsForAuth = 0
                
                if let credentials = UserDefaults.standard.value(forKey: "lastAuthUserCredentials") as? String {
                    guard let index = Credentials.allCases.firstIndex(where: { $0.rawValue == credentials }) else { return }
                    indexOfCredentialsForAuth = index + 1
                }
                
                let user = Credentials.allCases[indexOfCredentialsForAuth]
                let usernameAndPassword = user.rawValue.components(separatedBy: ":")
                let username = usernameAndPassword[0]
                let password = usernameAndPassword[1]
                
                self?.authDataSource.authInInstagram(username: username,
                                                     password: password) { result in
                    UserDefaults.standard.set(usernameAndPassword, forKey: "lastAuthUserCredentials")
                    switch result {
                    case .success(let secret):
                        completion(.success(secret))
                    case .failure(let error):
                        if indexOfCredentialsForAuth == Credentials.allCases.count - 1 {
                            completion(.failure(error))
                            break
                        }
                        self?.authInInstagram(completion: completion)
                    }
                }
                return
            }
            completion(.success(secret))
        }
    }
}
