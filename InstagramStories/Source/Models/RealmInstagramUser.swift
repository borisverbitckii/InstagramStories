//
//  RealmInstagramUser.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import Foundation
import RealmSwift

protocol RealmInstagramUserProtocol {
    var name: String { get set }
    var date: Date { get set }
    var profileDescription: String { get set }
    var instagramUsername: String { get set }
    var id: Int { get set }
    var userIconURL: String { get set }
    var posts: Int { get set }
    var subscribers: Int { get set }
    var subscription: Int { get set }
    var isPrivate: Bool { get set }
    var isOnFavorite: Bool { get set }
    var isRecent: Bool { get set }
    
}

struct InstagramUser: RealmInstagramUserProtocol {
    //MARK: - Public properties
    var name: String
    var date: Date
    var profileDescription: String
    var instagramUsername: String
    var id: Int
    var userIconURL: String
    var posts: Int
    var subscribers: Int
    var subscription: Int
    var isPrivate: Bool
    var isOnFavorite: Bool
    var isRecent: Bool
    
    //MARK: - Init
    init(instagramUser: RealmInstagramUser) {
        self.name = instagramUser.name
        self.date = instagramUser.date
        self.profileDescription = instagramUser.profileDescription
        self.instagramUsername = instagramUser.instagramUsername
        self.id = instagramUser.id
        self.userIconURL = instagramUser.userIconURL
        self.posts = instagramUser.posts
        self.subscribers = instagramUser.subscribers
        self.subscription = instagramUser.subscription
        self.isPrivate = instagramUser.isPrivate
        self.isOnFavorite = instagramUser.isOnFavorite
        self.isRecent = instagramUser.isRecent
    }
    
    init(name: String,
         profileDescription: String,
         instagramUsername: String,
         id: Int,
         userIconURL: String,
         posts: Int,
         subscribers: Int,
         subscription: Int,
         isPrivate: Bool,
         isOnFavorite: Bool,
         isRecent: Bool) {
        self.name               = name
        self.date               = Date()
        self.profileDescription = profileDescription
        self.instagramUsername  = instagramUsername
        self.id                 = id
        self.userIconURL        = userIconURL
        self.posts              = posts
        self.subscribers        = subscribers
        self.subscription       = subscription
        self.isPrivate          = isPrivate
        self.isOnFavorite       = isOnFavorite
        self.isRecent           = isRecent
    }
    
}

final class RealmInstagramUser: Object, RealmInstagramUserProtocol {
    
    //MARK: - Public properties
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    @objc dynamic var profileDescription = ""
    @objc dynamic var instagramUsername = ""
    @objc dynamic var id = 0
    @objc dynamic var userIconURL = ""
    @objc dynamic var posts = 0
    @objc dynamic var subscribers = 0
    @objc dynamic var subscription = 0
    @objc dynamic var isPrivate = false
    @objc dynamic var isOnFavorite = false
    @objc dynamic var isRecent = false
    
    //MARK: - Init
    convenience init(name: String,
         profileDescription: String,
         instagramUsername: String,
         id: Int,
         userIconURL: String,
         posts: Int,
         subscribers: Int,
         subscription: Int,
         isPrivate: Bool,
         isOnFavorite: Bool,
         isRecent: Bool) {
        self.init()
        self.name               = name
        self.profileDescription = profileDescription
        self.instagramUsername  = instagramUsername
        self.id                 = id
        self.userIconURL        = userIconURL
        self.posts              = posts
        self.subscribers        = subscribers
        self.subscription       = subscription
        self.isPrivate          = isPrivate
        self.isOnFavorite       = isOnFavorite
        self.isRecent           = isRecent
    }
    
    convenience init(user: RealmInstagramUserProtocol) {
        self.init()
        self.name               = user.name
        self.profileDescription = user.profileDescription
        self.instagramUsername  = user.instagramUsername
        self.id                 = user.id
        self.userIconURL        = user.userIconURL
        self.posts              = user.posts
        self.subscribers        = user.subscribers
        self.subscription       = user.subscription
        self.isPrivate          = user.isPrivate
        self.isOnFavorite       = user.isOnFavorite
        self.isRecent           = user.isRecent
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
