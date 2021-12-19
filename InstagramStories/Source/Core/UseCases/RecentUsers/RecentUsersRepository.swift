//
//  RecentUsersRepository.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Foundation

protocol RecentUsersRepositoryProtocol {
    func fetchRecentUsersFromBD(completion: @escaping (Result <[InstagramUser], Error>)->())
}

final class RecentUsersRepository {
    
    //MARK: - Private properties
    private let localDataSource: RecentUsersDataSourceProtocol
    
    //MARK: - Init
    init(localDataSource: RecentUsersDataSourceProtocol){
        self.localDataSource = localDataSource
    }
    
}

//MARK: - extension + RecentUsersRepositoryProtocol
extension RecentUsersRepository: RecentUsersRepositoryProtocol {
    func fetchRecentUsersFromBD(completion: @escaping (Result<[InstagramUser], Error>) -> ()) {
        localDataSource.getInstagramUsers { result in
            switch result{
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                print(#file, #line, error)
                completion(.failure(error))
            }
        }
    }
}
