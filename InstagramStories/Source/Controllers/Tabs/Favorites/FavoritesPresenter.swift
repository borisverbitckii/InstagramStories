//
//  FavoritesPresenter.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit

protocol FavoritesPresenterProtocol {
    func viewDidLoad()
    func presentPreferences(navigationController: UINavigationController)
}

final class FavoritesPresenter {
    
    //MARK: - Private properties
    private weak var view: FavoritesViewProtocol?
    private let coordinator: CoordinatorProtocol
    private let favoritesUseCase: FavoritesUseCaseProtocol
    
    //MARK: - Init
    init(coordinator: CoordinatorProtocol,
         favoritesUseCase: FavoritesUseCaseProtocol) {
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
        favoritesUseCase.fetchFavoritesUsersFromBD { [weak self] result in
            switch result{
            case .success(_):
                
                //TODO: Delete this
                self?.view?.showFavoritesUsers(users: [InstagramUser(name: "Boris", instagramUsername: "verbitsky", userIcon: UIImage(systemName: "heart")!.pngData()!, posts: 230, subscribers: 2786, subscriptions: 3376, isOnFavorite: false, getNotifications: false, stories: [Story]())])
                //--
            case .failure(let error):
                self?.view?.showAlertController(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    //MARK: Navigation
    
    func presentPreferences(navigationController: UINavigationController) {
        coordinator.presentPreferencesViewController(navigationController: navigationController)
    }
}
