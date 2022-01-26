//
//  Images.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit.UIImage

enum TabBarImagesType {
    case search
    case favorites
}

enum storyButtonsType {
    case save
    case share
}

enum Images {
    case rightBarButton(FavoriteButtonType)
    case tabBarImages(TabBarImagesType)
    case trailingCellButton(InstagramUserCellType)
    case storyButtons(storyButtonsType)
    case stateView(StateViewType)
    case scrollToTop
    
    func getImage() -> UIImage? {
        switch self {
        case .rightBarButton(let favoriteType):
            switch favoriteType {
            case .add:
                return UIImage(systemName: "heart")
            case .remove:
                return UIImage(systemName: "heart.fill")
            }
        case .trailingCellButton(let cellType):
            switch cellType {
            case .removeFromRecent:
                return  UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
            case .favorite(let type):
                switch type {
                case .add:
                    return UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate)
                case .remove:
                    return UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
                case .none:
                    return UIImage()
                }
            }
        case .tabBarImages(let type):
            switch type {
            case .search:
                return UIImage(systemName: "magnifyingglass")
            case .favorites:
                return UIImage(systemName: "heart")
            }
        case .storyButtons(let type):
            switch type {
            case .save:
                return UIImage(systemName: "square.and.arrow.down")?.withRenderingMode(.alwaysTemplate)
            case .share:
                return UIImage(systemName: "square.and.arrow.up")?.withRenderingMode(.alwaysTemplate)
            }
        case .scrollToTop:
            return UIImage(systemName: "arrow.up")?.withRenderingMode(.alwaysTemplate)
        case .stateView(let type):
            switch type {
            case .noStories:
                return UIImage(named: "bubble-gum-error")
            case .noSearchResults:
                return UIImage(named: "bubble-gum-searching")
            case .noRecents:
                return UIImage(named: "bubble-gum-shilling-on-vacation")
            case .noFavorites:
                return UIImage(named: "bubble-gum-woman-with-a-big-magnet-attracts-likes")
            case .isPrivate:
                return UIImage(named: "bubble-gum-private")
            }
        }
    }
}
