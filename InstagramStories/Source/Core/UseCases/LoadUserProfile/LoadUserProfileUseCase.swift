//
//  FetchUserProfileUseCase.swift
//  InstagramStories
//
//  Created by Борис on 18.12.2021.
//

import Foundation
import Swiftagram

protocol LoadUserProfileUseCaseProtocol {
    func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>)->())
    func fetchUserStories(userID: String, secret: Secret, completion: @escaping (Result<[Story], Error>)->())
}

final class LoadUserProfileUseCase: UseCase {
    //MARK: - Private properties
    private let userImageRepository: UserImageRepositoryProtocol
    private let storiesRepository: StoriesRepositoryProtocol
    
    //MARK: - Init
    init(repository: UserImageRepositoryProtocol,
         storiesRepository: StoriesRepositoryProtocol) {
        self.userImageRepository = repository
        self.storiesRepository = storiesRepository
    }
}

extension LoadUserProfileUseCase: LoadUserProfileUseCaseProtocol {
    //MARK: - Public methods
    func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>)->()) {
        userImageRepository.fetchImageData(urlString: urlString, completion: completion)
    }
    
    func fetchUserStories(userID: String, secret: Secret, completion: @escaping (Result<[Story], Error>)->()) {
        storiesRepository.fetchStories(userID: userID, secret: secret) { result in
            switch result {
            case .success(let stories):
                completion(.success(stories))
            case .failure(let error):
                print(#file, #line, error)
                completion(.failure(error))
            }
        }
    }
}
