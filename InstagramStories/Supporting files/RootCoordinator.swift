//
//  RootCoordinator.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit.UIViewController

final class RootCoordinator {
    
    //MARK: - Private methods
    private var window: UIWindow?
    private let tabBarController: UITabBarController
    private let presentationViewController: UIViewController
    
    //MARK: - Init
    init(tabBarController: UITabBarController,
         presentationViewController: UIViewController) {
        self.tabBarController = tabBarController
        self.presentationViewController = presentationViewController
        
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
    func presentTabBarController() {
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    func presentPresentationViewController() {
        window?.rootViewController = presentationViewController
        window?.makeKeyAndVisible()
    }
}
