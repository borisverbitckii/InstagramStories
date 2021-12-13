//
//  TabBarViewController.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit.UITabBarController

final class TabBarViewController: UITabBarController {
    
    private let navigationControllerForSearch: UINavigationController
    private let navigationControllerForFavorites : UINavigationController
    private let navigationControllerForPreferences: UINavigationController
    
    //MARK: - Init
    init(navigationControllerForSearch: UINavigationController,
         navigationControllerForFavorites : UINavigationController,
         navigationControllerForPreferences: UINavigationController) {
        self.navigationControllerForSearch = navigationControllerForSearch
        self.navigationControllerForFavorites = navigationControllerForFavorites
        self.navigationControllerForPreferences = navigationControllerForPreferences
        
        super.init(nibName: nil, bundle: nil)
        
        setupTabBarItems()
        setupTabBar()
        
        setViewControllers([navigationControllerForSearch,
                            navigationControllerForFavorites,
                            navigationControllerForPreferences], animated: true)
        
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setupTabBarItems() {
        navigationControllerForSearch.tabBarItem = UITabBarItem(title: "Search",
                                                                image: Images.searchTabIcon.getImage(),
                                                                selectedImage: Images.searchTabIcon.getImage())
        navigationControllerForFavorites.tabBarItem = UITabBarItem(title: "Favorites",
                                                                   image: Images.favoritesTabIcon.getImage(),
                                                                   selectedImage: Images.favoritesTabIcon.getImage())
        navigationControllerForPreferences.tabBarItem = UITabBarItem(title: "Preferences",
                                                                   image: Images.preferencesTabIcon.getImage(),
                                                                   selectedImage: Images.preferencesTabIcon.getImage())
    }
    
    private func setupTabBar() {
        Utils.addShadow(type: .shadowIdAbove, layer: tabBar.layer)

        self.tabBar.backgroundColor = UIColor.white
    }
}

//MARK: - extension + UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransition(viewControllers: tabBarController.viewControllers)
    }
}

