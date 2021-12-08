//
//  ServicesFacade.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import Foundation.NSError

enum UseCaseType {
    case searchViewController
    case favoritesViewController
    case preferencesViewController
}

protocol UseCasesRepositoryProtocol {
    func getUseCase(type: UseCaseType) -> UseCase
}

final class UseCasesRepository: UseCasesRepositoryProtocol {
    
    //MARK: - Private properties
    private let managerFactory: ManagerFactoryProtocol
    
    //MARK: - Init
    init(managerFactory: ManagerFactoryProtocol){
        self.managerFactory = managerFactory
    }
    
    func getUseCase(type: UseCaseType) -> UseCase {
        switch type {
        case .searchViewController:
            return SearchViewControllerUseCase(dataBaseManager: managerFactory.getDataBaseManager(),
                                               networkManager: managerFactory.getNetworkManager(),
                                               reachabilityManager: managerFactory.getReachabilityManager())
        case .favoritesViewController:
            return FavoritesViewControllerUseCase(dataBaseManager: managerFactory.getDataBaseManager())
        case .preferencesViewController:
            return PreferencesViewControllerUseCase()
        }
    }
}
