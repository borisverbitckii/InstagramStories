//
//  PreferencesDataSourceProtocol.swift
//  InstagramStories
//
//  Created by Борис on 19.12.2021.
//

protocol PreferencesDataSourceProtocol {
    func getMenuItems(completion: @escaping (Result<[Setting], Error>) -> ())
}
