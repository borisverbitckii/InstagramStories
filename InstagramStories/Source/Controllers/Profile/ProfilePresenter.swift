//
//  ProfilePresenter.swift
//  InstagramStories
//
//  Created by Борис on 11.12.2021.
//

import UIKit.UIImage

protocol ProfilePresenterProtocol {
    func viewDidLoad()
    func fetchUserImage(stringURL: String, completion: @escaping (UIImage) -> ())
}

final class ProfilePresenter {
    
    //MARK: - Private properties
    private weak var view: ProfileViewProtocol?
    private let coordinator: CoordinatorProtocol
    private let useCase: LoadUserProfileUseCase
    private var user: InstagramUser?
    
    //MARK: - Init
    init(coordinator: CoordinatorProtocol,
         useCase: LoadUserProfileUseCase) {
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
    
    func fetchUserImage(stringURL: String, completion: @escaping (UIImage) -> ()) {
        useCase.fetchImageData(urlString: stringURL) { result in
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else { return }
                completion(image)
            case .failure(let error):
                break //TODO: Fix this
            }
        }
    }
}
