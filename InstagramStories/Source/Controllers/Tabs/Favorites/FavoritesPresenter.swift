//
//  FavoritesPresenter.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit
import Swiftagram

protocol FavoritesPresenterProtocol {
    var favoritesUsers: [RealmInstagramUserProtocol] { get }
    
    func viewWillAppear()
    func userImageWillBeShown(stringURL: String, completion: @escaping (Result<UIImage,Error>)->())
    func trailingButtonTapped(type: InstagramUserCellType, user: RealmInstagramUserProtocol)
    func cellWasTapped(indexPath: Int)
}

final class FavoritesPresenter {
    
    //MARK: - Public properties
    var favoritesUsers: [RealmInstagramUserProtocol]
    
    //MARK: - Private properties
    private weak var view: FavoritesViewProtocol?
    private weak var transitionHandler: TransitionProtocol?
    private let coordinator: CoordinatorProtocol
    private let changeFavoritesUseCase: ChangeFavoritesUseCaseProtocol
    private let secret: Secret
    
    
    //MARK: - Init
    init(coordinator: CoordinatorProtocol,
         changeFavoritesUseCase: ChangeFavoritesUseCaseProtocol,
         secret: Secret) {
        self.favoritesUsers = [RealmInstagramUserProtocol]()
        self.coordinator = coordinator
        self.changeFavoritesUseCase = changeFavoritesUseCase
        self.secret = secret
    }
    
    //MARK: - Public methods
    func injectView(view: FavoritesViewProtocol) {
        self.view = view
    }
    
    func injectTransitionHandler(view: TransitionProtocol) {
        self.transitionHandler = view
    }
}

//MARK: - FavoritesPresenterProtocol
extension FavoritesPresenter: FavoritesPresenterProtocol {
    
    func viewWillAppear() {
        renewFavorites()
        if favoritesUsers.count != 0 {
            view?.hideStateView()
        }
    }
    
    func userImageWillBeShown(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        changeFavoritesUseCase.fetchImage(stringURL: stringURL, completion: completion)
    }
    
    func trailingButtonTapped(type: InstagramUserCellType, user: RealmInstagramUserProtocol) {
        
        let userState = DataBaseManager.getUserState(user: user)
        
        switch type {
        case .removeFromRecent: break
        case .favorite:
            switch userState {
            case .onlyOnFavorites:
                changeFavoritesUseCase.removeFavoriteUser(user: user) { [weak self] _ in
                    self?.renewFavorites()
                }
            case .onFavoritesAndRecents:
                var notFavoriteUser = user
                notFavoriteUser.isOnFavorite = false
                notFavoriteUser.isRecent = true
                changeFavoritesUseCase.changeFavoriteUser(user: notFavoriteUser) { [weak self] _ in
                    self?.renewFavorites()
                }
            case .notExist, .onlyOnRecents: break
            }
        }
    }
    
    func cellWasTapped(indexPath: Int) {
        let user = favoritesUsers[indexPath]
        guard let transitionHandler = transitionHandler else { return }
        coordinator.presentProfileViewController(transitionHandler: transitionHandler, with: user, secret: secret)
    }
    
    //MARK: - Private methods
    private func renewFavorites() {
        changeFavoritesUseCase.loadFavoritesUsers { [weak self] users in
            self?.favoritesUsers = users
            self?.view?.setupFavoritesCount(number: users.count)
        }
    }
}
