//
//  Palette.swift
//  InstagramStories
//
//  Created by Борис on 13.12.2021.
//

import UIKit.UIColor

enum Palette {
    case black
    case white
    case gray
    case lightGray
    case superLightGray
    case purple
    case clear

    var color: UIColor {
        switch self {
        case .white:
            return .white
        case .black:
            return .black
        case .gray:
            return .gray
        case .lightGray:
            return .black.withAlphaComponent(0.3)
        case .superLightGray:
            return .black.withAlphaComponent(0.04)
        case .purple:
            return UIColor(hexString: "B2B0F7")
        case .clear:
            return .clear
        }
    }
}
