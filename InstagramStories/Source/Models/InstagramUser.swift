//
//  InstagramUser.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import Foundation

struct InstagramUser {
    
    //MARK: - Public properties
    let name: String
    let profileDescription: String
    let instagramUsername: String
    let id: Int
    var userIconURL: String
    let posts: Int
    let subscribers: Int
    let subscriptions: Int
    let isPrivate: Bool
    var isOnFavorite = false
    var getNotifications = false
    
    //MARK: - Init
    
    init(instagramUser: RealmInstagramUser) {
        self.name = instagramUser.name
        self.profileDescription = instagramUser.profileDescription
        self.instagramUsername = instagramUser.instagramUsername
        self.id = instagramUser.id
        self.userIconURL = instagramUser.userIconURL
        self.posts = instagramUser.posts
        self.subscribers = instagramUser.subscribers
        self.subscriptions = instagramUser.subscription
        self.isPrivate = instagramUser.isPrivate
        self.isOnFavorite = instagramUser.isOnFavorite
        self.getNotifications = instagramUser.getNotifications
    }
    
    init(name: String,
         profileDescription: String,
         instagramUsername: String,
         id: Int,
         userIconURL: String,
         posts: Int,
         subscribers: Int,
         subscriptions: Int,
         isPrivate: Bool) {

        self.name = name
        self.profileDescription = profileDescription
        self.instagramUsername = instagramUsername
        self.id = id
        self.userIconURL = userIconURL
        self.posts = posts
        self.subscribers = subscribers
        self.subscriptions = subscriptions
        self.isPrivate = isPrivate
        self.isOnFavorite = false
        self.getNotifications = false
    }
}

enum StoryType {
    case photo
    case video
}

struct Story {
    //MARK: - Public properties
    let time: Int
    let type: StoryType
    let previewImageURL: String
    let contentURLString: String
    var contentURL: URL?
    
    //MARK: - Init
    
    init(time: Int,
         type: StoryType,
         previewImageURL: String,
         contentURL: String,
         content: URL? = nil) {
        self.time = time
        self.type = type
        self.previewImageURL = previewImageURL
        self.contentURLString = contentURL
        self.contentURL = content
    }
}
