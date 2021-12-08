//
//  RootCoordinatorAssembly.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import Swinject

final class RootCoordinatorAssembly: Assembly {
    func assemble(container: Container) {
        container.register(Coordinator.self) { resolver in
            let tabBarController = resolver.resolve(TabBarViewController.self)
            let presentationBuilder = resolver.resolve(PreferencesBuilder.self)
            return Coordinator(tabBarController: tabBarController!, presentationViewController: presentationBuilder!.build())
        }
    }
}
