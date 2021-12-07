//
//  Images.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit.UIImage

enum Images {
    case navBarSettingsButton
    case searchTabIcon
    case favoritesTabIcon
    
    case trailingCellButton(InstagramUserCellType)
    
    func getImage() -> UIImage? {
        switch self {
        case .navBarSettingsButton:
            return UIImage(named: "heart")
        case .searchTabIcon:
            return UIImage(named: "heart")
        case .favoritesTabIcon:
            return UIImage(named: "heart")
        case .trailingCellButton(let cellType):
            switch cellType {
            case .remove:
                return  UIImage(systemName: "xmark.circle")
            case .addToFavorites:
                return UIImage(systemName: "heart")
            }
        }
    }
}
