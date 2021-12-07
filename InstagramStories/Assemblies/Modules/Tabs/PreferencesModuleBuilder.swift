//
//  PreferencesModuleBuilder.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import Swinject

final class PreferencesModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PreferencesBuilder.self) { resolver in
            return PreferencesBuilder()
        }
    }
}
