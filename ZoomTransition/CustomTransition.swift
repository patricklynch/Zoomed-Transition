//
//  CustomTransition.swift
//  ZoomTransition
//
//  Created by Patrick Lynch on 5/6/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import UIKit

protocol Transition {
    var animationDuration: NSTimeInterval { get }
    func performTransitionIn(model: TransitionModel, completion: (Bool)->())
    func performTransitionOut(model: TransitionModel, completion: (Bool)->())
}

struct TransitionModel {
    let context: UIViewControllerContextTransitioning
    let transition: Transition
    let fromViewController: UIViewController
    let toViewController:UIViewController
    let presenting: Bool
    
    init(context: UIViewControllerContextTransitioning, transition: Transition) {
        self.context = context
        self.transition = transition
        guard let toViewController = context.viewControllerForKey(UITransitionContextToViewControllerKey),
            let fromViewController = context.viewControllerForKey(UITransitionContextFromViewControllerKey) else {
                abort()
        }
        
        self.toViewController = toViewController
        self.fromViewController = fromViewController
        
        let modal = toViewController.presentedViewController != nil || fromViewController.presentedViewController != nil
        if let fromNav = fromViewController.navigationController where !modal {
            presenting = fromNav.viewControllers.contains(fromViewController)
        } else {
            presenting = toViewController.presentedViewController != fromViewController
        }
    }
}

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let transition: Transition
    
    init(transition: Transition) {
        self.transition = transition
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transition.animationDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let model = TransitionModel(
            context: transitionContext,
            transition: transition
        )
        
        guard let container = transitionContext.containerView() else {
            abort()
        }
        
        if model.presenting {
            model.toViewController.view.frame = model.fromViewController.view.frame
            
            container.addSubview(model.fromViewController.view)
            container.addSubview(model.toViewController.view)
            
            transition.performTransitionIn(model) { completed in
                transitionContext.completeTransition(transitionContext.transitionWasCancelled())
            }
            
        } else {
            model.fromViewController.view.frame = model.toViewController.view.frame
            
            container.addSubview(model.toViewController.view)
            container.addSubview(model.fromViewController.view)
            
            transition.performTransitionOut(model) { completed in
                transitionContext.completeTransition(transitionContext.transitionWasCancelled())
            }
        }
    }
}

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    let animator: TransitionAnimator
    
    init(transition: Transition) {
        self.animator = TransitionAnimator(transition: transition)
    }
    
    // MARK: - FUCK
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
}
