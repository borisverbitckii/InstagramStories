//
//  Text.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import Foundation

enum Text {
    case navTitle(TabViewControllerType)
    case searchBarPlaceholderText
    case searchBarCancelButton
    case searchHeaderTitle(searchHeaderTitleType)
    
    func getText() -> String {
        switch self {
        case .navTitle(let titleType):
            switch titleType {
            case .search:
                return "Поиск".localized
            case .favorites:
                return "Избранное".localized
            case .preferences:
                return "Настройки".localized
            }
        case .searchBarPlaceholderText:
            return "Введите ник в Instagram".localized
        case .searchBarCancelButton:
            return "Отмена".localized
        case .searchHeaderTitle(let type):
            switch type {
            case .recent:
                return "Недавнее".localized
            case .searchResult:
                return "Результаты поиска".localized
            }
        }
    }
}

enum searchHeaderTitleType {
    case recent
    case searchResult
}
