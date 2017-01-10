//
//  Utils.swift
//  ZoomTransition
//
//  Created by Patrick Lynch on 5/9/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import UIKit

func dispatch_after( _ delay: TimeInterval, _ closure: @escaping () -> () ) {
    let time = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter( deadline: time, execute: closure)
}

extension UIViewController {
    static func fromStoryboard<T: UIViewController>( _ storyboardName: String? = nil, identifier: String? = nil) -> T {
        let storyboard = UIStoryboard(name: storyboardName ?? String(describing: self), bundle: nil )
        return storyboard.instantiateViewController( withIdentifier: identifier ?? String(describing: self) ) as! T
    }
    
    static func initialViewControllerFromStoryboard<T: UIViewController>( _ storyboardName: String? = nil ) -> T {
        let storyboard = UIStoryboard(name: storyboardName ?? String(describing: self), bundle: nil )
        return storyboard.instantiateInitialViewController() as! T
    }
}
