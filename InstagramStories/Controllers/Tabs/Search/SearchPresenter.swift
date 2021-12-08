//
//  SearchPresenter.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import UIKit


protocol SearchPresenterProtocol {
    func viewDidLoad()
    func fetchSearchingUsers(username: String)
    func presentPreferences(navigationController: UINavigationController)
}

final class SearchPresenter {
    
    //MARK: - Private properties
    private weak var view: SearchViewProtocol?
    private var coordinator: CoordinatorProtocol
    private var useCase: SearchUseCaseProtocol
    
    //MARK: - Init
    init(coordinator: CoordinatorProtocol,
         searchUseCase: SearchUseCaseProtocol) {
        self.coordinator = coordinator
        self.useCase =  searchUseCase
    }
    
    //MARK: - Public methods
    func injectView(view: SearchViewProtocol) {
        self.view = view
    }
}

//MARK: - SearchPresenterProtocol

extension SearchPresenter: SearchPresenterProtocol {
    
    //MARK: - Public methods
    func viewDidLoad() {
        useCase.fetchRecentUsersFromBD { [weak self] result in
            switch result {
            case .success(let users):
//                self?.view?.showRecentUsers(users: users) // dont delete
                
                //TODO: Delete this
                self?.view?.showRecentUsers(users: [InstagramUser(name: "Boris", instagramUsername: "verbitsky", userIcon: UIImage(systemName: "heart")!.pngData()!, posts: 230, subscribers: 2786, subscriptions: 3376, isOnFavorite: false, getNotifications: false, stories: [Story]())])
                //--
            case .failure(let error):
                self?.view?.showAlertController(title: "Error", message: error.localizedDescription)
                
            }
        }
    }
    
    func fetchSearchingUsers(username: String) {
        useCase.fetchInstagramUsersFromNetwork(searchingTitle: username) { [weak self] result in
            switch result {
            case .success(let users):
                self?.view?.showSearchingUsers(users: users)
            case .failure(let error):
                self?.view?.showAlertController(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    //MARK: - Navigation
    func presentPreferences(navigationController: UINavigationController) {
        coordinator.presentPreferences(navigationController: navigationController)
    }
}
