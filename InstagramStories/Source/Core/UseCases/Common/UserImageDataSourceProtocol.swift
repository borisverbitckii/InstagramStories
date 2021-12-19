//
//  UserImageDataSourceProtocol.swift
//  InstagramStories
//
//  Created by Борис on 18.12.2021.
//

import UIKit

protocol UserImageDataSourceProtocol {
    func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>)->())
}
