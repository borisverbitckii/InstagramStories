////
////  ViewInteractiveAnimator.swift
////  InstagramStories
////
////  Created by Борис on 13.12.2021.
////
//
// import UIKit
//
// final class ViewInteractiveAnimator: UIPercentDrivenInteractiveTransition {
//
// MARK: - Public properties
//    let fromViewController: UIViewController
//    let toViewController: UIViewController?
//    var isTransitionInProgress = false
//    var isEnabled = true {
//        didSet {
//            pan.isEnabled = isEnabled
//        }
//    }
//
// MARK: - Private properties
//    private var shouldComplete = false
//    private let threshold: CGFloat = 0.5
//    private let targetScreenWidth = UIScreen.main.bounds.width
//    private lazy var dragAmount = toViewController == nil ? targetScreenWidth : -targetScreenWidth
//    private lazy var pan: UIPanGestureRecognizer = {
//        let pan = UIPanGestureRecognizer()
//        pan.addTarget(self, action: #selector(onPan(_:)))
//        return pan
//    }()
//
// MARK: - Init
//    init(fromViewController: UIViewController, toViewController: UIViewController?, gestureView: UIView) {
//        self.fromViewController = fromViewController
//        self.toViewController = toViewController
//        super.init()
//        gestureView.addGestureRecognizer(self.pan)
//        completionSpeed = 0.5
//    }
//
// MARK: - Deinit
//    deinit {
//        pan.view?.removeGestureRecognizer(pan)
//    }
//
// MARK: - OBJC methods
//    @objc func onPan(_ pan: UIPanGestureRecognizer) {
//        let translation = pan.translation(in: pan.view?.superview)
//        switch pan.state {
//        case .began:
//            isTransitionInProgress = true
//            if let toViewController = toViewController {
//                fromViewController.present(toViewController, animated: true, completion: nil)
//            } else {
//                fromViewController.dismiss(animated: true, completion: nil)
//            }
//        case .changed:
//            isTransitionInProgress = true
//            var percent = translation.x / dragAmount
//            percent = fmax(percent, 0)
//            percent = fmin(percent, 1)
//            update(percent)
//            shouldComplete = percent > threshold
//            if shouldComplete {
//                (fromViewController as? Animatable)?.prepareBeingDismissed()
//                finish()
//            }
//        case .ended:
//            shouldComplete ? finish() : cancel()
//            isTransitionInProgress = false
//        case .cancelled:
//            cancel()
//            isTransitionInProgress = false
//        default:
//            isTransitionInProgress = false
//        }
//    }
// }
//
