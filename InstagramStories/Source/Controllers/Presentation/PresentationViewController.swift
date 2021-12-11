//
//  PresentationViewController.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit

protocol PresentationViewProtocol: AnyObject {
    
}

final class PresentationViewController: UIViewController {
    
    //MARK: - Private properties
    private let presenter: PresentationPresenterProtocol
    
    //MARK: - Init
    init(presenter: PresentationPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}


//MARK: - FavoritesViewProtocol
extension PresentationViewController: PresentationViewProtocol {
    
}
