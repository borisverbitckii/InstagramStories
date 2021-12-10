//
//  InstagramUser.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import Foundation

struct InstagramUser: Decodable {
    
    //MARK: - Public properties
    let name: String
    let instagramUsername: String
    let userIcon: Data
    let posts: Int
    let subscribers: Int
    let subscriptions: Int
    var isOnFavorite = false
    var getNotifications = false
    
    let stories: [Story]?
    
    //MARK: - Init
    enum CodingKeys: String,CodingKey {
        case name,instagramUsername, userIcon, posts, subscribers, subscribe, isOnFavorite, getNotifications, stories
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        instagramUsername = try container.decode(String.self, forKey: .instagramUsername)
        userIcon = try container.decode(Data.self, forKey: .userIcon)
        posts = try container.decode(Int.self, forKey: .posts)
        subscribers = try container.decode(Int.self, forKey: .subscribers)
        subscriptions = try container.decode(Int.self, forKey: .subscribe)
        isOnFavorite = try container.decode(Bool.self, forKey: .isOnFavorite)
        getNotifications = try container.decode(Bool.self, forKey: .getNotifications)
        
        stories = try container.decodeIfPresent([Story].self, forKey: .stories)
    }
    
    init(instagramUser: RealmInstagramUser) {
        self.name = instagramUser.name
        self.instagramUsername = instagramUser.instagramUsername
        self.posts = instagramUser.posts
        self.subscribers = instagramUser.subscribers
        self.subscriptions = instagramUser.subscription
        self.isOnFavorite = instagramUser.isOnFavorite
        self.getNotifications = instagramUser.getNotifications
        self.userIcon = instagramUser.userIcon
        
        guard let stories = instagramUser.stories else {
            self.stories = nil
            return
        }

        self.stories = stories.map({ Story(realmStory: $0)})
    }
    
    init(name: String,
         instagramUsername: String,
         userIcon: Data,
         posts: Int,
         subscribers: Int,
         subscriptions: Int,
         isOnFavorite: Bool,
         getNotifications: Bool,
         stories: [Story]) {

        self.name = name
        self.instagramUsername = instagramUsername
        self.userIcon = userIcon
        self.posts = posts
        self.subscribers = subscribers
        self.subscriptions = subscriptions
        self.isOnFavorite = isOnFavorite
        self.getNotifications = getNotifications
        self.stories = stories
    }
}

struct Story: Decodable {
    //MARK: - Public properties
    let time: Int
    let content: Data
    let isFavorite: Bool
    
    //MARK: - Init
    init(realmStory: RealmStory) {
        self.time = realmStory.time
        self.content = realmStory.content
        self.isFavorite = realmStory.isFavorite
    }
}
