//
//  extension+UINavigationController.swift
//  InstagramStories
//
//  Created by Борис on 11.12.2021.
//

import UIKit.UINavigationController

protocol TransitionProtocol: AnyObject {
    func pushViewControllerWithHandler(_ viewController: UIViewController, animated: Bool)
}

extension UINavigationController: TransitionProtocol {
    func pushViewControllerWithHandler(_ viewController: UIViewController, animated: Bool) {
        self.pushViewController(viewController, animated: true)
    }
}
