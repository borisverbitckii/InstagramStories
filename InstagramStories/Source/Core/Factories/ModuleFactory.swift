//
//  AppAssembler.swift
//  InstagramStories
//
//  Created by Борис on 08.12.2021.
//

import UIKit.UIViewController
import Swiftagram

protocol ModuleFactoryProtocol: AnyObject {
    func buildTabBarController(secret: Secret) -> UIViewController
    func buildSearchNavigationController(secret: Secret) -> UINavigationController
    func buildFavoritesNavigationController(secret: Secret) -> UINavigationController
    func buildSplashViewController() -> UIViewController
    func buildProfileViewController(with user: RealmInstagramUserProtocol, secret: Secret) -> UIViewController
    func buildStoryViewController(with user: RealmInstagramUserProtocol, stories: [Story], selectedStoryIndex: Int, secret: Secret) -> UIViewController
}

final class ModuleFactory: ModuleFactoryProtocol {
    
    //MARK: - Private properties
    private weak var coordinator: CoordinatorProtocol?
    private let useCasesFactory: UseCaseFactoryProtocol
    
    //MARK: - Init
    init(useCasesFactory: UseCaseFactoryProtocol) {
        self.useCasesFactory = useCasesFactory
    }
    
    
    //MARK: - Public methods
    func injectCoordinator(coordinator: CoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    func buildTabBarController(secret: Secret) -> UIViewController {
        let searchVC = buildSearchNavigationController(secret: secret)
        let favoritesVC = buildFavoritesNavigationController(secret: secret)
        return TabBarController(navigationControllerForSearch: searchVC,
                                    navigationControllerForFavorites: favoritesVC)
    }
    
    func buildSearchNavigationController(secret: Secret) -> UINavigationController {
        guard let coordinator = coordinator,
              let searchUseCase = useCasesFactory.getSearchUserUseCase() as? SearchUserUseCase,
              let changeRecentUsersUseCase = useCasesFactory.getChangeRecentsUserUseCase() as? ChangeRecentUseCaseProtocol,
              let changeFavoritesUseCase = useCasesFactory.getSaveFavoritesUsersUseCase() as? ChangeFavoritesUseCaseProtocol else {
            return UINavigationController()
        }
        let presenter = SearchPresenter(coordinator: coordinator,
                                        searchUseCase: searchUseCase,
                                        changeRecentUsersUseCase: changeRecentUsersUseCase,
                                        changeFavoritesUseCase: changeFavoritesUseCase,
                                        secret: secret)
        let view = SearchViewController(type: .search,
                                        presenter: presenter)
        presenter.injectView(view: view)
        let navigationController = UINavigationController(rootViewController: view)
        presenter.injectTransitionHandler(view: view)
        return navigationController
    }
    
    func buildFavoritesNavigationController(secret: Secret) -> UINavigationController {
        guard let coordinator = coordinator,
              let changeFavoritesUseCase = useCasesFactory.getSaveFavoritesUsersUseCase() as? ChangeFavoritesUseCaseProtocol
        else {
            return UINavigationController()
        }
        
        let presenter = FavoritesPresenter(coordinator: coordinator,
                                           changeFavoritesUseCase: changeFavoritesUseCase,
                                           secret: secret)
        let view = FavoritesViewController(type: .favorites, presenter: presenter)
        presenter.injectView(view: view)
        let navigationController = UINavigationController(rootViewController: view)
        presenter.injectTransitionHandler(view: view)
        return navigationController
    }

    func buildSplashViewController() -> UIViewController {
        guard let coordinator = coordinator,
              let useCase = useCasesFactory.getAuthUseCase() as? SplashUseCaseProtocol else {
            return UIViewController()
        }
        
        let presenter = SplashPresenter(coordinator: coordinator, useCase: useCase)
        let view = SplashViewController(presenter: presenter)
        presenter.injectView(view: view)
        return view
    }
    
    func buildProfileViewController(with user: RealmInstagramUserProtocol, secret: Secret) -> UIViewController {
        guard let coordinator = coordinator,
              let loadUserProfileUseCase = useCasesFactory.getLoadUserProfileUseCase() as? LoadUserProfileUseCase,
              let saveFavoritesUseCase = useCasesFactory.getSaveFavoritesUsersUseCase() as? ChangeFavoritesUseCaseProtocol
        else {
            return UIViewController()
        }
        
        let presenter = ProfilePresenter(coordinator: coordinator,
                                         loadUserProfileUseCase: loadUserProfileUseCase,
                                         saveFavoritesUseCase: saveFavoritesUseCase,
                                         secret: secret,
                                         user: user)
        let view = ProfileViewController(presenter: presenter)
        presenter.injectView(view: view)
        return view
    }
    
    func buildStoryViewController(with user: RealmInstagramUserProtocol, stories: [Story], selectedStoryIndex: Int, secret: Secret) -> UIViewController {
        guard let coordinator = coordinator,
              let useCase = useCasesFactory.getShowStoryUseCase() as? ShowStoryUseCaseProtocol else {
            return UIViewController()
        }
        let presenter = StoryPresenter(coordinator: coordinator,
                                       secret: secret,
                                       useCase: useCase,
                                       stories: stories,
                                       user: user,
                                       selectedStoryIndex: selectedStoryIndex)
        let view = StoryViewController(presenter: presenter)
        presenter.injectView(view: view)
        presenter.injectTransitionHandler(view: view)
        return view
    }
}
