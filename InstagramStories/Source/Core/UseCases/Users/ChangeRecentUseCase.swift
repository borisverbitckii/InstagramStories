//
//  SaveRecentUseCase.swift
//  InstagramStories
//
//  Created by Борис on 27.12.2021.
//

protocol ChangeRecentUseCaseProtocol {
    func fetchRecentUsersFromBD(completion: @escaping ([RealmInstagramUserProtocol]) -> Void)
    func saveRecentUser(user: RealmInstagramUserProtocol, isSavedCompletion: @escaping (Bool) -> Void)
    func changeRecentUser(user: RealmInstagramUserProtocol, isChangedCompletion: @escaping (Bool) -> Void)
    func removeRecentUser(user: RealmInstagramUserProtocol, isRemovedCompletion: @escaping (Bool) -> Void)
}

final class ChangeRecentUseCase: UseCase {
    // MARK: - Private properties
    private let usersRepository: UsersRepositoryProtocol

    // MARK: - Init
    init(usersRepository: UsersRepositoryProtocol) {
        self.usersRepository = usersRepository
    }
}

// MARK: - extension + SaveRecentUseCaseProtocol

extension ChangeRecentUseCase: ChangeRecentUseCaseProtocol {
    func fetchRecentUsersFromBD(completion: @escaping ([RealmInstagramUserProtocol]) -> Void) {
        usersRepository.fetchUsersFromBD(userType: .recent, completion: completion)
    }

    func removeRecentUser(user: RealmInstagramUserProtocol, isRemovedCompletion: @escaping (Bool) -> Void) {
        usersRepository.removeUserFromBD(user: user, isDeletedCompletion: isRemovedCompletion)
    }

    func saveRecentUser(user: RealmInstagramUserProtocol, isSavedCompletion: @escaping (Bool) -> Void) {
        usersRepository.saveUserToBD(user: user, isSavedCompletion: isSavedCompletion)
    }

    func changeRecentUser(user: RealmInstagramUserProtocol, isChangedCompletion: @escaping (Bool) -> Void) {
        usersRepository.changeUserInBD(user: user, isChangedCompletion: isChangedCompletion)
    }
}
