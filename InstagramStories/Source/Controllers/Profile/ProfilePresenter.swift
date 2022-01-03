//
//  ProfilePresenter.swift
//  InstagramStories
//
//  Created by Борис on 11.12.2021.
//

import UIKit.UIImage
import Swiftagram

protocol ProfilePresenterProtocol {
    var stories: [Story]? { get }
    
    func viewDidLoad()
    func presentStory(transitionHandler: TransitionProtocol, selectedStoryIndex: Int)
    func favoritesButtonTapped()
    func fetchImage(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> ())
}

final class ProfilePresenter {
    
    //MARK: - Public properties
    var stories: [Story]?
    
    //MARK: - Private properties
    private weak var view: ProfileViewProtocol?
    private weak var transitionHandler: TransitionProtocol?
    private let coordinator: CoordinatorProtocol
    private let loadUserProfileUseCase: LoadUserProfileUseCase
    private let changeFavoritesUseCase: ChangeFavoritesUseCaseProtocol
    private var user: RealmInstagramUserProtocol
    private let secret: Secret
    
    //MARK: - Init
    init(coordinator: CoordinatorProtocol,
         loadUserProfileUseCase: LoadUserProfileUseCase,
         saveFavoritesUseCase: ChangeFavoritesUseCaseProtocol,
         secret: Secret,
         user: RealmInstagramUserProtocol) {
        self.coordinator = coordinator
        self.loadUserProfileUseCase = loadUserProfileUseCase
        self.changeFavoritesUseCase = saveFavoritesUseCase
        self.secret = secret
        self.user = user
    }
    
    //MARK: - Public methods
    func injectView(view: ProfileViewProtocol) {
        self.view = view
    }
}

//MARK: - extension + ProfilePresenterProtocol
extension ProfilePresenter: ProfilePresenterProtocol {
    
    func viewDidLoad() {
        var userDetails = UserDetails(title: "@" + user.instagramUsername,
                                      instagramUsername: user.name)
        
        view?.setupUserDetails(details: userDetails)
        
        fetchImage(stringURL: user.userIconURL) { [weak self] result in
            switch result {
            case .success(let image):
                self?.view?.setupUserImage(image: image)
            case .failure(let error):
                print(#file, #line, error)
            }
        }
        
        if user.isPrivate {
            view?.showProfileIsPrivate()
            return
        }
        
        loadUserProfileUseCase.fetchUserDetails(userID: user.id, secret: secret) { [weak self] result in
            switch result {
            case .success(let details):
                userDetails.additionalUserDetails = details
                self?.view?.setupUserDetails(details: userDetails)
            case .failure(let error):
                print(#file, #line, error)
            }
        }
        
        loadUserProfileUseCase.fetchUserStories(userID: String(user.id), secret: secret) { [weak self] result in
            switch result {
            case .success(let stories):
                self?.stories = stories
                self?.view?.setupStoriesCount(stories.count)
            case .failure(let error): break
                break //TODO: Fix this
            }
        }
    }
    
    func favoritesButtonTapped() {
        let userState = DataBaseManager.getUserState(user: user)
        var favoriteUser = user
        
        switch userState {
        case .onlyOnFavorites:
            changeFavoritesUseCase.removeFavoriteUser(user: user) { _ in }
        case .onlyOnRecents:
            favoriteUser.isOnFavorite = true
            favoriteUser.isRecent = true
            changeFavoritesUseCase.changeFavoriteUser(user: favoriteUser) { _ in }
        case .onFavoritesAndRecents:
            favoriteUser.isRecent = true
            favoriteUser.isOnFavorite = false
            changeFavoritesUseCase.changeFavoriteUser(user: favoriteUser) { _ in }
        case .notExist: break
        }
    }
    
    func fetchImage(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        loadUserProfileUseCase.fetchImageData(urlString: stringURL) { result in
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else { return }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
                print(#file, #line, error)
            }
        }
    }
    
    func presentStory(transitionHandler: TransitionProtocol, selectedStoryIndex: Int) {
        coordinator.presentStoryViewController(transitionHandler: transitionHandler,
                                               user: user,
                                               selectedStoryIndex: selectedStoryIndex,
                                               stories: stories ?? [Story](),
                                               secret: secret)
        
    }
}
