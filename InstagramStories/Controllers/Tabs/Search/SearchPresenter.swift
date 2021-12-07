//
//  SearchPresenter.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import UIKit


protocol SearchPresenterProtocol: CommonPresenterProtocol {
    func fetchSearchingUsers(username: String)
}

final class SearchPresenter {
    
    //MARK: - Private properties
    private weak var view: SearchViewProtocol?
    private let dataServicesFacade: DataServicesFacadeProtocol
    
    //MARK: - Init
    init(dataServicesFacade: DataServicesFacadeProtocol) {
        self.dataServicesFacade = dataServicesFacade
    }
    
    //MARK: - Public methods
    func injectView(view: SearchViewProtocol) {
        self.view = view
    }
}

//MARK: - SearchPresenterProtocol

extension SearchPresenter: SearchPresenterProtocol {
    func viewDidLoad() {
        dataServicesFacade.fetchData (type: .recentUsers, completion: { [weak self] result in
            switch result {
            case .success(let users):
//                self?.view?.showRecentUsers(users: users) // dont delete
                
                //TODO: Delete this
                self?.view?.showRecentUsers(users: [InstagramUser(name: "Boris", instagramUsername: "verbitsky", userIcon: UIImage(systemName: "heart")!.pngData()!, posts: 230, subscribers: 2786, subscriptions: 3376, isOnFavorite: false, getNotifications: false, stories: [Story]())])
                //--
            case .failure(let error):
                self?.view?.showAlertController(title: "Error", message: error.localizedDescription)
                
            }
        })
    }
    
    func fetchSearchingUsers(username: String) {
        dataServicesFacade.fetchData(type: .search(username)) { [weak self] result in
            switch result {
            case .success(let users):
                self?.view?.showSearchingUsers(users: users)
            case .failure(let error):
                self?.view?.showAlertController(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
