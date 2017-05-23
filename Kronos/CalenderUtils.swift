//
//  CalenderUtils.swift
//  Kronos
//
//  Created by Wee, David G. on 9/29/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation


class CalenderUtils:NSObject
{
    
    
    class func getTimeWorked(day:Day) -> Dictionary<Int, Double>{
        var returnDict = Dictionary<Int, Double>()
        let date = Date(day: day.day, month: day.month, year: day.year)
        let calendarDays = CalendarDay.getCalenderDay(date: date)
        for days in calendarDays
        {
            let task = StageTask.getStageTask(forId: days.taskId.intValue)
            if !(task?.wasDeleted)! {
                returnDict[days.taskId.intValue] = days.timeWorked
            }
        }
        return returnDict
    }
    
    class func getDataFor(month:Int, year:Int) -> (Int, (Int, Int), Double, Int)
    {
        let calendarDays = CalendarDay.getCalenderDaysFor(month: month, year: year)
        
        let totalTimeWorked = CalenderUtils.getTotalTimeWorked(days: calendarDays)
        
        var taskArray = Set<Int>()
        for day in calendarDays
        {
            taskArray.insert(day.taskId.intValue)
        }
        let numberOfProjects = CalenderUtils.getNumberOfProjectsFor(taskIds: taskArray)
        let totalEarned = CalenderUtils.getTotalEarnedFor(days: calendarDays)
        var daySet = Set<Date>()
        for c in calendarDays
        {
            daySet.insert(c.date as! Date)
        }
        return (numberOfProjects,totalTimeWorked,totalEarned,daySet.count)
    }
    
    class func getTotalTimeWorked(days:Array<CalendarDay>) -> (Int, Int)
    {
        var totalTime = 0.0
        for day in days
        {
            totalTime = totalTime + day.timeWorked
        }
        if days.count > 0
        {
            let date = Date(day: 1, month: (days[0].date as! Date).getMonth(), year: (days[0].date as! Date).getYear())
            let numberOfDaysInMonth = Date.getNumberOfDays(month: date.getMonth(), year: date.getYear())
            let hours = Int(totalTime.truncatingRemainder(dividingBy: 86400) / 3600)
            let days = Int(totalTime.truncatingRemainder(dividingBy: (86400 * Double(numberOfDaysInMonth))) / 86400)

            return (days, hours)
        }
        return (0,0)
    }
    
    class func getNumberOfProjectsFor(taskIds:Set<Int>) -> Int
    {
        var projectArray = Set<Int>()
        for task in taskIds
        {
            let project = Project.getProject(forId: (StageTask.getStageTask(forId: task)?.id.intValue)!)
            if project != nil
            {
                projectArray.insert((project?.id.intValue)!)
            }
        }
        return projectArray.count
    }
    
    class func getTotalEarnedFor(days:Array<CalendarDay>) -> Double
    {
        var totalEarned = 0.0
        for day in days
        {
            let task = StageTask.getStageTask(forId: day.taskId.intValue)
            let fee = FeeRates.getRateWithId(id: (task?.feeRate.intValue)!)
            
            var ratePerMinute = fee.getRatePerMinute()

            totalEarned = totalEarned + (day.timeWorked/60.0)*ratePerMinute
        }
        return totalEarned
    }
    
    

}
