//
//  SearchPresenter.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import UIKit
import Swiftagram

protocol SearchPresenterProtocol {
    var searchingInstagramUsers: [RealmInstagramUserProtocol] { get }
    var recentUsers: [RealmInstagramUserProtocol] { get }

    func viewWillAppear()
    func searchResultWasUpdated(username: String)
    func userImageWillBeShown(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> Void)
    func cellWasTapped(indexPath: Int, isRecent: Bool)
    func searchBarCancelButtonClicked()
    func trailingButtonTapped(type: InstagramUserCellType, user: RealmInstagramUserProtocol)
    func cellForItemIsExecute(user: RealmInstagramUserProtocol) -> Bool
}

final class SearchPresenter {

    // MARK: - Public properties
    var searchingInstagramUsers: [RealmInstagramUserProtocol]
    var recentUsers: [RealmInstagramUserProtocol]

    // MARK: - Private properties
    private weak var view: SearchViewProtocol?
    private weak var transitionHandler: TransitionProtocol?
    private let secret: Secret
    private let coordinator: CoordinatorProtocol
    private let searchUseCase: SearchUseCaseProtocol
    private let changeRecentUsersUseCase: ChangeRecentUseCaseProtocol
    private let changeFavoritesUseCase: ChangeFavoritesUseCaseProtocol

    // MARK: - Init
    init(coordinator: CoordinatorProtocol,
         searchUseCase: SearchUseCaseProtocol,
         changeRecentUsersUseCase: ChangeRecentUseCaseProtocol,
         changeFavoritesUseCase: ChangeFavoritesUseCaseProtocol,
         secret: Secret) {
        self.searchingInstagramUsers = [RealmInstagramUserProtocol]()
        self.recentUsers = [RealmInstagramUserProtocol]()
        self.coordinator = coordinator
        self.searchUseCase =  searchUseCase
        self.changeRecentUsersUseCase = changeRecentUsersUseCase
        self.changeFavoritesUseCase = changeFavoritesUseCase
        self.secret = secret
    }

    // MARK: - Public methods
    func injectView(view: SearchViewProtocol) {
        self.view = view
    }

    func injectTransitionHandler(view: TransitionProtocol) {
        self.transitionHandler = view
    }
}

// MARK: - SearchPresenterProtocol

extension SearchPresenter: SearchPresenterProtocol {

    func viewWillAppear() {
        if recentUsers.isEmpty {
            changeRecentUsersUseCase.fetchRecentUsersFromBD { [weak self] users in
                self?.view?.setupRecentUsersCount(number: users.count)
                self?.recentUsers = users
            }
        }

        renewRecents(type: .reload)
    }

    func cellForItemIsExecute(user: RealmInstagramUserProtocol) -> Bool {
        DataBaseManager.isOnFavorite(user: user)
    }

    func trailingButtonTapped(type: InstagramUserCellType, user: RealmInstagramUserProtocol) {
        let userState = DataBaseManager.getUserState(user: user)
        let firstIndexOfUser = recentUsers.firstIndex { $0.id == user.id} ?? 0
        switch type {
        case .removeFromRecent:
            switch userState {
            case .onlyOnRecents:
                changeRecentUsersUseCase.removeRecentUser(user: user) { [weak self] _ in
                    self?.changeRecentUsersUseCase.fetchRecentUsersFromBD { _ in
                        self?.renewRecents(type: .remove(index: firstIndexOfUser))
                    }
                }
            case .onFavoritesAndRecents:
                var notRecentUser = user
                notRecentUser.isRecent = false
                changeRecentUsersUseCase.changeRecentUser(user: notRecentUser) { [weak self] _ in
                    self?.changeRecentUsersUseCase.fetchRecentUsersFromBD { _ in
                        self?.renewRecents(type: .remove(index: firstIndexOfUser))
                    }
                }
            case .notExist, .onlyOnFavorites: break
            }

        case .favorite:
            var favoriteUser = user

            switch userState {
            case .notExist:
                favoriteUser.isOnFavorite = true
                changeFavoritesUseCase.saveFavoritesUser(user: favoriteUser) { _ in }
            case .onlyOnFavorites:
                changeRecentUsersUseCase.removeRecentUser(user: user) { _ in }
            case .onlyOnRecents:
                favoriteUser.isRecent = true
                favoriteUser.isOnFavorite = true
                changeFavoritesUseCase.changeFavoriteUser(user: favoriteUser) { _ in }
            case .onFavoritesAndRecents:
                favoriteUser.isRecent = true
                favoriteUser.isOnFavorite = false
                changeFavoritesUseCase.changeFavoriteUser(user: favoriteUser) { _ in }
            }
        }
    }

    func cellWasTapped(indexPath: Int, isRecent: Bool) {

        if isRecent {
            let recentUser = recentUsers[indexPath]
            presentProfile(with: recentUser)
            return
        }

        var user = searchingInstagramUsers[indexPath]
        let userState = DataBaseManager.getUserState(user: user)

        switch userState {
        case .notExist:
            user.isRecent = true
            changeRecentUsersUseCase.saveRecentUser(user: user) { _ in }
        case .onlyOnFavorites:
            user.isOnFavorite = true
            user.isRecent = true
            changeRecentUsersUseCase.changeRecentUser(user: user) { _ in }
        case .onlyOnRecents, .onFavoritesAndRecents:
            break
        }

        presentProfile(with: user)
    }

    func userImageWillBeShown(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        searchUseCase.fetchImage(stringURL: stringURL, completion: completion)
    }

    func searchResultWasUpdated(username: String) {
        searchUseCase.fetchInstagramUsersFromNetwork(searchingTitle: username, secret: secret) { [weak self] result in
            switch result {
            case .success(let users):
                self?.searchingInstagramUsers = users
                self?.view?.setupSearchingUsersCount(number: users.count)
            case .failure(let error):
                self?.view?.showAlertController(title: "Error", message: error.localizedDescription, completion: nil)
            }
            self?.view?.hideActivityIndicator()
        }
    }

    func searchBarCancelButtonClicked() {
        searchUseCase.stopLastOperation()
        changeRecentUsersUseCase.fetchRecentUsersFromBD { [weak self] _ in
            self?.renewRecents(type: .reload)
            self?.view?.setupSearchingUsersCount(number: 0)
        }
    }

    // MARK: - Navigation
    private func presentProfile(with user: RealmInstagramUserProtocol) {
        guard let transitionHandler = transitionHandler else { return }
        coordinator.presentProfileViewController(transitionHandler: transitionHandler, with: user, secret: secret)
    }

    private func renewRecents(type: RenewCollectionViewType) {
        switch type {
        case .remove(index: let index):
            view?.removeItem(at: index)
            changeRecentUsersUseCase.fetchRecentUsersFromBD { [weak self] users in
                self?.recentUsers = users
            }
        case .reload:
            changeRecentUsersUseCase.fetchRecentUsersFromBD { [weak self] users in
                self?.recentUsers = users
                self?.view?.setupRecentUsersCount(number: users.count)
            }
        }
    }
}
