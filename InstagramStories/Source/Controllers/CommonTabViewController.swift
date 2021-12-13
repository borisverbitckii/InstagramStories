//
//  CommonViewController.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit

enum TabViewControllerType {
    case search
    case favorites
    case preferences
}

///  Only for inheritance
class CommonViewController: UIViewController {
    
    //MARK: - Public properties
    var type: TabViewControllerType
    let collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = ConstantsForCommonViewController.itemSpacing
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = ConstantsForCommonViewController.sectionInsets
        flowLayout.sectionHeadersPinToVisibleBounds = true
        
        $0.collectionViewLayout = flowLayout
        $0.contentInset = ConstantsForCommonViewController.collectionViewContentInsets
        $0.keyboardDismissMode = .onDrag
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
    //MARK: - Init
    init(type: TabViewControllerType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupGestureViewControllerTransition()
        registerCollectionViewCell()
        addSubviews()
        layout()
        view.backgroundColor = .white
    }
    
    //MARK: - Private methods
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.font: Fonts.navBarLargeTitle.getFont()]
        navBarAppearance.titleTextAttributes = [.font: Fonts.navBarLittleTitle.getFont()]
        navBarAppearance.backgroundColor = .white
        navBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        switch type{
        case .search:
            navigationItem.title = Text.navTitle(.search).getText()
        case .favorites:
            navigationItem.title = Text.navTitle(.favorites).getText()
        case .preferences:
            navigationItem.title = Text.navTitle(.preferences).getText()
        }
    
        if let layer = navigationController?.navigationBar.layer {
            Utils.addShadow(type: .navBar, layer: layer)
        }
    }
    
    private func setupGestureViewControllerTransition() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func layout() {
        collectionView.pin
            .top()
            .bottom()
            .left()
            .right()
    }
    
    private func registerCollectionViewCell() {
        switch type{
        case .search, .favorites:
            collectionView.register(InstagramUserCell.self, forCellWithReuseIdentifier: ConstantsForCommonViewController.reuseIdentifier)
        case .preferences:
            collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: ConstantsForCommonViewController.reuseIdentifier)
        }
    }
    
    //MARK: - OBJC methods
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if sender.direction == .left {
            self.tabBarController!.selectedIndex += 1
        }
        if sender.direction == .right {
            self.tabBarController!.selectedIndex -= 1
        }
    }
}

//MARK: - extension + UIScrollViewDelegate
extension CommonViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            changeTabBar(hidden: true, animated: true)
        }
        else{
            changeTabBar(hidden: false, animated: true)
        }
    }

    private func changeTabBar(hidden: Bool, animated: Bool) {
        let tabBar = self.tabBarController?.tabBar
        let offset = hidden ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.height - (tabBar?.frame.size.height ?? 0)
        if offset == tabBar?.frame.origin.y { return }
        let duration: TimeInterval = (animated ? ConstantsForCommonViewController.tabBarAnimationDuration : 0.0)
        UIView.animate(withDuration: duration, delay: 0,
                       options: .curveEaseInOut,
                       animations: { tabBar?.frame.origin.y = offset },
                       completion: nil)
    }
                       }

enum ConstantsForCommonViewController {
    static let collectionViewContentInsets = UIEdgeInsets(top: 20, left: 0, bottom: -50, right: 0)
    static let sectionInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    static let reuseIdentifier  = "reuseIdentifier"
    static let cellHeight: CGFloat = 70
    static let itemSpacing: CGFloat = 15
    static let tabBarAnimationDuration: TimeInterval = 0.45
}
