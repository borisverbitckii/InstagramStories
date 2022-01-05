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
    case error
    case errorInUsername
    case videoSaved
    case success
    case stateViewMain(StateViewType)
    case stateViewSecondary(StateViewType)
    case next
    
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
        case .error:
            return "Ошибка".localized
        case .errorInUsername:
            return "Пожалуйста, не используйте пробел".localized
        case .videoSaved:
            return "Видео сохранено".localized
        case .success:
            return "Прекрасно!".localized
        case .stateViewMain(let stateViewType):
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
        case .stateViewSecondary(let stateViewType):
            switch stateViewType {
            case .noStories:
                return "Попробуйте зайти позже".localized
            case .noSearchResults:
                return "Может вы где-то ошиблись?".localized
            case .noRecents:
                return "История поиска будет отображена здесь".localized
            case .noFavorites:
                return "Просто нажмите на сердечко в профиле".localized
            case .isPrivate:
                return "К сожалению, истории этого пользователя никак не посмотреть".localized
            }
            
        case .next:
            return "Далее".localized
        }
    }
}

enum searchHeaderTitleType {
    case recent
    case searchResult
}
