////
////  PresentingViewAnimator.swift
////  InstagramStories
////
////  Created by Борис on 13.12.2021.
////
//
// import UIKit
//
// protocol Animatable {
//    var animatableMainView: UIView { get }
//    func prepareBeingDismissed()
// }
//
// final class PresentingViewAnimator: NSObject {
// MARK: - Private properties
//    private let duration: TimeInterval
//
// MARK: - Init
//    init(duration: TimeInterval = 0.4) {
//        self.duration = duration
//    }
// }
//
// MARK: extension + UIViewControllerAnimatedTransitioning
// extension PresentingViewAnimator: UIViewControllerAnimatedTransitioning {
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return duration
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let fromVC = transitionContext.viewController(forKey: .from),
//            let toVC = transitionContext.viewController(forKey: .to),
//            let animatableToVC = toVC as? Animatable else {
//            return
//        }
//        let fromVCRect = transitionContext.initialFrame(for: fromVC)
//        var toVCRect = fromVCRect
//        toVCRect.origin.x = toVCRect.size.width
//        animatableToVC.animatableMainView.frame = toVCRect
//        toVC.view.frame = fromVCRect
//        transitionContext.containerView.addSubview(toVC.view)
//        fromVC.beginAppearanceTransition(false, animated: true)
//        toVC.beginAppearanceTransition(true, animated: true)
//        UIView.animate(withDuration: duration, animations: {
//            animatableToVC.animatableMainView.frame = fromVCRect
//        }) { (_) in
//            fromVC.beginAppearanceTransition(transitionContext.transitionWasCancelled, animated: false)
//            fromVC.endAppearanceTransition()
//            toVC.endAppearanceTransition()
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
//    }
//    
// }
