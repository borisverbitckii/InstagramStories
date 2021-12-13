//
//  CustomActivityIndicator.swift
//  InstagramStories
//
//  Created by Борис on 10.12.2021.
//

import UIKit
import Lottie
import SwiftUI

enum ActivityIndicatorType {
    case withBackgroundView(ActivityIndicatorSize)
    case defaultActivityIndicator(ActivityIndicatorSize)
}

enum ActivityIndicatorSize {
    case small
    case medium
    case large
}

final class CustomActivityIndicator: UIView {
    
    //MARK: - Public properties
    var type: ActivityIndicatorType? {
        didSet {
            addSubviews()
            layout()
            show()
        }
    }
    
    //MARK: - Private properties
    
    private let activityIndicator: AnimationView = {
        $0.animation = Animation.named("9131-loading-green")
        $0.contentMode = .scaleAspectFill
        return $0
    } (AnimationView())
    
    private let activityIndicatorContainer: UIView = {
        $0.clipsToBounds = true
        $0.backgroundColor = .white
        return $0
    }(UIView())
    
    private let activityIndicatorContainerShadow: UIView = {
        Utils.addShadow(type: .shadowIsUnder, layer: $0.layer)
        return $0
    }(UIView())
    
    //MARK: - Init
    init() {
        super.init(frame: .zero)
        activityIndicator.backgroundBehavior = .pauseAndRestore
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    //MARK: - Public methods
    
    func show() {
        self.activityIndicator.play(fromProgress: 0, toProgress: 1, loopMode: .loop)
        self.isHidden = false
        UIView.transition(with: self,
                          duration: LocalConstants.animationDuration,
                          options: .curveEaseOut) { [weak self] in
            self?.alpha = 1
        }
    }
    
    func hide() {
        self.activityIndicator.pause()
        UIView.transition(with: self,
                          duration: LocalConstants.animationDuration,
                          options: .curveEaseOut) { [weak self] in
            self?.alpha = 0
        } completion: { _ in
            self.isHidden = true
        }
    }
    
    //MARK: - Private methods
    private func addSubviews() {
        switch type {
        case .withBackgroundView(_):
            activityIndicator.removeFromSuperview()
            
            activityIndicatorContainer.addSubview(activityIndicator)
            activityIndicatorContainerShadow.addSubview(activityIndicatorContainer)
            addSubview(activityIndicatorContainerShadow)
            
        case .defaultActivityIndicator(_):
            activityIndicatorContainerShadow.removeFromSuperview()
            activityIndicatorContainer.removeFromSuperview()
            
            addSubview(activityIndicator)
        case .none:
            break
        }
    }
    
    private func layout() {
        switch type {
        case .withBackgroundView(let sizeType):
            switch sizeType {
            case .small:
                activityIndicator.pin.size(LocalConstants.activityIndicatorSmallSize).center()
            case .medium:
                activityIndicator.pin.size(LocalConstants.activityIndicatorMediumSize).center()
            case .large:
                activityIndicator.pin.size(LocalConstants.activityIndicatorLargeSize).center()
            }
            layoutContainers(activityIndicator: activityIndicator)
        case .defaultActivityIndicator(let sizeType):
            switch sizeType {
            case .small:
                activityIndicator.pin.size(LocalConstants.activityIndicatorSmallSize).center()
            case .medium:
                activityIndicator.pin.size(LocalConstants.activityIndicatorMediumSize).center()
            case .large:
                activityIndicator.pin.size(LocalConstants.activityIndicatorLargeSize).center()
            }
        case .none:
            break
        }
    }
    
    private func layoutContainers(activityIndicator: AnimationView) {
        activityIndicatorContainer.pin
            .center()
            .size(CGSize(width: activityIndicator.frame.width + 10, height:
                            activityIndicator.frame.height + 10))
        
        activityIndicatorContainerShadow.pin.sizeToFit().center()
        activityIndicatorContainer.layer.cornerRadius =  activityIndicatorContainer.frame.height / 2
    }
}

private enum LocalConstants {
    static let activityIndicatorSmallSize = CGSize(width: 30, height: 30)
    static let activityIndicatorMediumSize = CGSize(width: 60, height: 60)
    static let activityIndicatorLargeSize = CGSize(width: 100, height: 100)
    
    static let activityIndicatorContainerCornerRadius: CGFloat = 40
    
    static let animationDuration: TimeInterval = 0.45
}
