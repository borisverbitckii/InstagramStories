//
//  extension+UIView.swift
//  InstagramStories
//
//  Created by Борис on 14.12.2021.
//

import Foundation
import UIKit

extension UIView {
    func hideWithFade(with duration: TimeInterval) {
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseInOut) { [weak self] in
            self?.alpha = 0
        } completion: { _ in}
    }
    
    func showWithFade(with duration: TimeInterval) {
        self.isHidden = false
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseInOut) { [weak self] in
            self?.alpha = 1
        } completion: { _ in }
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
