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
    case tryAgain
    case tryLatter
    case error
    case errorInUsername
    case videoSaved
    case success
    case stateView(StateViewType)
    
    func getText() -> String {
        switch self {
        case .navTitle(let titleType):
            switch titleType {
            case .search:
                return "Поиск".localized
            case .favorites:
                return "Избранное".localized
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
        case .tryAgain:
            return "Попробуйте еще раз".localized
        case .tryLatter:
            return "Попробуйте позже".localized
        case .error:
            return "Ошибка".localized
        case .errorInUsername:
            return "Пожалуйста, не используйте пробел".localized
        case .videoSaved:
            return "Видео сохранено".localized
        case .success:
            return "Успех".localized
        case .stateView(let stateViewType):
            switch stateViewType {
            case .noStories:
                return "Нет новых stories".localized
            case .noSearchResults:
                return "Пользователь не найден".localized
            case .noRecents:
                return "Начните свой первый поиск".localized
            case .noFavorites:
                return "Вы еще не добавили никого в избранные"
            case .isPrivate:
                return "Профиль закрыт".localized
            }
        }
    }
}

enum searchHeaderTitleType {
    case recent
    case searchResult
}
