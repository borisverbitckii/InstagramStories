//
//  AuthManager.swift
//  InstagramStories
//
//  Created by Борис on 10.12.2021.
//

import SwiftagramCrypto
import Foundation

protocol AuthManagerProtocol {
    func authInInstagram(username: String, password: String, completion: @escaping (Result<Secret,Error>) -> ())
    func checkAuthorization(completion: @escaping(Secret?)->())
}

final class AuthManager {
    //MARK: - Private properties
    private var bin: Set<AnyCancellable> = []
}

//MARK: - extension + AuthManagerProtocol
extension AuthManager: AuthManagerProtocol {
    
    //MARK: - Public methods
    func checkAuthorization(completion: @escaping(Secret?)->()) {
        do {
            if UserDefaults.standard.value(forKey: "UUID") == nil { //TODO: fix auth bug
                completion(nil)
            } else if let secret = try KeychainStorage<Secret>().items().last {
                completion(secret)
            }
        } catch {
            print(#file, #line, Errors.noSecretIntoKeychainStorage.error)
        }
    }
    
    func authInInstagram(username: String, password: String, completion: @escaping (Result<Secret,Error>) -> ()) {
        let queue = DispatchQueue(label: "Auth", qos: .userInteractive)
        
        queue.async {
            Authenticator.keychain
                .basic(username: username,
                       password: password)
                .authenticate()
                .sink(receiveCompletion: { response in
                    switch response {
                    case .failure(let error):
                        print(#file, #line, error)
                        switch error {
                        case Authenticator.Error.twoFactorChallenge(_):
                            print(#file, #line, Errors.somethingWrongWithAuth)
                            DispatchQueue.main.async {
                                completion(.failure(Errors.needTwoFactorAuth.error))
                            }
                        default:
                            print(#file, #line, Errors.somethingWrongWithAuth)
                            DispatchQueue.main.async {
                                completion(.failure(Errors.somethingWrongWithAuth.error))
                            }
                        }
                    default:
                        print("successful log in")
                    }
                },
                      receiveValue: { [weak self] secret in
                    self?.storeSecret(secret)
                    DispatchQueue.main.async {
                        completion(.success(secret))
                    }
                }).store(in: &self.bin)
        }
    }
    
    //MARK: - Private methods
    private func storeSecret(_ secret: Secret) {
        do {
            try KeychainStorage<Secret>().empty()
            try KeychainStorage<Secret>().store(secret)
        } catch {
            print(#file, #line, Errors.cantSaveSecret)
        }
    }
}
