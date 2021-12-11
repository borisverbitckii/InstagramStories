//
//  extension+UITableView.swift
//  InstagramStories
//
//  Created by Борис on 11.12.2021.
//

import UIKit.UITableView

extension UITableView {
    func reloadWithFade () {
        UIView.transition(with: self,
                          duration: 0.45,
                          options: .transitionCrossDissolve,
                          animations: { self.reloadData() })
    }
}
