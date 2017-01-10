//
//  ZoomTransition.swift
//  ZoomTransition
//
//  Created by Patrick Lynch on 5/9/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import UIKit

class ZoomTransition: Transition {
    
    let animationDuration: TimeInterval = 0.5
    
    func performTransitionIn(_ model: TransitionModel, completion: @escaping (Bool)->()) {
        let scale: CGFloat = 5.0
        let inverstionScale: CGFloat = 1.0 / scale
        
        model.toViewController.view.transform = CGAffineTransform(scaleX: inverstionScale, y: inverstionScale)
        model.toViewController.view.alpha = 0.0
        
        UIView.animate(
            withDuration: animationDuration,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.9,
            options: [],
            animations: {
                model.fromViewController.view.transform = CGAffineTransform(scaleX: scale, y: scale)
                
                model.toViewController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                model.toViewController.view.alpha = 1.0
            },
            completion: completion
        )
    }
    
    func performTransitionOut(_ model: TransitionModel, completion: @escaping (Bool)->()) {
        let scale: CGFloat = 5.0
        let inverstionScale: CGFloat = 1.0 / scale
        
        model.toViewController.view.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        UIView.animate(
            withDuration: animationDuration,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.9,
            options: [],
            animations: {
                model.fromViewController.view.transform = CGAffineTransform(scaleX: inverstionScale, y: inverstionScale)
                model.fromViewController.view.alpha = 0.0
                
                model.toViewController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            },
            completion: { finished in
                model.fromViewController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                completion(finished)
            }
        )
    }
}
