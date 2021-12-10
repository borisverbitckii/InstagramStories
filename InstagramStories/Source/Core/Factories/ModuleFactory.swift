//
//  AppAssembler.swift
//  InstagramStories
//
//  Created by Борис on 08.12.2021.
//

import UIKit.UIViewController

protocol ModuleFactoryProtocol: AnyObject {
    func buildTabBarController() -> UIViewController
    func buildPresentationViewController() -> UIViewController
    func buildSearchViewController() -> CommonViewController
    func buildFavoritesViewController() -> CommonViewController
    func buildPreferencesViewController() -> CommonViewController
    func buildUsernameAccountViewController() -> UIViewController
    func buildUsernameStoryViewController() -> UIViewController
    func buildSplashViewController() -> UIViewController
}

final class ModuleFactory: ModuleFactoryProtocol {
    
    //MARK: - Private properties
    private weak var coordinator: CoordinatorProtocol?
    private let useCasesRepository: UseCasesRepositoryProtocol
    private let viewsFactory: ViewsFactoryProtocol
    
    //MARK: - Init
    init(useCasesRepository: UseCasesRepositoryProtocol,
         viewsFactory: ViewsFactoryProtocol) {
        self.useCasesRepository = useCasesRepository
        self.viewsFactory = viewsFactory
    }
    
    
    //MARK: - Public methods
    func injectCoordinator(coordinator: CoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    func buildTabBarController() -> UIViewController {
        let searchVC = buildSearchViewController()
        let favoritesVC = buildFavoritesViewController()
        return TabBarViewController(searchViewController: searchVC,
                                    favoritesViewController: favoritesVC)
    }
    
    func buildPresentationViewController() -> UIViewController {
        let presenter = PresentationPresenter()
        let view = PresentationViewController(presenter: presenter)
        presenter.injectView(view: view)
        return view
    }
    
    func buildSearchViewController() -> CommonViewController {
        guard let coordinator = coordinator,
              let useCase = useCasesRepository.getUseCase(type: .searchViewController) as? SearchViewControllerUseCase else {
            return CommonViewController(type: .search)
        }
        let presenter = SearchPresenter(coordinator: coordinator,
                                        searchUseCase: useCase)
        let view = SearchViewController(type: .search,presenter: presenter)
        presenter.injectView(view: view)
        
        return view
    }
    
    func buildFavoritesViewController() -> CommonViewController {
        guard let coordinator = coordinator,
              let useCase = useCasesRepository.getUseCase(type: .favoritesViewController) as? FavoritesViewControllerUseCase else {
            return CommonViewController(type: .favorites)
        }
        
        let presenter = FavoritesPresenter(coordinator: coordinator,
                                           favoritesUseCase: useCase)
        let view = FavoritesViewController(type: .favorites, presenter: presenter)
        presenter.injectView(view: view)
        
        return view
    }
    
    func buildPreferencesViewController() -> CommonViewController {
        guard let coordinator = coordinator,
              let useCase = useCasesRepository.getUseCase(type: .preferencesViewController) as? PreferencesViewControllerUseCase else {
            return CommonViewController(type: .preferences)
        }
        
        let presenter = PreferencesPresenter(coordinator: coordinator,preferencesUseCase: useCase)
        let view = PreferencesViewController(type: .preferences,presenter: presenter)
        presenter.injectView(view: view)
        
        return view
    }
    
    func buildUsernameAccountViewController() -> UIViewController {
        return UIViewController()
    }
    
    func buildUsernameStoryViewController() -> UIViewController {
        return UIViewController()
    }
    
    func buildSplashViewController() -> UIViewController {
        guard let coordinator = coordinator,
              let useCase = useCasesRepository.getUseCase(type: .splashViewController) as? SplashUseCaseProtocol else {
            return CommonViewController(type: .preferences)
        }
        
        let presenter = SplashPresenter(coordinator: coordinator, useCase: useCase)
        let view = SplashViewController(presenter: presenter, activityIndicator: viewsFactory.getCustomActivityIndicator())
        presenter.injectView(view: view)
        
        return view
    }
}
