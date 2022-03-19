//
//  UseCasesFactory.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

protocol UseCaseFactoryProtocol {
    func getAuthUseCase() -> UseCase
    func getLoadUserProfileUseCase() -> UseCase
    func getSearchUserUseCase() -> UseCase
    func getChangeRecentsUsersUseCase() -> UseCase
    func getShowFavoritesUsersUseCase() -> UseCase
    func getChangeRecentsUserUseCase() -> UseCase
    func getSaveFavoritesUsersUseCase() -> UseCase
    func getShowStoryUseCase() -> UseCase
}

/// Only for  inheritance
class UseCase {}

final class UseCasesFactory {
    // MARK: - Private properties
    private let managerFactory: ManagerFactoryProtocol
    private let repositoryFactory: RepositoryFactoryProtocol

    // MARK: - Init
    init(managerFactory: ManagerFactoryProtocol,
         repositoryFactory: RepositoryFactoryProtocol) {
        self.managerFactory = managerFactory
        self.repositoryFactory = repositoryFactory
    }
}

extension UseCasesFactory: UseCaseFactoryProtocol {

    func getAuthUseCase() -> UseCase {
        return AuthUseCase(authRepository: repositoryFactory.getAuthRepository())
    }

    func getChangeRecentsUsersUseCase() -> UseCase {
        return ChangeRecentUseCase(usersRepository: repositoryFactory.getUsersRepository())
    }

    func getSearchUserUseCase() -> UseCase {
        return SearchUserUseCase(
            fetchImageRepository: repositoryFactory.getUserImageRepository(),
            searchUserRepository: repositoryFactory.getSearchUserRepository(),
            usersRepository: repositoryFactory.getUsersRepository()
        )
    }

    func getLoadUserProfileUseCase() -> UseCase {
        return LoadUserProfileUseCase(
            repository: repositoryFactory.getUserImageRepository(),
            storiesRepository: repositoryFactory.getStoriesRepository(),
            searchUserRepository: repositoryFactory.getSearchUserRepository()
        )
    }

    func getShowFavoritesUsersUseCase() -> UseCase {
        return ChangeFavoritesUseCase(usersRepository: repositoryFactory.getUsersRepository(),
                                    fetchImageRepository: repositoryFactory.getUserImageRepository())
    }

    func getChangeRecentsUserUseCase() -> UseCase {
        return ChangeRecentUseCase(usersRepository: repositoryFactory.getUsersRepository())
    }

    func getSaveFavoritesUsersUseCase() -> UseCase {
        return ChangeFavoritesUseCase(usersRepository: repositoryFactory.getUsersRepository(),
                                      fetchImageRepository: repositoryFactory.getUserImageRepository())
    }

    func getShowStoryUseCase() -> UseCase {
        return ShowStoryUseCase(userImageRepository: repositoryFactory.getUserImageRepository(), storyRepository: repositoryFactory.getStoryRepository())
    }
}
