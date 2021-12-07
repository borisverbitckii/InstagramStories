//
//  PreferencesPresenter.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import Foundation

protocol PreferencesPresenterProtocol {
    func viewDidLoad()
}

final class PreferencesPresenter {
    
    //MARK: - Private properties
    private weak var view: PreferencesViewProtocol?
    private let dataServicesFacade: DataServicesFacadeProtocol
    
    //MARK: - Init
    init(dataServicesFacade: DataServicesFacadeProtocol) {
        self.dataServicesFacade = dataServicesFacade
    }
    
    //MARK: - Public methods
    func injectView(view: PreferencesViewProtocol) {
        self.view = view
    }
    
}

//MARK: - FavoritesPresenterProtocol
extension PreferencesPresenter: PreferencesPresenterProtocol {
    func viewDidLoad() {
    }
}
