//
//  Utils.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit.UIColor

enum ShadowType {
    case shadowIsAbove
    case shadowIsUnder
}

struct Utils {
    
    static func addShadow(type: ShadowType, layer: CALayer) {
        layer.shadowColor = Palette.black.color.cgColor
        
        switch type {
        case .shadowIsAbove:
            layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        case .shadowIsUnder:
            layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        }
        
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.10
    }
}
