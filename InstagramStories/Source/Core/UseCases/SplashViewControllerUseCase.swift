//
//  SplashUseCase.swift
//  InstagramStories
//
//  Created by Борис on 10.12.2021.
//

import Swiftagram

protocol SplashUseCaseProtocol {
    func authInInstagram(completion: @escaping(Result<Secret,Error>) -> ())
    
}

final class SplashViewControllerUseCase: UseCase {
    
    //MARK: - Private properties
    private let authManager: AuthManagerProtocol
    
    init(authManager: AuthManagerProtocol) {
        self.authManager = authManager
    }
}


//MARK: - extension + SplashUseCaseProtocol
extension SplashViewControllerUseCase: SplashUseCaseProtocol {
    
    //MARK: - Public methods
    func authInInstagram(completion: @escaping(Result<Secret,Error>) -> ()) {
        authManager.checkAuthorization { [weak self] secret in
            guard let secret = secret else {
                let username = Constants.credentialsUsername
                let password = Constants.credentialsPassword
                self?.authManager.authInInstagram(username: username,
                                                  password: password, completion: completion)
                return
            }
            completion(.success(secret))
        }
    }
}
