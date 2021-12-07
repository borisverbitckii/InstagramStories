//
//  FavoritesPresenter.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import Foundation

protocol FavoritesPresenterProtocol {
    func viewDidLoad()
}

final class FavoritesPresenter {
    
    //MARK: - Private properties
    private weak var view: FavoritesViewProtocol?
    private let dataServicesFacade: DataServicesFacadeProtocol
    
    //MARK: - Init
    init(dataServicesFacade: DataServicesFacadeProtocol) {
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
    }
}
