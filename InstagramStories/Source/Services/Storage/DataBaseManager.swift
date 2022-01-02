//
//  DataBaseManager.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import RealmSwift
import Foundation

enum DataBaseOperationType {
    case save
    case delete
    case update
    case getUsers
    case getUserWithPrimaryKey
}

protocol DataManagerSettingsProtocol {
    var type: DataBaseOperationType? { get }
    var user: RealmInstagramUserProtocol? { get }
    var primaryKey: Int? { get }
    var sortingSettings: SortingSettings? { get }
    var predicate: NSPredicate? { get }
}

protocol DataBaseManagerProtocol: ManagerProtocol {
    func executeDBOperation<T:DataManagerSettingsProtocol, Y>(settings: T,completion: @escaping (Result<Y, Error>)->())
}

enum UserState {
    case onlyExist
    case onlyOnFavorites
    case onlyOnRecents
    case onFavoritesAndRecents
}

final class DataBaseManager {
    
    //MARK: - Private properties
    private let realm = try! Realm()
    
    //MARK: - Public methods
    static func isAlreadyExist(user: RealmInstagramUserProtocol) -> Bool {
        let searchedUser = try! Realm().object(ofType: RealmInstagramUser.self, forPrimaryKey: user.id)
        return searchedUser != nil
    }
    
    static func isOnFavorite(user: RealmInstagramUserProtocol) -> Bool {
        let searchedUser = try! Realm().object(ofType: RealmInstagramUser.self, forPrimaryKey: user.id)
        return searchedUser?.isOnFavorite ?? false
    }
    
    static func isRecent(user: RealmInstagramUserProtocol) -> Bool {
        let searchedUser = try! Realm().object(ofType: RealmInstagramUser.self, forPrimaryKey: user.id)
        return searchedUser?.isRecent ?? false
    }
}

//MARK: - extension + DataBaseManagerProtocol, UsersDataSourceProtocol
extension DataBaseManager : DataBaseManagerProtocol {
    
    func executeDBOperation<T:DataManagerSettingsProtocol, Y>(settings: T,completion: @escaping (Result<Y, Error>)->()) {
        let type = settings.type
        guard Y.self == Bool.self else {
            if type == .getUsers {
                if Y.self == [RealmInstagramUserProtocol].self,
                   let predicate = settings.predicate {
                    let users = realm.objects(RealmInstagramUser.self)
                        .filter(predicate)
                        .sorted(byKeyPath: settings.sortingSettings?.sortingKeyPath ?? "",
                                ascending: settings.sortingSettings?.ascending ?? true
                        )
                    
                    var finalUsers = [RealmInstagramUserProtocol]()
                    for user in users {
                        finalUsers.append(InstagramUser(instagramUser: user))
                    }
                    guard let finalUsers = finalUsers as? Y else { return }
                    completion(.success(finalUsers))
                }
                return
            }
            if type == .getUserWithPrimaryKey {
                if Y.self == RealmInstagramUser.self {
                    guard let primaryKey = settings.primaryKey else { return }
                    guard let user = realm.object(ofType: RealmInstagramUser.self, forPrimaryKey: primaryKey) as? Y else {
                        completion(.failure(Errors.noUserInDataBase.error))
                        return }
                    completion(.success(user))
                }
                return
            }
            return
        }
        
        switch settings.type {
        case .save:
            do {
                try realm.write({
                    if let user = settings.user{
                        let realmUser = RealmInstagramUser(user: user)
                        realm.add(realmUser)
                        guard let result = true as? Y else { return }
                        completion(.success(result))
                    }
                })
            } catch {
                completion(.failure(error))
            }
        case .delete:
            do {
                try realm.write({
                    if let user = settings.user {
                        guard let realmUser = realm.object(ofType: RealmInstagramUser.self, forPrimaryKey: user.id) else { return }
                        realm.delete(realmUser)
                        guard let result = true as? Y else { return }
                        completion(.success(result))
                    }
                })
            } catch {
                completion(.failure(error))
            }
        case .update:
            do {
                if let user = settings.user {
                    let userToUpdate = realm.object(ofType: RealmInstagramUser.self, forPrimaryKey: user.id)
                    try realm.write({
                        
                        userToUpdate?.name = user.name
                        userToUpdate?.date = user.date
                        userToUpdate?.profileDescription = user.profileDescription
                        userToUpdate?.instagramUsername = user.instagramUsername
                        userToUpdate?.userIconURL = user.userIconURL
                        userToUpdate?.posts = user.posts
                        userToUpdate?.subscribers = user.subscribers
                        userToUpdate?.subscription = user.subscription
                        userToUpdate?.isPrivate = user.isPrivate
                        userToUpdate?.isRecent = user.isRecent // fix this because of data model
                        userToUpdate?.isOnFavorite = user.isOnFavorite
                        
                        guard let result = true as? Y else { return }
                        completion(.success(result))
                    })
                }
            } catch {
                completion(.failure(error))
            }
        default: break
        }
    }
}
