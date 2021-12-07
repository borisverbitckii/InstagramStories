//
//  File.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import Swinject

final class PresentationModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PresentationBuilder.self) { resolver in
            let dataServiceFacade = resolver.resolve(DataServicesFacade.self)
            return PresentationBuilder(dataServiceFacade: dataServiceFacade!)
        }
    }
}
