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
            collectionView.reloadWithFade()
        }
    }
    
    //MARK: - Init
    init(type: TabViewControllerType,
         presenter: FavoritesPresenterProtocol) {
        self.presenter = presenter
        self.favoritesUsers = [InstagramUser]()
        
        super.init(type: type)
        
        collectionView.delegate = self
        collectionView.dataSource = self
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

//MARK: - extension + UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesUsers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return favoritesUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstantsForCommonViewController.reuseIdentifier,
                                                 for: indexPath) as? InstagramUserCell else { return UICollectionViewCell() }
        
        let user = favoritesUsers[indexPath.row]
        cell.configure(type: .fromDB, user: user)
        cell.buttonDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // rootCoordinator
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: ConstantsForCommonViewController.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
}

//MARK: - extension + InstagramUserCellDelegate
extension FavoritesViewController: InstagramUserCellButtonDelegate {
    
    func trailingButtonTapped(type: InstagramUserCellType) {
        switch type {
        case .fromDB:
            break
        case .fromNetwork:
            break
        }
    }
}
