//
//  extension+UILabel.swift
//  InstagramStories
//
//  Created by Борис on 05.01.2022.
//

import UIKit.UILabel

extension UILabel {

    func setupTextWithAnimation(text: String, with duration: TimeInterval) {

        UIView.transition(with: self,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            self?.text = text
        }, completion: nil)
    }
}
