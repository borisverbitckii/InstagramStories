//
//  AuthManager.swift
//  InstagramStories
//
//  Created by Борис on 10.12.2021.
//

import SwiftagramCrypto
import Foundation

protocol AuthManagerProtocol {
    func authInInstagram(username: String, password: String, completion: @escaping (Result<Secret, Error>) -> Void)
    func checkAuthorization(completion: @escaping(Secret?) -> Void)
}

final class AuthManager {
    // MARK: - Private properties
    private var bin: Set<AnyCancellable> = []
}

// MARK: - extension + AuthManagerProtocol
extension AuthManager {

    // MARK: - Private methods
    private func storeSecret(_ secret: Secret) {
        do {
            try KeychainStorage<Secret>().store(secret)
        } catch {
            print(#file, #line, Errors.cantSaveSecret)
        }
    }
}

// MARK: - extension + AuthManagerProtocol
extension AuthManager: AuthManagerProtocol {

    // MARK: - Public methods
    func checkAuthorization(completion: @escaping(Secret?) -> Void) {
        do {
            if UserDefaults.standard.value(forKey: "secret.identifier") == nil {
                completion(nil)
            } else if let identifier = UserDefaults.standard.value(forKey: "secret.identifier") as? String,
                      let secret = try KeychainStorage<Secret>().items().last {
                if identifier == secret.identifier {
                    completion(secret)
                }
            } else {
                completion(nil)
            }
        } catch {
            print(#file, #line, Errors.noSecretIntoKeychainStorage.error)
        }
    }

    func authInInstagram(username: String, password: String, completion: @escaping (Result<Secret, Error>) -> Void) {
        let queue = DispatchQueue(label: "Auth", qos: .userInteractive)

        queue.async {
            Authenticator.keychain
                .basic(username: username,
                       password: password)
                .authenticate()
                .sink(receiveCompletion: { response in
                    switch response {
                    case .failure(let error):
                        if (error as NSError).code == -1200 { // no access to server (need VPN)
                            DispatchQueue.main.async {
                                completion(.failure(error))
                            }
                            return
                        }
                        
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
                        UserDefaults.standard.set(secret.identifier, forKey: "secret.identifier")
                        completion(.success(secret))
                    }
                }).store(in: &self.bin)
        }
    }
}
