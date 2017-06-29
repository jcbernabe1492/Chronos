//
//  ArchiveUtils.swift
//  Kronos
//
//  Created by Wee, David G. on 10/27/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

class ArchiveUtils:NSObject
{
    
    
    class func getEarned(agency:NSNumber, archived:Bool) -> Double{
        var earned = 0.0
        let tasks = StageTask.getAllTasksFor(agency: agency)
        for t in tasks!{
            if t.archived || !archived  && !t.wasDeleted
            {
                let fee = FeeRates.getRateWithId(id: t.feeRate.intValue)
                let timer = JobTimer.getTimerWithTask(id: t.id.intValue)
                earned = earned + (timer?.timeSpent.doubleValue)!/60 * fee.getRatePerMinute()
            }
        }
        return earned
    }
    
    class func getEarned(project:NSNumber, archived:Bool) -> Double {
        var earned = 0.0
        let tasks:[StageTask]?
        if archived
        {
             tasks = StageTask.getAllArchivedTasksFor(project: project)
        }else
        {
            tasks = StageTask.getAllTasksFor(project: project)
        }
        for t in tasks!{
            let fee = FeeRates.getRateWithId(id: t.feeRate.intValue)
            let timer = JobTimer.getTimerWithTask(id: t.id.intValue)
            earned = earned + (timer?.timeSpent.doubleValue)!/60 * fee.getRatePerMinute()
        }
        return earned
    }
    
    class func getEarned(task:NSNumber) -> Double{
        
        let t = StageTask.getStageTask(forId: task.intValue)
        let fee = FeeRates.getRateWithId(id: (t?.feeRate.intValue)!)
        let timer = JobTimer.getTimerWithTask(id: (t?.id.intValue)!)
        let earned = (timer?.timeSpent.doubleValue)!/60 * fee.getRatePerMinute()
      
        return earned
    }
    
    
    
    class func getProjectWorked(agency:NSNumber, archived:Bool) -> Int{
        let tasks = StageTask.getAllTasksFor(agency: agency)
        var projectSet = Set<Int>()
        for t in tasks!{
            if t.archived || !archived
            {
                projectSet.insert(Int(t.projectId))
            }
        }
        return projectSet.count
    }
    
    class func getProjectWorked(task:NSNumber) -> Int{
        return 1
    }
    
    

    class func getDaysWorked(agency:NSNumber, archived:Bool) -> Int
    {
        let tasks = StageTask.getAllTasksFor(agency: agency)
        var CalendarDaySet = Set<Date>()
        for t in tasks!{
            if t.archived || !archived
            {
                let days = CalendarDay.getCalenderDaysWith(taskId: t.id.intValue)
                for d in days
                {
                    CalendarDaySet.insert((d.date as! Date).simpleDate())
                }
            }
        }
        return CalendarDaySet.count
    }
    
    
    
    class func getDaysWorked(project:NSNumber, archived:Bool) -> Int
    {
        let tasks:[StageTask]?
        if archived
        {
             tasks = StageTask.getAllArchivedTasksFor(project: project)
        }else
        {
            tasks = StageTask.getAllTasksFor(project: project)
        }
        var CalendarDaySet = Set<Date>()
        for t in tasks!{
            let days = CalendarDay.getCalenderDaysWith(taskId: t.id.intValue)
            for d in days
            {
                CalendarDaySet.insert((d.date as! Date).simpleDate())
            }
        }
        return CalendarDaySet.count
    }
    
    
    class func getDaysWorked(task:NSNumber) -> Int
    {
        var CalendarDaySet = Set<Date>()
        let t = StageTask.getStageTask(forId: task.intValue)
        let days = CalendarDay.getCalenderDaysWith(taskId: (t?.id.intValue)!)
        for d in days
        {
            CalendarDaySet.insert((d.date as! Date).simpleDate())
        }
        return CalendarDaySet.count
    }
    
    
    
    class func getHoursWorked(agency:NSNumber, archived:Bool) -> (Int, Int)
    {
        var hours = 0
        var minutes = 0
        let tasks = StageTask.getAllTasksFor(agency: agency)

        for t in tasks!{
            if t.archived || !archived && !t.wasDeleted
            {
                let totalTime = InvoiceUtils.getTotalTimeWorked(task: t)
                hours = hours + totalTime.0
                minutes = minutes + totalTime.1
            }
        }
        while minutes >= 60
        {
            minutes = minutes - 60
            hours = hours + 1
        }
        
        return (hours, minutes)
    }
    
    
    
