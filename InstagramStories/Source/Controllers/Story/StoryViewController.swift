//
//  StoryViewController.swift
//  InstagramStories
//
//  Created by Борис on 21.12.2021.
//

import UIKit
import AVFoundation

protocol StoryViewProtocol: AnyObject {
    // Properties
    var videoPlayer: AVPlayer { get set }
    var videoPlayerLayer: AVPlayerLayer { get set }
    var isBeingDismissed: Bool { get }
    // Methods
    func present(viewController: UIViewController)
    func showAlertController(title: String, message: String)
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
    func showStoryPreview(with image: UIImage)
    func layoutStoryWasPostedTimeLabel()
    func reloadCollectionViewItems(indexPaths: [IndexPath])
    // Setup properties
    func setupTitle(_ title: String)
    func setupSelectedStoryIndex(index: Int)
    func setupStoriesCount(_ number: Int)
    func setupStoryPostingTime(_ time: String)
    func setupVideoProgressViewWidth(percentWidth: CGFloat)
}

final class StoryViewController: UIViewController, UINavigationBarDelegate {

    // MARK: - Private properties
    private let presenter: StoryPresenterProtocol
    private var storiesCount = 0
    private var currentStoriesIndex: Int?

    // UI Elements
    private var navBar: UINavigationBar = {
        let navItem = UINavigationItem()

        /// Disable downloading and sharing because of apple regulations
//        let saveItem = UIBarButtonItem(image: Images.storyButtons(.save).getImage(), style: .plain, target: self, action: #selector(saveButtonTapped))
//        let shareItem = UIBarButtonItem(image: Images.storyButtons(.share).getImage(), style: .plain, target: self, action: #selector(shareButtonTapped))
        let closeItem = UIBarButtonItem(barButtonSystemItem: .close, target: StoryViewController.self, action: #selector(closeBarButtonTapped))
        navItem.rightBarButtonItems = [closeItem]

//        saveItem.tintColor = Palette.purple.color
//        shareItem.tintColor = Palette.purple.color

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

    private let videoProgressView: UIView = {
        $0.alpha = LocalConstants.videoProgressViewAlpha
        $0.clipsToBounds = true
        $0.backgroundColor = .white
        return $0
    }(UIView())

    private let storyPreviewImageView: UIImageView = {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())

    // VideoPlayer
    var videoPlayer: AVPlayer = {
        return $0
    }(AVPlayer())

    var videoPlayerLayer: AVPlayerLayer = {
        $0.videoGravity = .resizeAspectFill
        return $0
    }(AVPlayerLayer())

    // for story changing
    private let leftSideView = UIView()
    private let rightSideView = UIView()

    // MARK: - Init
    init(presenter: StoryPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        collectionViewForStories.delegate = self
        collectionViewForStories.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        view.backgroundColor = Palette.white.color
        addSubviews()
        setupViewsForStoriesChanging()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewDidDisappear()
    }

    // MARK: - Private methods
    private func addSubviews() {
        navBar.addSubview(usernameLabel)
        navBar.addSubview(storyWasPostedTimeLabel)
        view.addSubview(collectionViewForStories)
        view.addSubview(navBar)
        view.addSubview(storyPreviewImageView)
        view.layer.addSublayer(videoPlayerLayer)
        view.addSubview(videoProgressView)
        view.addSubview(leftSideView)
        view.addSubview(rightSideView)
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

        videoPlayerLayer.pin
            .below(of: collectionViewForStories.layer)
            .left()
            .right()
            .bottom()

        videoProgressView.layer.cornerRadius = videoProgressView.frame.height / 2

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
    }
    private func setupViewsForStoriesChanging() {
        leftSideView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftSideWasTapped)))
        rightSideView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightSideWasTapped)))
    }

    @objc private func leftSideWasTapped() {
        presenter.selectedStoryIndexWasDecreased()
    }

    @objc private func rightSideWasTapped() {
        presenter.selectedStoryIndexWasIncreased()
    }

    @objc private func closeBarButtonTapped() {
        self.dismiss(animated: true)
    }

    /// Disable downloading and sharing because of apple regulations
//    @objc private func shareButtonTapped() {
//        if let currentStoriesIndex = currentStoriesIndex {
//            presenter.shareStory(storyIndex: currentStoriesIndex)
//        }
//    }

//    @objc private func saveButtonTapped() {
//        if let currentStoriesIndex = currentStoriesIndex {
//            presenter.saveVideoToLibrary(storyIndex: currentStoriesIndex)
//        }
//    }
}

extension StoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storiesCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocalConstants.reuseIdentifier, for: indexPath)
        if indexPath.item == currentStoriesIndex {
            cell.backgroundColor = Palette.purple.color
            return cell
        }
        cell.backgroundColor = Palette.superLightGray.color
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if storiesCount > 0 {
            let collectionViewWidth = collectionView.frame.width

            let cellWidth = (collectionViewWidth - CGFloat(storiesCount - 1) * LocalConstants.collectionViewMinimumInteritemSpacing) / CGFloat(storiesCount)
            return CGSize(width: cellWidth, height: collectionView.frame.height)
        }

        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - extension + StoryViewProtocol
extension StoryViewController: StoryViewProtocol {
    func present(viewController: UIViewController) {
        presentViewController(viewController, animated: true)
    }

    func showAlertController(title: String, message: String) {
        showAlertController(title: title, message: message, completion: nil)
    }

    func setupVideoProgressViewWidth(percentWidth: CGFloat) {
        videoProgressView.pin
            .below(of: collectionViewForStories).marginTop(LocalConstants.videoProgressViewTopInset)
            .left()
            .width(view.frame.width * percentWidth)
            .height(LocalConstants.videoProgressViewHeight)
    }

    func setupStoriesCount(_ number: Int) {
        self.storiesCount = number
    }

    func setupSelectedStoryIndex(index: Int) {
        self.currentStoriesIndex = index
    }

    func setupStoryPostingTime(_ time: String) {
        storyWasPostedTimeLabel.text = time
    }

    func layoutStoryWasPostedTimeLabel() {
        storyWasPostedTimeLabel.sizeToFit()
        storyWasPostedTimeLabel.pin
            .after(of: usernameLabel, aligned: .center).marginLeft(LocalConstants.storyWasPostedTimeLabelLeftInset)
    }

    func reloadCollectionViewItems(indexPaths: [IndexPath]) {
        collectionViewForStories.reloadItems(at: indexPaths)
    }

    func showStoryPreview(with image: UIImage) {
        storyPreviewImageView.image = image
    }

    func setupTitle(_ title: String) {
        usernameLabel.text = title
    }

    func injectCurrentStoryIndex(_ index: Int) {
        currentStoriesIndex = index
    }
}

private enum LocalConstants {
    static let reuseIdentifier = "story"
    static let collectionViewMinimumInteritemSpacing: CGFloat = 3
    static let collectionViewHeight: CGFloat = 3
    static let collectionViewTopOffset: CGFloat = 10
    static let videoProgressViewHeight: CGFloat = 3
    static let videoProgressViewAlpha: CGFloat = 0.3
    static let videoProgressViewTopInset: CGFloat = 5
    static let videoProgressViewDefaultWidth: CGFloat = 0
    static let navBarHeight: CGFloat = 44
    static let usernameLabelLeftInset: CGFloat = 16
    static let storyWasPostedTimeLabelLeftInset: CGFloat = 16
}
