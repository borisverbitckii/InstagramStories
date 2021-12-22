//
//  StoryViewController.swift
//  InstagramStories
//
//  Created by Борис on 21.12.2021.
//

import UIKit

protocol StoryViewProtocol: AnyObject {
    func injectUser(_ user: InstagramUser)
    func injectStories(_ stories: [Story])
    func injectCurrentStoryIndex(_ index: Int)
}

final class StoryViewController: UIViewController, UINavigationBarDelegate {
    
    //MARK: - Private properties
    private let presenter: StoryPresenterProtocol
    private var user: InstagramUser? {
        didSet {
            usernameLabel.text = "@" + (user?.instagramUsername ?? "")
        }
    }
    private var stories: [Story]?
    
    private var currentStoriesIndex = 0 {
        didSet{
            if let stories = stories {
                storyWasPostedTimeLabel.text = Utils.handleDate(unixDate: stories[currentStoriesIndex].time) + " назад"
                layoutStoryWasPostedTimeLabel()
            }
            
            if oldValue < currentStoriesIndex {
                let indexPaths = (currentStoriesIndex - 1...currentStoriesIndex).map { IndexPath(item: $0, section: 0)}
                collectionViewForStories.reloadItems(at: indexPaths)
            } else if oldValue > currentStoriesIndex {
                let indexPaths = (currentStoriesIndex...oldValue).map { IndexPath(item: $0, section: 0)}
                collectionViewForStories.reloadItems(at: indexPaths)
            } else {
                collectionViewForStories.reloadItems(at: [IndexPath(item: currentStoriesIndex, section: 0)])
            }
            guard let stringURL = stories?[currentStoriesIndex].previewImageURL else { return }
            presenter.fetchStoryPreview(urlString: stringURL) { [weak self] result in
                switch result {
                case .success(let image):
                    self?.storyPreviewImageView.image = image
                case .failure(_): break
                    //TODO: Fix this
                }
            }
        }
    }
    
    //UI Elements
    private var navBar: UINavigationBar = {
        let navItem = UINavigationItem()
        
        let closeItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(rightBarButtonTapped))
        navItem.rightBarButtonItem = closeItem
        $0.setItems([navItem], animated: false)

        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.backgroundColor = Palette.white.color
        standardAppearance.shadowColor = Palette.clear.color
        standardAppearance.titleTextAttributes = [.font: Fonts.avenir(.heavy).getFont(size: .mediumPlus)]
        $0.standardAppearance = standardAppearance
        
