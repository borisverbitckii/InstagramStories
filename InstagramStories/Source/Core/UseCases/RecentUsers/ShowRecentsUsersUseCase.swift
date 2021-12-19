//
//  ShowRecentsUsersUseCase.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Foundation

protocol ShowRecentsUsersUseCaseProtocol {
    func fetchRecentUsersFromBD(completion: @escaping (Result <[InstagramUser], Error>)->())
}

final class ShowRecentsUsersUseCase: UseCase {
    
    //MARK: - Private properties
    private let recentUsersRepository: RecentUsersRepositoryProtocol
    
    init(recentUsersRepository: RecentUsersRepositoryProtocol) {
        self.recentUsersRepository = recentUsersRepository
    }
    
}

//MARK: - extension + ShowRecentsUsersUseCaseProtocol
extension ShowRecentsUsersUseCase: ShowRecentsUsersUseCaseProtocol {
    func fetchRecentUsersFromBD(completion: @escaping (Result <[InstagramUser], Error>)->()) {
        recentUsersRepository.fetchRecentUsersFromBD(completion: completion)
    }
}
