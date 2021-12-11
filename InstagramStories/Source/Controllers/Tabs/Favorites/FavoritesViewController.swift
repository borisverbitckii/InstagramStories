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


//MARK: - extension + FavoritesViewProtocol
extension FavoritesViewController: FavoritesViewProtocol {
    func showFavoritesUsers(users: [InstagramUser]) {
        favoritesUsers = users
    }
}

//MARK: - extension + UITableViewDataSource, UITableViewDelegate
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConstantsForCommonViewController.reuseIdentifier,
                                                 for: indexPath) as? InstagramUserCell else { return UITableViewCell() }
        
        let user = favoritesUsers[indexPath.row]
        cell.configure(type: .remove, user: user)
        cell.buttonDelegate = self
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

//MARK: - extension + InstagramUserCellDelegate
extension FavoritesViewController: InstagramUserCellButtonDelegate {
    
    func trailingButtonTapped(type: InstagramUserCellType) {
        switch type {
        case .remove:
            break
        case .addToFavorites:
            break
        }
    }
}
