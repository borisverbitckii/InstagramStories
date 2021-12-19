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

final class AuthUseCase: UseCase {
    
    //MARK: - Private properties
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
}


//MARK: - extension + SplashUseCaseProtocol
extension AuthUseCase: SplashUseCaseProtocol {
    
    //MARK: - Public methods
    func authInInstagram(completion: @escaping(Result<Secret,Error>) -> ()) {
        authRepository.authInInstagram(completion: completion)
    }
}
