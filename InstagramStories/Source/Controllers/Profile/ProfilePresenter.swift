//
//  ProfilePresenter.swift
//  InstagramStories
//
//  Created by Борис on 11.12.2021.
//

protocol ProfilePresenterProtocol {
    func viewDidLoad()
}

final class ProfilePresenter {
    
    //MARK: - Private properties
    private weak var view: ProfileViewProtocol?
    private let coordinator: CoordinatorProtocol
    private let useCase: ProfileUseCaseProtocol
    
    //MARK: - Init
    init(coordinator: CoordinatorProtocol,
         useCase: ProfileUseCaseProtocol) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
    
    //MARK: - Public methods
    func injectView(view: ProfileViewProtocol) {
        self.view = view
    }
}

//MARK: - extension + ProfilePresenterProtocol
extension ProfilePresenter: ProfilePresenterProtocol {
    func viewDidLoad() {
        
    }
}
