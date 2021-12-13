////
////  TransitionCoordinator.swift
////  InstagramStories
////
////  Created by Борис on 13.12.2021.
////
//
//import UIKit
//
//final class TransitionCoordinator: NSObject, UIViewControllerTransitioningDelegate {
//    
//    // MARK: Properties
//    
//    var toViewController: UIViewController?
//    var interactivePresentTransition: ViewInteractiveAnimator?
//    var interactiveDismissTransition: ViewInteractiveAnimator?
//    
//    // MARK: Methods
//    
//    func prepareViewForCustomTransition(fromViewController: UITabBarController, toViewController: UINavigationController) {
//        if self.toViewController != nil { return }
//        let toViewController = toViewController
//        toViewController.transitioningDelegate = self
//        toViewController.modalPresentationStyle = .custom
//        interactivePresentTransition = ViewInteractiveAnimator(fromViewController: fromViewController, toViewController: toViewController, gestureView: fromViewController.view)
//        interactiveDismissTransition = ViewInteractiveAnimator(fromViewController: toViewController, toViewController: nil, gestureView: toViewController.view)
//        self.toViewController = toViewController
//    }
//    
//    func removeCustomTransitionBehaviour() {
//        interactivePresentTransition = nil
//        interactiveDismissTransition = nil
//        toViewController = nil
//    }
//    
//    // MARK: UIViewControllerTransitioningDelegate
//    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return PresentingViewAnimator()
//    }
//    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return DismissingViewAnimator()
//    }
//    
//    // отвечают за скролл
//    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        guard let presentInteractor = interactivePresentTransition else {
//            return nil
//        }
//        guard presentInteractor.isTransitionInProgress else {
//            return nil
//        }
//        return presentInteractor
//    }
//    
//    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        guard let dismissInteractor = interactiveDismissTransition else {
//            return nil
//        }
//        guard dismissInteractor.isTransitionInProgress else {
//            return nil
//        }
//        return dismissInteractor
//    }
//}
