//
//  RootCoordinator.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit.UIViewController
import Swiftagram

protocol CoordinatorProtocol: AnyObject {
    func presentTabBarController(secret: Secret)
    func presentPresentationViewController()
    func presentProfileViewController(transitionHandler: TransitionProtocol, with user: InstagramUser, secret: Secret)
    func presentStoryViewController(transitionHandler: TransitionProtocol,
                                    user: InstagramUser,
                                    selectedStoryIndex: Int,
                                    stories: [Story],
                                    secret: Secret)
}

final class Coordinator {
    
    //MARK: - Private methods
    private var window: UIWindow?
    var moduleFactory: ModuleFactoryProtocol
    
    //MARK: - Init
    init(moduleFactory: ModuleFactoryProtocol) {
        self.moduleFactory = moduleFactory
    }
    
    //MARK: - Public methods
    func start() {
        let scene = UIApplication.shared.connectedScenes.first
        
        guard let sceneDelegate: SceneDelegate = (scene?.delegate as? SceneDelegate) else { return }
        window = sceneDelegate.window
        
        if UserDefaults.standard.value(forKey: "UUID") == nil {
            UserDefaults.standard.set(UUID().uuidString, forKey: "UUID")
            presentPresentationViewController()
            return
        }
        
        presentSplashViewController()
    }
}

//MARK: - extension + CoordinatorProtocol
extension Coordinator: CoordinatorProtocol {
    
    func presentTabBarController(secret: Secret) {
        window?.rootViewController = moduleFactory.buildTabBarController(secret: secret)
        window?.makeKeyAndVisible()
        
        guard let window = window else { return }
        
        UIView.transition(with: window,
                          duration: LocalConstants.tabBarTransitionDuration,
                          options: [.transitionCrossDissolve],
                          animations: nil)
    }
    
    func presentPresentationViewController() {
        window?.rootViewController = moduleFactory.buildPresentationViewController()
        window?.makeKeyAndVisible()
    }
    
    func presentSplashViewController() {
        window?.rootViewController = moduleFactory.buildSplashViewController()
        window?.makeKeyAndVisible()
    }
    
    func presentProfileViewController(transitionHandler: TransitionProtocol, with user: InstagramUser, secret: Secret) {
        transitionHandler.pushViewControllerWithHandler(moduleFactory.buildProfileViewController(with: user,secret: secret),
                                                        animated: true)
    }
    func presentStoryViewController(transitionHandler: TransitionProtocol,
                                    user: InstagramUser,
                                    selectedStoryIndex: Int,
                                    stories: [Story],
                                    secret: Secret) {
        let storyViewController = moduleFactory.buildStoryViewController(user: user,
                                                                         stories: stories,
                                                                         selectedStoryIndex: selectedStoryIndex,
                                                                         secret: secret)
        storyViewController.modalTransitionStyle = .coverVertical
        storyViewController.modalPresentationStyle = .fullScreen
        transitionHandler.presentViewController(storyViewController,
                                                animated: true)
    }
}

private enum LocalConstants {
    static let tabBarTransitionDuration: TimeInterval = 0.45
}
