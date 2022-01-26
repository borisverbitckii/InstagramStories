////
////  DismissingViewAnimator.swift
////  InstagramStories
////
////  Created by Борис on 13.12.2021.
////
//
//import UIKit
//
//final class DismissingViewAnimator: NSObject {
//    //MARK: - Private properties
//    private let duration: TimeInterval
//    
//    //MARK: - Init
//    init(duration: TimeInterval = 0.4) {
//        self.duration = duration
//    }
//}
//
////MARK: - extension + UIViewControllerAnimatedTransitioning
//extension DismissingViewAnimator: UIViewControllerAnimatedTransitioning {
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return duration
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let toVC = transitionContext.viewController(forKey: .to),
//            let fromVC = transitionContext.viewController(forKey: .from),
//            let animatableFromVC = fromVC as? Animatable else {
//            return
//        }
//        var fromVCRect = transitionContext.initialFrame(for: fromVC)
//        fromVCRect.origin.x = fromVCRect.size.width
//        UIView.animate(withDuration: duration, animations: {
//            animatableFromVC.animatableMainView.frame = fromVCRect
//        }) { (_) in
//            if !transitionContext.transitionWasCancelled {
//                fromVC.beginAppearanceTransition(false, animated: true)
//                toVC.beginAppearanceTransition(true, animated: true)
//                fromVC.endAppearanceTransition()
//                toVC.endAppearanceTransition()
//            }
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
//    }
//}
