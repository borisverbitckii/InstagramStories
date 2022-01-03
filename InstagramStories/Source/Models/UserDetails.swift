//
//  UserDetails.swift
//  InstagramStories
//
//  Created by Борис on 03.01.2022.
//

struct UserDetails {
    let title: String
    let instagramUsername: String
    var additionalUserDetails: AdditionalUserDetails?
}

struct AdditionalUserDetails {
    let description: String
    var subscription: Int?
    var subscribers: Int?
    var posts: Int?
}
