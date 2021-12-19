//
//  AuthDataSourceProtocol.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

import Swiftagram

protocol AuthDataSourceProtocol {
    func authInInstagram(username: String, password: String, completion: @escaping (Result<Secret,Error>) -> ())
    func checkAuthorization(completion: @escaping(Secret?)->())
}
 
