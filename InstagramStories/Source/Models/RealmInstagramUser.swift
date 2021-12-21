//
//  RealmInstagramUser.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import Foundation
import RealmSwift

final class RealmInstagramUser: Object {
    
    //MARK: - Public properties
    @objc dynamic let name: String
    @objc dynamic let profileDescription: String
    @objc dynamic let instagramUsername: String
    @objc dynamic let id: Int
    @objc dynamic var userIconURL: String
    @objc dynamic let posts: Int
    @objc dynamic let subscribers: Int
    @objc dynamic let subscription: Int
    @objc dynamic let isPrivate: Bool
    @objc dynamic var isOnFavorite: Bool
    @objc dynamic var getNotifications: Bool
    
    //MARK: - Init
    init(instagramUser: InstagramUser) {
        self.name = instagramUser.name
        self.profileDescription = instagramUser.profileDescription
        self.instagramUsername = instagramUser.instagramUsername
        self.id = instagramUser.id
        self.userIconURL = instagramUser.userIconURL
        self.posts = instagramUser.posts
        self.subscribers = instagramUser.subscribers
        self.subscription = instagramUser.subscriptions
        self.isPrivate = instagramUser.isPrivate
        self.isOnFavorite = instagramUser.isOnFavorite
        self.getNotifications = instagramUser.getNotifications
    }
}
