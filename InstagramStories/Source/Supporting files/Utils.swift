//
//  Utils.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit.UIColor

enum ShadowType {
    case shadowIsAbove
    case shadowIsBelow
}

struct Utils {
    
    static func addShadow(type: ShadowType, layer: CALayer, opacity: Float? = nil) {
        layer.shadowColor = Palette.black.color.cgColor
        
        switch type {
        case .shadowIsAbove:
            layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        case .shadowIsBelow:
            layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        }
        
        layer.shadowRadius = 6.0
        if let opacity = opacity {
            layer.shadowOpacity = opacity
            return
        }
        layer.shadowOpacity = 0.07
    }
}
