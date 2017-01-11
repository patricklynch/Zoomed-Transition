//
//  ViewControllers.swift
//  ZoomTransition
//
//  Created by Patrick Lynch on 5/6/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import UIKit

class OriginViewController: UIViewController {
    
    let transitionDelegate = TransitionDelegate(transition: ZoomTransition())
    let vc = UIViewController.fromStoryboard("Main", identifier: "ZoomedViewController")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func onPresent() {
        vc.transitioningDelegate = self.transitionDelegate
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onPush() {
        vc.transitioningDelegate = self.transitionDelegate
        navigationController?.delegate = self.transitionDelegate
        navigationController?.pushViewController(vc, animated: true)
    }
}

class DestinationViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func onBack() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
