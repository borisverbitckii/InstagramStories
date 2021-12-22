//
//  ProfileViewController.swift
//  InstagramStories
//
//  Created by Борис on 11.12.2021.
//

import UIKit

protocol ProfileViewProtocol: AnyObject {
    func showUser(_ user: InstagramUser)
    func showStoriesPreview(stories: [Story])
    func showProfileIsPrivate()
}

final class ProfileViewController: UIViewController {
    
    //MARK: - Private properties
    private let presenter: ProfilePresenterProtocol
    private var stories: [Story]? {
        didSet{
            activityIndicator.hide()
            if stories?.count == 0 {
                stateView.showWithFade(with: LocalConstants.noStoriesAnimationDuration)
            }
            storiesCollectionView.reloadWithFade()
            layout()
        }
    }
    
    private var user: InstagramUser? {
        didSet {
            guard let instagramUsername = user?.instagramUsername else { return }
            title = "@" + instagramUsername
            nameLabel.text = user?.name
            descriptionLabel.text = user?.profileDescription
            presenter.fetchImage(stringURL: user?.userIconURL ?? "") { [weak self] result in
                switch result {
                case .success(let image):
                    self?.userImage.image = image
                case .failure(_):
                    // fix this
                    break
                }
            }
        }
    }
    
    // UI Elements
    private var activityIndicator: CustomActivityIndicator = {
        $0.type = .withBackgroundView(.medium)
        return $0
    }(CustomActivityIndicator())
    
    private let scrollView: UIScrollView = {
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = LocalConstants.contentInset
        return $0
    }(UIScrollView())
    
    private let userImage: UIImageView = {
        $0.backgroundColor = Palette.superLightGray.color
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    private let nameLabel: UILabel = {
        $0.font = Fonts.avenir(.heavy).getFont(size: .mediumPlus)
        return $0
    }(UILabel())
    
    private let descriptionLabel: UILabel = {
        $0.numberOfLines = 0
        $0.font = Fonts.avenir(.light).getFont(size: .medium)
        return $0
    }(UILabel())
    
    private let postsLabel: UILabel = {
        return $0
    }(UILabel())
    
    private let postsName: UILabel = {
        return $0
    }(UILabel())
    
    // StackViews
    private var postsStackView: UIStackView?
    private var subscribersStackView: UIStackView?
    private var subscriptionsStackView: UIStackView?
    
    private let mainStackViewForNumbers: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        return $0
    }(UIStackView())
    
    private let stateView: StateView = {
        $0.alpha = LocalConstants.noStoriesViewDefaultAlpha
        return $0
    } (StateView(type: .noStories))
    
