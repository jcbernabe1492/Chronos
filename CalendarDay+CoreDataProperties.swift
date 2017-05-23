//
//  CalendarDay+CoreDataProperties.swift
//  Kronos
//
//  Created by Wee, David G. on 9/27/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import CoreData


extension CalendarDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CalendarDay> {
        return NSFetchRequest<CalendarDay>(entityName: "CalendarDay");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var taskId: NSNumber
    @NSManaged public var timeWorked: Double
    @NSManaged public var timeStarted: NSDate?
    @NSManaged public var timeStopped: NSDate?

    
    func encode() -> [String: Any?] {
        return [
            "date": date?.toString(),
            "taskid": taskId,
            "timeworked": timeWorked,
            "timestarted": timeStarted?.toString(),
            "timestopped": timeStopped?.toString()
        ]
    }

    func decode(data: [[String: Any]]) {
        for d in data{
            let day:CalendarDay = NSEntityDescription.insertNewObject(forEntityName: "CalendarDay", into: DataController.sharedInstance.managedObjectContext) as! CalendarDay
            day.date = (d["date"] as! String).toDate() as NSDate?
            let value = UserDefaults.standard.value(forKey: "download_count") as! Int * 100
            day.taskId = NSNumber(value: (d["taskid"] as! Int) + value)
        }
    }

    class func all() -> [CalendarDay]? {
        let fetchRequest:NSFetchRequest<CalendarDay> = CalendarDay.fetchRequest()
        return try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
    }


    class func exists(date:NSDate, taskId:Int) -> CalendarDay?
    {
        let fetchRequest:NSFetchRequest<CalendarDay> = CalendarDay.fetchRequest()
        fetchRequest.fetchLimit = 1
        let predicate = NSPredicate(format: "(taskId == %@) && (date == %@)", NSNumber(value: taskId), date)
        fetchRequest.predicate = predicate
        let exists = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest).first
        if exists == nil
        {
            return nil
        }
        return exists
    }
    
    class func createNewCalendarDay(date:NSDate, withTask task:Int) -> CalendarDay
    {
        let entityDesc = NSEntityDescription.entity(forEntityName: "CalendarDay", in: DataController.sharedInstance.managedObjectContext)
        let calendar = CalendarDay(entity: entityDesc!, insertInto: DataController.sharedInstance.managedObjectContext)
        calendar.date = Date().simpleDate() as NSDate
        calendar.taskId = NSNumber(value: task)
        return calendar
    }
    
    class func getCalenderDay(date:Date) -> [CalendarDay]
    {
        let fetchRequest:NSFetchRequest<CalendarDay> = CalendarDay.fetchRequest()
        let predicate = NSPredicate(format: "date == %@",  date as NSDate)
        fetchRequest.predicate = predicate
        let array = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        return array
    }
    
    class func getCalenderDaysFor(month:Int, year:Int) -> [CalendarDay]
    {
        let fetchRequest:NSFetchRequest<CalendarDay> = CalendarDay.fetchRequest()
        var returnArray = Array<CalendarDay>()
        let days = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        for day in days
        {
            if (day.date as! Date).getMonth() == month &&  (day.date as! Date).getYear() == year
            {
                returnArray.append(day)
            }
        }
        return returnArray
    }
    
    class func getCalenderDaysWith(taskId:Int) -> [CalendarDay]
    {
        let fetchRequest:NSFetchRequest<CalendarDay> = CalendarDay.fetchRequest()
        let predicate = NSPredicate(format: "taskId == %@",  NSNumber(value: taskId))
        fetchRequest.predicate = predicate
        let array = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        return array
    }

}

extension Array where Element: CalendarDay {
    subscript(taskId:Int ) -> CalendarDay? {
        for cal in self {
            if (cal as CalendarDay).taskId.intValue == taskId {
                return cal as CalendarDay
            }
        }
        return nil
    }
}
extension Date
{
    
    init(day:Int, month:Int, year:Int)
    {
        let calender = Calendar(identifier: .gregorian)
        var simpleDateCompnents = DateComponents()
        
        simpleDateCompnents.calendar = calender
        simpleDateCompnents.month = month
        simpleDateCompnents.day = day
        simpleDateCompnents.year = year
        
        self = calender.date(from: simpleDateCompnents)!
    }
    
    func simpleDateString() -> String
    {
        let date = self.simpleDate()
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    func simpleDate() -> Date
    {
        let calender = Calendar(identifier: .gregorian)
        let dateComponents = calender.dateComponents([.year, .day, .month], from: self)
        var simpleDateCompnents = DateComponents()
        
        simpleDateCompnents.calendar = calender
        simpleDateCompnents.month = dateComponents.month!
        simpleDateCompnents.day = dateComponents.day!
        simpleDateCompnents.year = dateComponents.year!
        
        return calender.date(from: simpleDateCompnents)!
    }
    
    func getMonth() -> Int
    {
        let calender = Calendar(identifier: .gregorian)
        let dateComponents = calender.dateComponents([.year, .day, .month], from: self)
        return dateComponents.month!
    }
    
    func getYear() -> Int
    {
        let calender = Calendar(identifier: .gregorian)
        let dateComponents = calender.dateComponents([.year, .day, .month], from: self)
        return dateComponents.year!
    }
    
    func getDay() -> Int
    {
        let calender = Calendar(identifier: .gregorian)
        let dateComponents = calender.dateComponents([.year, .day, .month], from: self)
        return dateComponents.day!
    }
    func isToday() -> Bool
    {
        let today = Date()
        if today.getDay() == self.getDay() && today.getMonth() == self.getMonth() && today.getYear() == self.getYear()
        {
            return true
        }
        return false
    }
    
    static func getDayOfWeek(dateString:String)->Int {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: dateString)
        let myCalendar = NSCalendar(identifier: .gregorian)!
        if todayDate == nil
        {
            return 1
        }
        let weekday = myCalendar.component(.weekday, from: todayDate!)
        return weekday
    }
    
    
    static func getNumberOfDays(month:Int, year:Int) -> Int
    {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return  range.count
    }

    static func yesterday() -> Date {
        return  Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
}


