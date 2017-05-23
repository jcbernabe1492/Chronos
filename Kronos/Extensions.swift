//
//  Extensions.swift
//  Kronos
//
//  Created by Wee, David G. on 8/22/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit


enum DaysOfTheWeek:String{
    case Monday = "MON"
    case Tuesday = "TUES"
    case Wednesday = "WED"
    case Thursday = "THUR"
    case Friday = "FRI"
    case Saturday = "SAT"
    case Sunday = "SUN"
}


struct Months{
    let monthArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
}





extension Int {
    var degreesToRadians: Double { return Double(self) * M_PI / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / M_PI }
}
extension Double
{
    var degreesToRadians: Double { return Double(self) * M_PI / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / M_PI }
}



extension Array
{
    mutating func removeAndShift(value:Element)
    {
        
        for i in 0...self.count-2
        {
            self[i] = self[i+1]
        }
        self.remove(at: self.count-1)
        self.insert(value, at: self.count)
    }
    
    mutating func removeValue(value:Element)
    {
        for i in 0...self.count - 1
        {
            if (self[i] as! Int) == (value as! Int)
            {
                self.remove(at: i)
                break
            }
        }
    }
}
extension UIView
{
    func constraintWithName(identifier:String) -> NSLayoutConstraint?
    {
        for c in self.constraints
        {
            if c.identifier == identifier
            {
                return c
            }
        }
        return nil
    }
    
    func removeConstraint(identifier:String)
    {
        for c in self.constraints
        {
            if c.identifier == identifier
            {
                self.removeConstraint(c)
            }
        }
      
    }
}

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: false)
    }
}


extension UIScreen
{
    func isiPhone6() -> Bool
    {
         if UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height == 667.0{
            return true
        }
        return false
    }
    
    func isiPhone6Plus() -> Bool{
        if UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height > 668
        {
            return true
        }
        return false
    }
    
    func isIphone5() -> Bool
    {
        if isiPhone6Plus() { return false }
        if isiPhone6() { return false }
        return true
    }
    
    func showActivity() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.tag = 999
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activity)
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: activity, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: activity, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        activity.startAnimating()
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    func hideActivity() {
        UIApplication.shared.keyWindow?.subviews.last?.removeFromSuperview()
    }
}

extension UILabel
{
    convenience init(medium:Bool)
    {
        self.init()
        if medium
        {
            self.font = UIFont(name: "NeoSans-Medium", size: 12)
        }
        else
        {
            self.font = UIFont(name: "NeoSans", size: 12)
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


extension UIButton
{
    convenience init(medium:Bool)
    {
        self.init()
        if medium
        {
            self.titleLabel?.font = UIFont().boldFont()
        }
        else
        {
            self.titleLabel?.font = UIFont().normalFont()
        }
    }
}

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafePointer(to: &i) {
            $0.withMemoryRebound(to: T.self, capacity: 1) { $0.pointee }
        }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}

protocol Animatable
{
    var isAnimating:Bool? {get set}
}

extension UIViewController:Animatable
{
    private struct Animating
    {
        static var isAnimating:Bool?
    }
    internal var isAnimating: Bool? {
        get {
             return Animating.isAnimating
        }
        set {
            Animating.isAnimating = newValue
        }
    }
}


extension NSDate {
    func toString () -> String {
        let formetter = DateFormatter()
        formetter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formetter.string(from: self as Date)
    }
}

extension String {
    func toDate() -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return  dateFormatter.date(from: self)!
    }
}


