//
//  SearchViewControllerUseCase.swift
//  InstagramStories
//
//  Created by Борис on 08.12.2021.
//

import UIKit.UIImage
import Swiftagram

protocol SearchUseCaseProtocol {
    func fetchInstagramUsersFromNetwork(searchingTitle: String,
                                        secret: Secret,
                                        completion: @escaping (Result <[InstagramUser], Error>)->())
    func saveUserToRecents(user: InstagramUser)
    func fetchImage(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> ()) // перепроверить нужен ли
    func stopLastOperation() 
}

final class SearchUserUseCase: UseCase, SearchUseCaseProtocol {
    
    //MARK: - Private properties
    private let fetchImageRepository: UserImageRepositoryProtocol
    private let searchUserRepository: SearchUserRepositoryProtocol
    
    //MARK: - Init
    init(fetchImageRepository: UserImageRepositoryProtocol,
         searchUserRepository: SearchUserRepositoryProtocol) {
        self.fetchImageRepository = fetchImageRepository
        self.searchUserRepository = searchUserRepository
    }
    
    //MARK: - Public methods
    func saveUserToRecents(user: InstagramUser) {
        let _ = RealmInstagramUser(instagramUser: user)
        
    }
    
    func fetchInstagramUsersFromNetwork(searchingTitle: String,
                                        secret: Secret,
                                        completion: @escaping (Result <[InstagramUser], Error>)->()) {
        searchUserRepository.fetchInstagramUsersFromNetwork(searchingTitle: searchingTitle, secret: secret, completion: completion)
    }
    
    func fetchImage(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        
        fetchImageRepository.fetchImageData(urlString: stringURL) { result in
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else { return }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func stopLastOperation() {
        searchUserRepository.stopLastOperation()
    }
}
