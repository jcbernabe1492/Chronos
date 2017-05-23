//
//  Screens.swift
//  Kronos
//
//  Created by Wee, David G. on 8/16/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

enum DEVICE {
    case iphone_6
    case iphone_6_PLUS
    case iphone_5
    case unknown
}

extension UIScreen
{
    class func device() -> DEVICE
    {
        if UIScreen.main.bounds.height == 568
        {
            return .iphone_5
        }
        else if UIScreen.main.bounds.height == 667
        {
            return .iphone_6
        }
        else if UIScreen.main.bounds.height == 736
        {
            return .iphone_6_PLUS
        }
        else
        {
            return .unknown
        }
    }
}

extension UIFont
{
    func boldFont() -> UIFont
    {
        if UIScreen.device() == .iphone_5
        {
            return UIFont(name: "NeoSans-Medium", size: 11)!
        }
        else
        {
            return UIFont(name: "NeoSans-Medium", size: 12)!
        }
    }
    
    func smallFont() -> UIFont
    {
        if UIScreen.device() == .iphone_5
        {
            return UIFont(name: "NeoSans-Medium", size: 8)!
        }
        else
        {
            return UIFont(name: "NeoSans-Medium", size: 7)!
        }
    }
    func smallerFont() -> UIFont
    {
        if UIScreen.device() == .iphone_5
        {
            return UIFont(name: "NeoSans-Medium", size: 8)!
        }
        else
        {
            return UIFont(name: "NeoSans-Medium", size: 5)!
        }
    }
    
    func headerFont() -> UIFont
    {
        if UIScreen.device() == .iphone_5
        {
            return UIFont(name: "NeoSans-Medium", size: 10)!
        }
        else
        {
            return UIFont(name: "NeoSans-Medium", size: 12)!
        }
    }
    
    func normalFont() -> UIFont
    {
        if UIScreen.device() == .iphone_5
        {
            return UIFont(name: "NeoSans", size: 11)!
        }
        else
        {
            return UIFont(name: "NeoSans", size: 12)!
        }
    }
}
