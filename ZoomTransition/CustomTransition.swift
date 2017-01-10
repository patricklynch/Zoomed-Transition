//
//  CustomTransition.swift
//  ZoomTransition
//
//  Created by Patrick Lynch on 5/6/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import UIKit

protocol Transition {
    var animationDuration: TimeInterval { get }
    func performTransitionIn(_ model: TransitionModel, completion: @escaping (Bool)->())
    func performTransitionOut(_ model: TransitionModel, completion: @escaping (Bool)->())
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
        guard let toViewController = context.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromViewController = context.viewController(forKey: UITransitionContextViewControllerKey.from) else {
                abort()
        }
        
        self.toViewController = toViewController
        self.fromViewController = fromViewController
        
        let modal = toViewController.presentedViewController != nil || fromViewController.presentedViewController != nil
        if let fromNav = fromViewController.navigationController , !modal {
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
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transition.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let model = TransitionModel(
            context: transitionContext,
            transition: transition
        )
        
        let containerView = transitionContext.containerView
        
        if model.presenting {
            model.toViewController.view.frame = model.fromViewController.view.frame
            
            containerView.addSubview(model.fromViewController.view)
            containerView.addSubview(model.toViewController.view)
            
            transition.performTransitionIn(model) { completed in
                transitionContext.completeTransition( !transitionContext.transitionWasCancelled )
            }
            
        } else {
            model.fromViewController.view.frame = model.toViewController.view.frame
            
            containerView.addSubview(model.toViewController.view)
            containerView.addSubview(model.fromViewController.view)
            
            transition.performTransitionOut(model) { completed in
                transitionContext.completeTransition( !transitionContext.transitionWasCancelled )
            }
        }
    }
}

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    let animator: TransitionAnimator
    
    init(transition: Transition) {
        self.animator = TransitionAnimator(transition: transition)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
}