    private let storiesCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = LocalConstants.minimumLineSpacing
        flowLayout.minimumInteritemSpacing = LocalConstants.minimimInteritemSpacing
        $0.collectionViewLayout = flowLayout
        $0.register(StoryCell.self, forCellWithReuseIdentifier: LocalConstants.reuseIdentifier)
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.clipsToBounds = false
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()))
    
    //MARK: - Init
    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        storiesCollectionView.delegate = self
        storiesCollectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupStackViews()
        setupGestureViewControllerTransition()
        view.backgroundColor = Palette.white.color
        setupNavigationBar()
        addSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    //MARK: - Private methods
    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = Palette.black.color
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.searchTabIcon.getImage(), style: .done, target: self, action: #selector(addToFavorites)) // fix image
    }
    
    private func setupStackViews() {
        subscriptionsStackView = getColumnStackView(value: String(user?.subscriptions ?? 0), name: Text.subscriptions.getText())
        subscribersStackView = getColumnStackView(value: String(user?.subscribers ?? 0), name: Text.subscribers.getText())
        postsStackView = getColumnStackView(value: String(user?.posts ?? 0), name: Text.posts.getText())
    }
    
    private func getColumnStackView(value: String, name: String) -> UIStackView {
        let valueLabel = UILabel()
        let valueNameLabel = UILabel()
        
        valueLabel.text = value
        valueLabel.font = Fonts.avenir(.heavy).getFont(size: .mediumPlus)
        
        valueNameLabel.text = name
        valueNameLabel.font = Fonts.avenir(.light).getFont(size: .small)
        
        let stackView = UIStackView()
        
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(valueNameLabel)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        
        return stackView
    }
    
    private func addSubviews() {
        scrollView.addSubview(userImage)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(activityIndicator)
        scrollView.addSubview(stateView)
        scrollView.addSubview(storiesCollectionView)
        
        guard let subscribersStackView = subscribersStackView,
              let subscriptionsStackView = subscriptionsStackView,
              let postsStackView = postsStackView else { return }
        
        mainStackViewForNumbers.addArrangedSubview(postsStackView)
        mainStackViewForNumbers.addArrangedSubview(subscribersStackView)
        mainStackViewForNumbers.addArrangedSubview(subscriptionsStackView)
        
        scrollView.addSubview(mainStackViewForNumbers)
        view.addSubview(scrollView)
    }
    
    private func layout() {
        if let navigationBar = navigationController?.navigationBar,
           let tabBar = tabBarController?.tabBar  {
            scrollView.pin
                .below(of: navigationBar)
                .left()
                .right()
                .above(of: tabBar)
        }
        
        userImage.pin
            .top(LocalConstants.userImageTopInset)
            .left(LocalConstants.leftInset)
            .size(LocalConstants.userImage)
        
        userImage.layer.cornerRadius = userImage.frame.height / 2
        
        mainStackViewForNumbers.pin
            .after(of: userImage,aligned: .center).marginLeft(LocalConstants.valuesLeftInset)
            .right(LocalConstants.valuesRightInset)
            .height(LocalConstants.valuesHeight)
        
        storiesCollectionView.pin
            .size(CGSize(width: UIScreen.main.bounds.width, height: 10)) // for calculation content size
        
        storiesCollectionView.layoutIfNeeded()
        
        if !(nameLabel.text?.isEmpty ?? true) && !(descriptionLabel.text?.isEmpty ?? true) {
            nameLabel.pin
                .below(of: userImage).marginTop(LocalConstants.nameLabelTopInset)
                .left(LocalConstants.leftInset)
                .right(LocalConstants.rightInset)
                .height(nameLabel.intrinsicContentSize.height)
            
            descriptionLabel.pin
                .below(of: nameLabel).marginTop(LocalConstants.descriptionLabelTopInset)
                .left(LocalConstants.leftInset)
                .right(LocalConstants.rightInset)
            
            descriptionLabel.sizeToFit()
        
            stateView.pin
                .below(of: descriptionLabel).marginTop(LocalConstants.noStoriesTopInset)
                .hCenter()
            
            activityIndicator.pin
                .below(of: descriptionLabel).marginTop(LocalConstants.activityIndicatoriInset)
                .hCenter()
            
            storiesCollectionView.pin
                .below(of: descriptionLabel).marginTop(LocalConstants.collectionViewTopInset)
                .left(LocalConstants.leftInset)
                .right(LocalConstants.rightInset)
                .height(storiesCollectionView.contentSize.height)
        } else {
            activityIndicator.pin
                .below(of: userImage).marginTop(LocalConstants.activityIndicatoriInset)
                .hCenter()
            
            stateView.pin
                .below(of: userImage).marginTop(LocalConstants.noStoriesTopInset)
                .hCenter()
            
            storiesCollectionView.pin
                .below(of: userImage).marginTop(LocalConstants.collectionViewTopInset)
                .left(LocalConstants.leftInset)
                .right(LocalConstants.rightInset)
                .height(storiesCollectionView.contentSize.height)
        }
        
        let contentViewHeight = userImage.frame.height + nameLabel.frame.height + descriptionLabel.frame.height + storiesCollectionView.contentSize.height + LocalConstants.nameLabelTopInset + LocalConstants.userImageTopInset + LocalConstants.descriptionLabelTopInset
        scrollView.contentSize = CGSize(width: view.frame.width,
                                        height: contentViewHeight)
    }
    
    private func setupGestureViewControllerTransition() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    //MARK: - OBJC methods
    @objc private func addToFavorites() {
        
    }
    
    @objc private  func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if sender.direction == .left {
            self.tabBarController?.selectedIndex += 1
        }
        if sender.direction == .right {
            self.tabBarController?.selectedIndex -= 1
        }
    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocalConstants.reuseIdentifier, for: indexPath) as? StoryCell else { return UICollectionViewCell()}
        cell.imageDelegate = self
        if let story = stories?[indexPath.item] {
            cell.configure(story: story)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return LocalConstants.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let stories = stories, let navigationController = navigationController else { return }
        presenter.presentStory(transitionHandler: navigationController,with: stories, selectedStoryIndex: indexPath.item)
    }
}

//MARK: - extension + ProfileViewProtocol
extension ProfileViewController: ProfileViewProtocol {
    
    func showStoriesPreview(stories: [Story]) {
        self.stories = stories
    }
    
    func showUser(_ user: InstagramUser) {
        self.user = user
    }
    
    func showProfileIsPrivate() {
        activityIndicator.hide()
        stateView.type = .isPrivate
        stateView.showWithFade(with: LocalConstants.noStoriesAnimationDuration)
    }
}

//MARK: - extension + StoryCellImageDelegate
extension ProfileViewController: StoryCellImageDelegate {
    func fetchImage(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        presenter.fetchImage(stringURL: stringURL, completion: completion)
    }
}

private enum LocalConstants {
    static let reuseIdentifier = "story"
    static let cellSize = CGSize(width: UIScreen.main.bounds.width / 3 - (minimimInteritemSpacing * 2),
                                 height: 200)
    static let contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 40, right: 0)
    static let minimumLineSpacing: CGFloat = 15
    static let minimimInteritemSpacing: CGFloat = 10
    
    static let noStoriesAnimationDuration: TimeInterval = 0.6
    
    //Layout
    static let leftInset: CGFloat = 16
    static let rightInset: CGFloat = 16
    static let userImage = CGSize(width: 90, height: 90)
    static let userImageTopInset: CGFloat = 10
    static let valuesLeftInset: CGFloat = 50
    static let valuesRightInset: CGFloat = 50
    static let valuesHeight: CGFloat = 40
    static let nameLabelTopInset: CGFloat = 10
    static let descriptionLabelTopInset: CGFloat = 2
    static let collectionViewTopInset: CGFloat = 20
    static let activityIndicatoriInset: CGFloat = 200
    static let noStoriesTopInset: CGFloat = 50
    static let noStoriesViewDefaultAlpha: CGFloat = 0
}
