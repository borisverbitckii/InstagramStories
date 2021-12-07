//
//  SearchModuleAssembly.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import Swinject

final class SearchModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SearchBuilder.self) { resolver in
            let dataServicesFacade = resolver.resolve(DataServicesFacadeProtocol.self)
            return SearchBuilder(dataServiceFacade: dataServicesFacade!)
        }
    }
}
