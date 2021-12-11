//
//  ProfileViewController.swift
//  InstagramStories
//
//  Created by Борис on 11.12.2021.
//

import UIKit

protocol ProfileViewProtocol: AnyObject {
    
}

final class ProfileViewController: UIViewController {
    
    //MARK: - Private properties
    private let presenter: ProfilePresenterProtocol
    private let viewsFactory: ViewsFactoryProtocol
    
    //MARK: - Init
    init(presenter: ProfilePresenterProtocol,
         viewsFactory: ViewsFactoryProtocol) {
        self.presenter = presenter
        self.viewsFactory = viewsFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        view.backgroundColor = .darkGray
    }
}

//MARK: - extension + ProfileViewProtocol
extension ProfileViewController: ProfileViewProtocol {
    
}
