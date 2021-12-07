//
//  SearchPresenter.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import Foundation

protocol SearchPresenterProtocol {
    func viewDidLoad()
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
                self?.view?.showUsers(users: users)
            case .failure(let error):
                self?.view?.showAlertController(title: "Error", message: error.localizedDescription)
            }
        })
    }
    
    func fetchSearchingUsers(username: String) {
        dataServicesFacade.fetchData(type: .search(username)) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                self.view?.showAlertController(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
