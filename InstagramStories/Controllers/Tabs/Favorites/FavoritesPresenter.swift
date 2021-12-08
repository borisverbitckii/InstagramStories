//
//  FavoritesPresenter.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit

protocol FavoritesPresenterProtocol: CommonPresenterProtocol {
}

final class FavoritesPresenter {
    
    //MARK: - Private properties
    private weak var view: FavoritesViewProtocol?
    private weak var coordinator: CoordinatorProtocol?
    private let dataServicesFacade: DataServicesFacadeProtocol
    
    //MARK: - Init
    init(dataServicesFacade: DataServicesFacadeProtocol,
         coordinator: CoordinatorProtocol) {
        self.dataServicesFacade = dataServicesFacade
    }
    
    //MARK: - Public methods
    func injectView(view: FavoritesViewProtocol) {
        self.view = view
    }
    
}

//MARK: - FavoritesPresenterProtocol
extension FavoritesPresenter: FavoritesPresenterProtocol {
    func viewDidLoad() {
        dataServicesFacade.fetchData(type: .favorites) { [weak self] result in
            switch result{
            case .success(let users):
                
                //TODO: Delete this
                self?.view?.showFavoritesUsers(users: [InstagramUser(name: "Boris", instagramUsername: "verbitsky", userIcon: UIImage(systemName: "heart")!.pngData()!, posts: 230, subscribers: 2786, subscriptions: 3376, isOnFavorite: false, getNotifications: false, stories: [Story]())])
                //--
            case .failure(let error):
                self?.view?.showAlertController(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
