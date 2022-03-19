//
//  RecentUsersDataSourceProtocol.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Foundation

protocol UsersDataSourceProtocol {
    func fetchUsersFromBD(userType: UserType,
                          completion: @escaping ([RealmInstagramUserProtocol]) -> Void)
    func fetchUserWithPrimaryKey(primaryKey: Int, completion: @escaping (Result<RealmInstagramUser, Error>) -> Void)
    func saveUserToBD(user: RealmInstagramUserProtocol, isSavedCompletion: @escaping (Bool) -> Void)
    func changeUserInBD(user: RealmInstagramUserProtocol, isChangedCompletion: @escaping (Bool) -> Void)
    func removeUserFromBD(user: RealmInstagramUserProtocol, isDeletedCompletion: @escaping (Bool) -> Void)
}

final class UsersDataSource {
    // MARK: - Private properties
    private let dataBaseManager: DataBaseManagerProtocol

    // MARK: - Init
    init(dataBaseManager: DataBaseManagerProtocol) {
        self.dataBaseManager = dataBaseManager
    }
}

// MARK: - extension + UsersDataSourceProtocol
extension UsersDataSource: UsersDataSourceProtocol {

    func fetchUsersFromBD(userType: UserType,
                          completion: @escaping ([RealmInstagramUserProtocol]) -> Void) {

        let predicate: NSPredicate?

        switch userType {
        case .recent:
            predicate = NSPredicate(format: "isRecent == YES")
        case .favorite:
            predicate = NSPredicate(format: "isOnFavorite == YES")
        }

        let settings = UsersDataBaseManagerSettings(
            type: .getUsers,
            sortingSettings: SortingSettings(sortingKeyPath: "date",
                                             ascending: false),
            predicate: predicate)
        dataBaseManager.executeDBOperation(settings: settings) { (result: Result<[RealmInstagramUserProtocol], Error>) -> Void in
            switch result {
            case .success(let users):
                completion(users)
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchUserWithPrimaryKey(primaryKey: Int, completion: @escaping (Result<RealmInstagramUser, Error>) -> Void) {
        let settings = UsersDataBaseManagerSettings(type: .getUserWithPrimaryKey, primaryKey: primaryKey)

        dataBaseManager.executeDBOperation(settings: settings) { (result: Result<RealmInstagramUser, Error>) -> Void in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getUserFromBD(primaryKey: Int, completion: @escaping (RealmInstagramUser) -> Void) {
        let settings = UsersDataBaseManagerSettings(type: .getUserWithPrimaryKey, primaryKey: primaryKey)
        dataBaseManager.executeDBOperation(settings: settings) { (result: Result<RealmInstagramUser, Error>) -> Void in
            switch result {
            case .success(let user):
                completion(user)
            case .failure(let error):
                print(#file, #line, error)
            }
        }
    }

    func saveUserToBD(user: RealmInstagramUserProtocol, isSavedCompletion: @escaping (Bool) -> Void) {
        let settings = UsersDataBaseManagerSettings(
            type: .save,
            user: user)
        dataBaseManager.executeDBOperation(settings: settings) { (result: Result<Bool, Error>) -> Void in
            switch result {
            case .success(let success):
                isSavedCompletion(success)
            case .failure(let error):
                print(error)
            }
        }
    }

    func changeUserInBD(user: RealmInstagramUserProtocol, isChangedCompletion: @escaping (Bool) -> Void) {
        let settings = UsersDataBaseManagerSettings(
            type: .update,
            user: user)
        dataBaseManager.executeDBOperation(settings: settings) { (result: Result<Bool, Error>) -> Void in
            switch result {
            case .success(let success):
                isChangedCompletion(success)
            case .failure(let error):
                print(error)
            }
        }
    }

    func removeUserFromBD(user: RealmInstagramUserProtocol, isDeletedCompletion: @escaping (Bool) -> Void) {
        let settings = UsersDataBaseManagerSettings(
            type: .delete,
            user: user)
        dataBaseManager.executeDBOperation(settings: settings) { (result: Result<Bool, Error>) -> Void in
            switch result {
            case .success(let success):
                isDeletedCompletion(success)
            case .failure(let error):
                print(error)
            }
        }
    }
}
