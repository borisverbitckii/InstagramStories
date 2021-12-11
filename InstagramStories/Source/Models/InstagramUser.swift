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
    let instagramUsername: String
    let id: Int
    var userIconURL: String
    let posts: Int
    let subscribers: Int
    let subscriptions: Int
    let isPrivate: Bool
    var isOnFavorite = false
    var getNotifications = false
    
    let stories: [Story]?
    
    //MARK: - Init
    
    init(instagramUser: RealmInstagramUser) {
        self.name = instagramUser.name
        self.instagramUsername = instagramUser.instagramUsername
        self.id = instagramUser.id
        self.userIconURL = instagramUser.userIconURL
        self.posts = instagramUser.posts
        self.subscribers = instagramUser.subscribers
        self.subscriptions = instagramUser.subscription
        self.isPrivate = instagramUser.isPrivate
        self.isOnFavorite = instagramUser.isOnFavorite
        self.getNotifications = instagramUser.getNotifications
        
        guard let stories = instagramUser.stories else {
            self.stories = nil
            return
        }

        self.stories = stories.map({ Story(realmStory: $0)})
    }
    
    init(name: String,
         instagramUsername: String,
         id: Int,
         userIconURL: String,
         posts: Int,
         subscribers: Int,
         subscriptions: Int,
         isPrivate: Bool,
         stories: [Story]?) {

        self.name = name
        self.instagramUsername = instagramUsername
        self.id = id
        self.userIconURL = userIconURL
        self.posts = posts
        self.subscribers = subscribers
        self.subscriptions = subscriptions
        self.isPrivate = isPrivate
        self.isOnFavorite = false
        self.getNotifications = false
        self.stories = stories
    }
}

struct Story {
    //MARK: - Public properties
    let time: Int
    let content: Data
    
    //MARK: - Init
    init(realmStory: RealmStory) {
        self.time = realmStory.time
        self.content = realmStory.content
    }
    
    init(time: Int,
         content: Data) {
        self.time = time
        self.content = content
    }
}
