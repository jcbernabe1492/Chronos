//
//  ArchiveWireframe.swift
//  Kronos
//
//  Created by Wee, David G. on 10/27/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import  UIKit

class ArchiveWireframe:NSObject
{
    var archiveViewController:ArchiveViewController?
    var isAnimating = false
    
    func createArchiveViewController() -> ArchiveViewController
    {
        archiveViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArchiveViewController") as? ArchiveViewController
        return archiveViewController!
    }
    
    
    class func showOnScreen(view:UIView)
    {
        UIApplication.shared.keyWindow?.addSubview(view)
        UIApplication.shared.keyWindow?.addConstraint(NSLayoutConstraint(item: UIApplication.shared.keyWindow!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        UIApplication.shared.keyWindow?.addConstraint(NSLayoutConstraint(item: UIApplication.shared.keyWindow!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        UIApplication.shared.keyWindow?.addConstraint(NSLayoutConstraint(item: UIApplication.shared.keyWindow!, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0.0))
        UIApplication.shared.keyWindow?.addConstraint(NSLayoutConstraint(item: UIApplication.shared.keyWindow!, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: 0.0))
    }
    
    func set(animating:Bool)
    {
        isAnimating = animating
    }
    

    
}
