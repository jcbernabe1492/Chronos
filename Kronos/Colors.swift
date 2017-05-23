//
//  Colors.swift
//  Kronos
//
//  Created by Wee, David G. on 8/16/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit


extension UIColor
{
    class func topBarGrayColor() -> UIColor
    {
        return UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    }
    
    class func homeScreenBackground() -> UIColor
    {
        return UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
    }
    
    
    //Timer Colors
    class func timerBackgroundColor() -> UIColor
    {
        return UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
    }
    
    class func timerDaysBackgroundColorDefault() -> UIColor
    {
        return UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1.0)
    }
    
    class func minuteViewBackgroundUnFilled() -> UIColor
    {
        return UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
    }
    
    class func minuteViewBackgroundFilled() -> UIColor
    {
        return UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    }
    class func hoursViewBackground() -> UIColor
    {
        return UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
    }
    
    class func unfilledAllocatedDayCircle() -> UIColor
    {
        return UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0)
    }
    class func unfilledUnAllocatedDayCircle() -> UIColor
    {
        return UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1.0)
    }
    class func hoursPassedYellow() -> UIColor
    {
        return UIColor(red: 255/255, green: 231/255, blue: 22/255, alpha: 1.0)
    }
    
    //Settings Color
    class func tabSelectedYellow() -> UIColor
    {
        return UIColor(red: 255/255, green: 228/255, blue: 17/255, alpha: 1.0)
    }
    class func cellBackgroundColor() -> UIColor
    {
        return UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
    }
    //Colors for ColorPicker
    class func color1() -> UIColor
    {
        return UIColor(red: 255/255, green: 228/255, blue: 17/255, alpha: 1.0)
    }
    class func color2() -> UIColor
    {
        return UIColor(red: 247/255, green: 146/255, blue: 30/255, alpha: 1.0)
    }
    class func color3() -> UIColor
    {
        return UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
    }
    class func color4() -> UIColor
    {
        return UIColor(red: 234/255, green: 67/255, blue: 152/255, alpha: 1.0)
    }
    class func color5() -> UIColor
    {
        return UIColor(red: 173/255, green: 32/255, blue: 141/255, alpha: 1.0)
    }
    class func color6() -> UIColor
    {
        return UIColor(red: 73/255, green: 23/255, blue: 109/255, alpha: 1.0)
    }
    class func color7() -> UIColor
    {
        return UIColor(red: 0/255, green: 112/255, blue: 187/255, alpha: 1.0)
    }
    class func color8() -> UIColor
    {
        return UIColor(red: 65/255, green: 195/255, blue: 220/255, alpha: 1.0)
    }
    class func color9() -> UIColor
    {
        return UIColor(red: 0/255, green: 171/255, blue: 161/255, alpha: 1.0)
    }
    class func color10() -> UIColor
    {
        return UIColor(red: 84/255, green: 184/255, blue: 71/255, alpha: 1.0)
    }
    class func colorPickerArray() -> Array<UIColor>
    {
        return [color1(), color2(), color3(), color4(), color5(), color6(), color7(), color8(), color9(), color10()]
    }
    
    class func tableHeaderColor() -> UIColor
    {
        return UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
    }
    
    class func invoicedColor() -> UIColor
    {
        return UIColor(red: 64/255, green: 195/255, blue: 220/255, alpha: 1.0)
    }
    
    class func invoicedOverdueColor() -> UIColor
    {
        return UIColor(red: 246/255, green: 146/255, blue: 30/255, alpha: 1.0)
    }
    class func invoicedCriticalColor() -> UIColor
    {
        return UIColor(red: 240/255, green: 80/255, blue: 50/255, alpha: 1.0)
    }
    class func invoicedClearedColor() -> UIColor
    {
        return UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1.0)
    }
}
