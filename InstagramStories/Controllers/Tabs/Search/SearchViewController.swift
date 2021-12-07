//
//  ViewController.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit

protocol SearchViewProtocol: AnyObject {
    func showUsers(users: [InstagramUser])
    func showAlertController(title: String, message: String)
}

final class SearchViewController: UIViewController {
    
    //MARK: - Public properties
    private var instagramUsers = [InstagramUser]()
    private var filteredInstagramUsers = [InstagramUser]() // for search results
    private var searchBarIsEmpty: Bool {
        guard let text =  searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    //MARK: - Private properties
    private var presenter: SearchPresenterProtocol?
    
    // UI elements
    private let searchController: UISearchController = {
        $0.searchBar.placeholder = LocalConstants.searchBarPlaceholderText
        $0.obscuresBackgroundDuringPresentation = false
        return $0
    }(UISearchController(searchResultsController: nil))
    private let tableView : UITableView = {
        return $0
    }(UITableView())
    
    //MARK: - Init
    init(presenter: SearchPresenterProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupSearchController()
        setupUI()
    }
    
    //MARK: - Private methods
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupUI() {
        view.backgroundColor = .white
    }
}

//MARK: - SearchViewControllerProtocol

extension SearchViewController: SearchViewProtocol {
    func showUsers(users: [InstagramUser]) {
        instagramUsers = users
        tableView.reloadData()
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


//MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instagramUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
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

private enum LocalConstants {
    static let searchBarPlaceholderText = "Введите ник в Instagram"
}
