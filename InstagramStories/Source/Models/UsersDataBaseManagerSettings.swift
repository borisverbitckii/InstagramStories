//
//  UsersDataBaseManagerSettings.swift
//  InstagramStories
//
//  Created by Борис on 29.12.2021.
//

import Foundation

struct UsersDataBaseManagerSettings: DataManagerSettingsProtocol {
    var type: DataBaseOperationType?
    var user: RealmInstagramUserProtocol?
    var primaryKey: Int?
    var sortingSettings: SortingSettings?
    var predicate: NSPredicate?
}

enum UserType {
    case recent
    case favorite
}

struct SortingSettings {
    var sortingKeyPath: String
    var ascending: Bool
}
