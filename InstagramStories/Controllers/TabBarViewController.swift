//
//  TabBarViewController.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import Foundation
import UIKit

final class TabBarViewController: UITabBarController {
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    //MARK: - Private methods
    private func setupTabBar() {
        
        let searchViewController = SearchViewController(searchResultsController: nil)
        let navigationControllerForSearch = UINavigationController(rootViewController: searchViewController)
        
        let favoritesViewController = FavoritesViewController()
        let navigationControllerForFavorites = UINavigationController(rootViewController: favoritesViewController)
        
        let preferencesViewController = PreferencesViewController()
        let navigationControllerForPreferences = UINavigationController(rootViewController: preferencesViewController)
        
        navigationControllerForSearch.tabBarItem = UITabBarItem(title: "Search", image: nil, selectedImage: nil)
        navigationControllerForFavorites.tabBarItem = UITabBarItem(title: "Favorites", image: nil, selectedImage: nil)
        navigationControllerForPreferences.tabBarItem = UITabBarItem(title: "Preferences", image: nil, selectedImage: nil)
        
        setViewControllers([navigationControllerForSearch, navigationControllerForFavorites, navigationControllerForPreferences], animated: true)
    }
}
