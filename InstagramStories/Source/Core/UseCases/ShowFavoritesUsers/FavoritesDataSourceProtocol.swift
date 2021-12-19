//
//  FavoritesDataSourceProtocol.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Foundation

protocol FavoritesDataSourceProtocol {
    func getInstagramUsers(completion: @escaping (Result<[InstagramUser], Error>)->())
}
