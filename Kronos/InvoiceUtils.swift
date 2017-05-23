//
//  ArchiveUtils.swift
//  Kronos
//
//  Created by Wee, David G. on 10/20/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation


class InvoiceUtils:NSObject
{
    class func getTotalForProject(projectId:Int) -> Double
    {
        let taskArray = InvoiceUtils.getAllTasksForProject(id: projectId)
        var totalMade:Double = 0.0
        
        for task in taskArray
        {
            if !(task as! StageTask).wasDeleted {
                let minPerRate = FeeRates.getRateWithId(id: (task as! StageTask).feeRate.intValue).getRatePerMinute()
                let taskIncome = (JobTimer.getTimerWithTask(id: (task as! StageTask).id.intValue)?.timeSpent.doubleValue)! / 60 * minPerRate
                totalMade = totalMade + taskIncome
            }
        }
        
        return totalMade
    }
    
    
    class func getAllTasksForProject(id:Int) -> NSMutableArray
    {
        let returnArray = NSMutableArray()
        let tasks = DataController.sharedInstance.getAllProjectTasks()
        for t in tasks
        {
            if (t as! StageTask).projectId.intValue == id
            {
                returnArray.add(t)
            }
        }
        return returnArray
    }
    
    class func getTotalTimeWorked(task:StageTask) -> (Int, Int)
    {
        let totalTime = ceil((JobTimer.getTimerWithTask(id: task.id.intValue)?.timeSpent.doubleValue)!)
        let hours:Int = Int(totalTime / 3600)
        let mins:Int = Int(totalTime.truncatingRemainder(dividingBy: 3600) / 60)
        return (hours, mins)
    }
    
    class func getTotalTimeWorked(project:Project) -> (Int, Int)
    {
        let tasks = InvoiceUtils.getAllTasksForProject(id: project.id.intValue)
        var final = (0,0)
        for task in tasks
        {
            let taskTime = InvoiceUtils.getTotalTimeWorked(task: task as! StageTask)
            final.0 = final.0 + taskTime.0
            final.1 = final.1 + taskTime.1
        }
        while final.1 >=  60
        {
            final.0 = final.0 + 1
            final.1 = final.1 - 60
        }
        return final
    }
    
    class func getNumberOfDaysWorked(task:StageTask) -> Double
    {
        let project = Project.getProject(forId: task.projectId.intValue)
        let dayLength = project?.dayLength
        let timer = JobTimer.getTimerWithTask(id: task.id.intValue)
        let timeWorked = timer?.timeSpent.doubleValue
        let timeInHours = timeWorked!/60.0/60.0
        return  timeInHours / dayLength!.doubleValue 
       
    }
    
    class func getNumberOfDaysWorked(project:Project) -> Double
    {
        let dayLength = project.dayLength.doubleValue
        let tasks = InvoiceUtils.getAllTasksForProject(id: project.id.intValue)
        var totalTime = 0.0
        for task in tasks
        {
            if !(task as! StageTask).wasDeleted
            {
                let timer = JobTimer.getTimerWithTask(id: (task as! StageTask).id.intValue)
                totalTime = totalTime + timer!.timeSpent.doubleValue
            }
        }
        totalTime = totalTime / 60.0 / 60.0
        return totalTime / dayLength
    }
    
    
    class func getDaysHoursMinutesFor(timer:JobTimer) -> (Int, Int, Int)
    {
        var dayHours = Int(UserDefaults.standard.value(forKey: "workHoursPerDay") as! String)
        if dayHours == nil{dayHours = 8}
        let totalTime = timer.timeSpent.doubleValue
        let minutes = Int((totalTime.truncatingRemainder(dividingBy: 3600)) / 60)
        let hours = Int((totalTime.truncatingRemainder(dividingBy: 3600*Double(dayHours!))) / 3600)
        let days = totalTime / (3600.0 * Double(dayHours!))
        return (Int(days),hours,minutes)
    }
    
}
