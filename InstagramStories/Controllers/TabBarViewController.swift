//
//  TabBarViewController.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import Foundation
import UIKit

final class TabBarViewController: UITabBarController {
    
    private let navigationControllerForSearch: UIViewController
    private let navigationControllerForFavorites : UIViewController
    private let navigationControllerForPreferences: UIViewController
    
    //MARK: - Init
    init(searchViewController: UIViewController,
         favoritesViewController : UIViewController,
         preferencesViewController: UIViewController) {

        self.navigationControllerForSearch = UINavigationController(rootViewController: searchViewController)
        self.navigationControllerForFavorites = UINavigationController(rootViewController: favoritesViewController)
        self.navigationControllerForPreferences = UINavigationController(rootViewController: preferencesViewController)
        
        super.init(nibName: nil, bundle: nil)
        
        setupTabBarItems()
        
        setViewControllers([navigationControllerForSearch, navigationControllerForFavorites, navigationControllerForPreferences], animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setupTabBarItems() {
        navigationControllerForSearch.tabBarItem = UITabBarItem(title: "Search", image: nil, selectedImage: nil)
        navigationControllerForFavorites.tabBarItem = UITabBarItem(title: "Favorites", image: nil, selectedImage: nil)
        navigationControllerForPreferences.tabBarItem = UITabBarItem(title: "Preferences", image: nil, selectedImage: nil)
    }
}
