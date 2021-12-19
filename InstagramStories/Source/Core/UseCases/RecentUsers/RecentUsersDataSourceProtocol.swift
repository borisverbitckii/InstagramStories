//
//  RecentUsersDataSourceProtocol.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Foundation

protocol RecentUsersDataSourceProtocol {
    func getInstagramUsers(completion: @escaping (Result<[InstagramUser], Error>)->())
    func removeUserFromDB()
}
