//
//  FavoritesPresenter.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit

protocol FavoritesPresenterProtocol {
    func viewDidLoad()
}

final class FavoritesPresenter {
    
    //MARK: - Private properties
    private weak var view: FavoritesViewProtocol?
    private let coordinator: CoordinatorProtocol
    private let favoritesUseCase: ShowFavoritesUseCaseProtocol
    
    //MARK: - Init
    init(coordinator: CoordinatorProtocol,
         favoritesUseCase: ShowFavoritesUseCaseProtocol) {
        self.coordinator = coordinator
        self.favoritesUseCase = favoritesUseCase
    }
    
    //MARK: - Public methods
    func injectView(view: FavoritesViewProtocol) {
        self.view = view
    }
}

//MARK: - FavoritesPresenterProtocol
extension FavoritesPresenter: FavoritesPresenterProtocol {
    
    func viewDidLoad() {
        favoritesUseCase.showFavoritesUsers { [weak self] result in
            switch result{
            case .success(_):
                
                //TODO: Delete this
                self?.view?.showFavoritesUsers(users: [InstagramUser(name: "Boris",profileDescription: "desription", instagramUsername: "verbitsky",id: 100, userIconURL: "", posts: 230, subscribers: 2786, subscriptions: 3376,isPrivate: false)])
                //--
            case .failure(let error):
                self?.view?.showAlertController(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    //MARK: Navigation
}
