//
//  HomeInteractor.swift
//  Kronos
//
//  Created by Wee, David G. on 8/15/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation

class HomeInteractor : NSObject, HomeInteractorInput
{
    weak var presenter: HomeInteractorOutput?


    func updateCalendarDay(stopping: Bool) {
        guard let currentTimerId = UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) as? NSNumber else {
            return
        }
        let currentTimer = JobTimer.getTimerWith(id: currentTimerId.intValue)
        let currentTaskId = currentTimer?.stageTaskId.intValue

        if let currentDay = isCalenderNew(taskId: currentTaskId!) {

            var tempTimeWorked: Double?
            
            if currentDay.timeStarted != nil {
                //currentDay.timeWorked = currentDay.timeWorked + Date().timeIntervalSince(currentDay.timeStarted as! Date)
                tempTimeWorked = currentDay.timeWorked + Date().timeIntervalSince(currentDay.timeStarted as! Date)
                if stopping {
                    currentDay.timeStarted = nil
                } else {
                    currentDay.timeStarted = NSDate()
                    tempTimeWorked = currentDay.timeWorked + Date().timeIntervalSince(NSDate() as Date)
                }
            }else {
                currentDay.timeStarted = NSDate()
                tempTimeWorked = currentDay.timeWorked + Date().timeIntervalSince(NSDate() as Date)
            }

            currentDay.timeWorked = tempTimeWorked!
            
        }
        else {
            if yesterday(task: currentTaskId!)?.timeStarted != nil {
                yesterday(task: currentTaskId!)!.timeWorked = yesterday(task: currentTaskId!)!.timeWorked + NSCalendar.current.startOfDay(for: Date()).timeIntervalSince(yesterday(task: currentTaskId!)!.timeStarted! as Date)
                let newDay = CalendarDay.createNewCalendarDay(date: NSDate(), withTask: currentTaskId!)
                newDay.timeWorked = Date().timeIntervalSince(NSCalendar.current.startOfDay(for: Date()))
                newDay.timeStarted = NSDate()
                if stopping {
                    newDay.timeStarted = nil
                }
                print(newDay.timeWorked)
            }
            else {
                let newDay = CalendarDay.createNewCalendarDay(date: NSDate(), withTask: currentTaskId!)
                newDay.timeStarted = NSDate()
            }
        }
        try! DataController.sharedInstance.managedObjectContext.save()

    }

    private func isCalenderNew(taskId: Int) -> CalendarDay? {
        return CalendarDay.exists(date: Date().simpleDate() as NSDate, taskId: taskId)
    }

    private func yesterday(task: Int) -> CalendarDay? {
        print(CalendarDay.getCalenderDay(date: Date.yesterday().simpleDate()))
        return CalendarDay.getCalenderDay(date: Date.yesterday().simpleDate())[task]
    }

    func getEarnedFor(agency:Agency) -> Double
    {
        var earned = 0.0
        let tasks = StageTask.getAllTasksFor(agency: agency.id)
        for t in tasks!{
            let fee = FeeRates.getRateWithId(id: t.feeRate.intValue)
            let timer = JobTimer.getTimerWithTask(id: t.id.intValue)
            earned = earned + (timer?.timeSpent.doubleValue)!/60 * fee.getRatePerMinute()
        }
        return earned
    }
    
    func getEarnedFor(project: Project) -> Double
    {
        var earned = 0.0
        let tasks = StageTask.getAllTasksFor(project: project.id)
        for t in tasks!{
            let fee = FeeRates.getRateWithId(id: t.feeRate.intValue)
            let timer = JobTimer.getTimerWithTask(id: t.id.intValue)
            earned = earned + (timer?.timeSpent.doubleValue)!/60 * fee.getRatePerMinute()
        }
        return earned
    }
    
    
}
