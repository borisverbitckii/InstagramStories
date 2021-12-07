//
//  Fonts.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit.UIFont

enum Fonts {
    case navBarLargeTitle
    case navBarLitleTitle
    case searchBarPlaceholder
    case instagramCellName
    case instagramCellNickname
    case searchBarCancelButton
    
    func getFont() -> UIFont {
        switch self{
        case .navBarLargeTitle:
            guard let font = UIFont(name: "Avenir-Heavy", size: 34) else { return UIFont() }
            return font
        case .navBarLitleTitle:
            guard let font = UIFont(name: "Avenir-Heavy", size: 16) else { return UIFont() }
            return font
        case .searchBarPlaceholder:
            guard let font = UIFont(name: "Avenir-Light", size: 14) else { return UIFont() }
            return font
        case .instagramCellName:
            guard let font = UIFont(name: "Avenir-Heavy", size: 14) else { return UIFont() }
            return font
        case .instagramCellNickname:
            guard let font = UIFont(name: "Avenir-Light", size: 12) else { return UIFont() }
            return font
        case .searchBarCancelButton:
            guard let font = UIFont(name: "Avenir-Heavy", size: 14) else { return UIFont() }
            return font
        }
    }
}
