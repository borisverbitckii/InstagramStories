//
//  extension+UIViewControllere.swift
//  InstagramStories
//
//  Created by Борис on 08.12.2021.
//

import UIKit

extension UIViewController {
    func showAlertController(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default) { _ in
            if let completion = completion {
                completion()
            }
        }

        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

protocol TransitionProtocol: AnyObject {
    func presentViewController(_ viewController: UIViewController, animated: Bool)
    func pushViewControllerWithHandler(_ viewController: UIViewController, animated: Bool)
}

// MARK: - extension + TransitionProtocol
extension UIViewController: TransitionProtocol {
    func presentViewController(_ viewController: UIViewController, animated: Bool) {
        self.present(viewController, animated: animated)
    }

    func pushViewControllerWithHandler(_ viewController: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
