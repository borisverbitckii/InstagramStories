//
//  Preferences.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

struct Preferences {}

//MARK: - extension + PreferencesDataSourceProtocol
extension Preferences: PreferencesDataSourceProtocol {
    func getMenuItems(completion: @escaping (Result<[Setting], Error>) -> ()) {
        completion(.success([Setting(name: "Общие"), Setting(name: "Настройка ленты постов")]))
    }
}
