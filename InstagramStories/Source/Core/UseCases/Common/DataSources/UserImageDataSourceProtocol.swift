//
//  UserImageDataSourceProtocol.swift
//  InstagramStories
//
//  Created by Борис on 18.12.2021.
//

import Foundation
import Swiftagram

protocol UserImageDataSourceProtocol {
    func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>)->())
    func stopLastOperation()
}

final class UserImageDataSource {
    //MARK: - Private properties
    private let networkManager: NetworkManagerProtocol
    
    //MARK: - Init
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}

extension UserImageDataSource: UserImageDataSourceProtocol {
    func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>) -> ()) {
        networkManager.fetchImageData(urlString: urlString, completion: completion)
    }
    
    func stopLastOperation() {
        networkManager.stopLastOperation()
    }
}
