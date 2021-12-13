//
//  PreferencesViewController.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit.UIViewController

protocol PreferencesViewProtocol: AnyObject {
    func showMenuItem(settings: [Setting])
    func showAlertController(title: String, message: String)
}

final class PreferencesViewController: CommonViewController {
    
    //MARK: - Private properties
    private let presenter: PreferencesPresenterProtocol
    private var settings: [Setting] {
        didSet {
            collectionView.reloadWithFade()
        }
    }
    
    //MARK: - Init
    init(type: TabViewControllerType, presenter: PreferencesPresenterProtocol) {
        self.presenter = presenter
        self.settings = [Setting]()
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
        
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        
        //TODO: Change back bar button font
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

//MARK: - FavoritesViewProtocol
extension PreferencesViewController: PreferencesViewProtocol {
    func showMenuItem(settings: [Setting]) {
        self.settings = settings
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension PreferencesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstantsForCommonViewController.reuseIdentifier, for: indexPath) as? SettingsCell else { return UICollectionViewCell() }
        let setting = settings[indexPath.row]
        cell.configure(setting: setting)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: LocalConstants.cellHeight)
    }
}

private enum LocalConstants {
    static let cellHeight: CGFloat = 25
}
