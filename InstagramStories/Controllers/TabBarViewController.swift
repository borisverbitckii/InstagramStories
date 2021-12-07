//
//  TabBarViewController.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit.UITabBarController

final class TabBarViewController: UITabBarController {
    
    private let navigationControllerForSearch: UIViewController
    private let navigationControllerForFavorites : UIViewController
    
    //MARK: - Init
    init(searchViewController: UIViewController,
         favoritesViewController : UIViewController) {

        self.navigationControllerForSearch = UINavigationController(rootViewController: searchViewController)
        self.navigationControllerForFavorites = UINavigationController(rootViewController: favoritesViewController)
        
        super.init(nibName: nil, bundle: nil)
        
        setupTabBarItems()
        setupTabBar()
        
        setViewControllers([navigationControllerForSearch, navigationControllerForFavorites], animated: true)
        
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
    }
    
    private func setupTabBar() {
        Utils.addShadow(for: .tabBar, layer: tabBar.layer)

        self.tabBar.backgroundColor = UIColor.white
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransition(viewControllers: tabBarController.viewControllers)
    }
}

class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let viewControllers: [UIViewController]?
    let transitionDuration: Double = 0.35
    
    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromVC.view,
            let fromIndex = getIndex(forViewController: fromVC),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = toVC.view,
            let toIndex = getIndex(forViewController: toVC)
            else {
                transitionContext.completeTransition(false)
                return
        }
        
        let frame = transitionContext.initialFrame(for: fromVC)
        var fromFrameEnd = frame
        var toFrameStart = frame
        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        toView.frame = toFrameStart
        
        DispatchQueue.main.async {
            transitionContext.containerView.addSubview(toView)
            UIView.animate(withDuration: self.transitionDuration, animations: {
                fromView.frame = fromFrameEnd
                toView.frame = frame
            }, completion: {success in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(success)
            })
        }
    }
    
    func getIndex(forViewController vc: UIViewController) -> Int? {
        guard let vcs = self.viewControllers else { return nil }
        for (index, thisVC) in vcs.enumerated() {
            if thisVC == vc { return index }
        }
        return nil
    }
}
