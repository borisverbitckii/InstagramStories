//
//  PreferencesViewControllerUseCase.swift
//  InstagramStories
//
//  Created by Борис on 08.12.2021.
//

import Foundation

protocol PreferencesUseCaseProtocol {
    func getMenuItems(completion: @escaping (Result<[Setting], Error>) -> ())
}

final class PreferencesViewControllerUseCase: UseCase, PreferencesUseCaseProtocol {
    func getMenuItems(completion: @escaping (Result<[Setting], Error>) -> ()) {
        completion(.success([Setting(name: "Общие"), Setting(name: "Настройка ленты постов")]))
    }
}
