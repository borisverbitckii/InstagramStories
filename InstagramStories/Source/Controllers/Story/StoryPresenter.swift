//
//  StoryPresenter.swift
//  InstagramStories
//
//  Created by Борис on 21.12.2021.
//

import UIKit
import Swiftagram
import AVFoundation

protocol StoryPresenterProtocol {
    func viewDidLoad()
    func viewDidDisappear()
    func selectedStoryIndexWasIncreased()
    func selectedStoryIndexWasDecreased()
}

final class StoryPresenter: NSObject {
    
    //MARK: - Private properties
    private weak var view: StoryViewProtocol?
    private let coordinator: CoordinatorProtocol
    private let useCase: ShowStoryUseCaseProtocol
    private let secret: Secret
    private let stories: [Story]
    private let username: String
    private var timer: Timer?
    private var timerForProgressWidth: Timer?
    private var selectedStoryIndex: Int {
        didSet {
            showSelectedStory(oldValue: oldValue)
        }
    }
    private var progressWidth: CGFloat = 0
    
    //MARK: - Init
    init(coordinator: CoordinatorProtocol,
         secret: Secret,
         useCase: ShowStoryUseCaseProtocol,
         stories: [Story],
         user: InstagramUser,
         selectedStoryIndex: Int) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.secret = secret
        self.username = user.instagramUsername
        self.stories = stories.reversed() // for changing story position (new at the end)
        self.selectedStoryIndex = stories.count - 1 - selectedStoryIndex
    }
    
    //MARK: - Override methods
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate" {
            if (view?.videoPlayer.rate ?? 0) > 0 {
                timer?.fire()
            }
        }
    }
    
    //MARK: - Public methods
    func injectView(view: StoryViewProtocol) {
        self.view = view
    }
    
    
    //MARK: - Private methods
    private func showSelectedStory(oldValue: Int? = nil) {
        view?.setupSelectedStoryIndex(index: selectedStoryIndex)
        
        // Posting time
        let postingTime = Utils.handleDate(unixDate: stories[selectedStoryIndex].time) + " назад"
        view?.setupStoryPostingTime(postingTime)
        
        // CollectionViewProgress
        if let oldValue = oldValue, oldValue < selectedStoryIndex {
            let indexPaths = (selectedStoryIndex - 1...selectedStoryIndex).map { IndexPath(item: $0, section: 0)}
            view?.reloadCollectionViewItems(indexPaths: indexPaths)
        } else if let oldValue = oldValue, oldValue > selectedStoryIndex {
            let indexPaths = (selectedStoryIndex...oldValue).map { IndexPath(item: $0, section: 0)}
            view?.reloadCollectionViewItems(indexPaths: indexPaths)
        } else {
            view?.reloadCollectionViewItems(indexPaths: [IndexPath(item: selectedStoryIndex, section: 0)])
        }
        
        // StoryPreview
        useCase.fetchStoryPreview(urlString: stories[selectedStoryIndex].previewImageURL) { [weak self] result in
            switch result {
            case .success(let image):
                self?.view?.showStoryPreview(with: image)
            case .failure(_):
                break // fix this
            }
        }
        
        // StoryVideo
        self.view?.videoPlayer.pause()
        view?.videoPlayer.replaceCurrentItem(with: nil)
        useCase.downloadCurrentStoryVideo(urlString: stories[selectedStoryIndex].contentURLString) { [weak self] videoURL in
            // Play video
            guard let self = self else { return }
            guard self.view?.isBeingDismissed != true else { return }
            self.view?.videoPlayer = AVPlayer(url: videoURL)
            self.view?.videoPlayerLayer.player = self.view?.videoPlayer
            self.view?.videoPlayer.play()
            
            // Fire timer
            let asset = AVAsset(url: videoURL)
            let duration = asset.duration
            var durationTime: TimeInterval = CMTimeGetSeconds(duration)
            if durationTime == 0 {
                durationTime = LocalConstants.mainTimerDurationTime
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
            timer.tolerance = LocalConstants.mainTimerTolerance
            RunLoop.current.add(timer, forMode: .common)
            
            self.progressWidth = 0
            self.timerForProgressWidth = Timer(timeInterval: LocalConstants.timerForProgressWidthDurationTime,
                                               repeats: true) { [weak self] timer in
                guard let self = self else { return }
                if self.timer?.isValid == false {
                    timer.invalidate()
                    self.progressWidth = 0
                    return
                }
                self.progressWidth += LocalConstants.timerForProgressWidthDurationTime / durationTime
                self.view?.setupVideoProgressViewWidth(percentWidth: self.progressWidth)
            }
            
            guard let timerForProgressWidth = self.timerForProgressWidth else { return }
            timerForProgressWidth.tolerance = LocalConstants.timerForProgressWidthTolerance
            RunLoop.current.add(timerForProgressWidth, forMode: .common)
        }
    }
}

//MARK: - extension + StoryPresenterProtocol
extension StoryPresenter: StoryPresenterProtocol {
    
    func viewDidLoad() {
        // Title
        let title = "@" + username
        view?.setupTitle(title)
        view?.setupStoriesCount(stories.count)
        showSelectedStory()
    }
    
    func viewDidDisappear() {
        view?.videoPlayer.pause()
        view?.videoPlayer.replaceCurrentItem(with: nil)
        timer?.removeObserver(self, forKeyPath: "rate")
        timer?.invalidate()
        timerForProgressWidth?.invalidate()
    }
    
    func selectedStoryIndexWasIncreased() {
        timer?.invalidate()
        timerForProgressWidth?.invalidate()
        progressWidth = 0
        view?.setupVideoProgressViewWidth(percentWidth: progressWidth)
        
        if selectedStoryIndex < stories.count - 1 {
            selectedStoryIndex += 1
            return
        }
        
        view?.dismiss(animated: true,completion: nil)
    }
    
    func selectedStoryIndexWasDecreased() {
        timer?.invalidate()
        timerForProgressWidth?.invalidate()
        progressWidth = 0
        view?.setupVideoProgressViewWidth(percentWidth: progressWidth)
        
        if selectedStoryIndex > 0 {
            selectedStoryIndex -= 1
        }
    }
    
    //MARK: - OBJC methods
    @objc private func timerWasFired() {
        timer?.invalidate()
        timerForProgressWidth?.invalidate()
        progressWidth = 0
        view?.setupVideoProgressViewWidth(percentWidth: progressWidth)
        
        if selectedStoryIndex < stories.count  - 1 {
            selectedStoryIndex += 1
            return
        }
        
        view?.dismiss(animated: true, completion: nil)
    }
}

private enum LocalConstants {
    static let mainTimerDurationTime: TimeInterval = 15
    static let mainTimerTolerance: TimeInterval = 0.3
    static let timerForProgressWidthDurationTime: TimeInterval = 0.01
    static let timerForProgressWidthTolerance: TimeInterval = 0.05
}
