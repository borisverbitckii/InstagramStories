//
//  DataServicesFacadeModuleAssembly.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import Swinject

final class DataServicesFacadeModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DataBaseManagerProtocol.self) { _ in
            return DataBaseManager()
        }
        
        container.register(NetworkManagerProtocol.self) { _ in
            return NetworkManager()
        }
        
        container.register(ReachabilityManagerProtocol.self) { _ in
            return ReachabilityManager()
        }
        
        container.register(DataServicesFacadeProtocol.self) { resolver in
            let reachabilityManager = resolver.resolve(ReachabilityManagerProtocol.self)
            let networkManager = resolver.resolve(NetworkManagerProtocol.self)
            let dataBaseManager = resolver.resolve(DataBaseManagerProtocol.self)
            return DataServicesFacade(reachabilityManager: reachabilityManager!, networkManager: networkManager!, dataBaseManager: dataBaseManager!)
        }
    }
}
