//
//  PreferencesViewController.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import Foundation
import UIKit

import UIKit

protocol PreferencesViewProtocol: AnyObject {
    
}

final class PreferencesViewController: UIViewController {
    
    //MARK: - Private properties
    private let presenter: PreferencesPresenterProtocol
    
    //MARK: - Init
    init(presenter: PreferencesPresenterProtocol) {
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
extension PreferencesViewController: PreferencesViewProtocol {
    
}
