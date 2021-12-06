//
//  DataBaseManager.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

protocol DataBaseManagerProtocol {
    func fetchInstagramUsers(completion: @escaping (Result<[InstagramUser], Error>)->())
    func saveDataToDB(_ users: [InstagramUser])
    func removeDataFromDB()
}

final class DataBaseManager: DataBaseManagerProtocol {
    
    func fetchInstagramUsers(completion: @escaping (Result<[InstagramUser], Error>)->()) {
        let realmInstagramUsers = [RealmInstagramUser]()
        let instagramUsers = realmInstagramUsers.map { InstagramUser(instagramUser: $0) }
        completion(.success(instagramUsers))
    }
    
    func saveDataToDB(_ users: [InstagramUser]) {
        let _ = users.map { RealmInstagramUser(instagramUser: $0)}
    }
    
    func removeDataFromDB() {
    }
}
