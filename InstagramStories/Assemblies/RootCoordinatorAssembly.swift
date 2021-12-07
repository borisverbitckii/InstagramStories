//
//  RootCoordinatorAssembly.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import Swinject

final class RootCoordinatorAssembly: Assembly {
    func assemble(container: Container) {
        container.register(RootCoordinator.self) { resolver in
            let tabBarController = resolver.resolve(TabBarViewController.self)
            let presentationBuilder = resolver.resolve(PreferencesBuilder.self)
            return RootCoordinator(tabBarController: tabBarController!, presentationViewController: presentationBuilder!.build())
        }
    }
}
