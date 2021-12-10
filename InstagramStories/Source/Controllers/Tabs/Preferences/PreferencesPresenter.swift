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
    private weak var coordinator: CoordinatorProtocol?
    private let useCase: PreferencesUseCaseProtocol
    
    //MARK: - Init
    init(coordinator: CoordinatorProtocol,
         preferencesUseCase: PreferencesUseCaseProtocol) {
        self.coordinator = coordinator
        self.useCase = preferencesUseCase
    }
    
    //MARK: - Public methods
    func injectView(view: PreferencesViewProtocol) {
        self.view = view
    }
    
}

//MARK: - FavoritesPresenterProtocol
extension PreferencesPresenter: PreferencesPresenterProtocol {
    
    func viewDidLoad() {
        useCase.getMenuItems { [weak self] result in
            switch result {
            case .success(let settings):
                self?.view?.showMenuItem(settings: settings)
            case .failure(let error):
                self?.view?.showAlertController(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
