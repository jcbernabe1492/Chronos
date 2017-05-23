//
//  StageTask+CoreDataProperties.swift
//  Kronos
//
//  Created by Wee, David G. on 9/8/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import CoreData

extension StageTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StageTask> {
        return NSFetchRequest<StageTask>(entityName: "StageTask");
    }

    @NSManaged public var allocatedTaskTime : NSNumber
    @NSManaged public var projectId: NSNumber
    @NSManaged public var completed: Bool
    @NSManaged public var feeRate: NSNumber
    @NSManaged public var id: NSNumber
    @NSManaged public var order: NSNumber
    @NSManaged public var name: String?
    @NSManaged public var startDate:NSDate
    @NSManaged public var reference:String
    @NSManaged public var wasDeleted:Bool
    @NSManaged public var archived:Bool


    func encode() -> [String: Any?] {
        return [
            "allocatedtasktime": allocatedTaskTime,
            "projectid": projectId,
            "completed": completed,
            "feerate": feeRate,
            "order": order,
            "name": name,
            "startdate": startDate.toString(),
            "reference": reference,
            "wasdeleted": wasDeleted,
            "archived": archived
        ]
    }

//    class func decode(data: [[String: Any]]) {
//        for t in data{
//
//            let task:CalendarDay = NSEntityDescription.insertNewObject(forEntityName: "CalendarDay", into: DataController.sharedInstance.managedObjectContext) as! CalendarDay
//    }


    class func all() -> [StageTask]? {
        let fetchRequest:NSFetchRequest<StageTask> = StageTask.fetchRequest()
        return try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
    }


    class func tempStageTask() -> StageTask
    {
        let entityDesc = NSEntityDescription.entity(forEntityName: "StageTask", in: DataController.sharedInstance.managedObjectContext)
        return StageTask(entity: entityDesc!, insertInto: nil)
    }
    
    class func getNextStageTaskId() -> Int
    {
        let fetchRequest:NSFetchRequest<StageTask> = StageTask.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let highest = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest).first
        if highest == nil
        {
            return 1
        }
        return Int((highest?.id)!) + 1
    }
    
    class func getStageTask(forId id:Int) -> StageTask?
    {
        let fetchRequest:NSFetchRequest<StageTask> = StageTask.fetchRequest()
        fetchRequest.fetchLimit = 1
        let predicate = NSPredicate(format: "id == %@", NSNumber(value:id))
        fetchRequest.predicate = predicate
        let result = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        if result.count == 0
        {
            return nil
        }
        return result.first!
    }
    
    class func getAllStageTasksInPastYear() -> [StageTask]?
    {
        let fetchRequest:NSFetchRequest<StageTask> = StageTask.fetchRequest()
        let result = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        let predicate = NSPredicate(format: "archived == %@", NSNumber(value: true))
        fetchRequest.predicate = predicate
        var returnArray = Array<StageTask>()
        for task in result
        {
            let days = CalendarDay.getCalenderDaysWith(taskId: task.id.intValue)
            for day in days{
                if (day.date as! Date).getYear() == Date().getYear()
                {
                    returnArray.append(task)
                }
            }
        }
        return returnArray
    }
    
    class func getAllTasks() -> [StageTask]?
    {
        let fetchRequest:NSFetchRequest<StageTask> = StageTask.fetchRequest()
        return  try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
    }
    
    
    class func deleteTaskWith(id:Int)
    {
        let fetchRequest:NSFetchRequest<StageTask> = StageTask.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", NSNumber(value:id))
        fetchRequest.predicate = predicate
        let result = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        for task in result
        {
            DataController.sharedInstance.delete(obj: task)
        }
    }
    
    class func getAllTasksFor(agency:NSNumber) -> [StageTask]?
    {
        let tasks = self.getAllTasks()
        var returnArray = Array<StageTask>()
        for t in tasks!{
            let project = Project.getProject(forId: t.projectId.intValue)
            
            let a = Agency.getAgency(forId: agency.intValue)
            let compare : Int?
            if (a?.isAgency)! { compare = project?.agencyId.intValue }
            else{ compare = project?.clientId.intValue }
            
            if compare == agency.intValue
            {
                returnArray.append(t)
            }
        }
        return returnArray
    }
    
    class func getAllArchivedTasksFor(project:NSNumber) -> [StageTask]?
    {
        let tasks = self.getAllTasks()
        var returnArray = Array<StageTask>()
        for t in tasks!{
            if t.projectId == project
            {
                if t.archived == true
                {
                    returnArray.append(t)
                }
            }
        }
        return returnArray
    }
    
    
    class func getAllTasksFor(project:NSNumber) -> [StageTask]?
    {
        let tasks = self.getAllTasks()
        var returnArray = Array<StageTask>()
        for t in tasks!{
            if t.projectId == project
            {
                if t.archived == false && t.wasDeleted == false
                {
                    returnArray.append(t)
                }
            }
        }
        return returnArray
    }
    
    
    class func getAllArhivedTasksFor(agency:Int) -> [StageTask]?
    {
        let tasks = self.getAllTasks()
        var returnArray = Array<StageTask>()
        for t in tasks!{
            let project = Project.getProject(forId: t.projectId.intValue)
            if project?.agencyId.intValue == agency && t.archived == true
            {
                returnArray.append(t)
            }
        }
        return returnArray
    }
    

    
    class func getAllArchived() -> [StageTask]?
    {
        let fetchRequest:NSFetchRequest<StageTask> = StageTask.fetchRequest()
        let predicate = NSPredicate(format: "archived == %@", NSNumber(value: true))
        fetchRequest.predicate = predicate
        return try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
       
    }
    
    class func deleteTasksWith(projectId:Int) -> [Int]
    {
        let fetchRequest:NSFetchRequest<StageTask> = StageTask.fetchRequest()
        
        let predicate = NSPredicate(format: "projectId == %@", NSNumber(value:projectId))
        fetchRequest.predicate = predicate
        let result = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        var deleted = Array<Int>()
        for task in result
        {
            deleted.append(task.id.intValue)
            task.wasDeleted = true
        }
        
        return deleted
    }
    
    
    class func getUniqueTaskNames() -> Set<String>
    {
        let fetchRequest:NSFetchRequest<StageTask> = StageTask.fetchRequest()
        let result = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        var returnSet = Set<String>()
        for task in result
        {
            returnSet.insert(task.name!)
        }
        return returnSet
    }
    
}
