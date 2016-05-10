//
//  ZoomTransition.swift
//  ZoomTransition
//
//  Created by Patrick Lynch on 5/9/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import UIKit

class ZoomTransition: Transition {
    
    let animationDuration: NSTimeInterval = 0.5
    
    func performTransitionIn(model: TransitionModel, completion: (Bool)->()) {
        let scale: CGFloat = 5.0
        let inverstionScale: CGFloat = 1.0 / scale
        
        model.toViewController.view.transform = CGAffineTransformMakeScale(inverstionScale, inverstionScale)
        model.toViewController.view.alpha = 0.0
        
        UIView.animateWithDuration(
            animationDuration,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.9,
            options: [],
            animations: {
                model.fromViewController.view.transform = CGAffineTransformMakeScale(scale, scale)
                
                model.toViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
                model.toViewController.view.alpha = 1.0
            },
            completion: completion
        )
    }
    
    func performTransitionOut(model: TransitionModel, completion: (Bool)->()) {
        let scale: CGFloat = 5.0
        let inverstionScale: CGFloat = 1.0 / scale
        
        model.toViewController.view.transform = CGAffineTransformMakeScale(scale, scale)
        
        UIView.animateWithDuration(
            animationDuration,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.9,
            options: [],
            animations: {
                model.fromViewController.view.transform = CGAffineTransformMakeScale(inverstionScale, inverstionScale)
                model.fromViewController.view.alpha = 0.0
                
                model.toViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            },
            completion: { finished in
                model.fromViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
                completion(finished)
            }
        )
    }
}
