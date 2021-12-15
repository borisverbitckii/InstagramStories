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
    private var activityIndicator: CustomActivityIndicator = {
        $0.type = .withBackgroundView(.medium)
        return $0
    }(CustomActivityIndicator())
    
    //MARK: - Init
    init(presenter: SplashPresenterProtocol) {
        self.presenter = presenter
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
        addSubviews()
        layout()
    }
    
    //MARK: - Private methods
    private func addSubviews() {
        view.addSubview(activityIndicator)
        
    }
    
    private func layout() {
        activityIndicator.pin
            .center()
    }
}

//MARK: - extension + SplashView
extension SplashViewController: SplashView {
    
}
