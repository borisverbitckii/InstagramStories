//
//  PreferencesPresenter.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//


protocol PreferencesPresenterProtocol {
    func viewDidLoad()
}

final class PreferencesPresenter {
    
    //MARK: - Private properties
    private weak var view: PreferencesViewProtocol?
    
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
