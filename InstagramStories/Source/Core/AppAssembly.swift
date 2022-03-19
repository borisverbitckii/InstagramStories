//
//  AppAssembly.swift
//  InstagramStories
//
//  Created by Борис on 08.12.2021.
//

import Foundation

final class AppAssembly {

    // MARK: - Private methods
    private let coordinator: Coordinator
    private let managerFactory: ManagerFactoryProtocol
    private let dataSourceFactory: DataSourceFactoryProtocol
    private let repositoryFactory: RepositoryFactoryProtocol
    private let useCasesFactory: UseCaseFactoryProtocol
    private let moduleFactory: ModuleFactory

    // MARK: - Init
    init() {
        self.managerFactory = ManagerFactory()
        self.dataSourceFactory = DataSourceFactory(managerFactory: managerFactory)
        self.repositoryFactory = RepositoryFactory(dataSourceFactory: dataSourceFactory)
        self.useCasesFactory = UseCasesFactory(managerFactory: managerFactory,
                                               repositoryFactory: repositoryFactory)
        self.moduleFactory = ModuleFactory(useCasesFactory: useCasesFactory)
        self.coordinator = Coordinator(moduleFactory: moduleFactory)
        self.moduleFactory.injectCoordinator(coordinator: coordinator)
        coordinator.start()
    }
}
