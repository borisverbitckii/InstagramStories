//
//  FavoritesViewController.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit

protocol FavoritesViewProtocol: AnyObject {
    
}

final class FavoritesViewController: UIViewController {
    
    //MARK: - Private properties
    private let presenter: FavoritesPresenterProtocol
    
    //MARK: - Init
    init(presenter: FavoritesPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}


//MARK: - FavoritesViewProtocol
extension FavoritesViewController: FavoritesViewProtocol {
    
}
