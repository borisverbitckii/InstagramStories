//
//  UseCasesFactory.swift
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

protocol UseCaseFactoryProtocol {
    func getAuthUseCase() -> UseCase
    func getFetchUserImageUseCase() -> UseCase
    func getUseCase(type: UseCaseType) -> UseCase
}

/// Only for  inheritance
class UseCase {}

final class UseCasesFactory: UseCaseFactoryProtocol {
    //MARK: - Private properties
    private let managerFactory: ManagerFactoryProtocol
    private let repositoryFactory: RepositoryFactoryProtocol
    
    //MARK: - Init
    init(managerFactory: ManagerFactoryProtocol,
         repositoryFactory: RepositoryFactoryProtocol){
        self.managerFactory = managerFactory
        self.repositoryFactory = repositoryFactory
    }
    
    func getAuthUseCase() -> UseCase {
        return AuthUseCase(authManager: managerFactory.getAuthManager())
    }
    
    func getFetchUserImageUseCase() -> UseCase {
        return FetchUserImageUseCase(repository: repositoryFactory.getUserImageRepository())
    }
    
    func getUseCase(type: UseCaseType) -> UseCase { //TODO: Fix use case production
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
