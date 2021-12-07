//
//  FavoritesViewController.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit.UIViewController

protocol FavoritesViewProtocol: AnyObject {
    func showAlertController(title: String, message: String)
    func showFavoritesUsers(users: [InstagramUser])
}

final class FavoritesViewController: CommonViewController {
    
    //MARK: - Private properties
    private let presenter: FavoritesPresenterProtocol
    
    private var favoritesUsers: [InstagramUser] {
        didSet{
            tableView.reloadData()
        }
    }
    
    //MARK: - Init
    init(type: TabViewControllerType,
         presenter: FavoritesPresenterProtocol) {
        self.presenter = presenter
        self.favoritesUsers = [InstagramUser]()
        
        super.init(type: type)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}


//MARK: - FavoritesViewProtocol
extension FavoritesViewController: FavoritesViewProtocol {
    func showFavoritesUsers(users: [InstagramUser]) {
        favoritesUsers = users
    }
    
    func showAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConstantsForCommonViewController.reuseIdentifier,
                                                 for: indexPath) as? InstagramUserCell else { return UITableViewCell() }
        
        let user = favoritesUsers[indexPath.row]
        cell.configure(type: .remove, user: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // rootCoordinator
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConstantsForCommonViewController.cellHeight
    }
}