    class func getHoursWorked(project:NSNumber, archived:Bool) -> (Int, Int)
    {
        var hours = 0
        var minutes = 0
        let tasks:[StageTask]?
        if archived{
             tasks = StageTask.getAllArchivedTasksFor(project: project)
        }else
        {
            tasks = StageTask.getAllTasksFor(project: project)
        }
        
        for t in tasks!{
            let totalTime = InvoiceUtils.getTotalTimeWorked(task: t)
            hours = hours + totalTime.0
            minutes = minutes + totalTime.1
        }
        
        return (hours, minutes)
    }
    
    class func getHoursWorked(task:NSNumber) -> (Int, Int)
    {
        let t = StageTask.getStageTask(forId: task.intValue)
        let totalTime = InvoiceUtils.getTotalTimeWorked(task: t!)
        let hours = totalTime.0
        let minutes =  totalTime.1
        
        return (hours, minutes)
    }
    
    
    
    
    class func getInvoicesStatus(proj:Int) -> (Int, Int, Int, Int)
    {
        let invoices = Invoice.getArchived()
        var cleared = 0
        var invoiced = 0
        var overdue = 0
        var critical = 0
        
        for i in invoices
        {
            let timer = JobTimer.getTimerWith(id: i.timerID.intValue)
            let task = StageTask.getStageTask(forId: (timer?.stageTaskId.intValue)!)
            let project = Project.getProject(forId: (task?.projectId.intValue)!)
            if project?.id.intValue == proj
            {
                if i.status == "INVOICED"
                {
                    invoiced = invoiced + 1
                }else if i.status == "CLEARED"
                {
                    cleared = cleared + 1
                }else if i.status == "OVERDUE"
                {
                    overdue = overdue + 1
                }
                else if i.status == "CRITICAL"
                {
                    critical = critical + 1
                }
            }
        }
        return (invoiced, overdue, critical, cleared)
    }
    class func getInvoicesStatus(agency:Int) -> (Int, Int, Int, Int)
    {
        let invoices = Invoice.getArchived()
        var cleared = 0
        var invoiced = 0
        var overdue = 0
        var critical = 0
        
        for i in invoices
        {
            let timer = JobTimer.getTimerWith(id: i.timerID.intValue)
            let task = StageTask.getStageTask(forId: (timer?.stageTaskId.intValue)!)
            let project = Project.getProject(forId: (task?.projectId.intValue)!)
            
            let a = Agency.getAgency(forId: agency)
            let compare : Int?
            if (a?.isAgency)! { compare = project?.agencyId.intValue }
            else{ compare = project?.clientId.intValue }
            
            if compare == agency
            {
                if i.status == "INVOICED"
                {
                    invoiced = invoiced + 1
                }else if i.status == "CLEARED"
                {
                    cleared = cleared + 1
                }else if i.status == "OVERDUE"
                {
                    overdue = overdue + 1
                }
                else if i.status == "CRITICAL"
                {
                    critical = critical + 1
                }
            }
        }
        return (invoiced, overdue, critical, cleared)
    }
    
    class func getInvoiceStatus(task:Int)  -> (Int, Int, Int, Int)
    {
        let invoices = Invoice.getArchived()
        var cleared = 0
        var invoiced = 0
        var overdue = 0
        var critical = 0
        
        for i in invoices
        {
            let timer = JobTimer.getTimerWith(id: i.timerID.intValue)
            let compareTask = StageTask.getStageTask(forId: (timer?.stageTaskId.intValue)!)
            
            if compareTask?.id.intValue == task
            {
                if i.status == "INVOICED"
                {
                    invoiced = invoiced + 1
                }else if i.status == "CLEARED"
                {
                    cleared = cleared + 1
                }else if i.status == "OVERDUE"
                {
                    overdue = overdue + 1
                }
                else if i.status == "CRITICAL"
                {
                    critical = critical + 1
                }
            }
        }
        return (invoiced, overdue, critical, cleared)
    }
    
    class func getAgencies(thisYear:Bool) -> Array<NSNumber>
    {
        var agencies = Set<NSNumber>()
        let tasks = StageTask.getAllArchived()
        for t in tasks!
        {
            if thisYear == true
            {
                 if !ArchiveUtils.didHaveWorkDayThisYear(task: t.id.intValue) { continue }
            }
            let project = Project.getProject(forId: t.projectId.intValue)
            if project?.agencyId != -1 {
                agencies.insert((project?.agencyId)!)
            }
        }
        
        return NSArray(array: Array(agencies)) as! Array<NSNumber>
    }
    
