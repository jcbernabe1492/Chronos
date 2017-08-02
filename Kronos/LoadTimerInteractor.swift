//
//  LoadTimerInteractor.swift
//  Kronos
//
//  Created by Wee, David G. on 9/12/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation


class LoadTimerInteractor:NSObject, LoadTimerInteractorProtocol
{
    var presenter: LoadTimerPresenterProtocol?

    func getAllCurrentJobTimers() -> NSMutableArray {
        return DataController.sharedInstance.getAllCurrentJobTimers()
    }
    
    func getAllProjects() -> NSMutableArray
    {
        return DataController.sharedInstance.getAllProjects()
    }
    
    func getClientForId(id: Int) -> Agency? {
        return Agency.getClient(forId: id)
    }
    
    func getProjectForId(id: Int) -> Project {
        return Project.getProject(forId: id)!
    }
    
    func delete(jobs: NSMutableArray) {
        for project in jobs
        {
            if project is Project
            {
                let deleted = StageTask.deleteTasksWith(projectId: (project as! Project).id.intValue)
                var recents = (UserDefaults.standard.value(forKey: RECENT_TASKS) as! Array<Int>)
                for taskId in deleted
                {
                    if recents.contains(taskId)
                    {
                        recents.remove(at: recents.index(of: taskId)!)
                    }
                    
                }
                UserDefaults.standard.setValue(recents, forKey: RECENT_TASKS)
                Project.deleteProjectWith(id: (project as! Project).id.intValue)
           
            }
            else if project is StageTask
            {
                let timer = JobTimer.getTimerWithTask(id: Int((project as! StageTask).id))
                let timerID = timer?.id
                let task = StageTask.getStageTask(forId: Int((project as! StageTask).id))
                task?.wasDeleted = true
                
                /** 
                    Reset current job timer or the to be deleted timer current time, instead of deleting it completely.
                    To prevent repeating job id.
                 */
                if UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) != nil {
                    DataController.sharedInstance.updateCurrentJobTimer(timer: 0.00)
                }
                
                //DataController.sharedInstance.delete(obj: timer!)
                //try! DataController.sharedInstance.managedObjectContext.save()
                var recents = UserDefaults.standard.value(forKey: RECENT_TASKS) as! Array<Int>
                if recents.contains(timerID as! Int)
                {
                    recents.remove(at: recents.index(of: (project as! StageTask).id.intValue)!)
                }
                UserDefaults.standard.setValue(recents, forKey: RECENT_TASKS)
            }
            
            
        }
    }
    
    func getRecentTasks() -> NSMutableArray
    {
        let returnArray = NSMutableArray()
        let recents = (UserDefaults.standard.value(forKey: RECENT_TASKS) as! Array<Int>).reversed()
        for id in recents
        {
            let task = StageTask.getStageTask(forId: id)
            let timer = JobTimer.getTimerWithTask(id: task!.id.intValue)
            if !(task?.wasDeleted)! && !Invoice.timerHasBeenInvoiced(timer: timer!.id.intValue)
            {
                returnArray.add(task!)
            }
        }
        return returnArray
    }
    
    func getAllTasksForProject(id:Int) -> NSMutableArray
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
    
}
