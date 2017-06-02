//
//  Project+CoreDataProperties.swift
//  Kronos
//
//  Created by Wee, David G. on 9/7/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import CoreData

extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project");
    }

    @NSManaged public var agencyId : NSNumber
    @NSManaged public var allocatedProjectTime : NSNumber
    @NSManaged public var archived : Bool
    @NSManaged public var clientId : NSNumber
    @NSManaged public var name: String?
    @NSManaged public var id: NSNumber
    @NSManaged public var dayLength: NSNumber
    
    class func tempProject() -> Project
    {
        let entityDesc = NSEntityDescription.entity(forEntityName: "Project", in: DataController.sharedInstance.managedObjectContext)
        return Project(entity: entityDesc!, insertInto: nil)
    }
    
    class func getProject(forId id:Int) -> Project?
    {
        let fetchRequest:NSFetchRequest<Project> = Project.fetchRequest()
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
    

    class func getNewProjectID() -> Int64
    {
        let fetchRequest:NSFetchRequest<Project> = Project.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let highest = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest).first
        if highest == nil
        {
            return 1
        }
        
        let newProjectID = Int((highest?.id)!) + 1
        return Int64(newProjectID)
    }

    class func deleteProjectWith(id:Int)
    {
        let fetchRequest:NSFetchRequest<Project> = Project.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", NSNumber(value:id))
        fetchRequest.predicate = predicate
        let result = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        for project in result
        {
            DataController.sharedInstance.delete(obj: project)
        }

    }
    
    class func getUniqueProjectNames() -> Set<String>
    {
        let fetchRequest:NSFetchRequest<Project> = Project.fetchRequest()
        let result = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        var returnSet = Set<String>()
        for project in result
        {
            returnSet.insert(project.name!)
        }
        return returnSet
    }

    class func all() -> [Project]? {
        let fetchRequest:NSFetchRequest<Project> = Project.fetchRequest()
        return try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
    }




    func encode() -> [String: Any?] {
        return [
            "agencyid": agencyId,
            "allocatedprojecttime": allocatedProjectTime,
            "archived": archived,
            "clientid": clientId,
            "name": name,
            "dayLength": dayLength,
            "id": id
        ]
    }

    class func decode(data: [[String: Any]]) {
        for p in data{
            let project:Project = NSEntityDescription.insertNewObject(forEntityName: "Project", into: DataController.sharedInstance.managedObjectContext) as! Project
            if Project.getUniqueProjectNames().contains(project.name!) {
                continue
            }
             let value = UserDefaults.standard.value(forKey: "download_count") as! Int * 100
            project.id = NSNumber(value: (p["id"] as! Int) + value)
            project.agencyId = NSNumber(value: (p["agencyid"] as! Int) + value)
            project.allocatedProjectTime = NSNumber(value: p["allocatedprojecttime"] as! Int)
            project.archived = p["archived"] as! Bool
            project.clientId = NSNumber(value: (p["clientid"] as! Int) + value)
            project.name = p["name"] as? String
            project.dayLength = NSNumber(value: p["daylength"] as! Int)
        }
        try! DataController.sharedInstance.managedObjectContext.save()
    }


}

