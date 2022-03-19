//
//  StoriesRepository.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Foundation
import Swiftagram

protocol StoriesPreviewRepositoryProtocol {
    func fetchStories(userID: String, secret: Secret, completion: @escaping (Result<[Story], Error>) -> Void)
    func stopLastOperation()
}

final class StoriesPreviewRepository {

    // MARK: - Private properties
    private let remoteDataSource: StoriesDataSourceProtocol

    // MARK: - Init
    init(remoteDataSource: StoriesDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
}

// MARK: - extension + StoriesRepositoryProtocol
extension StoriesPreviewRepository: StoriesPreviewRepositoryProtocol {
    func fetchStories(userID: String, secret: Secret, completion: @escaping (Result<[Story], Error>) -> Void) {
        remoteDataSource.fetchStories(userID: userID, secret: secret, completion: completion)
    }

    func stopLastOperation() {
        remoteDataSource.stopLastOperation()
    }
}
