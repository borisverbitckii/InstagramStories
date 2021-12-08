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
}

final class ModuleFactory: ModuleFactoryProtocol {
    
    //MARK: - Private properties
    private weak var coordinator: CoordinatorProtocol?
    private let repository: UseCasesRepositoryProtocol
    
    //MARK: - Init
    init(dataServiceFacade: UseCasesRepositoryProtocol) {
        self.repository = dataServiceFacade
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
              let useCase = repository.getUseCase(type: .searchViewController) as? SearchViewControllerUseCase else {
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
              let useCase = repository.getUseCase(type: .favoritesViewController) as? FavoritesViewControllerUseCase else {
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
              let useCase = repository.getUseCase(type: .preferencesViewController) as? PreferencesViewControllerUseCase else {
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
}
