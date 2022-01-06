//
//  RecentUsersRepository.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

protocol UsersRepositoryProtocol {
    func fetchUsersFromBD(userType: UserType,
                          completion: @escaping ([RealmInstagramUserProtocol])->())
    func fetchUserWithPrimaryKey(primaryKey: Int, completion: @escaping (Result<RealmInstagramUser, Error>) -> ())
    func saveUserToBD(user: RealmInstagramUserProtocol, isSavedCompletion: @escaping (Bool)->())
    func changeUserInBD(user: RealmInstagramUserProtocol, isChangedCompletion: @escaping (Bool)->())
    func removeUserFromBD(user: RealmInstagramUserProtocol, isDeletedCompletion: @escaping (Bool)->())
}

final class UsersRepository {
    
    //MARK: - Private properties
    private let localDataSource: UsersDataSourceProtocol
    
    //MARK: - Init
    init(localDataSource: UsersDataSourceProtocol){
        self.localDataSource = localDataSource
    }
    
}

//MARK: - extension + RecentUsersRepositoryProtocol
extension UsersRepository: UsersRepositoryProtocol {
    func fetchUserWithPrimaryKey(primaryKey: Int, completion: @escaping (Result<RealmInstagramUser, Error>) -> ()) {
        localDataSource.fetchUserWithPrimaryKey(primaryKey: primaryKey, completion: completion)
    }
    
    func removeUserFromBD(user: RealmInstagramUserProtocol, isDeletedCompletion: @escaping (Bool)->()) {
        localDataSource.removeUserFromBD(user: user, isDeletedCompletion: isDeletedCompletion)
    }
    
    func changeUserInBD(user: RealmInstagramUserProtocol, isChangedCompletion: @escaping (Bool)->()) {
        localDataSource.changeUserInBD(user: user, isChangedCompletion: isChangedCompletion)
    }
    
    func saveUserToBD(user: RealmInstagramUserProtocol, isSavedCompletion: @escaping (Bool)->()) {
        localDataSource.saveUserToBD(user: user, isSavedCompletion: isSavedCompletion)
    }
    
    func fetchUsersFromBD(userType: UserType,
                          completion: @escaping ([RealmInstagramUserProtocol])->()) {
        localDataSource.fetchUsersFromBD(userType: userType,
                                         completion: completion)
    }
}
