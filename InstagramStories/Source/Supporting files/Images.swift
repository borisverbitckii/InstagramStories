//
//  Images.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit.UIImage

enum Images {
    case searchTabIcon
    case favoritesTabIcon
    case preferencesTabIcon
    case trailingCellButton(InstagramUserCellType)
    case userImageIsEmpty
    
    func getImage() -> UIImage? {
        switch self {
        case .searchTabIcon:
            return UIImage(systemName: "heart")
        case .favoritesTabIcon:
            return UIImage(systemName: "heart")
        case .preferencesTabIcon:
            return UIImage(systemName: "heart")
        case .trailingCellButton(let cellType):
            switch cellType {
            case .remove:
                return  UIImage(systemName: "xmark.circle")
            case .addToFavorites:
                return UIImage(systemName: "heart")
            }
        case .userImageIsEmpty:
            return UIImage(systemName: "heart")
        }
    }
}
