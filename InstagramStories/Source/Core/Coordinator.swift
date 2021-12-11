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
    func presentProfileViewController(transitionHandler: TransitionProtocol)
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
                          duration: LocalConstans.tabBarTransitionDuration,
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
    
    func presentProfileViewController(transitionHandler: TransitionProtocol) {
        transitionHandler.pushViewControllerWithHandler(moduleFactory.buildProfileViewController(),
                                                        animated: true)
    }
}

enum LocalConstans {
    static let tabBarTransitionDuration: TimeInterval = 0.30
}
