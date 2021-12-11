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
    case small
    case medium
    case large
}

final class CustomActivityIndicator: UIView {
    
    //MARK: - Public properties
    var size: ActivityIndicatorType = .large {
        didSet {
            switch size {
            case .small:
                activityIndicator.pin.size(LocalConstants.activityIndicatorSmallSize).center()
            case .medium:
                activityIndicator.pin.size(LocalConstants.activityIndicatorMediumSize).center()
            case .large:
                activityIndicator.pin.size(LocalConstants.activityIndicatorLargeSize).center()
            }
            layoutIfNeeded()
        }
    }
    
    //MARK: - Private properties
    private let activityIndicator: AnimationView = {
        $0.animation = Animation.named("9131-loading-green")
        $0.contentMode = .scaleAspectFill
        return $0
    } (AnimationView())
   
    //MARK: - Init
    init() {
        super.init(frame: .zero)
        addSubview(activityIndicator)
        activityIndicator.play(fromProgress: 0, toProgress: 1, loopMode: .loop)
        activityIndicator.backgroundBehavior = .pauseAndRestore
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private enum LocalConstants {
    static let activityIndicatorSmallSize = CGSize(width: 30, height: 30)
    static let activityIndicatorMediumSize = CGSize(width: 60, height: 60)
    static let activityIndicatorLargeSize = CGSize(width: 100, height: 100)
}
