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
    private let dataServiceFacade: DataServicesFacadeProtocol
    
    //MARK: - Init
    init(dataServiceFacade: DataServicesFacadeProtocol) {
        self.dataServiceFacade = dataServiceFacade
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
        return UIViewController()
    }
    
    func buildSearchViewController() -> CommonViewController {
        guard let coordinator = coordinator else {
            return CommonViewController(type: .search)
        }

        let presenter = SearchPresenter(coordinator: coordinator,
                                        dataServicesFacade: dataServiceFacade)
        let view = SearchViewController(type: .search,presenter: presenter)
        presenter.injectView(view: view)
        
        return view
    }
    
    func buildFavoritesViewController() -> CommonViewController {
        guard let coordinator = coordinator else {
            return CommonViewController(type: .favorites)
        }
        
        let presenter = FavoritesPresenter(coordinator: coordinator,
                                           dataServicesFacade: dataServiceFacade)
        let view = FavoritesViewController(type: .favorites, presenter: presenter)
        presenter.injectView(view: view)
        
        return view
    }
    
    func buildPreferencesViewController() -> CommonViewController {
        guard let coordinator = coordinator else {
            return CommonViewController(type: .preferences)
        }
        
        let presenter = PreferencesPresenter(coordinator: coordinator)
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
