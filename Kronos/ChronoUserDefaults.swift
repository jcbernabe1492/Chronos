//
//  KronosUserDefaults.swift
//  Kronos
//
//  Created by Wee, David G. on 8/21/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

let activeImageArray = ["img-hours-active-1-hr", "img-hours-active-2-hr", "img-hours-active-3-hr", "img-hours-active-4-hr", "img-hours-active-5-hr", "img-hours-active-6-hr", "img-hours-active-7-hr", "img-hours-active-8-hr", "img-hours-active-8-hr", "img-hours-active-10-hr", "img-hours-active-11-hr", "img-hours-active-12-hr"]

let inactiveImageArray = ["img-hours-inactive-1-hr", "img-hours-inactive-2-hr", "img-hours-inactive-3-hr", "img-hours-inactive-4-hr", "img-hours-inactive-5-hr", "img-hours-inactive-6-hr", "img-hours-inactive-7-hr", "img-hours-inactive-8-hr", "img-hours-inactive-9-hr", "img-hours-inactive-10-hr", "img-hours-inactive-11-hr", "img-hours-inactive-12-hr"]



let FIRST_LAUNCH = "firstLaunch"
let TIMER_DAYS_BACKGROUND_COLOR = "timerDaysBackgroundColor"
let MINUTE_VIEW_UNFILLED_BACKGROUND_COLOR = "minuteViewUnfilledBackgroundColor"
let MINUTE_VIEW_FILLED_BACKGROUND_COLOR = "minuteViewfilledBackgroundColor"
let HOURS_VIEW_BACKGROUND_COLOR = "hoursViewBackgroundColor"
let HOURS_VIEW_BACKGROUND_FILLED_COLOR = "hoursViewBackgroundFilledColor"
let CURRENT_JOB_TIMER = "currentTimer"
let TIMER_IS_ON = "timerIson"
let RECENT_TASKS = "recentTasks"

enum INVOICE_PERSONAL:Int {
    case NAME = 0
    case EMAIL
    case PHONE
    case POSTCODE
    case ADDRESSLINE1
    case ADDRESSLINE2
    case CITY
    case COUNTRY
    case URL
}

enum INVOICE_ACCOUNT:Int {
    case ACCOUNT_NAME = 0
    case BANK_NAME
    case ACCOUNT_NO
    case IBAN_NO
    case SORT_CODE
    case SWIFT_CODE
}

enum DAY_TYPE : Int{
    case AVAILABLE = 0
    case DAY_OFF
    case HALF_DAY
    case FULL_DAY
}



class ChronoUserDefaults
{

    class func setupFistTimeValues()
    {
        UserDefaults.standard.setValue(false, forKey: FIRST_LAUNCH)
        UserDefaults.standard.setColor(UIColor.timerDaysBackgroundColorDefault(), forKey: TIMER_DAYS_BACKGROUND_COLOR)
        UserDefaults.standard.setColor(UIColor.minuteViewBackgroundFilled(), forKey: MINUTE_VIEW_FILLED_BACKGROUND_COLOR)
        UserDefaults.standard.setColor(UIColor.minuteViewBackgroundUnFilled(), forKey: MINUTE_VIEW_UNFILLED_BACKGROUND_COLOR)
        UserDefaults.standard.setColor(UIColor.hoursViewBackground(), forKey: HOURS_VIEW_BACKGROUND_COLOR)
        UserDefaults.standard.setColor(UIColor.color1(), forKey: "timerColor")
        
        
        //Default Settings
        UserDefaults.standard.setValue(true, forKey: "helpButtonVIsability")
        UserDefaults.standard.setValue(false, forKey: "simpleTimer")
        UserDefaults.standard.setValue("NO BACKUPS AVAILABLE", forKey: "lastBackupData")
        UserDefaults.standard.setValue(false, forKey: "passcodeOnOff")
        UserDefaults.standard.setValue("NO PASSCODE SET", forKey: "passcode")
        UserDefaults.standard.setValue("NO PASSCODE SET", forKey: "repeatPasscode")
        UserDefaults.standard.setValue("CHARCOAL", forKey: "timerDaysBackgroundColor")
        UserDefaults.standard.setValue(false, forKey: "timerMarkingsMins")
        UserDefaults.standard.setValue(false, forKey: "timerMarkingsHours")
        UserDefaults.standard.setValue("OFF", forKey: "timerNumberVisability")
        UserDefaults.standard.setValue(true, forKey: "autoStartTimer")
        UserDefaults.standard.setValue("SELECT NUMBER 1-24", forKey: "workHoursPerDay")
        UserDefaults.standard.setValue("4", forKey: "defaultDayRate")
        UserDefaults.standard.setValue([], forKey: "calenderDays")
        UserDefaults.standard.setValue("01", forKey: "invoiceToNearest")
        UserDefaults.standard.setValue(true, forKey: "includeThingsOnInvoice")
        UserDefaults.standard.setValue([], forKey: RECENT_TASKS)
        
        DataController.sharedInstance.addFeeRate(name: "15 MIN RATE", fee: nil, hours: 4, custom: false, interval: "minutes")
        DataController.sharedInstance.addFeeRate(name: "HOURLY RATE", fee: nil, hours: 1, custom: false, interval: "hours")
        DataController.sharedInstance.addFeeRate(name: "HALF DAY RATE", fee: nil, hours: nil, custom: false, interval: "hours")
        DataController.sharedInstance.addFeeRate(name: "DAY RATE", fee: nil, hours: 8, custom: false, interval: "hours")
        DataController.sharedInstance.addFeeRate(name: "WEEKLY RATE (5 DAYS)", fee: nil, hours: nil, custom: false, interval: "hours")
        DataController.sharedInstance.addFeeRate(name: "MONTHLY RATE", fee: nil, hours: nil, custom: false, interval: "hours")
        DataController.sharedInstance.addFeeRate(name: "QUARTERLY (65 DAYS)", fee: nil, hours: nil, custom: false, interval: "hours")
        DataController.sharedInstance.addFeeRate(name: "SIX MONTHS (131 DAYS)", fee: nil, hours: nil, custom: false, interval: "hours")
        DataController.sharedInstance.addFeeRate(name: "ANNUAL (261 DAYS)", fee: nil, hours: nil, custom: false, interval: "hours")
    }
    
    class func getInvoiceArray() -> NSMutableArray
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.appending("Invoices.plist")
        let array = NSMutableArray(contentsOfFile: path)
        return array!
    }
    
    
    class func getPersonalInvoiceValue(value:INVOICE_PERSONAL) -> String
    {
        let section = getInvoiceArray()[0] as! NSDictionary
        let cells = section["PERSONAL INFO"] as! NSArray
        let cell = cells[value.rawValue] as! NSDictionary
        return cell["SUBTITLE"] as! String
    }
    
    class func getBankInvoiceValue(value:INVOICE_ACCOUNT) -> String
    {
        let section = getInvoiceArray()[0] as! NSDictionary
        let cells = section["ACCOUNT DETAILS"] as! NSArray
        let cell = cells[value.rawValue] as! NSDictionary
        return cell["SUBTITLE"] as! String
    }
}

extension UserDefaults {
    
    func colorForKey(_ key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    
    func setColor(_ color: UIColor?, forKey key: String) {
        var colorData: Data?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        }
        set(colorData, forKey: key)
    }
}
