//
//  PresentationPresenter.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

protocol PresentationPresenterProtocol {
    func viewDidLoad()
}

final class PresentationPresenter {
    
    //MARK: - Private properties
    private weak var view: PresentationViewProtocol?
    
    //MARK: - Public methods
    func injectView(view: PresentationViewProtocol) {
        self.view = view
    }
}

//MARK: - FavoritesPresenterProtocol
extension PresentationPresenter: PresentationPresenterProtocol {
    func viewDidLoad() {
    }
}
