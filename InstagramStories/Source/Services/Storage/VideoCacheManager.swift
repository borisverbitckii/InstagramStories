//
//  VideoCacheManager.swift
//  InstagramStories
//
//  Created by Борис on 25.12.2021.
//

import Foundation

protocol VideoCacheManagerProtocol {
    func directoryFor(stringUrl: String) -> URL
    func fileExists(atPath: String) -> Bool
}

final class VideoCacheManager {
    
    static let shared = VideoCacheManager()
    
    //MARK: - Private properties
    private let fileManager = FileManager.default
    private lazy var mainDirectoryUrl: URL = {
        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsUrl
    }()
}

//MARK: - extension + VideoCacheManagerProtocol
extension VideoCacheManager: VideoCacheManagerProtocol {
    func directoryFor(stringUrl: String) -> URL {
        guard let url = URL(string: stringUrl) else { return URL(fileReferenceLiteralResourceName: "")}
        let fileURL = url.lastPathComponent
        let file = self.mainDirectoryUrl.appendingPathComponent(fileURL)
        return file
    }
    
    func fileExists(atPath: String) -> Bool {
        fileManager.fileExists(atPath: atPath)
    }
}