    class func getProjects(thisYear:Bool) -> (Array<NSNumber>, Array<NSNumber>)
    {
        let tasks = StageTask.getAllArchived()
        var projects = Array<NSNumber>()
        var agencies = Array<NSNumber>()
        for t in tasks!
        {
            if thisYear == true
            {
                if !ArchiveUtils.didHaveWorkDayThisYear(task: t.id.intValue) { continue }
            }
            let project = Project.getProject(forId: t.projectId.intValue)
            if !projects.contains((project?.id)!) && !agencies.contains((project?.agencyId)!)
            {
                projects.append((project?.id)!)
                agencies.append((project?.agencyId)!)
            }
        }
        return (projects, agencies)
    }
    
    
    class func getClients(thisYear:Bool) -> (Array<NSNumber>, Array<NSNumber>)
    {
        let tasks = StageTask.getAllArchived()
        var clients = Array<NSNumber>()
        var agencies = Array<NSNumber>()
        for t in tasks!
        {
            if thisYear == true
            {
                if !ArchiveUtils.didHaveWorkDayThisYear(task: t.id.intValue) { continue }
            }
            let project = Project.getProject(forId: t.projectId.intValue)
            let client = Agency.getClient(forId: (project?.clientId.intValue)!)
                if client != nil && project?.agencyId != nil {
                    if !clients.contains((client?.id)!) && !agencies.contains((project?.agencyId)!)
                    {
                        clients.append((client?.id)!)
                        agencies.append((project?.agencyId)!)
                    }
            }
        }
        return (clients, agencies)
    }
    
    class func getClientsWith(agency:Int, thisYear:Bool) -> Array<NSNumber>
    {
        let tasks = StageTask.getAllArhivedTasksFor(agency: agency)
        var clients = Set<NSNumber>()
        for t in tasks!
        {
            if thisYear == true
            {
                if !ArchiveUtils.didHaveWorkDayThisYear(task: t.id.intValue) { continue }
            }
            let project = Project.getProject(forId: t.projectId.intValue)
            let client = Agency.getClient(forId: (project?.clientId.intValue)!)
            clients.insert((client?.id)!)
        }
        return NSArray(array: Array(clients)) as! Array<NSNumber>
    }
    
   class func getProjectsWith(client:Int, thisYear:Bool) -> Array<NSNumber>
    {
        let tasks = StageTask.getAllArchived()
        var projects = Set<NSNumber>()
        for t in tasks!
        {
            if thisYear
            {
                 if !ArchiveUtils.didHaveWorkDayThisYear(task: t.id.intValue) { continue }
            }
            let project = Project.getProject(forId: t.projectId.intValue)
            if project?.clientId.intValue == client { projects.insert((project?.id)!) }
        }
        
        return Array(projects) 
    }
    
    class func getTaskswith(project:Int, thisYear:Bool) -> Array<NSNumber>
    {
        let tasks = StageTask.getAllArchived()
        var tasksArray = Set<NSNumber>()
        for t in tasks!
        {
            if thisYear
            {
                if !ArchiveUtils.didHaveWorkDayThisYear(task: t.id.intValue) { continue }
            }
            if t.projectId.intValue == project { tasksArray.insert(t.id) }
        }
        return Array(tasksArray)
    }
    
    class func getTasks(thisYear:Bool) -> Array<NSNumber>
    {
        let tasks = StageTask.getAllArchived()
        var tasksArray = Set<NSNumber>()
        for t in tasks!
        {
            if thisYear
            {
                if !ArchiveUtils.didHaveWorkDayThisYear(task: t.id.intValue) { continue }
            }
           tasksArray.insert(t.id)
        }
        return Array(tasksArray)
    }
    
    class func didHaveWorkDayThisYear(task:Int) -> Bool
    {
        let workDays = CalendarDay.getCalenderDaysWith(taskId: task)
        for days in workDays
        {
            if (days.date as! Date).getYear() == Date().getYear()
            {
                return true
            }
        }
        return false
    }
    
    class func getLastDayWorked(task:NSNumber) -> String
    {
        var CalendarDaySet = Set<Date>()
        let t = StageTask.getStageTask(forId: task.intValue)
        let days = CalendarDay.getCalenderDaysWith(taskId: (t?.id.intValue)!)
        for d in days
        {
            CalendarDaySet.insert((d.date as! Date).simpleDate())
        }
        
        let sorted = CalendarDaySet.sorted()
        return sorted.first!.simpleDateString()
    }
}
