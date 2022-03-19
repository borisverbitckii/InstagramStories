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
}

///  Only for inheritance
class CommonViewController: UIViewController {

    // MARK: - Public properties
    var type: TabViewControllerType
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
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

    // MARK: - Private properties
    private var previousValueForScrollViewGesture: CGFloat = 0
    private var keyboardIsOpen = false

    // UI Elements
    private var scrollToTopButton: CustomButton = {
        return $0
    }(CustomButton(buttonType: .scroll))

    // MARK: - Init
    init(type: TabViewControllerType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override methods
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

    // MARK: - Public methods
    func scrollToTop(animated: Bool = true ) {
        let headerAttributes = UICollectionViewLayoutAttributes()
        var offsetY = headerAttributes.frame.origin.y - collectionView.contentInset.top
        offsetY -= collectionView.safeAreaInsets.top
        collectionView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: animated)

        changeTabBar(hidden: false, animated: true)
    }

    // MARK: - Private methods
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white

        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.configureWithOpaqueBackground()
        scrollEdgeAppearance.largeTitleTextAttributes = [.font: Fonts.avenir(.heavy).getFont(size: .large)]
        scrollEdgeAppearance.titleTextAttributes = [.font: Fonts.avenir(.heavy).getFont(size: .mediumPlus)]
        scrollEdgeAppearance.backgroundColor = Palette.clear.color
        scrollEdgeAppearance.shadowColor = Palette.clear.color

        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.backgroundColor = Palette.white.color
        standardAppearance.shadowColor = Palette.clear.color
        standardAppearance.titleTextAttributes = [.font: Fonts.avenir(.heavy).getFont(size: .mediumPlus)]

        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        navigationController?.navigationBar.standardAppearance = standardAppearance

        switch type {
        case .search:
            navigationItem.title = Text.navTitle(.search).getText()
        case .favorites:
            navigationItem.title = Text.navTitle(.favorites).getText()
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

        scrollToTopButton.pin
            .right(ConstantsForCommonViewController.scrollToTopButtonRightInset)
            .bottom(ConstantsForCommonViewController.scrollToTopButtonBottomInset)
    }

    private func registerCollectionViewCell() {
        switch type {
        case .search, .favorites:
            collectionView.register(InstagramUserCell.self, forCellWithReuseIdentifier: ConstantsForCommonViewController.reuseIdentifier)
        }
    }

    private func animateScrollToTopButton(isHidden: Bool) {
        isHidden
        ? scrollToTopButton.hideWithFade(with: ConstantsForCommonViewController.scrollToTopButtonHideWithFadeDuration)
        : scrollToTopButton.showWithFade(with: ConstantsForCommonViewController.scrollToTopButtonShowWithFadeDuration)
    }

    // MARK: - OBJC methods

    @objc private func keyboardWillShow(notification: NSNotification) {
        if !keyboardIsOpen {
            guard let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

            let keyboardRectangle = keyboardFrameValue.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            scrollToTopButton.pin
                .bottom(keyboardHeight + ConstantsForCommonViewController.scrollToTopButtonBottomInset)
            keyboardIsOpen = true
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if keyboardIsOpen {
            guard let tabBar = tabBarController?.tabBar else { return }

            if tabBar.frame.minY == view.frame.maxY {
                scrollToTopButton.pin
                    .bottom(ConstantsForCommonViewController.scrollToTopButtonBottomInset)
            } else {
                scrollToTopButton.pin
                    .bottom(ConstantsForCommonViewController.scrollToTopButtonBottomInset + tabBar.frame.height)
            }

            keyboardIsOpen = false
        }
    }

    @objc func scrollToTopButtonTapped() {
        scrollToTop()
    }

    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            self.tabBarController?.selectedIndex += 1
        }
        if sender.direction == .right {
            self.tabBarController?.selectedIndex -= 1
        }
    }
}

// MARK: - extension + UIScrollViewDelegate
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

        let screenHeight = UIScreen.main.bounds.size.height
        let offset = hidden ? screenHeight : screenHeight - (tabBarController?.tabBar.frame.size.height ?? 0)
        if offset == tabBarController?.tabBar.frame.origin.y { return }
        let duration: TimeInterval = (animated ? ConstantsForCommonViewController.tabBarAnimationDuration : 0.0)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: { [weak self] in

            if offset == screenHeight {
                self?.scrollToTopButton.pin
                    .bottom(ConstantsForCommonViewController.scrollToTopButtonBottomInset)
            } else {
                self?.scrollToTopButton.pin
                    .bottom(ConstantsForCommonViewController.scrollToTopButtonBottomInset + (self?.tabBarController?.tabBar.frame.height ?? 0) )
            }

            self?.tabBarController?.tabBar.frame.origin.y = offset
        },
                       completion: nil)
    }
}

enum ConstantsForCommonViewController {
    static let collectionViewContentInsets = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
    static let sectionInsets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
    static let reuseIdentifier  = "reuseIdentifier"
    static let cellHeight: CGFloat = 70
    static let itemSpacing: CGFloat = 15
    static let tabBarAnimationDuration: TimeInterval = 0.35
    static let scrollToTopButtonRightInset: CGFloat = 16
    static let scrollToTopButtonBottomInset: CGFloat = 32
    static let scrollToTopButtonPushAnimationDuration: TimeInterval = 0.1
    static let scrollToTopButtonPushAnimationToDefault: TimeInterval = 0.45
    static let scrollToTopButtonShowWithFadeDuration: TimeInterval = 0.6
    static let scrollToTopButtonHideWithFadeDuration: TimeInterval = 0.2
}
