//
//  TabBarViewController.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit.UITabBarController

final class TabBarController: UITabBarController {

    // MARK: - Public properties
    override var selectedIndex: Int {
        didSet {
            animateIndicator(index: selectedIndex + 1)
        }
    }

    // MARK: - Private properties
    private let navigationControllerForSearch: UINavigationController
    private let navigationControllerForFavorites: UINavigationController

    private let indicatorView: UIView = {
        $0.backgroundColor = Palette.purple.color
        $0.clipsToBounds = true
        $0.frame.size = LocalConstants.indicatorViewSize
        $0.layer.cornerRadius = $0.frame.height / 2
        return $0
    }(UIView())

    // MARK: - Init
    init(navigationControllerForSearch: UINavigationController,
         navigationControllerForFavorites: UINavigationController) {
        self.navigationControllerForSearch = navigationControllerForSearch
        self.navigationControllerForFavorites = navigationControllerForFavorites

        super.init(nibName: nil, bundle: nil)

        setupTabBar()
        setupTabBarItems()
        setViewControllers([navigationControllerForSearch,
                            navigationControllerForFavorites], animated: true)

        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override methods
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let number = -(tabBar.items?.firstIndex(of: item)?.distance(to: 0) ?? 0) + 1
        animateIndicator(index: number)
    }

    // MARK: - Private methods
    private func setupTabBar() {
        let tabBar = CustomTabBar(frame: .zero)
        tabBar.delegate = self
        setValue(tabBar, forKey: "tabBar")
        tabBar.tintColor = Palette.purple.color
        tabBar.unselectedItemTintColor = Palette.lightGray.color
        tabBar.addSubview(indicatorView)
        indicatorView.center.x =  tabBar.frame.width/3/2
        indicatorView.pin.bottom(0)
    }

    private func setupTabBarItems() {
        navigationControllerForSearch.tabBarItem = UITabBarItem(title: "",
                                                                image: Images.tabBarImages(.search).getImage(),
                                                                selectedImage: Images.tabBarImages(.search).getImage())
        navigationControllerForFavorites.tabBarItem = UITabBarItem(title: "",
                                                                   image: Images.tabBarImages(.favorites).getImage(),
                                                                   selectedImage: Images.tabBarImages(.favorites).getImage())
    }

    private func animateIndicator(index: Int) {
        UIView.animate(withDuration: LocalConstants.indicatorViewAnimationDuration) { [weak self] in
            guard let self = self else { return }
            if index == 1 {
                self.indicatorView.center.x = self.tabBar.frame.width/2/2
            } else if index == 2 {
                self.indicatorView.center.x = self.tabBar.frame.width/2/2 + self.tabBar.frame.width/2
            }
        }
    }
}

// MARK: - extension + UITabBarControllerDelegate
extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransition(viewControllers: tabBarController.viewControllers)
    }
}

private enum LocalConstants {
    static let indicatorViewSize = CGSize(width: 30, height: 5)
    static let indicatorViewAnimationDuration: TimeInterval = 0.45
}
