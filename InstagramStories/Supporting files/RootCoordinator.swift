//
//  RootCoordinator.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit

final class RootCoordinator {
    
    //MARK: - Public properties
    
    //    var rootViewController: UIViewController {
    //        guard let window = window,
    //              let rootViewController = window.rootViewController else { return UIViewController()}
    //        return rootViewController
    //    }
    
    //    var tabBarController: UITabBarController? {
    //        guard let window = window else { return nil }
    //        if window.rootViewController is TabBarViewController {
    //            return window.rootViewController as? TabBarViewController
    //        }
    //        return nil
    //    }
    
    //MARK: - Private methods
    private var window: UIWindow?
    private let tabBarController: UITabBarController
    private let presentationViewController: UIViewController
    
    //MARK: - Init
    init(tabBarController: UITabBarController, presentationViewController: UIViewController) {
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
