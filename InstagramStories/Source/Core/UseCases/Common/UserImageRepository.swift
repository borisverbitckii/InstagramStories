//
//  UserImageRepository.swift
//  InstagramStories
//
//  Created by Борис on 18.12.2021.
//

import Foundation

protocol UserImageRepositoryProtocol {
    func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>)->())
    func stopLastOperation()
}

final class UserImageRepository {
    //MARK: - Private properties
    private let remoteDataSource: UserImageDataSourceProtocol
    
    //MARK: - Init
    init(remoteDataSource: UserImageDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
}

//MARK: - extension + UserImageRepositoryProtocol
extension UserImageRepository: UserImageRepositoryProtocol {
    func stopLastOperation() {
        remoteDataSource.stopLastOperation()
    }
    
    func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>)->()) {
        remoteDataSource.fetchImageData(urlString: urlString, completion: completion)
    }
}
