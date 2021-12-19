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
    func buildPresentationViewController() -> UIViewController
    func buildSearchNavigationController(secret: Secret) -> UINavigationController
    func buildFavoritesNavigationController() -> UINavigationController
    func buildPreferencesNavigationController() -> UINavigationController
    func buildUsernameStoryViewController() -> UIViewController
    func buildSplashViewController() -> UIViewController
    func buildProfileViewController(with user: InstagramUser) -> UIViewController
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
        let favoritesVC = buildFavoritesNavigationController()
        let preferencesVC = buildPreferencesNavigationController()
        return TabBarController(navigationControllerForSearch: searchVC,
                                    navigationControllerForFavorites: favoritesVC,
                                    navigationControllerForPreferences: preferencesVC)
    }
    
    func buildPresentationViewController() -> UIViewController {
        let presenter = PresentationPresenter()
        let view = PresentationViewController(presenter: presenter)
        presenter.injectView(view: view)
        return view
    }
    
    func buildSearchNavigationController(secret: Secret) -> UINavigationController {
        guard let coordinator = coordinator,
              let searchUseCase = useCasesFactory.getSearchUserUseCase() as? SearchUserUseCase,
              let recentUsersUseCase = useCasesFactory.getShowRecentsUsersUseCase() as? ShowRecentsUsersUseCase else {
            return UINavigationController()
        }
        let presenter = SearchPresenter(coordinator: coordinator,
                                        searchUseCase: searchUseCase,
                                        recentUsersUseCase: recentUsersUseCase,
                                        secret: secret)
        let view = SearchViewController(type: .search,
                                        presenter: presenter)
        presenter.injectView(view: view)
        let navigationController = UINavigationController(rootViewController: view)
        presenter.injectTransitionHandler(view: navigationController)
        return navigationController
    }
    
    func buildFavoritesNavigationController() -> UINavigationController {
        guard let coordinator = coordinator,
              let useCase = useCasesFactory.getShowFavoritesUsersUseCase() as? ShowFavoritesUseCaseProtocol else {
            return UINavigationController()
        }
        
        let presenter = FavoritesPresenter(coordinator: coordinator,
                                           favoritesUseCase: useCase)
        let view = FavoritesViewController(type: .favorites, presenter: presenter)
        presenter.injectView(view: view)
        let navigationController = UINavigationController(rootViewController: view)
        return navigationController
    }
    
    func buildPreferencesNavigationController() -> UINavigationController {
        guard let coordinator = coordinator,
              let useCase = useCasesFactory.getShowPreferencesUseCase() as? ShowPreferencesUseCase else {
            return UINavigationController()
        }
        
        let presenter = PreferencesPresenter(coordinator: coordinator,preferencesUseCase: useCase)
        let view = PreferencesViewController(type: .preferences,presenter: presenter)
        presenter.injectView(view: view)
        let navigationController = UINavigationController(rootViewController: view)
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
    
    func buildProfileViewController(with user: InstagramUser) -> UIViewController {
        guard let coordinator = coordinator,
              let useCase = useCasesFactory.getLoadUserProfileUseCase() as? LoadUserProfileUseCase else {
            return UIViewController()
        }
        
        let presenter = ProfilePresenter(coordinator: coordinator, useCase: useCase)
        let view = ProfileViewController(presenter: presenter)
        presenter.injectUser(user)
        presenter.injectView(view: view)
        
        return view
    }
    
    func buildUsernameStoryViewController() -> UIViewController {
        return UIViewController()
    }
    
}
