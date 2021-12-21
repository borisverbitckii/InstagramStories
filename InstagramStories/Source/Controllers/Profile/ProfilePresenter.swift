//
//  ProfilePresenter.swift
//  InstagramStories
//
//  Created by Борис on 11.12.2021.
//

import UIKit.UIImage
import Swiftagram

protocol ProfilePresenterProtocol {
    func viewDidLoad()
    func fetchImage(stringURL: String, completion: @escaping (Result<UIImage, Error>)->())
}

final class ProfilePresenter {
    
    //MARK: - Private properties
    private weak var view: ProfileViewProtocol?
    private let coordinator: CoordinatorProtocol
    private let useCase: LoadUserProfileUseCase
    private var user: InstagramUser?
    private let secret: Secret
    
    //MARK: - Init
    init(coordinator: CoordinatorProtocol,
         useCase: LoadUserProfileUseCase,
         secret: Secret) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.secret = secret
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
        useCase.fetchUserStories(userID: String(user.id), secret: secret) { [weak self] result in
            switch result {
            case .success(let stories):
                self?.view?.showStoriesPreview(stories: stories)
            case .failure(let error): break
                break //TODO: Fix this
            }
        }
    }
    
    func fetchImage(stringURL: String, completion: @escaping (Result<UIImage, Error>)->()) {
        useCase.fetchImageData(urlString: stringURL) { result in
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else { return }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
