//
//  CredentialsDataSource.swift
//  InstaStories
//
//  Created by Борис on 07.02.2022.
//

import Foundation
import Firebase

protocol CredentialsDataSourceProtocol {
    func fetchCredentials(completion: @escaping ([String:String]) -> ())
    func removeCredentials(pathString: String)
}

final class CredentialsDataSource {
    
    //MARK: - Private properties
    private let fireBaseManager: FireBaseManagerProtocol
    
    //MARK: - Init
    init(fireBaseManager: FireBaseManagerProtocol) {
        self.fireBaseManager = fireBaseManager
    }
    
}

//MARK: - extension + CredentialsDataSourceProtocol
extension CredentialsDataSource: CredentialsDataSourceProtocol {
    func fetchCredentials(completion: @escaping ([String:String]) -> ()) {
        fireBaseManager.fetchCredentials(completion: completion)
    }
    
    func removeCredentials(pathString: String) {
        fireBaseManager.removeCredentials(pathString: pathString)
    }
}
