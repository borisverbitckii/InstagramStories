//
//  UseCasesFactory.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import Foundation.NSError

enum UseCaseType {
    case preferencesViewController
}

protocol UseCaseFactoryProtocol {
    func getAuthUseCase() -> UseCase
    func getLoadUserProfileUseCase() -> UseCase
    func getSearchUserUseCase() -> UseCase
    func getShowRecentsUsersUseCase() -> UseCase
    func getShowFavoritesUsersUseCase() -> UseCase
    func getShowPreferencesUseCase() -> UseCase
    func getShowStoryUseCase() -> UseCase
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
        return AuthUseCase(authRepository: repositoryFactory.getAuthRepository())
    }
    
    func getShowRecentsUsersUseCase() -> UseCase {
        return ShowRecentsUsersUseCase(recentUsersRepository: repositoryFactory.getRecentUsersRepository())
    }
    
    func getSearchUserUseCase() -> UseCase {
        return SearchUserUseCase(
            fetchImageRepository: repositoryFactory.getUserImageRepository(),
            searchUserRepository: repositoryFactory.getSearchUserRepository()
        )
    }
    
    func getLoadUserProfileUseCase() -> UseCase {
        return LoadUserProfileUseCase(
            repository: repositoryFactory.getUserImageRepository(),
            storiesRepository: repositoryFactory.getStoriesRepository()
        )
    }
    
    func getShowFavoritesUsersUseCase() -> UseCase {
        return ShowFavoritesUseCase(favoritesRepository: repositoryFactory.getFavoritesUsersRepository())
    }
    
    func getShowPreferencesUseCase() -> UseCase {
        return ShowPreferencesUseCase(preferencesRepository: repositoryFactory.getPreferencesRepository())
    }
    
    func getShowStoryUseCase() -> UseCase {
        return ShowStoryUseCase(userImageRepository: repositoryFactory.getUserImageRepository(),storyRepository: repositoryFactory.getStoryRepository())
    }
}
