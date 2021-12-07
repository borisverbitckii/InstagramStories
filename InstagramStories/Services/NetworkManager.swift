//
//  NetworkManager.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchInstagramUsers<T: Decodable>(username: String, completion: @escaping (Result<[T], Error>)->())
}

final class NetworkManager: NetworkManagerProtocol {
    func fetchInstagramUsers<T: Decodable>(username: String, completion: @escaping (Result<[T], Error>)->()){
        // create request with username
        let urlRequest = URLRequest(url: URL(string: "https://www.yandex.ru")!) // fix force unwrap
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let users = try JSONDecoder().decode([T].self, from: data)
                completion(.success(users))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
}
