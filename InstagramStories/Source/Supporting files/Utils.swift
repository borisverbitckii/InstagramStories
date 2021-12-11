//
//  Utils.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit.UIColor

enum ShadowType {
    case tabBar
    case navBar
}

struct Utils {
    
    static func addShadow(type: ShadowType, layer: CALayer) {
        layer.shadowColor = UIColor.black.cgColor
        
        switch type {
        case .tabBar:
            layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        case .navBar:
            layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        }
        
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.10
    }
}
