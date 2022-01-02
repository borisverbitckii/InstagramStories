//
//  SearchViewControllerUseCase.swift
//  InstagramStories
//
//  Created by Борис on 08.12.2021.
//

import UIKit.UIImage
import Swiftagram
import RealmSwift

protocol SearchUseCaseProtocol {
    func fetchInstagramUsersFromNetwork(searchingTitle: String,
                                        secret: Secret,
                                        completion: @escaping (Result <[InstagramUser], Error>)->())
    func fetchImage(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> ())
    func stopLastOperation() 
}

final class SearchUserUseCase: UseCase, SearchUseCaseProtocol {
    
    //MARK: - Private properties
    private let fetchImageRepository: UserImageRepositoryProtocol
    private let searchUserRepository: SearchUserRepositoryProtocol
    private let usersRepository: UsersRepositoryProtocol
    
    //MARK: - Init
    init(fetchImageRepository: UserImageRepositoryProtocol,
         searchUserRepository: SearchUserRepositoryProtocol,
         usersRepository: UsersRepositoryProtocol
    ) {
        self.fetchImageRepository = fetchImageRepository
        self.searchUserRepository = searchUserRepository
        self.usersRepository = usersRepository
    }
    
    //MARK: - Public methods
    func fetchInstagramUsersFromNetwork(searchingTitle: String,
                                        secret: Secret,
                                        completion: @escaping (Result <[InstagramUser], Error>)->()) {
        
        searchUserRepository.fetchInstagramUsersFromNetwork(searchingTitle: searchingTitle,
                                                            secret: secret) { [weak self] result in
            switch result {
            case .success(let users):
                var finalUsers = [InstagramUser]()
                
                for user in users {
                    self?.usersRepository.fetchUserWithPrimaryKey(primaryKey: user.id) { result in
                        switch result {
                        case .success(let userFromBD):
                            if user.id == userFromBD.id {
                                finalUsers.append(InstagramUser(instagramUser: userFromBD))
                            }
                        case .failure(_):
                            finalUsers.append(user)
                        }
                    }
                }
                
                completion(.success(finalUsers))
            case .failure(let error):
                print(#file, #line, error)
                completion(.failure(error))
            }
        }
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
        fetchImageRepository.stopLastOperation()
        searchUserRepository.stopLastOperation()
    }
}
