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
    private var user: InstagramUser?
    
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
    
    func injectUser(_ user: InstagramUser) {
        self.user = user
    }
}

//MARK: - extension + ProfilePresenterProtocol
extension ProfilePresenter: ProfilePresenterProtocol {
    func viewDidLoad() {
        guard let user = user else { return }
        view?.showUser(user)
    }
}
