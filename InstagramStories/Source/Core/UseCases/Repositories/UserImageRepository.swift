//
//  UserImageRepository.swift
//  InstagramStories
//
//  Created by Борис on 18.12.2021.
//

import Foundation

protocol UserImageRepositoryProtocol {
    func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>)->())
}

final class UserImageRepository {
    //MARK: - Private properties
    private let dataSource: UserImageDataSourceProtocol
    
    //MARK: - Init
    init(dataSource: UserImageDataSourceProtocol) {
        self.dataSource = dataSource
    }
}

//MARK: - extension + UserImageRepositoryProtocol
extension UserImageRepository: UserImageRepositoryProtocol {
    func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>)->()) {
        dataSource.fetchImageData(urlString: urlString, completion: completion)
    }
}
