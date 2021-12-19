//
//  SearchDataSourceProtocol.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Swiftagram

protocol SearchDataSourceProtocol {
    func fetchInstagramUsers(searchingTitle: String,
                             secret: Secret,
                             completion: @escaping (Result<[InstagramUser], Error>)->())
    func stopLastOperation()
}
