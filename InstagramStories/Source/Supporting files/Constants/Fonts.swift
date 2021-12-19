//
//  Fonts.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit.UIFont

enum AvenirTypes {
    case book
    case heavy
    case light
}

enum FontSizes: CGFloat {
    case small = 12
    case medium = 14
    case mediumPlus = 16
    case large = 34
}

enum Fonts {
    case avenir(AvenirTypes)
    
    func getFont(size: FontSizes) -> UIFont {
        switch self{
        case .avenir(let type):
            switch type{
            case .book:
                guard let font = UIFont(name: "Avenir-Book", size: size.rawValue) else { return UIFont() }
                return font
            case .heavy:
                guard let font = UIFont(name: "Avenir-Heavy", size: size.rawValue) else { return UIFont() }
                return font
            case .light:
                guard let font = UIFont(name: "Avenir-Light", size: size.rawValue) else { return UIFont() }
                return font
            }
        }
    }
}
