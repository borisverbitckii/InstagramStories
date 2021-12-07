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
            let dataServiceFacade = resolver.resolve(DataServicesFacadeProtocol.self)
            return PreferencesBuilder(dataServiceFacade: dataServiceFacade!)
        }
    }
}
