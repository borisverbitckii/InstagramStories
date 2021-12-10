//
//  RootCoordinator.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit.UIViewController

protocol CoordinatorProtocol: AnyObject {
    func presentTabBarController()
    func presentPresentationViewController()
    func presentPreferencesViewController(navigationController: UINavigationController)
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
    
    func presentTabBarController() {
        window?.rootViewController = moduleFactory.buildTabBarController()
        window?.makeKeyAndVisible()
        
        guard let window = window else { return }
        
        UIView.transition(with: window, duration: 0.30, options: [.transitionCrossDissolve], animations: nil)
    }
    
    func presentPresentationViewController() {
        window?.rootViewController = moduleFactory.buildPresentationViewController()
        window?.makeKeyAndVisible()
    }
    
    func presentPreferencesViewController(navigationController: UINavigationController) {
        navigationController.pushViewController(moduleFactory.buildPreferencesViewController(), animated: true)
    }
    
    func presentSplashViewController() {
        window?.rootViewController = moduleFactory.buildSplashViewController()
        window?.makeKeyAndVisible()
    }
}
