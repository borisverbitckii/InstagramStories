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
    let posts: Int
    let subscribers: Int
    let subscriptions: Int
    var isOnFavorite = false
    var getNotifications = false
    
    let stories: [Story]
    
    //MARK: - Init
    enum CodingKeys: String,CodingKey {
        case name,instagramUsername, posts, subscribers, subscribe, isOnFavorite, getNotifications, stories
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        instagramUsername = try container.decode(String.self, forKey: .instagramUsername)
        posts = try container.decode(Int.self, forKey: .posts)
        subscribers = try container.decode(Int.self, forKey: .subscribers)
        subscriptions = try container.decode(Int.self, forKey: .subscribe)
        isOnFavorite = try container.decode(Bool.self, forKey: .isOnFavorite)
        getNotifications = try container.decode(Bool.self, forKey: .getNotifications)
        
        stories = try container.decode([Story].self, forKey: .stories)
    }
    
    init(instagramUser: RealmInstagramUser) {
        self.name = instagramUser.name
        self.instagramUsername = instagramUser.instagramUsername
        self.posts = instagramUser.posts
        self.subscribers = instagramUser.subscribers
        self.subscriptions = instagramUser.subscription
        self.isOnFavorite = instagramUser.isOnFavorite
        self.getNotifications = instagramUser.getNotifications
        
        self.stories = instagramUser.stories.map({ Story(realmStory: $0)})
    }
}

struct Story: Decodable {
    //MARK: - Public properties
    let time: Int
    let content: Data
    
    //MARK: - Init
    init(realmStory: RealmStory) {
        self.time = realmStory.time
        self.content = realmStory.content
    }
}
