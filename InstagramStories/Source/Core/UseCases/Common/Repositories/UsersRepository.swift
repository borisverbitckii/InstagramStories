//
//  RecentUsersRepository.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

protocol UsersRepositoryProtocol {
    func fetchUsersFromBD(userType: UserType,
                          completion: @escaping ([RealmInstagramUserProtocol]) -> Void)
    func fetchUserWithPrimaryKey(primaryKey: Int, completion: @escaping (Result<RealmInstagramUser, Error>) -> Void)
    func saveUserToBD(user: RealmInstagramUserProtocol, isSavedCompletion: @escaping (Bool) -> Void)
    func changeUserInBD(user: RealmInstagramUserProtocol, isChangedCompletion: @escaping (Bool) -> Void)
    func removeUserFromBD(user: RealmInstagramUserProtocol, isDeletedCompletion: @escaping (Bool) -> Void)
}

final class UsersRepository {

    // MARK: - Private properties
    private let localDataSource: UsersDataSourceProtocol

    // MARK: - Init
    init(localDataSource: UsersDataSourceProtocol) {
        self.localDataSource = localDataSource
    }

}

// MARK: - extension + RecentUsersRepositoryProtocol
extension UsersRepository: UsersRepositoryProtocol {
    func fetchUserWithPrimaryKey(primaryKey: Int, completion: @escaping (Result<RealmInstagramUser, Error>) -> Void) {
        localDataSource.fetchUserWithPrimaryKey(primaryKey: primaryKey, completion: completion)
    }

    func removeUserFromBD(user: RealmInstagramUserProtocol, isDeletedCompletion: @escaping (Bool) -> Void) {
        localDataSource.removeUserFromBD(user: user, isDeletedCompletion: isDeletedCompletion)
    }

    func changeUserInBD(user: RealmInstagramUserProtocol, isChangedCompletion: @escaping (Bool) -> Void) {
        localDataSource.changeUserInBD(user: user, isChangedCompletion: isChangedCompletion)
    }

    func saveUserToBD(user: RealmInstagramUserProtocol, isSavedCompletion: @escaping (Bool) -> Void) {
        localDataSource.saveUserToBD(user: user, isSavedCompletion: isSavedCompletion)
    }

    func fetchUsersFromBD(userType: UserType,
                          completion: @escaping ([RealmInstagramUserProtocol]) -> Void) {
        localDataSource.fetchUsersFromBD(userType: userType,
                                         completion: completion)
    }
}
