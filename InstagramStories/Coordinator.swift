//
//  RootCoordinator.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit.UIViewController

protocol CoordinatorProtocol: AnyObject {
    init(navigationController: UINavigationController)
    func presentTabBarController()
    func presentPresentationViewController()
    func presentPreferences()
}

final class Coordinator {
    
    //MARK: - Private methods
    private var window: UIWindow?
    private let navigationController: UINavigationController
    private weak var moduleFactory: ModuleFactoryProtocol?
    
    //MARK: - Init
    init() {
        self.navigationController = UINavigationController()
        
        let scene = UIApplication.shared.connectedScenes.first
        
        guard let sceneDelegate: SceneDelegate = (scene?.delegate as? SceneDelegate) else { return }
        window = sceneDelegate.window
        
        if UserDefaults.standard.value(forKey: "UUID") == nil {
            UserDefaults.standard.set(UUID().uuidString, forKey: "UUID")
            presentPresentationViewController()
            return
        }
        
        presentTabBarController()
    }
    
    //MARK: - Public methods
    func injectModuleFactory(factory: ModuleFactoryProtocol) {
        self.moduleFactory = factory
    }
    
    func presentTabBarController() {
        window?.rootViewController = moduleFactory?.buildTabBarController()
        window?.makeKeyAndVisible()
    }
    
    func presentPresentationViewController() {
        window?.rootViewController = moduleFactory?.buildPresentationViewController()
        window?.makeKeyAndVisible()
    }
    
    func presentPreferences() {
    }
}
