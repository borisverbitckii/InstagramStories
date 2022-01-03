//
//  FetchUserProfileUseCase.swift
//  InstagramStories
//
//  Created by Борис on 18.12.2021.
//

import Foundation
import Swiftagram

protocol LoadUserProfileUseCaseProtocol {
    func fetchImageData(urlString: String,
                        completion: @escaping (Result<Data, Error>)->())
    func fetchUserStories(userID: String,
                          secret: Secret,
                          completion: @escaping (Result<[Story], Error>)->())
    func fetchUserDetails(userID: Int,
                          secret: Secret,
                          completion: @escaping (Result<AdditionalUserDetails, Error>) -> ())
}

final class LoadUserProfileUseCase: UseCase {
    //MARK: - Private properties
    private let userImageRepository: UserImageRepositoryProtocol
    private let storiesPreviewRepository: StoriesPreviewRepositoryProtocol
    private let searchUserRepository: SearchUserRepositoryProtocol
    
    //MARK: - Init
    init(repository: UserImageRepositoryProtocol,
         storiesRepository: StoriesPreviewRepositoryProtocol,
         searchUserRepository: SearchUserRepositoryProtocol) {
        self.userImageRepository = repository
        self.storiesPreviewRepository = storiesRepository
        self.searchUserRepository = searchUserRepository
    }
}

extension LoadUserProfileUseCase: LoadUserProfileUseCaseProtocol {
    func fetchUserDetails(userID: Int,
                          secret: Secret,
                          completion: @escaping (Result<AdditionalUserDetails, Error>) -> ()) {
        searchUserRepository.fetchInstagramUserProfileFromNetwork(userID: userID,
                                                                  secret: secret,
                                                                  completion: completion)
    }
    
    //MARK: - Public methods
    func fetchImageData(urlString: String,
                        completion: @escaping (Result<Data, Error>)->()) {
        userImageRepository.fetchImageData(urlString: urlString, completion: completion)
    }
    
    func fetchUserStories(userID: String,
                          secret: Secret,
                          completion: @escaping (Result<[Story], Error>)->()) {
        storiesPreviewRepository.fetchStories(userID: userID, secret: secret, completion: completion)
    }
}
