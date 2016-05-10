//
//  Utils.swift
//  ZoomTransition
//
//  Created by Patrick Lynch on 5/9/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import UIKit

func dispatch_after( delay: NSTimeInterval, _ closure: () -> () ) {
    let time = dispatch_time( DISPATCH_TIME_NOW,  Int64(delay * Double(NSEC_PER_SEC)) )
    dispatch_after( time, dispatch_get_main_queue(), closure)
}

extension UIViewController {
    static func fromStoryboard<T: UIViewController>( storyboardName: String? = nil, identifier: String? = nil) -> T {
        let storyboard = UIStoryboard(name: storyboardName ?? String(self), bundle: nil )
        return storyboard.instantiateViewControllerWithIdentifier( identifier ?? String(self) ) as! T
    }
    
    static func initialViewControllerFromStoryboard<T: UIViewController>( storyboardName: String? = nil ) -> T {
        let storyboard = UIStoryboard(name: storyboardName ?? String(self), bundle: nil )
        return storyboard.instantiateInitialViewController() as! T
    }
}
