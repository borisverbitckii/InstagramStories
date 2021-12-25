//
//  ShowStoryUseCase.swift
//  InstagramStories
//
//  Created by Борис on 21.12.2021.
//

import UIKit.UIImage

protocol ShowStoryUseCaseProtocol {
    func fetchStoryPreview(urlString: String, completion: @escaping (Result<UIImage, Error>) -> ())
    func downloadCurrentStoryVideo(urlString: String, completion: @escaping (URL)->())
}

final class ShowStoryUseCase: UseCase {
    
    //MARK: - Private properties
    private let userImageRepository: UserImageRepositoryProtocol
    private let storyRepository: StoryRepositoryProtocol
    
    //MARK: - Init
    init(userImageRepository: UserImageRepositoryProtocol,
         storyRepository: StoryRepositoryProtocol) {
        self.storyRepository = storyRepository
        self.userImageRepository = userImageRepository
    }
    
}

//MARK: - extension + ShowStoryUseCaseProtocol
extension ShowStoryUseCase: ShowStoryUseCaseProtocol {
    func fetchStoryPreview(urlString: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        userImageRepository.fetchImageData(urlString: urlString) { result in
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else { return }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func downloadCurrentStoryVideo(urlString: String, completion: @escaping (URL)->()) {
        storyRepository.downloadCurrentStoryVideo(urlString: urlString, completion: completion)
    }
}
