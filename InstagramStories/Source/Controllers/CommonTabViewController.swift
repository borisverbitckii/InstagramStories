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
        let flowLayout = CustomCollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = ConstantsForCommonViewController.itemSpacing
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = ConstantsForCommonViewController.sectionInsets
        flowLayout.sectionHeadersPinToVisibleBounds = true
        
        $0.setCollectionViewLayout(flowLayout, animated: false)
        $0.contentInset = ConstantsForCommonViewController.collectionViewContentInsets
        $0.keyboardDismissMode = .onDrag
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
    var scrollButtonIsHidden = true {
        didSet {
            if scrollButtonIsHidden {
                scrollToTopButton.isHidden = true
            } else {
                scrollToTopButton.isHidden = false
            }
        }
    }
    
    //MARK: - Private properties
    private var previousValueForScrollViewGesture: CGFloat = 0
    
    private var scrollToTopButton: ScrollToTopButton = {
        return $0
    }(ScrollToTopButton())
    
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
        view.backgroundColor = .white
        setupNavigationBar()
        setupGestureViewControllerTransition()
        registerCollectionViewCell()
        addSubviews()
        layout()
        
        scrollToTopButton.addTarget(self, action: #selector(scrollToTopButtonTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    //MARK: - Public methods
    func scrollToTop(animated: Bool = true ) {
        let headerAttributes = UICollectionViewLayoutAttributes()
        var offsetY = headerAttributes.frame.origin.y - collectionView.contentInset.top
        offsetY -= collectionView.safeAreaInsets.top
        collectionView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: animated)
        
        changeTabBar(hidden: false, animated: true)
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
            Utils.addShadow(type: .shadowIsUnder, layer: layer)
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
        view.addSubview(scrollToTopButton)
    }
    
    private func layout() {
        collectionView.pin
            .top()
            .bottom()
            .left()
            .right()
        
        guard let tabBar = tabBarController?.tabBar else { return }
        
        scrollToTopButton.pin
            .right(ConstantsForCommonViewController.scrollToTopButtonRightInset)
            .above(of: tabBar).margin(ConstantsForCommonViewController.scrollToTopButtonBottomInset)
    }
    
    private func registerCollectionViewCell() {
        switch type{
        case .search, .favorites:
            collectionView.register(InstagramUserCell.self, forCellWithReuseIdentifier: ConstantsForCommonViewController.reuseIdentifier)
        case .preferences:
            collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: ConstantsForCommonViewController.reuseIdentifier)
        }
    }
    
    private func animateScrollToTopButton(isHidden: Bool) {
        isHidden ? scrollToTopButton.hideWithFade(with: ConstantsForCommonViewController.scrollToTopButtonHideWithFadeDuration) : scrollToTopButton.showWithFade(with: ConstantsForCommonViewController.scrollToTopButtonShowWithFadeDuration)
    }
    
    //MARK: - OBJC methods
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardRectangle = keyboardFrameValue.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        if let tabBarController = tabBarController {
            if tabBarController.tabBar.frame.origin.y != view.frame.height {
                scrollToTopButton.frame.origin.y -= keyboardHeight - tabBarController.tabBar.frame.height
            } else {
                scrollToTopButton.frame.origin.y -= keyboardHeight
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let tabBar = tabBarController?.tabBar else { return }
        scrollToTopButton.frame.origin.y = tabBar.frame.origin.y -  tabBar.frame.height
    }
    
    @objc func scrollToTopButtonTapped() {
        scrollToTop()
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if sender.direction == .left {
            self.tabBarController?.selectedIndex += 1
        }
        if sender.direction == .right {
            self.tabBarController?.selectedIndex -= 1
        }
    }
}

//MARK: - extension + UIScrollViewDelegate
extension CommonViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > 10 {
            animateScrollToTopButton(isHidden: false)
        } else {
            animateScrollToTopButton(isHidden: true)
        }
        
        guard previousValueForScrollViewGesture.rounded() != scrollView.panGestureRecognizer.translation(in: scrollView).y.rounded() else { return }

        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            changeTabBar(hidden: true, animated: true)
        } else if scrollView.panGestureRecognizer.translation(in: scrollView).y > 0 {
            changeTabBar(hidden: false, animated: true)
        }
        previousValueForScrollViewGesture = scrollView.panGestureRecognizer.translation(in: scrollView).y
    }
    
    func changeTabBar(hidden: Bool, animated: Bool) {
        let offset = hidden ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.height - (tabBarController?.tabBar.frame.size.height ?? 0)
        if offset == tabBarController?.tabBar.frame.origin.y { return }
        let duration: TimeInterval = (animated ? ConstantsForCommonViewController.tabBarAnimationDuration : 0.0)
        UIView.animate(withDuration: duration, delay: 0,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
            self?.scrollToTopButton.frame.origin.y = offset - (self?.tabBarController?.tabBar.frame.height ?? 0)
            self?.tabBarController?.tabBar.frame.origin.y = offset
        },
                       completion: nil)
    }
}

enum ConstantsForCommonViewController {
    static let collectionViewContentInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    static let sectionInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    static let reuseIdentifier  = "reuseIdentifier"
    static let cellHeight: CGFloat = 70
    static let itemSpacing: CGFloat = 15
    static let tabBarAnimationDuration: TimeInterval = 0.35
    static let scrollToTopButtonRightInset: CGFloat = 0
    static let scrollToTopButtonBottomInset: CGFloat = 16
    static let scrollToTopButtonPushAnimationDuration: TimeInterval = 0.1
    static let scrollToTopButtonPushAnimationToDefault: TimeInterval = 0.45
    static let scrollToTopButtonShowWithFadeDuration : TimeInterval = 0.6
    static let scrollToTopButtonHideWithFadeDuration : TimeInterval = 0.2
}
