//
//  Errors.swift
//  InstagramStories
//
//  Created by Борис on 10.12.2021.
//

import Foundation

enum Errors {
    case networkIsNotAvailable
    case noSecretIntoKeychainStorage
    case needTwoFactorAuth
    case somethingWrongWithAuth
    case cantSaveSecret
    case urlNotValid
    case cantDownloadStory
    case cantFetchUserProfile
    case cantFetchUsers
    case noUserInDataBase
    
    var error: NSError {
        switch self {
        case .networkIsNotAvailable:
            return NSError(domain: "Network is not available", code: 0)
        case .noSecretIntoKeychainStorage:
            return NSError(domain: "Error with getting secret from KeychainStorage", code: 1)
        case .needTwoFactorAuth:
            return NSError(domain: "Need two factor auth", code: 2)
        case .somethingWrongWithAuth:
            return NSError(domain: "Something wrong with auth", code: 3)
        case .cantSaveSecret:
            return NSError(domain: "Cant save secret", code: 4)
        case .urlNotValid:
            return NSError(domain: "URL is not valid", code: 5)
        case .cantDownloadStory:
            return NSError(domain: "Cant download story", code: 6)
        case .cantFetchUserProfile:
            return NSError(domain: "Cant fetch user profile", code: 7)
        case .cantFetchUsers:
            return NSError(domain: "Cant fetch users", code: 8)
        case .noUserInDataBase:
            return NSError(domain: "No user in dataBase", code: 9)
        }
    }
}
