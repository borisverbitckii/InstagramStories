//
//  ViewController.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit
import PinLayout

protocol SearchViewProtocol: AnyObject {
    func showAlertController(title: String, message: String, completion: (()->())?)
    func hideActivityIndicator()
    func setupRecentUsersCount(number: Int)
    func setupSearchingUsersCount(number: Int)
}

final class SearchViewController: CommonViewController {
    
    //MARK: - Private properties
    private var recentUsersCount = 0 {
        didSet{
            collectionView.reloadWithFade()
        }
    }
    private var searchingInstagramUsersCount = 0 {
        didSet{
            collectionView.reloadWithFade()
        }
    }
    
    private var searchBarIsEmpty: Bool {
        guard let text =  searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var previousValue: String?
    private let presenter: SearchPresenterProtocol?
    
    // UI elements
    private let searchController: UISearchController = {
        $0.obscuresBackgroundDuringPresentation = false
        return $0
    }(UISearchController(searchResultsController: nil))
    
    private var activityIndicator: CustomActivityIndicator = {
        $0.type = .withBackgroundView(.medium)
        $0.hide()
        return $0
    }(CustomActivityIndicator())
    
    private let noSearchResults: StateView = {
        $0.isHidden = true
        return $0
    }(StateView(type: .noSearchResults))
    
    //MARK: - Init
    init(type: TabViewControllerType,
         presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        
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
        view.backgroundColor = Palette.white.color
        setupSearchBar()
        addSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchController.searchBar.searchTextField.layer.cornerRadius = searchController.searchBar.searchTextField.frame.height / 2
        searchController.searchBar.searchTextField.layer.masksToBounds = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        changeTabBar(hidden: false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        activityIndicator.hide()
    }
    
    //MARK: - Private methods
    private func addSubviews() {
        view.addSubview(activityIndicator)
        view.addSubview(noSearchResults)
    }
    
    private func layout() {
        activityIndicator.pin.center()
    
        noSearchResults.pin
            .top(view.frame.height / 5)
            .hCenter()
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let cancelButtonText = Text.searchBarCancelButton.getText
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = cancelButtonText()
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = Palette.black.color
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([.font: Fonts.avenir(.heavy).getFont(size: .medium)], for: .normal)
        definesPresentationContext = true
        
        searchController.searchBar.searchTextField.autocapitalizationType = .none
        searchController.searchBar.searchTextField.font = Fonts.avenir(.book).getFont(size: .medium)
        searchController.searchBar.searchTextField.textColor = Palette.lightGray.color
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: Text.searchBarPlaceholderText.getText(), attributes: [.foregroundColor : Palette.lightGray.color, .font : Fonts.avenir(.book).getFont(size: .medium)])
        
        // searchBar textField background colod
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            let backgroundView = textField.subviews.first
            backgroundView?.subviews.forEach({ $0.removeFromSuperview() })
            searchController.searchBar.searchTextField.backgroundColor = Palette.superLightGray.color
        }
    }
}

//MARK: - SearchViewControllerProtocol
extension SearchViewController: SearchViewProtocol {
    
    func setupRecentUsersCount(number: Int) {
        recentUsersCount = number
    }
    
    func setupSearchingUsersCount(number: Int) {
        searchingInstagramUsersCount = number
        scrollToTop(animated: false)
    }
    
    func hideActivityIndicator() {
        activityIndicator.hide()
    }
}


//MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // Rows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !searchBarIsEmpty && searchingInstagramUsersCount == 0 {
            noSearchResults.showWithFade(with: LocalConstants.noSearchResultAnimationDuration)
            return 0
        } else if searchingInstagramUsersCount == 0 {
            noSearchResults.hideWithFade(with: LocalConstants.noSearchResultAnimationDuration)
            return recentUsersCount
        }
        noSearchResults.hideWithFade(with: LocalConstants.noSearchResultAnimationDuration)
        return searchingInstagramUsersCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstantsForCommonViewController.reuseIdentifier,
                                                 for: indexPath) as? InstagramUserCell else { return UICollectionViewCell() }
        cell.buttonDelegate = self
        cell.imageDelegate = self
        
        guard searchingInstagramUsersCount != 0 else {
            guard let user = presenter?.recentUsers[indexPath.row] else { return cell}
            cell.configure(type: .removeFromRecent, user: user)
            return cell
        }
        
        guard let user = presenter?.searchingInstagramUsers[indexPath.row] else { return cell}
        presenter?.cellForItemIsExecute(user: user) == true
        ? cell.configure(type: .favorite(.remove), user: user)
        : cell.configure(type: .favorite(.add), user: user)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if searchingInstagramUsersCount != 0 {
            presenter?.cellWasTapped(indexPath: indexPath.row, isRecent: false)
        } else if recentUsersCount != 0 {
            presenter?.cellWasTapped(indexPath: indexPath.row, isRecent: true)
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
        
        if !searchBarIsEmpty && searchingInstagramUsersCount == 0 {
            headerView.configure(title: Text.searchHeaderTitle(.searchResult).getText())
            return headerView
        } else if searchingInstagramUsersCount == 0 {
            headerView.configure(title: Text.searchHeaderTitle(.recent).getText())
            return headerView
        }
        
        headerView.configure(title: Text.searchHeaderTitle(.searchResult).getText())
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
        guard !text.contains(where: { $0 == " "}) else {
            showAlertController(title: Text.error.getText(), message: Text.errorInUsername.getText()) {
                searchController.searchBar.becomeFirstResponder()
            }
            searchController.searchBar.text?.removeLast()
            return }
        activityIndicator.show()
        noSearchResults.hideWithFade(with: LocalConstants.noSearchResultAnimationDuration)
        presenter?.searchResultWasUpdated(username: text)
        previousValue = text
    }
}

//MARK: - extension + UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.searchBarCancelButtonClicked()
        searchingInstagramUsersCount = 0
        changeTabBar(hidden: false, animated: true)
        previousValue = ""
        collectionView.setContentOffset(collectionView.contentOffset, animated:false)
    }
}

//MARK: - extension + InstagramUserCellDelegate
extension SearchViewController: InstagramUserCellButtonDelegate {
    
    func trailingButtonTapped(type: InstagramUserCellType, user: RealmInstagramUserProtocol) {
        presenter?.trailingButtonTapped(type: type, user: user)
    }
}

//MARK: - extension + InstagramUserCellImageDelegate
extension SearchViewController: InstagramUserCellImageDelegate {
    
    func userImageWillBeShown(stringURL: String, completion: @escaping (Result<UIImage,Error>)->()) {
        presenter?.userImageWillBeShown(stringURL: stringURL, completion: completion)
    }
}

private enum LocalConstants {
    static let headerReuseIdentifier = "header"
    static let headerHeight: CGFloat = 30
    static let noSearchResultAnimationDuration: TimeInterval = 0.6
}
