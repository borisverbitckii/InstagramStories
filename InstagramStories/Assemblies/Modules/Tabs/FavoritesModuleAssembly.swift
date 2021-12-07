//
//  FavoritesModuleAssembly.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import Swinject

final class FavoritesModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FavoritesBuilder.self) { resolver in
            let dataServiceFacade = resolver.resolve(DataServicesFacadeProtocol.self)
            return FavoritesBuilder(dataServiceFacade: dataServiceFacade!)
        }
    }
}
