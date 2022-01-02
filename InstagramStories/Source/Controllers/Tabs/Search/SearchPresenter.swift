//
//  SearchPresenter.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import UIKit
import Swiftagram
import RealmSwift

protocol SearchPresenterProtocol {
    var searchingInstagramUsers: [RealmInstagramUserProtocol] { get }
    var recentUsers: [RealmInstagramUserProtocol] { get }
    
    func viewDidLoad()
    func searchResultWasUpdated(username: String)
    func userImageWillBeShown(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> ())
    func cellWasTapped(indexPath: Int, isRecent: Bool)
    func searchBarCancelButtonClicked()
    func trailingButtonTapped(type: InstagramUserCellType, user: RealmInstagramUserProtocol)
    func cellForItemIsExecute(user: RealmInstagramUserProtocol) -> Bool
}

final class SearchPresenter {
    
    //MARK: - Public properties
    var searchingInstagramUsers: [RealmInstagramUserProtocol]
    var recentUsers: [RealmInstagramUserProtocol]
    
    //MARK: - Private properties
    private weak var view: SearchViewProtocol?
    private weak var transitionHandler: TransitionProtocol?
    private let secret: Secret
    private let coordinator: CoordinatorProtocol
    private let searchUseCase: SearchUseCaseProtocol
    private let changeRecentUsersUseCase: ChangeRecentUseCaseProtocol
    private let changeFavoritesUseCase: ChangeFavoritesUseCaseProtocol
    
    //MARK: - Init
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
    
    //MARK: - Public methods
    func injectView(view: SearchViewProtocol) {
        self.view = view
    }
    
    func injectTransitionHandler(view: TransitionProtocol) {
        self.transitionHandler = view
    }
}

//MARK: - SearchPresenterProtocol

extension SearchPresenter: SearchPresenterProtocol {
    
    func cellForItemIsExecute(user: RealmInstagramUserProtocol) -> Bool {
        DataBaseManager.isOnFavorite(user: user)
    }
    
    func trailingButtonTapped(type: InstagramUserCellType, user: RealmInstagramUserProtocol) {
        switch type {
        case .removeFromRecent:
            if user.isRecent {
                if !DataBaseManager.isOnFavorite(user: user) {
                    changeRecentUsersUseCase.removeRecentUser(user: user) { [weak self] _ in
                        self?.changeRecentUsersUseCase.fetchRecentUsersFromBD { users in
                            self?.view?.setupRecentUsersCount(number: users.count) // fix reloadData to reloadItem
                            self?.recentUsers = users
                        }
                    }
                } else {
                    var notRecentUser = user
                    notRecentUser.isRecent = false
                    changeRecentUsersUseCase.changeRecentUser(user: notRecentUser) { [weak self] _ in
                        self?.changeRecentUsersUseCase.fetchRecentUsersFromBD { users in
                            self?.view?.setupRecentUsersCount(number: users.count) // fix reloadData to reloadItem
                            self?.recentUsers = users
                        }
                    }
                }
            }
        case .favorite(_):
            
            if DataBaseManager.isOnFavorite(user: user) {
                var notFavoriteUser = user
                notFavoriteUser.isOnFavorite = false
                changeFavoritesUseCase.changeFavoriteUser(user: notFavoriteUser) { _ in
                    return
                        //TODO: fix with deleting user which is not necessary
                }
            } else {
                var favoriteUser = user
                if DataBaseManager.isAlreadyExist(user: user) {
                    favoriteUser.isOnFavorite = true
                    if DataBaseManager.isRecent(user: user ) {
                        favoriteUser.isRecent = true
                        changeFavoritesUseCase.changeFavoriteUser(user: favoriteUser) { _ in }
                    } else {
                        changeFavoritesUseCase.changeFavoriteUser(user: favoriteUser) { _ in }
                    }
                } else {
                    favoriteUser.isOnFavorite = true
                    changeFavoritesUseCase.saveFavoritesUser(user: favoriteUser) { _ in }
                }
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
        if !DataBaseManager.isAlreadyExist(user: user) {
            user.isRecent = true
            changeRecentUsersUseCase.saveRecentUser(user: user) { _ in }
        } else {
            if DataBaseManager.isOnFavorite(user: user) {
                user.isOnFavorite = true
                user.isRecent = true
                changeRecentUsersUseCase.changeRecentUser(user: user) { _ in }
            } else {
                user.isRecent = true
                changeRecentUsersUseCase.changeRecentUser(user: user) { _ in }
            }
            
        }
        presentProfile(with: user)
    }
    
    func userImageWillBeShown(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        searchUseCase.fetchImage(stringURL: stringURL, completion: completion)
    }
    
    //MARK: - Public methods
    func viewDidLoad() {
        changeRecentUsersUseCase.fetchRecentUsersFromBD { [weak self] users in
            self?.view?.setupRecentUsersCount(number: users.count)
            self?.recentUsers = users
        }
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
        changeRecentUsersUseCase.fetchRecentUsersFromBD { [weak self] users in
            self?.recentUsers = users
            self?.view?.setupRecentUsersCount(number: users.count)
            self?.view?.setupSearchingUsersCount(number: 0)
        }
    }
    
    //MARK: - Navigation
    private func presentProfile(with user: RealmInstagramUserProtocol) {
        guard let transitionHandler = transitionHandler else { return }
        coordinator.presentProfileViewController(transitionHandler: transitionHandler,with: user, secret: secret)
    }
}

final class UserStateHandler { // StateHandler
    
    func onlyExist() -> Bool {
        return false
    }
    
    func onlyOnFavorite() -> Bool {
        return false
    }
    
    func onlyOnRecents() -> Bool {
        return false
    }
    
    func onFavoritesAndRecents() -> Bool {
        return false
    }
    
}