        return $0
    }(UINavigationBar(frame: CGRect(x: 0, y: 0, width: 0, height: LocalConstants.navBarHeight)))
    
    private let usernameLabel: UILabel = {
        $0.font = Fonts.avenir(.heavy).getFont(size: .mediumPlus)
        return $0
    }(UILabel())
    
    private let storyWasPostedTimeLabel: UILabel = {
        $0.font = Fonts.avenir(.light).getFont(size: .small)
        return $0
    }(UILabel())
    
    private let collectionViewForStories: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = LocalConstants.collectionViewMinimumInteritemSpacing
        $0.collectionViewLayout = flowLayout
        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: LocalConstants.reuseIdentifier)
        $0.isScrollEnabled = false
        
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()))
    
    private let storyPreviewImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    // for story changing
    private let leftSideView = UIView()
    private let rightSideView = UIView()
    
    private let shareButton = CustomButton(buttonType: .share)
    private let saveButton = CustomButton(buttonType: .save)
    
    //MARK: - Init
    init(presenter: StoryPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        collectionViewForStories.delegate = self
        collectionViewForStories.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        view.backgroundColor = Palette.white.color
        addSubviews()
        setupButtons()
        setupViewsForStoriesChanging()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shareButton.layer.cornerRadius = shareButton.frame.height / 2
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - Private methods
    private func addSubviews() {
        navBar.addSubview(usernameLabel)
        navBar.addSubview(storyWasPostedTimeLabel)
        view.addSubview(collectionViewForStories)
        view.addSubview(navBar)
        view.addSubview(storyPreviewImageView)
        view.addSubview(leftSideView)
        view.addSubview(rightSideView)
        view.addSubview(shareButton)
        view.addSubview(saveButton)
    }
    
    private func layout() {
        let topSafeAreaInset = view.safeAreaInsets.top
        
        navBar.pin
            .top(topSafeAreaInset)
            .width(view.frame.width)
        
        usernameLabel.sizeToFit()
        usernameLabel.pin
            .vCenter()
            .left(LocalConstants.usernameLabelLeftInset)
        
        layoutStoryWasPostedTimeLabel()
        
        collectionViewForStories.pin
            .left()
            .right()
            .below(of: navBar).marginTop(LocalConstants.collectionViewTopOffset)
            .height(LocalConstants.collectionViewHeight)
        
        storyPreviewImageView.pin
            .below(of: collectionViewForStories)
            .left()
            .right()
            .bottom()
        
        leftSideView.pin
            .below(of: collectionViewForStories)
            .left()
            .right(view.frame.width/2)
            .bottom()
        
        rightSideView.pin
            .after(of: leftSideView)
            .below(of: collectionViewForStories)
            .right()
            .bottom()
        
        saveButton.pin
            .right(LocalConstants.rightInset)
            .bottom(LocalConstants.bottomInset)
        
        shareButton.pin
            .before(of: saveButton, aligned: .center).marginRight(LocalConstants.shareButtonSpacing)
    }
    
    private func layoutStoryWasPostedTimeLabel() {
        storyWasPostedTimeLabel.sizeToFit()
        storyWasPostedTimeLabel.pin
            .center()
    }
    
    private func setupButtons() {
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    private func setupViewsForStoriesChanging() {
        leftSideView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftSideWasTapped)))
        rightSideView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightSideWasTapped)))
    }
    
    //MARK: - OBJC methods
    @objc private func leftSideWasTapped() {
        if currentStoriesIndex > 0 {
            currentStoriesIndex -= 1
        }
    }
    
    @objc private func rightSideWasTapped() {
        if currentStoriesIndex < (stories?.count ?? 0 ) - 1 {
            currentStoriesIndex += 1
        }
    }
    
    @objc private func rightBarButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func shareButtonTapped() {
        print("share")
    }
    
    @objc private func saveButtonTapped() {
        print("save")
    }
}

extension StoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocalConstants.reuseIdentifier, for: indexPath)
        if indexPath.item == currentStoriesIndex {
            cell.backgroundColor = Palette.green.color
            return cell
        }
        cell.backgroundColor = Palette.superLightGray.color
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let stories = stories {
            let collectionViewWidth = collectionView.frame.width
            
            let cellWidth = (collectionViewWidth - CGFloat(stories.count - 1) * LocalConstants.collectionViewMinimumInteritemSpacing) / CGFloat(stories.count)
            return CGSize(width: cellWidth, height: collectionView.frame.height)
        }
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
 
//MARK: - extension + StoryViewProtocol
extension StoryViewController: StoryViewProtocol {
    func injectCurrentStoryIndex(_ index: Int) {
        currentStoriesIndex = index
    }
    
    func injectUser(_ user: InstagramUser) {
        self.user = user
    }
    
    func injectStories(_ stories: [Story]) {
        self.stories = stories
    }
}

private enum LocalConstants {
    static let reuseIdentifier = "story"
    static let collectionViewMinimumInteritemSpacing: CGFloat = 3
    static let collectionViewHeight: CGFloat = 3
    static let collectionViewTopOffset: CGFloat = 10
    
    static let navBarHeight: CGFloat = 44
    static let usernameLabelLeftInset: CGFloat = 16
    static let storyWasPostedTimeLabelLeftInset: CGFloat = 16
    
    //Buttons
    static let rightInset: CGFloat = 16
    static let bottomInset: CGFloat = 32
    static let shareButtonSpacing: CGFloat = 16
}
