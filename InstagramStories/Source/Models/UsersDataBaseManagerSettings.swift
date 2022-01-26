//
//  UsersDataBaseManagerSettings.swift
//  InstagramStories
//
//  Created by Борис on 29.12.2021.
//

import Foundation

struct UsersDataBaseManagerSettings: DataManagerSettingsProtocol {
    var type: DataBaseOperationType? = nil
    var user: RealmInstagramUserProtocol? = nil
    var primaryKey: Int? = nil
    var sortingSettings: SortingSettings? = nil
    var predicate: NSPredicate? = nil
}

enum UserType {
    case recent
    case favorite
}

struct SortingSettings {
    var sortingKeyPath: String
    var ascending: Bool
}
