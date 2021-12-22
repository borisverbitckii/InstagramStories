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
    private weak var transitionHandler: TransitionProtocol?
    private weak var coordinator: CoordinatorProtocol?
    private let useCase: ShowPreferencesUseCaseProtocol
    
    //MARK: - Init
    init(coordinator: CoordinatorProtocol,
         preferencesUseCase: ShowPreferencesUseCaseProtocol) {
        self.coordinator = coordinator
        self.useCase = preferencesUseCase
    }
    
    //MARK: - Public methods
    func injectView(view: PreferencesViewProtocol) {
        self.view = view
    }
    
    func injectTransitionHandler(view: TransitionProtocol) {
        self.transitionHandler = view
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
                self?.view?.showAlertController(title: "Error", message: error.localizedDescription, completion: nil)
            }
        }
    }
}
