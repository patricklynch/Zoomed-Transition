//
//  ViewController.swift
//  ZoomTransition
//
//  Created by Patrick Lynch on 5/6/16.
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
            animations: {
                model.fromViewController.view.transform = CGAffineTransformMakeScale(scale, scale)
                
                model.toViewController.view.alpha = 1.0
                model.toViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            },
            completion: completion
        )
    }
    
    func performTransitionOut(model: TransitionModel, completion: (Bool)->()) {
        let scale: CGFloat = 5.0
        let inverstionScale: CGFloat = 1.0 / scale
        
        model.toViewController.view.transform = CGAffineTransformMakeScale(inverstionScale, inverstionScale)
        model.toViewController.view.alpha = 0.0
        
        UIView.animateWithDuration(
            animationDuration,
            animations: {
                model.fromViewController.view.transform = CGAffineTransformMakeScale(scale, scale)
                
                model.toViewController.view.alpha = 1.0
                model.toViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            },
            completion: completion
        )
    }
}

class ViewController: UIViewController {
    
    let transitionDelegate = TransitionDelegate(transition: ZoomTransition())
    let vc = UIViewController()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func onTransition() {
        vc.view.backgroundColor = UIColor.redColor()
        vc.transitioningDelegate = self.transitionDelegate
        presentViewController(vc, animated: true, completion: nil)
        
        dispatch_after(4.0) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

func dispatch_after( delay: NSTimeInterval, _ closure: () -> () ) {
    let time = dispatch_time( DISPATCH_TIME_NOW,  Int64(delay * Double(NSEC_PER_SEC)) )
    dispatch_after( time, dispatch_get_main_queue(), closure)
}
