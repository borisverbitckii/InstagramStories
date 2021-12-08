//
//  AppAssembly.swift
//  InstagramStories
//
//  Created by Борис on 08.12.2021.
//

import Foundation

final class AppAssembly {
    
    //MARK: - Private methods
    private let coordinator: Coordinator
    private let managerFactory: ManagerFactory
    private let dataServiceFacade: DataServicesFacade
    private let moduleFactory: ModuleFactory
    
    //MARK: - Init
    init() {
        self.managerFactory = ManagerFactory()
        self.dataServiceFacade = DataServicesFacade(managerFactory: managerFactory)
        self.moduleFactory = ModuleFactory(dataServiceFacade: dataServiceFacade)
        self.coordinator = Coordinator(moduleFactory: moduleFactory)
        self.moduleFactory.injectCoordinator(coordinator: coordinator)
        coordinator.start()
    }
}
