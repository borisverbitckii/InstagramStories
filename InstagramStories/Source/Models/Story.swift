//
//  InstagramUser.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import Foundation

struct Story {
    //MARK: - Public properties
    let time: Int
    let previewImageURL: String
    let contentURLString: String
    
    //MARK: - Init
    
    init(time: Int,
         previewImageURL: String,
         contentURL: String) {
        self.time = time
        self.previewImageURL = previewImageURL
        self.contentURLString = contentURL
    }
}
