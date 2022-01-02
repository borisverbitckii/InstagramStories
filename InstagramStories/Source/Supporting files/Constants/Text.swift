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
    case posts
    case subscribers
    case subscriptions
    case noSearchResult
    case tryAgain
    case noStories
    case tryLatter
    case isPrivate
    case error
    case errorInUsername
    case videoSaved
    case success
    
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
        case .posts:
            return "Публикации".localized
        case .subscribers:
            return "Подписчики".localized
        case .subscriptions:
            return "Подписки".localized
        case .noSearchResult:
            return "Пользователь не найден".localized
        case .tryAgain:
            return "Попробуйте еще раз".localized
        case .noStories:
            return "Нет новых stories".localized
        case .tryLatter:
            return "Попробуйте позже".localized
        case .isPrivate:
            return "Профиль закрыт"
        case .error:
            return "Ошибка".localized
        case .errorInUsername:
            return "Пожалуйста, не используйте пробел".localized
        case .videoSaved:
            return "Видео сохранено".localized
        case .success:
            return "Успех".localized
        }
    }
}

enum searchHeaderTitleType {
    case recent
    case searchResult
}
