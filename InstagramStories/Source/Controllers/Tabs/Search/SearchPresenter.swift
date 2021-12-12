//
//  SearchPresenter.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import UIKit
import Swiftagram


protocol SearchPresenterProtocol {
    func viewDidLoad()
    func fetchSearchingUsers(username: String)
    func fetchImage(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> ())
    func presentProfile(with user: InstagramUser)
    func stopFetching()
}

final class SearchPresenter {
    
    //MARK: - Private properties
    private let secret: Secret
    private weak var view: SearchViewProtocol?
    private weak var transitionHandler: TransitionProtocol?
    private let coordinator: CoordinatorProtocol
    private let useCase: SearchUseCaseProtocol
    
    //MARK: - Init
    init(coordinator: CoordinatorProtocol,
         searchUseCase: SearchUseCaseProtocol,
         secret: Secret) {
        self.coordinator = coordinator
        self.useCase =  searchUseCase
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
    func fetchImage(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        useCase.fetchImage(stringURL: stringURL, completion: completion)
    }
    
    //MARK: - Public methods
    func viewDidLoad() {
        useCase.fetchRecentUsersFromBD { [weak self] result in
            switch result {
            case .success(_):
//                self?.view?.showRecentUsers(users: users) // dont delete
                //TODO: Delete this
                self?.view?.showRecentUsers(users: [InstagramUser(name: "Boris", instagramUsername: "verbitsky",id: 1000, userIconURL: "", posts: 230, subscribers: 2786, subscriptions: 3376, isPrivate: false, stories: [Story]())])
                //--
            case .failure(let error):
                self?.view?.showAlertController(title: "Error", message: error.localizedDescription)
                
            }
        }
    }
    
    func fetchSearchingUsers(username: String) {
        useCase.fetchInstagramUsersFromNetwork(searchingTitle: username, secret: secret) { [weak self] result in
            switch result {
            case .success(let users):
                self?.view?.showSearchingUsers(users: users)
            case .failure(let error):
                self?.view?.showAlertController(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func stopFetching() {
        useCase.stopLastOperation()
    }
    
    //MARK: - Navigation
    func presentProfile(with user: InstagramUser) {
        guard let transitionHandler = transitionHandler else { return }
        coordinator.presentProfileViewController(transitionHandler: transitionHandler,with: user)
    }
}
