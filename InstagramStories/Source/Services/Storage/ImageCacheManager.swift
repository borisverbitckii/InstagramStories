//
//  ImageCacheManager.swift
//  InstagramStories
//
//  Created by Борис on 10.12.2021.
//

import UIKit.UIImage

protocol ImageCacheManagerProtocol {
    func saveImageToCache(imageData: Data, response: URLResponse)
    func getCacheImage(stringURL: String) -> Data?
}

final class ImageCacheManager: ImageCacheManagerProtocol {

    static func isAlreadyCached(stringURL: String) -> Bool {
        guard let url = URL(string: stringURL) else { return false }
        if URLCache.shared.cachedResponse(for: URLRequest(url: url)) != nil {
            return true
        }
        return false
    }

    func saveImageToCache(imageData: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: imageData)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }

    func getCacheImage(stringURL: String) -> Data? {
        guard let url = URL(string: stringURL) else { return nil }
        if let cacheResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            return cacheResponse.data
        }

        return nil
    }
}
