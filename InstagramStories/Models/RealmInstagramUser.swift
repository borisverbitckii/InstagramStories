//
//  RealmInstagramUser.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import Foundation

final class RealmInstagramUser {
    //MARK: - Public properties
    @objc dynamic let name: String
    @objc dynamic let instagramUsername: String
    @objc dynamic let posts: Int
    @objc dynamic let subscribers: Int
    @objc dynamic let subscription: Int
    @objc dynamic var isOnFavorite: Bool
    @objc dynamic var getNotifications: Bool
    
    var stories: [RealmStory]
    
    //MARK: - Init
    init(instagramUser: InstagramUser) {
        self.name = instagramUser.name
        self.instagramUsername = instagramUser.instagramUsername
        self.posts = instagramUser.posts
        self.subscribers = instagramUser.subscribers
        self.subscription = instagramUser.subscriptions
        self.isOnFavorite = instagramUser.isOnFavorite
        self.getNotifications = instagramUser.getNotifications
        
        self.stories = instagramUser.stories.map({ RealmStory(story: $0)})
    }
}

final class RealmStory {
    
    //MARK: - Public methods
    @objc dynamic let time: Int
    @objc dynamic let content: Data
    
    //MARK: - Init
    init(story: Story) {
        self.time = story.time
        self.content = story.content
    }
}
