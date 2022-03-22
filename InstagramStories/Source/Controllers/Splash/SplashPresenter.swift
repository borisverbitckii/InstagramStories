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

    // MARK: - Private methods
    private weak var view: SplashView?
    private let coordinator: CoordinatorProtocol
    private let useCase: SplashUseCaseProtocol

    // MARK: - Init
    init(coordinator: CoordinatorProtocol,
         useCase: SplashUseCaseProtocol) {
        self.coordinator = coordinator
        self.useCase = useCase
    }

    // MARK: - Public methods
    func injectView(view: SplashView) {
        self.view = view
    }
}

// MARK: - extension + SplashPresenterProtocol

extension SplashPresenter: SplashPresenterProtocol {
    func viewDidLoad() {
        useCase.authInInstagram {[weak self] result in
            switch result {
            case .success(let secret):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.coordinator.presentTabBarController(secret: secret)
                }
            case .failure(let error):
                if (error as NSError).code == -1200 {
                    self?.view?.showAlertController(title: Text.errorHeader.getText(),
                                                    message: Text.needVPN.getText(),
                                                    action: nil,
                                                    completion: nil)
                } else {
                    self?.view?.showAlertController(title: Text.errorHeader.getText(),
                                                    message: Text.errorText.getText(),
                                                    action: nil,
                                                    completion: nil)
                }
                self?.view?.hideActivityIndicator()
            }
        }
    }
}
