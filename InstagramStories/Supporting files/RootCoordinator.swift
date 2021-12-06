//
//  RootCoordinator.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit

final class RootCoordinator {
    
    //MARK: - Public properties
    static let shared = RootCoordinator()
    
    var rootViewController: UIViewController {
        guard let window = window,
              let rootViewController = window.rootViewController else { return UIViewController()}
        return rootViewController
    }
    
    var tabBarController: UITabBarController? {
        guard let window = window else { return nil }
        if window.rootViewController is TabBarViewController {
            return window.rootViewController as? TabBarViewController
        }
        return nil
    }
    
    //MARK: - Private methods
    private var window: UIWindow?
    
    //MARK: - Init
    private init() {
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
        let vc = TabBarViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    func presentPresentationViewController() {
        let vc = PresentationViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}
