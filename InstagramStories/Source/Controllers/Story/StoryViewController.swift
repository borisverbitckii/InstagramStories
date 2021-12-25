//
//  StoryViewController.swift
//  InstagramStories
//
//  Created by Борис on 21.12.2021.
//

import UIKit
import WebKit
import AVFoundation

protocol StoryViewProtocol: AnyObject {
    func injectUser(_ user: InstagramUser)
    func injectStories(_ stories: [Story])
    func injectCurrentStoryIndex(_ index: Int)
    func setupTitle(_ title: String)
}

final class StoryViewController: UIViewController, UINavigationBarDelegate {
    
    //MARK: - Private properties
    private let presenter: StoryPresenterProtocol
    private var timer: Timer?
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
            
            // Change selection collection view item
            if oldValue < currentStoriesIndex {
                let indexPaths = (currentStoriesIndex - 1...currentStoriesIndex).map { IndexPath(item: $0, section: 0)}
                collectionViewForStories.reloadItems(at: indexPaths)
            } else if oldValue > currentStoriesIndex {
                let indexPaths = (currentStoriesIndex...oldValue).map { IndexPath(item: $0, section: 0)}
                collectionViewForStories.reloadItems(at: indexPaths)
            } else {
                collectionViewForStories.reloadItems(at: [IndexPath(item: currentStoriesIndex, section: 0)])
            }
            
            // Show story preview
            guard let stringURL = stories?[currentStoriesIndex].previewImageURL else { return }
            presenter.fetchStoryPreview(urlString: stringURL) { [weak self] result in
                switch result {
                case .success(let image):
                    self?.storyPreviewImageView.image = image
                case .failure(_): break
                    //TODO: Fix this
                }
            }
            
            // Play video
            videoPlayer.pause()
            guard let urlString = stories?[currentStoriesIndex].contentURLString else { return }
            presenter.downloadCurrentStoryVideo(urlString: urlString) { [weak self] url in
                guard let self = self else { return }
                if self.isBeingDismissed { // stop player when vc is dismissed
                    return
                }
                self.videoPlayer = AVPlayer(url: url)
                self.videoPlayerLayer.player = self.videoPlayer
                self.videoPlayer.play()
                
                // Fire timer
                guard let url = URL(string: urlString) else { return }
                let asset = AVAsset(url: url)
                let duration = asset.duration
                var durationTime: TimeInterval = CMTimeGetSeconds(duration)
                if durationTime == 0 {
                    durationTime = LocalConstants.storyVideoDuration
                }
                
                if self.timer != nil {
                    self.timer?.invalidate()
                }
                
                self.timer = Timer(timeInterval: durationTime, target: self,
                                   selector: #selector(self.timerWasFired),
                                   userInfo: nil,
                                   repeats: false)
                
                guard let timer = self.timer else { return }
                timer.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)
                timer.tolerance = 0.3
                RunLoop.current.add(timer, forMode: .common)
            }
        }
    }
    
    //UI Elements
    private var navBar: UINavigationBar = {
        let navItem = UINavigationItem()
        
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        let shareItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(shareButtonTapped))
        let closeItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBarButtonTapped))
        navItem.rightBarButtonItems = [closeItem, saveItem, shareItem]
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
    let videoPlayerLayer: AVPlayerLayer = {
        $0.videoGravity = .resizeAspectFill
        return $0
    } (AVPlayerLayer())
    
    // for story changing
    private let leftSideView = UIView()
    private let rightSideView = UIView()
    
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
        setupViewsForStoriesChanging()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoPlayer.replaceCurrentItem(with: nil)
        videoPlayer.pause()
        timer?.removeObserver(self, forKeyPath: "rate")
        timer?.invalidate()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate" {
            if videoPlayer.rate > 0 {
                timer?.fire()
            }
        }
    }
    
    //MARK: - Private methods
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
        
        layoutVideoPlayerLayer()
        
        videoProgressView.pin
            .below(of: collectionViewForStories).marginTop(LocalConstants.videoProgressViewTopInset)
            .left()
            .width(LocalConstants.videoProgressViewDefaultWidth)
            .height(LocalConstants.videoProgressViewHeight)
        
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
    
    private func layoutVideoPlayerLayer() {
        videoPlayerLayer.pin
            .below(of: collectionViewForStories.layer)
            .left()
            .right()
            .bottom()
    }
    
    private func layoutStoryWasPostedTimeLabel() {
        storyWasPostedTimeLabel.sizeToFit()
        storyWasPostedTimeLabel.pin
            .after(of: usernameLabel, aligned: .center).marginLeft(LocalConstants.storyWasPostedTimeLabelLeftInset)
    }
    
    private func setupViewsForStoriesChanging() {
        leftSideView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftSideWasTapped)))
        rightSideView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightSideWasTapped)))
    }
    
    private func increaseCurrentStoryIndex() {
        timer?.invalidate()
        
        if currentStoriesIndex < (stories?.count ?? 0 ) - 1 {
            currentStoriesIndex += 1
            return
        }
        
        dismiss(animated: true)
    }
    
    //MARK: - OBJC methods
    @objc private func timerWasFired() {
        increaseCurrentStoryIndex()
    }
    
    @objc private func leftSideWasTapped() {
        timer?.invalidate()
        if currentStoriesIndex > 0 {
            currentStoriesIndex -= 1
        }
    }
    
    @objc private func rightSideWasTapped() {
        increaseCurrentStoryIndex()
    }
    
    @objc private func closeBarButtonTapped() {
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
    func setupTitle(_ title: String) {
        usernameLabel.text = title
    }
    
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
    static let storyVideoDuration: TimeInterval = 15
    
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
