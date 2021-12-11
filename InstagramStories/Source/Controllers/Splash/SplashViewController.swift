//
//  SplashViewController.swift
//  InstagramStories
//
//  Created by Борис on 10.12.2021.
//

import UIKit.UIViewController

protocol SplashView: AnyObject {
    func showAlertController(title: String, message: String)
}

final class SplashViewController: UIViewController {
    
    //MARK: - Private properties
    private let presenter: SplashPresenterProtocol
    private let viewsFactory: ViewsFactoryProtocol
    private var activityIndicator: CustomActivityIndicator?
    
    //MARK: - Init
    init(presenter: SplashPresenterProtocol,
         viewsFactory: ViewsFactoryProtocol) {
        self.presenter = presenter
        self.viewsFactory = viewsFactory
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        activityIndicator = viewsFactory.getCustomActivityIndicator()
        activityIndicator?.size = .large
        addSubviews()
        layout()
    }
    
    //MARK: - Private methods
    private func addSubviews() {
        if let activityIndicator = activityIndicator {
            view.addSubview(activityIndicator)
        }
    }
    
    private func layout() {
        activityIndicator?.pin
            .center()
    }
}

//MARK: - extension + SplashView
extension SplashViewController: SplashView {
    
}
