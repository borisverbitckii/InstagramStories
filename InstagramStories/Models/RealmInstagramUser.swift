//
//  RealmInstagramUser.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import RealmSwift

final class RealmInstagramUser: Object {
    
    //MARK: - Public properties
    @objc dynamic let name: String
    @objc dynamic let instagramUsername: String
    @objc dynamic let userIcon: Data
    @objc dynamic let posts: Int
    @objc dynamic let subscribers: Int
    @objc dynamic let subscription: Int
    @objc dynamic var isOnFavorite: Bool
    @objc dynamic var getNotifications: Bool
    
    var stories: [RealmStory]?
    
    //MARK: - Init
    init(instagramUser: InstagramUser) {
        self.name = instagramUser.name
        self.instagramUsername = instagramUser.instagramUsername
        self.userIcon = instagramUser.userIcon
        self.posts = instagramUser.posts
        self.subscribers = instagramUser.subscribers
        self.subscription = instagramUser.subscriptions
        self.isOnFavorite = instagramUser.isOnFavorite
        self.getNotifications = instagramUser.getNotifications
        
        guard let stories = instagramUser.stories else { return }
        self.stories = stories.map({ RealmStory(story: $0)})
    }
}

final class RealmStory: Object {
    
    //MARK: - Public methods
    @objc dynamic let time: Int
    @objc dynamic let content: Data
    @objc dynamic let isFavorite: Bool
    
    //MARK: - Init
    init(story: Story) {
        self.time = story.time
        self.content = story.content
        self.isFavorite = story.isFavorite
    }
}
