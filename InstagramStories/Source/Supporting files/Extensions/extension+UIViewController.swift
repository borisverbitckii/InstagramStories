//
//  extension+UIViewControllere.swift
//  InstagramStories
//
//  Created by Борис on 08.12.2021.
//

import UIKit.UIViewController

extension UIViewController {
    func showAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
