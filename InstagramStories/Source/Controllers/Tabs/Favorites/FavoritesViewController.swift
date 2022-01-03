//
//  FavoritesViewController.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit.UIViewController

protocol FavoritesViewProtocol: AnyObject {
    func showAlertController(title: String, message: String, completion: (()->())?)
    func setupFavoritesCount(number: Int)
    func hideStateView()
}

final class FavoritesViewController: CommonViewController {
    
    //MARK: - Private properties
    private let presenter: FavoritesPresenterProtocol
    
    private var favoritesUsersCount = 0 {
        didSet{
            collectionView.reloadWithFade()
        }
    }
    
    // UIElements
    
    private let stateView: StateView = {
        $0.isHidden = true
        return $0
    }(StateView(type: .noSearchResults))
    
    //MARK: - Init
    init(type: TabViewControllerType,
         presenter: FavoritesPresenterProtocol) {
        self.presenter = presenter
        
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
        addSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout()
    }
    
    //MARK: - Private methods
    private func addSubviews() {
        view.addSubview(stateView)
    }
    
    private func layout() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        stateView.pin
            .below(of: navigationBar).marginTop(LocalConstants.stateViewTopInset)
            .hCenter()
    }
}


//MARK: - extension + FavoritesViewProtocol
extension FavoritesViewController: FavoritesViewProtocol {
    func hideStateView() {
        stateView.isHidden = true
    }
    
    func setupFavoritesCount(number: Int) {
        favoritesUsersCount = number
    }
}

//MARK: - extension + UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if favoritesUsersCount == 0 {
            stateView.type = .noFavorites
            stateView.showWithFade(with: LocalConstants.stateViewAnimationDuration)
            return 0
        }
        stateView.hideWithFade(with: LocalConstants.stateViewAnimationDuration)
        return favoritesUsersCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstantsForCommonViewController.reuseIdentifier,
                                                 for: indexPath) as? InstagramUserCell else { return UICollectionViewCell() }
        cell.buttonDelegate = self
        cell.imageDelegate = self
        
        let user = presenter.favoritesUsers[indexPath.row]
        cell.configure(type: .favorite(.remove), user: user)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        presenter.cellWasTapped(indexPath: indexPath.item)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: ConstantsForCommonViewController.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
}

//MARK: - extension + InstagramUserCellImageDelegate
extension FavoritesViewController: InstagramUserCellImageDelegate {
    
    func userImageWillBeShown(stringURL: String, completion: @escaping (Result<UIImage,Error>)->()) {
        presenter.userImageWillBeShown(stringURL: stringURL, completion: completion)
    }
}

//MARK: - extension + InstagramUserCellDelegate
extension FavoritesViewController: InstagramUserCellButtonDelegate {
    func trailingButtonTapped(type: InstagramUserCellType, user: RealmInstagramUserProtocol) {
        presenter.trailingButtonTapped(type: type, user: user)
    }
}

private enum LocalConstants {
    static let stateViewAnimationDuration: TimeInterval = 0.6
    static let stateViewTopInset: CGFloat = 50
}
