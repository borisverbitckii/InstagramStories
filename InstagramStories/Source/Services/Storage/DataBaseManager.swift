//
//  DataBaseManager.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

protocol DataBaseManagerProtocol: ManagerProtocol {
    func removeUserFromDB()
}

final class DataBaseManager: DataBaseManagerProtocol {
    
    func saveDataToDB(_ users: [InstagramUser]) {
        let _ = users.map { RealmInstagramUser(instagramUser: $0)}
    }
}

//MARK: - extension + RecentUsersDataSourceProtocol
extension DataBaseManager : RecentUsersDataSourceProtocol, FavoritesDataSourceProtocol {
    func getInstagramUsers(completion: @escaping (Result<[InstagramUser], Error>)->()) {
        let realmInstagramUsers = [RealmInstagramUser]()
        let instagramUsers = realmInstagramUsers.map { InstagramUser(instagramUser: $0) }
        completion(.success(instagramUsers))
    }
    
    func removeUserFromDB() {
    }
}
 
