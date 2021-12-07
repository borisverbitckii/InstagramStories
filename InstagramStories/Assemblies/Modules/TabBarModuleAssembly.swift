//
//  TabBarModuleAssembly.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import Swinject

final class TabBarModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(TabBarViewController.self) { resolver in
            let searchBuilder = resolver.resolve(SearchBuilder.self)
            let favoritesViewController = resolver.resolve(FavoritesBuilder.self)
            
            return TabBarViewController(searchViewController: searchBuilder!.build(),
                                        favoritesViewController: favoritesViewController!.build())
        }
    }
}
