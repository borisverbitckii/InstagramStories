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
        
        storiesRepository.fetchStoriesURLs(userID: userID, secret: secret) { [weak self] result in
            switch result {
            case .success(let urlStrings):
                var stories = [Story]()
                for urlString in urlStrings {
                    self?.storiesRepository.fetchStoryData(urlString: urlString) { result in
                        switch result {
                        case .success(let data):
                            //TODO: FIX data
                            let story = Story(time: 100, content: data) // find time
                            stories.append(story)
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                print(#file, #line, error)
                completion(.failure(error))
            }
        }
    }
}
