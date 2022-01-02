//
//  StoryPresenter.swift
//  InstagramStories
//
//  Created by Борис on 21.12.2021.
//

import UIKit
import Swiftagram
import AVFoundation
import Photos

protocol StoryPresenterProtocol {
    func viewDidLoad()
    func viewDidDisappear()
    func selectedStoryIndexWasIncreased()
    func selectedStoryIndexWasDecreased()
    func saveVideoToLibrary(storyIndex: Int)
    func shareStory(storyIndex: Int)
}

final class StoryPresenter {
    
    //MARK: - Private properties
    private weak var view: StoryViewProtocol?
    private weak var transitionHandler: TransitionProtocol?
    private let coordinator: CoordinatorProtocol
    private let showStoryUseCase: ShowStoryUseCaseProtocol
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
    private var durationForCurrentStory: TimeInterval = 0
    private var previousDurationWhenWasPaused: TimeInterval = 0
    private var durationWhenWasPaused: TimeInterval = 0
    
    //MARK: - Init
    init(coordinator: CoordinatorProtocol,
         secret: Secret,
         useCase: ShowStoryUseCaseProtocol,
         stories: [Story],
         user: RealmInstagramUserProtocol,
         selectedStoryIndex: Int) {
        self.coordinator = coordinator
        self.showStoryUseCase = useCase
        self.secret = secret
        self.username = user.instagramUsername
        self.stories = stories.reversed() // for changing story position (new at the end)
        self.selectedStoryIndex = stories.count - 1 - selectedStoryIndex
    }
    
    //MARK: - Public methods
    func injectView(view: StoryViewProtocol) {
        self.view = view
    }
    
    func injectTransitionHandler(view: TransitionProtocol) {
        self.transitionHandler = view
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
        showStoryUseCase.fetchStoryPreview(urlString: stories[selectedStoryIndex].previewImageURL) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let image):
                self.view?.showStoryPreview(with: image)
                
                /// Image already cached so I can show video in completion without any delay
                
                // StoryVideo
                self.view?.videoPlayer.pause()
                self.view?.videoPlayer.replaceCurrentItem(with: nil)
                self.showStoryUseCase.downloadCurrentStoryVideo(urlString: self.stories[self.selectedStoryIndex].contentURLString) { [weak self] videoURL in
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
                    
                    self.durationForCurrentStory = durationTime // for calculate pause progress
                    
                    if self.timer != nil {
                        self.timer?.invalidate()
                    }
                    
                    self.timer = Timer(timeInterval: durationTime, target: self,
                                       selector: #selector(self.timerWasFired),
                                       userInfo: nil,
                                       repeats: false)
                    
                    guard let timer = self.timer else { return }
                    timer.tolerance = LocalConstants.mainTimerTolerance
                    RunLoop.current.add(timer, forMode: .common)
                    
                    self.progressWidth = 0
                    self.timerForProgressWidth = Timer(timeInterval: LocalConstants.timerForProgressWidthDurationTime,
                                                       repeats: true) { [weak self] timer in
                        guard let self = self else { return }
                        self.durationWhenWasPaused += LocalConstants.timerForProgressWidthDurationTime
                        self.progressWidth += LocalConstants.timerForProgressWidthDurationTime / durationTime
                        self.view?.setupVideoProgressViewWidth(percentWidth: self.progressWidth)
                    }
                    
                    guard let timerForProgressWidth = self.timerForProgressWidth else { return }
                    timerForProgressWidth.tolerance = LocalConstants.timerForProgressWidthTolerance
                    RunLoop.current.add(timerForProgressWidth, forMode: .common)
                }
            case .failure(_):
                break // fix this
            }
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
        timer?.invalidate()
        timerForProgressWidth?.invalidate()
    }
    
    func selectedStoryIndexWasIncreased() {
        timer?.invalidate()
        timerForProgressWidth?.invalidate()
        progressWidth = 0
        view?.setupVideoProgressViewWidth(percentWidth: progressWidth)
        durationWhenWasPaused = 0
        previousDurationWhenWasPaused = 0
        
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
        durationWhenWasPaused = 0
        previousDurationWhenWasPaused = 0
        
        if selectedStoryIndex > 0 {
            selectedStoryIndex -= 1
        } else {
            selectedStoryIndex = 0
        }
    }
    
    func saveVideoToLibrary(storyIndex: Int) {
        PHPhotoLibrary.shared().performChanges({ [weak self] in
            guard let self = self else { return }
            let storyVideoPath = VideoCacheManager.shared.directoryFor(stringUrl: self.stories[storyIndex].contentURLString)
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: storyVideoPath)
        }) { saved, error in
            if saved {
                DispatchQueue.main.async {
                    self.view?.showAlertController(title: Text.success.getText(),
                                                   message: Text.videoSaved.getText())
                }
            }
        }
    }
    
    func shareStory(storyIndex: Int) {
        let storyVideoPath = VideoCacheManager.shared.directoryFor(stringUrl: self.stories[storyIndex].contentURLString)
        let objectsToShare = [storyVideoPath]
        let excludedActivityTypes = [UIActivity.ActivityType.airDrop,
                                     UIActivity.ActivityType.copyToPasteboard,
                                     UIActivity.ActivityType.message,
                                     UIActivity.ActivityType.postToTencentWeibo,
                                     UIActivity.ActivityType.postToWeibo]
        if let transitionHandler = transitionHandler {
            view?.videoPlayer.pause()
            timerForProgressWidth?.invalidate()
            timer?.invalidate()
            
            let completion: ()->() = { [weak self] in
                guard let self = self else { return }
                self.view?.videoPlayer.play()
            
                let remainderOfStoryDuration = self.durationForCurrentStory - (self.previousDurationWhenWasPaused + self.durationWhenWasPaused)
                
                self.previousDurationWhenWasPaused += self.durationWhenWasPaused
                self.durationWhenWasPaused = 0
                self.timer = Timer(timeInterval: remainderOfStoryDuration, target: self,
                                   selector: #selector(self.timerWasFired),
                                   userInfo: nil,
                                   repeats: false)
                
                guard let timer = self.timer else { return }
                timer.tolerance = LocalConstants.mainTimerTolerance
                RunLoop.current.add(timer, forMode: .common)

                self.timerForProgressWidth = Timer(timeInterval: LocalConstants.timerForProgressWidthDurationTime,
                                                   repeats: true) { [weak self] timer in
                    guard let self = self else { return }
                    self.durationWhenWasPaused += LocalConstants.timerForProgressWidthDurationTime
                    self.progressWidth += LocalConstants.timerForProgressWidthDurationTime / self.durationForCurrentStory
                    self.view?.setupVideoProgressViewWidth(percentWidth: self.progressWidth)
                }

                guard let timerForProgressWidth = self.timerForProgressWidth else { return }
                timerForProgressWidth.tolerance = LocalConstants.timerForProgressWidthTolerance
                RunLoop.current.add(timerForProgressWidth, forMode: .common)
            }
            coordinator.presentActivityViewController(
                type: .video(ActivityViewControllerSettings(
                    key: "subject",
                    value: "Video",
                    objectsToShare: objectsToShare,
                    excludedActivityTypes: excludedActivityTypes)),
                transitionHandler: transitionHandler,
                completion: completion)
        }
    }
    
    //MARK: - OBJC methods
    @objc private func timerWasFired() {
        timer?.invalidate()
        timerForProgressWidth?.invalidate()
        progressWidth = 0
        view?.setupVideoProgressViewWidth(percentWidth: progressWidth)
        durationWhenWasPaused = 0
        previousDurationWhenWasPaused = 0
        
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
