//
//  ProfileViewController.swift
//  InstagramStories
//
//  Created by Борис on 11.12.2021.
//

import UIKit

protocol ProfileViewProtocol: AnyObject {
    func showUser(_ user: InstagramUser)
}

final class ProfileViewController: UIViewController {
    
    private var user: InstagramUser? {
        didSet {
            title = user?.name
        }
    }
    
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
        view.backgroundColor = .white
    }
}

//MARK: - extension + ProfileViewProtocol
extension ProfileViewController: ProfileViewProtocol {
    func showUser(_ user: InstagramUser) {
        self.user = user
    }
}
