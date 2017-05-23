//
//  Timer+CoreDataProperties.swift
//  Kronos
//
//  Created by Wee, David G. on 9/7/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import CoreData

extension JobTimer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JobTimer> {
        return NSFetchRequest<JobTimer>(entityName: "JobTimer");
    }

    @NSManaged public var id: NSNumber
    @NSManaged public var stageTaskId: NSNumber
    @NSManaged public var timeSpent: NSNumber

    
    func encode() -> [String: Any?] {
        return [
            "stagetaskid": stageTaskId,
            "timespent": timeSpent
        ]
    }

    class func all() -> [JobTimer]? {
        let fetchRequest:NSFetchRequest<JobTimer> = JobTimer.fetchRequest()
        return try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
    }
    
    class func tempTimer() -> JobTimer
    {
        let entityDesc = NSEntityDescription.entity(forEntityName: "JobTimer", in: DataController.sharedInstance.managedObjectContext)
        let temp = JobTimer(entity: entityDesc!, insertInto: nil)
        return temp
    }
    
    class func getTimerWith(id:Int) -> JobTimer?
    {
        let fetchRequest:NSFetchRequest<JobTimer> = JobTimer.fetchRequest()
        fetchRequest.fetchLimit = 1
        let predicate = NSPredicate(format: "id == %@", NSNumber(value:id))
        fetchRequest.predicate = predicate
        let result = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        if result.count > 0
        {
            return result.first!
        }
        return nil
    }
    
    class func getTimerWithTask(id:Int) -> JobTimer?
    {
        let fetchRequest:NSFetchRequest<JobTimer> = JobTimer.fetchRequest()
        fetchRequest.fetchLimit = 1
        let predicate = NSPredicate(format: "stageTaskId == %@", NSNumber(value:id))
        fetchRequest.predicate = predicate
        let result = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        if result.count > 0
        {
            return result.first!
        }
        return nil
    }
    class func getNewTimerID() -> Int64
    {
        let fetchRequest:NSFetchRequest<JobTimer> = JobTimer.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let highest = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest).first
        if highest == nil
        {
            return 1
        }
        return Int((highest?.id)!) + 1
    }
    
    class func delete(id:Int)
    {
        let job = JobTimer.getTimerWith(id: id)
        DataController.sharedInstance.delete(obj: job!)
    }
    
    class func getAllJobs() -> Array<JobTimer>
    {
        let fetchRequest:NSFetchRequest<JobTimer> = JobTimer.fetchRequest()
        let result = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        return result

    }
    
    
}
