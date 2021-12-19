//
//  FetchUserProfileUseCase.swift
//  InstagramStories
//
//  Created by Борис on 18.12.2021.
//

import Foundation

protocol FetchUserImageUseCaseProtocol {
    func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>)->())
}

final class FetchUserImageUseCase: UseCase {
    //MARK: - Private properties
    private let repository: UserImageRepositoryProtocol
    
    //MARK: - Init
    init(repository: UserImageRepositoryProtocol) {
        self.repository = repository
    }
}

extension FetchUserImageUseCase: FetchUserImageUseCaseProtocol {
    //MARK: - Public methods
    func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>)->()) {
        repository.fetchImageData(urlString: urlString, completion: completion)
    }
}
