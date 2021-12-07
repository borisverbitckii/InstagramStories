//
//  ViewController.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit
import PinLayout

protocol SearchViewProtocol: AnyObject {
    func showRecentUsers(users: [InstagramUser])
    func showSearchingUsers(users: [InstagramUser])
    func showAlertController(title: String, message: String)
}

final class SearchViewController: CommonViewController {
    
    //MARK: - Public properties
    private var recentUsers: [InstagramUser] {
        didSet{
            tableView.reloadData()
        }
    }
    private var searchingInstagramUsers : [InstagramUser] { // for search results
        didSet {
            tableView.reloadData()
        }
    }
    
    private var searchBarIsEmpty: Bool {
        guard let text =  searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    //MARK: - Private properties
    private var presenter: SearchPresenterProtocol?
    
    // UI elements
    private let searchController: UISearchController = {
        $0.searchBar.placeholder = Text.searchBarPlaceholderText.getText()
        $0.obscuresBackgroundDuringPresentation = false
        return $0
    }(UISearchController(searchResultsController: nil))
    
    //MARK: - Init
    init(type: TabViewControllerType, presenter: SearchPresenterProtocol) {
        self.recentUsers = [InstagramUser]()
        self.searchingInstagramUsers = [InstagramUser]()
        self.presenter = presenter
        
        super.init(type: type)
        
        //Delegates
        searchController.searchResultsUpdater = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupSearchBar()
        view.backgroundColor = .white
    }
    
    override func viewWillLayoutSubviews() {
        searchController.searchBar.searchTextField.layer.cornerRadius = searchController.searchBar.searchTextField.frame.height / 2
        searchController.searchBar.searchTextField.layer.masksToBounds = true
    }
    
    //MARK: - Private methods
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let cancelButtonText = Text.searchBarCancelButton.getText
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = cancelButtonText()
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([.font: Fonts.searchBarCancelButton.getFont()], for: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = Fonts.searchBarPlaceholder.getFont()
        definesPresentationContext = true
        
    }
}

//MARK: - SearchViewControllerProtocol

extension SearchViewController: SearchViewProtocol {
    func showAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func showRecentUsers(users: [InstagramUser]) {
        recentUsers = users
    }
    
    func showSearchingUsers(users: [InstagramUser]) {
        searchingInstagramUsers = users
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchingInstagramUsers.isEmpty {
            return recentUsers.count
        }
        return searchingInstagramUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConstantsForCommonViewController.reuseIdentifier,
                                                 for: indexPath) as? InstagramUserCell else { return UITableViewCell() }
        
        if searchingInstagramUsers.isEmpty {
            let user = recentUsers[indexPath.row]
            cell.configure(type: .remove, user: user)
            return cell
        }
        
        let user = searchingInstagramUsers[indexPath.row]
        cell.configure(type: .addToFavorites, user: user)
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

//MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    
}

//MARK: - UISearchControllerDelegate
extension SearchViewController: UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.isEmpty { return }
        presenter?.fetchSearchingUsers(username: text)
    }
}
