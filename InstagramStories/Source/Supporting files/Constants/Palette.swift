//
//  Palette.swift
//  InstagramStories
//
//  Created by Борис on 13.12.2021.
//

import UIKit.UIColor

enum Palette {
    case lightGray
    case searchBarTintColor // not sure needed
    
    var color: UIColor {
        switch self {
        case .lightGray:
            return .black.withAlphaComponent(0.3)
        case .searchBarTintColor:
            return UIColor(hexString: "04FAB3")
        }
    }
}
