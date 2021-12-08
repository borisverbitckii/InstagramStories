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
    private let coordinator: Coordinator
    private let dataServiceFacade: DataServicesFacadeProtocol
    
    //MARK: - Init
    init(coordinator: Coordinator,
         dataServiceFacade: DataServicesFacadeProtocol) {
        self.dataServiceFacade = dataServiceFacade
        self.coordinator = coordinator
    }
    
    
    //MARK: - Public methods
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
        let presenter = SearchPresenter(dataServicesFacade: dataServiceFacade,
                                        coordinator: coordinator)
        let view = SearchViewController(type: .search,presenter: presenter)
        presenter.injectView(view: view)
        
        return view
    }
    
    func buildFavoritesViewController() -> CommonViewController {
        let presenter = FavoritesPresenter(dataServicesFacade: dataServiceFacade, coordinator: coordinator)
        let view = FavoritesViewController(type: .favorites, presenter: presenter)
        presenter.injectView(view: view)
        
        return view
    }
    
    func buildPreferencesViewController() -> CommonViewController {
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
