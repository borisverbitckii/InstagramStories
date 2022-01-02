//
//  FavoritesPresenter.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit
import RealmSwift

protocol FavoritesPresenterProtocol {
    var favoritesUsers: [RealmInstagramUserProtocol] { get }
    
    func viewWillAppear()
    func userImageWillBeShown(stringURL: String, completion: @escaping (Result<UIImage,Error>)->())
    func trailingButtonTapped(type: InstagramUserCellType, user: RealmInstagramUserProtocol)
}

final class FavoritesPresenter {
    
    //MARK: - Public properties
    var favoritesUsers: [RealmInstagramUserProtocol]
    
    //MARK: - Private properties
    private weak var view: FavoritesViewProtocol?
    private weak var transitionHandler: TransitionProtocol?
    private let coordinator: CoordinatorProtocol
    private let changeFavoritesUseCase: ChangeFavoritesUseCaseProtocol
    
    //MARK: - Init
    init(coordinator: CoordinatorProtocol,
         changeFavoritesUseCase: ChangeFavoritesUseCaseProtocol) {
        self.favoritesUsers = [RealmInstagramUserProtocol]()
        self.coordinator = coordinator
        self.changeFavoritesUseCase = changeFavoritesUseCase
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
        changeFavoritesUseCase.loadFavoritesUsers { [weak self] users in
            self?.favoritesUsers = users
            self?.view?.setupFavoritesCount(number: users.count)
        }
    }
    
    func userImageWillBeShown(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        changeFavoritesUseCase.fetchImage(stringURL: stringURL, completion: completion)
    }
    
    func trailingButtonTapped(type: InstagramUserCellType, user: RealmInstagramUserProtocol) {
        switch type {
        case .removeFromRecent: break
        case .favorite: break
        }
    }
}
