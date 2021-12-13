//
//  Palette.swift
//  InstagramStories
//
//  Created by Борис on 13.12.2021.
//

import UIKit.UIColor

enum Palette {
    case headerTitle
    case searchPlaceholderText
    
    var color: UIColor {
        switch self {
        case .headerTitle, .searchPlaceholderText:
            return .black.withAlphaComponent(0.3)
        }
    }
}
