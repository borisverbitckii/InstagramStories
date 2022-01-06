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
    func presentSplashViewController()
    func presentProfileViewController(transitionHandler: TransitionProtocol,
                                      with user: RealmInstagramUserProtocol,
                                      secret: Secret)
    func presentStoryViewController(transitionHandler: TransitionProtocol,
                                    user: RealmInstagramUserProtocol,
                                    selectedStoryIndex: Int,
                                    stories: [Story],
                                    secret: Secret)
    func presentActivityViewController(type: ActivityViewControllerType ,
                                       transitionHandler: TransitionProtocol,
                                       completion: (()->())?)
}

enum ActivityViewControllerType {
    case video(ActivityViewControllerSettings)
}

struct ActivityViewControllerSettings {
    let key: String
    let value: String
    let objectsToShare: [URL]
    let excludedActivityTypes: [UIActivity.ActivityType]
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
    
    func presentSplashViewController() {
        window?.rootViewController = moduleFactory.buildSplashViewController()
        window?.makeKeyAndVisible()
    }
    
    func presentProfileViewController(transitionHandler: TransitionProtocol,
                                      with user: RealmInstagramUserProtocol,
                                      secret: Secret) {
        transitionHandler.pushViewControllerWithHandler(moduleFactory.buildProfileViewController(with: user,
                                                                                                 secret: secret),
                                                        animated: true)
    }
    func presentStoryViewController(transitionHandler: TransitionProtocol,
                                    user: RealmInstagramUserProtocol,
                                    selectedStoryIndex: Int,
                                    stories: [Story],
                                    secret: Secret) {
        let storyViewController = moduleFactory.buildStoryViewController(with: user,
                                                                         stories: stories,
                                                                         selectedStoryIndex: selectedStoryIndex,
                                                                         secret: secret)
        storyViewController.modalTransitionStyle = .coverVertical
        storyViewController.modalPresentationStyle = .fullScreen
        transitionHandler.presentViewController(storyViewController,
                                                animated: true)
    }
    
    func presentActivityViewController(type: ActivityViewControllerType ,
                                       transitionHandler: TransitionProtocol,
                                       completion: (()->())?) {
        switch type {
        case .video(let settings):
            let activityViewController = UIActivityViewController(activityItems: settings.objectsToShare,
                                                                  applicationActivities: nil)
            activityViewController.setValue(settings.value, forKey: settings.key)
            activityViewController.excludedActivityTypes = settings.excludedActivityTypes
            activityViewController.completionWithItemsHandler = { _, _, _, error in
                if let error = error {
                    print(error) 
                }
                if let completion = completion {
                    completion()
                }
                
            }
            transitionHandler.presentViewController(activityViewController, animated: true)
        }
    }
}

private enum LocalConstants {
    static let tabBarTransitionDuration: TimeInterval = 0.45
}
