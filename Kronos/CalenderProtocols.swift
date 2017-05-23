//
//  CalenderProtocols.swift
//  Kronos
//
//  Created by Wee, David G. on 9/29/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation

let DaysOfTheWeekArray:Array<DaysOfTheWeek> = [.Sunday, .Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday]

protocol ChronoDay {
    var month:Int {get set}
    var day:Int {get set}
    var year:Int {get set}
    var parentCalendar:CalenderView!{ get set }
    init(day:Int, month:Int, year:Int, parent:CalenderView)
}

class Day:ChronoDay {
    var day:Int
    var month:Int
    var year:Int
    var parentCalendar:CalenderView!
    
    var type:DAY_TYPE  {
        if UserDefaults.standard.value(forKey: "\(month)/\(day)/\(year)") != nil
        {
            return DAY_TYPE(rawValue: UserDefaults.standard.value(forKey: "\(month)/\(day)/\(year)") as! Int)!
        }
        let date = Date(day: day, month:month, year: year)
        if date >= Date().simpleDate()
        {
            let daysOff = UserDefaults.standard.value(forKey: "calenderDays") as! NSArray
            let dayOfTheWeek = Date.getDayOfWeek(dateString: "\(year)/\(month)/\(day)")
            let dayString = DaysOfTheWeekArray[dayOfTheWeek-1].rawValue
            if daysOff.contains(dayString)
            {
                return .DAY_OFF
            }
            return .AVAILABLE
        }
        else
        {
            return .AVAILABLE
        }
        
    }
    required init(day:Int, month:Int, year:Int, parent:CalenderView) {
        self.day = day
        self.month = month
        self.year = year
        self.parentCalendar = parent
    }
    
    func equals(day:Day) -> Bool
    {
        if day.day == self.day && day.month == self.month && day.year == self.year {return true}
        return false
    }
}

protocol ChronoCalender{
    var year:Int? {get set}
    var days:Array<DayView> {get set}
    var currentMonth:Int? {get set}
}

protocol CalenderViewDelegate {
    func monthChanged(month:Int)
    func yearChanged(year:Int)
    func dayViewWasPressed(day:Day)
    func updateBottomLabels(amounts:(Int, (Int, Int), Double, Int))
}
