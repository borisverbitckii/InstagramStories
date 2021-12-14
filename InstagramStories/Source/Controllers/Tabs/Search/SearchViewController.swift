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
            collectionView.reloadWithFade()
        }
    }
    private var searchingInstagramUsers : [InstagramUser] { // for search results
        didSet {
            collectionView.reloadWithFade()
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
    
        collectionView.register(HeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: LocalConstants.headerReuseIdentifier)
        
        //Delegates
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        collectionView.delegate = self
        collectionView.dataSource = self
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
        definesPresentationContext = true
        
        searchController.searchBar.searchTextField.autocapitalizationType = .none
        searchController.searchBar.searchTextField.font = Fonts.searchBarPlaceholder.getFont()
        searchController.searchBar.searchTextField.textColor = Palette.lightGray.color
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: Text.searchBarPlaceholderText.getText(), attributes: [.foregroundColor : Palette.lightGray.color, .font : Fonts.searchBarPlaceholder.getFont()])
    }
    
    private func scrollToTop() {
        let headerAttributes = UICollectionViewLayoutAttributes()
        var offsetY = headerAttributes.frame.origin.y - collectionView.contentInset.top
        offsetY -= collectionView.safeAreaInsets.top

        collectionView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
    }
}

//MARK: - SearchViewControllerProtocol
extension SearchViewController: SearchViewProtocol {
    
    func showRecentUsers(users: [InstagramUser]) {
        recentUsers = users
    }
    
    func showSearchingUsers(users: [InstagramUser]) {
        searchingInstagramUsers = users
        scrollToTop()
    }
}


//MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // Rows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchingInstagramUsers.isEmpty {
            return recentUsers.count
        }
        return searchingInstagramUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstantsForCommonViewController.reuseIdentifier,
                                                 for: indexPath) as? InstagramUserCell else { return UICollectionViewCell() }
        cell.buttonDelegate = self
        cell.imageDelegate = self
        
        if searchingInstagramUsers.isEmpty {
            let user = recentUsers[indexPath.row]
            cell.configure(type: .fromDB, user: user)
            return cell
        }
        
        let user = searchingInstagramUsers[indexPath.row]
        cell.configure(type: .fromNetwork, user: user)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if !searchingInstagramUsers.isEmpty{
            presenter?.presentProfile(with: searchingInstagramUsers[indexPath.row])
        } else {
            presenter?.presentProfile(with: recentUsers[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: ConstantsForCommonViewController.cellHeight)
    }
    
    // Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: LocalConstants.headerReuseIdentifier,
                                                                               for: indexPath) as? HeaderReusableView else { return UICollectionReusableView() }
        
        if !searchingInstagramUsers.isEmpty {
            headerView.configure(title: Text.searchHeaderTitle(.searchResult).getText())
            return headerView
        }
        headerView.configure(title: Text.searchHeaderTitle(.recent).getText())
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: LocalConstants.headerHeight)
    }
}

//MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
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
        presenter?.stopFetching()
        searchingInstagramUsers = []
        changeTabBar(hidden: false, animated: true)
    }
}

//MARK: - extension + InstagramUserCellDelegate
extension SearchViewController: InstagramUserCellButtonDelegate {
    
    func trailingButtonTapped(type: InstagramUserCellType) {
        switch type {
        case .fromDB:
            break
        case .fromNetwork:
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

private enum LocalConstants {
    static let headerReuseIdentifier = "header"
    static let headerHeight: CGFloat = 30
}
