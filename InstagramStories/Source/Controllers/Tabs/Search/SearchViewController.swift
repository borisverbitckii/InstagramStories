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
    
    //MARK: - Private properties
    private var recentUsers: [InstagramUser] {
        didSet{
            tableView.reloadWithFade()
        }
    }
    private var searchingInstagramUsers : [InstagramUser] { // for search results
        didSet {
            tableView.reloadWithFade()
            activityIndicator?.hide()
        }
    }
    
    private var searchBarIsEmpty: Bool {
        guard let text =  searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var previousValue = ""
    
    private let presenter: SearchPresenterProtocol?
    
    // UI elements
    private let searchController: UISearchController = {
        $0.searchBar.placeholder = Text.searchBarPlaceholderText.getText()
        $0.obscuresBackgroundDuringPresentation = false
        return $0
    }(UISearchController(searchResultsController: nil))
    
    private var activityIndicator: CustomActivityIndicator?
    
    //MARK: - Init
    init(type: TabViewControllerType,
         presenter: SearchPresenterProtocol,
         viewsFactory: ViewsFactoryProtocol) {
        self.recentUsers = [InstagramUser]()
        self.searchingInstagramUsers = [InstagramUser]()
        self.presenter = presenter
        self.activityIndicator = viewsFactory.getCustomActivityIndicator()
        if let activityIndicator = activityIndicator {
            activityIndicator.type = .withBackgroundView(.medium)
            activityIndicator.hide()
        }
        
        super.init(type: type)
        
        //Delegates
        searchController.searchBar.delegate = self
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
        addSubviews()
        layout()
    }
    
    override func viewWillLayoutSubviews() {
        searchController.searchBar.searchTextField.layer.cornerRadius = searchController.searchBar.searchTextField.frame.height / 2
        searchController.searchBar.searchTextField.layer.masksToBounds = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        activityIndicator?.hide()
    }
    
    //MARK: - Private methods
    private func addSubviews() {
        guard let activityIndicator = activityIndicator else { return }
        view.addSubview(activityIndicator)
    }
    
    private func layout() {
        activityIndicator?.pin.center()
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let cancelButtonText = Text.searchBarCancelButton.getText
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = cancelButtonText()
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([.font: Fonts.searchBarCancelButton.getFont()], for: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = Fonts.searchBarPlaceholder.getFont()
        definesPresentationContext = true
        
        searchController.searchBar.searchTextField.autocapitalizationType = .none
    }
}

//MARK: - SearchViewControllerProtocol
extension SearchViewController: SearchViewProtocol {
    
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
            cell.buttonDelegate = self
            cell.imageDelegate = self
            cell.configure(type: .remove, user: user)
            return cell
        }
        
        let user = searchingInstagramUsers[indexPath.row]
        cell.buttonDelegate = self
        cell.imageDelegate = self
        cell.configure(type: .addToFavorites, user: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !searchingInstagramUsers.isEmpty{
            presenter?.presentProfile(with: searchingInstagramUsers[indexPath.row])
        } else {
            presenter?.presentProfile(with: recentUsers[indexPath.row])
        }
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
        guard let text = searchController.searchBar.text,
              !text.isEmpty,
              previousValue != text else { return }
        activityIndicator?.show()
        presenter?.fetchSearchingUsers(username: text)
        previousValue = text
    }
}

//MARK: - extension + UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchingInstagramUsers.removeAll()
        presenter?.stopFetching()
    }
}

//MARK: - extension + InstagramUserCellDelegate
extension SearchViewController: InstagramUserCellButtonDelegate {
    
    func trailingButtonTapped(type: InstagramUserCellType) {
        switch type {
        case .remove:
            break
        case .addToFavorites:
            break
        }
    }
}

//MARK: - extension + InstagramUserCellImageDelegate
extension SearchViewController: InstagramUserCellImageDelegate {
    
    func fetchImage(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        presenter?.fetchImage(stringURL: stringURL, completion: completion)
    }
}
