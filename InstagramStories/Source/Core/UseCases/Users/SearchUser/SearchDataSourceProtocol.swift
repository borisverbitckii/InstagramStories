//
//  SearchDataSourceProtocol.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Swiftagram
import RealmSwift

protocol SearchDataSourceProtocol {
    func fetchInstagramUsers(searchingTitle: String,
                             secret: Secret,
                             completion: @escaping (Result <[InstagramUser], Error>)->())
    func fetchUserProfile(id: Int,
                          secret: Secret,
                          completion: @escaping (Result<AdditionalUserDetails, Error>) -> ())
    func stopLastOperation()
}
