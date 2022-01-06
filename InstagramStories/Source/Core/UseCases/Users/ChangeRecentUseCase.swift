//
//  SaveRecentUseCase.swift
//  InstagramStories
//
//  Created by Борис on 27.12.2021.
//

protocol ChangeRecentUseCaseProtocol {
    func fetchRecentUsersFromBD(completion: @escaping ([RealmInstagramUserProtocol])->())
    func saveRecentUser(user: RealmInstagramUserProtocol, isSavedCompletion: @escaping (Bool)->())
    func changeRecentUser(user: RealmInstagramUserProtocol, isChangedCompletion: @escaping (Bool)->())
    func removeRecentUser(user: RealmInstagramUserProtocol, isRemovedCompletion: @escaping (Bool)->())
}

final class ChangeRecentUseCase: UseCase {
    //MARK: - Private properties
    private let usersRepository: UsersRepositoryProtocol
    
    // MARK: - Init
    init(usersRepository: UsersRepositoryProtocol) {
        self.usersRepository = usersRepository
    }
}

//MARK: - extension + SaveRecentUseCaseProtocol

extension ChangeRecentUseCase: ChangeRecentUseCaseProtocol {
    func fetchRecentUsersFromBD(completion: @escaping ([RealmInstagramUserProtocol])->()) {
        usersRepository.fetchUsersFromBD(userType: .recent,completion: completion)
    }
    
    func removeRecentUser(user: RealmInstagramUserProtocol, isRemovedCompletion: @escaping (Bool) -> ()) {
        usersRepository.removeUserFromBD(user: user, isDeletedCompletion: isRemovedCompletion)
    }
    
    
    func saveRecentUser(user: RealmInstagramUserProtocol, isSavedCompletion: @escaping (Bool)->()) {
        usersRepository.saveUserToBD(user: user, isSavedCompletion: isSavedCompletion)
    }
    
    func changeRecentUser(user: RealmInstagramUserProtocol, isChangedCompletion: @escaping (Bool)->()) {
        usersRepository.changeUserInBD(user: user, isChangedCompletion: isChangedCompletion)
    }
}


