
//
//  DataController.swift
//  Kronos
//
//  Created by Wee, David G. on 9/7/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit
import CoreData


class DataController:NSObject
{
    var managedObjectContext:NSManagedObjectContext

    
    static var sharedInstance = DataController()
    
    
    override init()
    {
        guard let modelURL = Bundle.main.url(forResource: "ChronosDataModal", withExtension: "momd") else{
            fatalError("Error loading model from bundle")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else
        {
            fatalError("Error initilizing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        
        
        let storeURL = docURL.appendingPathComponent("ChronosDataModal.sqlite")
        do{
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: [NSMigratePersistentStoresAutomaticallyOption:true, NSInferMappingModelAutomaticallyOption:true])
        }catch
        {
            fatalError("error migrating store: \(error)")
        }
    }
    
    
    func addStageTask(tempStageTask:StageTask)
    {
        let newStageTask:StageTask = NSEntityDescription.insertNewObject(forEntityName: "StageTask", into: managedObjectContext) as! StageTask
        newStageTask.name = tempStageTask.name
        newStageTask.id = tempStageTask.id
        newStageTask.order = tempStageTask.order
        newStageTask.allocatedTaskTime = tempStageTask.allocatedTaskTime
        newStageTask.completed = false
        newStageTask.projectId = tempStageTask.projectId
        newStageTask.startDate = NSDate()
        newStageTask.feeRate = tempStageTask.feeRate
        do
        {
            try managedObjectContext.save()
        }
        catch
        {
            print("error saving task")
        }
    }
    
    func addProject(tempProject:Project)
    {
        let newProject:Project = NSEntityDescription.insertNewObject(forEntityName: "Project", into: managedObjectContext) as! Project
        newProject.name = tempProject.name
        newProject.id = tempProject.id
        newProject.agencyId = tempProject.agencyId
        newProject.clientId = tempProject.clientId
        newProject.archived = false
        newProject.allocatedProjectTime = tempProject.allocatedProjectTime
        newProject.dayLength = tempProject.dayLength
        do
        {
            try managedObjectContext.save()
        }
        catch
        {
            print("error saving project")
        }
    }
    
    func addJobTimer(tempTimer:JobTimer)
    {
        let newJobTimer:JobTimer = NSEntityDescription.insertNewObject(forEntityName: "JobTimer", into: managedObjectContext) as! JobTimer
        newJobTimer.stageTaskId = tempTimer.stageTaskId
        newJobTimer.timeSpent = 0.0
        newJobTimer.id = tempTimer.id
        do
        {
            try managedObjectContext.save()
        }
        catch
        {
            print("error saving timer")
        }
    }
    
    func addFeeRate(name:String, fee:Double?, hours:Int?, custom:Bool, interval:String)
    {
        let newRate = NSEntityDescription.insertNewObject(forEntityName: "FeeRates", into: managedObjectContext) as! FeeRates
        newRate.id = FeeRates.getNextFeeRate()
        newRate.name = name
        newRate.timeInterval = interval
        if fee != nil
        {
            newRate.fee = NSNumber(value: fee!)
        }
        if hours != nil
        {
            newRate.hours = NSNumber(value: hours!)
        }
        newRate.custom = custom
        try! managedObjectContext.save()
    }
    
    func addAgency(tempAgency:Agency, isAgency:Bool) -> Bool
    {
        if verifyIfAgencyNameExists(name: tempAgency.name!) {
            return false
        }
        
        let newAgency:Agency = NSEntityDescription.insertNewObject(forEntityName: "Agency", into: managedObjectContext) as! Agency
        newAgency.address1 = tempAgency.address1
        newAgency.address2 = tempAgency.address2
        newAgency.contact = tempAgency.contact
        newAgency.email = tempAgency.email
        newAgency.location = tempAgency.location
        newAgency.name = tempAgency.name
        newAgency.phone = tempAgency.phone
        newAgency.postcode = tempAgency.postcode
        newAgency.isAgency = isAgency
        newAgency.id = tempAgency.id
        do
        {
            try managedObjectContext.save()
        }
        catch
        {
            print("error saving agency")
        }
        
        return true
        
    }
    
    func getAllClients() -> NSMutableArray
    {
        return getAgency(agency: false)
    }
    
    func getAllAgencies() -> NSMutableArray
    {
        return getAgency(agency: true)
    }

    func getAgency(agency:Bool) -> NSMutableArray
    {
        var fetchedObjects:Array<Agency>
        let context = managedObjectContext
        let fetch:NSFetchRequest<Agency> = Agency.fetchRequest()
        let entityDescription = NSEntityDescription.entity(forEntityName: "Agency", in: context)
        fetch.entity = entityDescription
        var predicate:NSPredicate?
        if agency
        {
            predicate = NSPredicate(format: "isAgency == true")
        }
        else
        {
            predicate = NSPredicate(format: "isAgency == false")
        }
        fetch.predicate = predicate
        fetchedObjects = try! context.fetch(fetch)
        if !fetchedObjects.isEmpty
        {
           
            return NSMutableArray(array: fetchedObjects)
        }
        return []
    }
    
    func verifyIfAgencyNameExists(name: String) -> Bool
    {
        var array = getAllAgencies()
     
        let predicate = NSPredicate(format: "name == %@", name)
        array = array.filtered(using: predicate) as! NSMutableArray
        
        if array.count > 0 {
            return true
        }
        
        return false
    }
    
    func getAllActiveProjectTasks() -> NSMutableArray
    {
        let tasks = self.getAllProjectTasks()
        let returnArray = NSMutableArray()
        for t in tasks
        {
            if !(t as! StageTask).wasDeleted
            {
                returnArray.add(t)
            }
        }
        return returnArray
    }
    
    
    func getAllProjects() -> NSMutableArray
    {
        var fetchedObjects:Array<Project>
        let context = managedObjectContext
        let fetch:NSFetchRequest<Project> = Project.fetchRequest()
        let entityDescription = NSEntityDescription.entity(forEntityName: "Project", in: context)
        fetch.entity = entityDescription
        fetchedObjects = try! context.fetch(fetch)
        if !fetchedObjects.isEmpty
        {
            return NSMutableArray(array: fetchedObjects)
        }
        return []

    }
    
    func getAllProjectTasks() -> NSMutableArray
    {
        var fetchedObjects:Array<StageTask>
        let context = managedObjectContext
        let fetch:NSFetchRequest<StageTask> = StageTask.fetchRequest()
        let entityDescription = NSEntityDescription.entity(forEntityName: "StageTask", in: context)
        fetch.entity = entityDescription
        fetchedObjects = try! context.fetch(fetch)
        if !fetchedObjects.isEmpty
        {
            
            return NSMutableArray(array: fetchedObjects)
        }
        return []
    }
    
    
    func getAllCurrentJobTimers() -> NSMutableArray
    {
        
        let fetchedArchive:Array<TimerArchive>
        var context = managedObjectContext
        let fetchArchive:NSFetchRequest<TimerArchive> = TimerArchive.fetchRequest()
        let entityDesc = NSEntityDescription.entity(forEntityName: "TimerArchive", in: context)
        fetchArchive.entity = entityDesc
        fetchedArchive = try! context.fetch(fetchArchive)
        
        var fetchedObjects:Array<JobTimer>
        context = managedObjectContext
        let fetch:NSFetchRequest<JobTimer> = JobTimer.fetchRequest()
        let entityDescription = NSEntityDescription.entity(forEntityName: "JobTimer", in: context)
        let predicate = NSPredicate(format: "(completed == %@) ", NSNumber(value: false))
        fetch.predicate = predicate
        fetch.entity = entityDescription
        fetchedObjects = try! context.fetch(fetch)
        
        let allProjects = NSMutableArray()
        for job in fetchedObjects
        {
            var found = false
            for a in fetchedArchive
            {
                if a.timerID == job.id
                {
                    found = true
                }
            }
            if !found
            {
                allProjects.add(job)
            }
        }
        if allProjects.count > 0        {
            return allProjects
        }
        return []
    }
    
    
    func updateCurrentJobTimer(timer:Double)
    {
        let fetch:NSFetchRequest<JobTimer> = JobTimer.fetchRequest()
        let entityDescription = NSEntityDescription.entity(forEntityName: "JobTimer", in: managedObjectContext)
        let predicate = NSPredicate(format: "id == %@", NSNumber(value: UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) as! Int))
        fetch.entity = entityDescription
        fetch.predicate = predicate
        let currentTimer = try! managedObjectContext.fetch(fetch).first
        currentTimer?.timeSpent = NSNumber(value: timer)
        try! managedObjectContext.save()
        
    }
    
    func delete(obj:NSManagedObject)
    {
        managedObjectContext.delete(obj)
        try! managedObjectContext.save()
    }
    
    func getClientForTaskId(id:Int) -> Agency?
    {
        let task = StageTask.getStageTask(forId: id)
        let project = Project.getProject(forId: task?.projectId as! Int)

        return Agency.getClient(forId: (project?.clientId.intValue)!)
    }
    
    func getAgencyForTask(id:Int) -> Agency?
    {
        let project = Project.getProject(forId: id)
        return Agency.getAgency(forId: (project?.agencyId.intValue)!)!
    }
    
    func getAllTimeSpentOnProject(project:NSNumber) -> Double
    {
        var time = 0.0
        let allJobTimers = JobTimer.getAllJobs()
        for job in allJobTimers
        {
            let task = StageTask.getStageTask(forId: job.stageTaskId.intValue)
            if task?.projectId == project
            {
                time = time + job.timeSpent.doubleValue
            }
        }
        
        return time
    }
    
    func getTotalTimeForProject(project:NSNumber) -> Double
    {
        let p = Project.getProject(forId: project.intValue)!

        return p.allocatedProjectTime.doubleValue
    }
}

