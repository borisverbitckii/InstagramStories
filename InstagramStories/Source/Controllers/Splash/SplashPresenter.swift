//
//  SplashPresenter.swift
//  InstagramStories
//
//  Created by Борис on 10.12.2021.
//

import Foundation

protocol SplashPresenterProtocol {
    func viewDidLoad()
}

final class SplashPresenter {
    
    //MARK: - Private methods
    private weak var view: SplashView?
    private let coordinator: CoordinatorProtocol
    private let useCase: SplashUseCaseProtocol
    
    //MARK: - Init
    init(coordinator: CoordinatorProtocol,
         useCase: SplashUseCaseProtocol) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
    
    //MARK: - Public methods
    func injectView(view: SplashView) {
        self.view = view
    }
}

//MARK: - extension + SplashPresenterProtocol

extension SplashPresenter: SplashPresenterProtocol {
    func viewDidLoad() {
        useCase.authInInstagram {[weak self] result in
            switch result {
            case .success(let secret):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.coordinator.presentTabBarController(secret: secret)
                }
            case .failure(let error):
                self?.view?.showAlertController(title: "Error", message: error.localizedDescription, completion: nil)
            }
        }
    }
}
