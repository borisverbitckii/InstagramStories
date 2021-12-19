//
//  UserImageDataSourceProtocol.swift
//  InstagramStories
//
//  Created by Борис on 18.12.2021.
//

import Foundation
import Swiftagram

protocol UserImageDataSourceProtocol {
    func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>)->())
}
