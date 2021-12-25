//
//  StoryPresenter.swift
//  InstagramStories
//
//  Created by Борис on 21.12.2021.
//

import UIKit
import Swiftagram

protocol StoryPresenterProtocol {
    func viewDidLoad()
    func fetchStoryPreview(urlString: String, completion: @escaping (Result<UIImage, Error>) -> ())
    func downloadCurrentStoryVideo(urlString: String, completion: @escaping (URL)->())
}

final class StoryPresenter {
    
    //MARK: - Private properties
    private weak var view: StoryViewProtocol?
    private let coordinator: CoordinatorProtocol
    private let useCase: ShowStoryUseCaseProtocol
    private let secret: Secret
    private let stories: [Story]
    private let user: InstagramUser
    private let selectedStoryIndex: Int
    
    //
    private var timer: Timer?
    
    //MARK: - Init
    init(coordinator: CoordinatorProtocol,
         secret: Secret,
         useCase: ShowStoryUseCaseProtocol,
         stories: [Story],
         user: InstagramUser,
         selectedStoryIndex: Int) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.secret = secret
        self.stories = stories
        self.user = user
        self.selectedStoryIndex = selectedStoryIndex
    }
    
    //MARK: - Public methods
    func injectView(view: StoryViewProtocol) {
        self.view = view
    }
}

//MARK: - extension + StoryPresenterProtocol
extension StoryPresenter: StoryPresenterProtocol {
    func viewDidLoad() {
        view?.injectUser(user)
        let reversedStories: [Story] = stories.reversed()
        view?.injectStories(reversedStories) // for changing story position (new at the end)
        let reversedSelectedIndex = reversedStories.count - 1 - selectedStoryIndex
        view?.injectCurrentStoryIndex(reversedSelectedIndex)
        let title = "@" + user.instagramUsername
        view?.setupTitle(title)
    }
    
    func fetchStoryPreview(urlString: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        useCase.fetchStoryPreview(urlString: urlString, completion: completion)
    }
    
    func downloadCurrentStoryVideo(urlString: String, completion: @escaping (URL)->()) {
        useCase.downloadCurrentStoryVideo(urlString: urlString, completion: completion)
    }
}
