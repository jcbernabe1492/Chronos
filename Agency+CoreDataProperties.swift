//
//  Agency+CoreDataProperties.swift
//  Kronos
//
//  Created by Wee, David G. on 9/7/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import CoreData

extension Agency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Agency> {
        return NSFetchRequest<Agency>(entityName: "Agency");
    }

    @NSManaged public var address1: String?
    @NSManaged public var address2: String?
    @NSManaged public var contact: String?
    @NSManaged public var email: String?
    @NSManaged public var id: NSNumber
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var postcode: String?
    @NSManaged public var isAgency: Bool


    
    class func tempAgency() -> Agency
    {
        let entityDesc = NSEntityDescription.entity(forEntityName: "Agency", in: DataController.sharedInstance.managedObjectContext)
        return Agency(entity: entityDesc!, insertInto: nil)
    }
    
    class func getAgency(forId id:Int) -> Agency?
    {
        let fetchRequest:NSFetchRequest<Agency> = Agency.fetchRequest()
        fetchRequest.fetchLimit = 1
        let predicate = NSPredicate(format: "id == %@", NSNumber(value:id))
        fetchRequest.predicate = predicate
        let result = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        return result.first
       
    }
    
    class func getClient(forId id:Int) -> Agency?
    {
        let fetchRequest:NSFetchRequest<Agency> = Agency.fetchRequest()
        fetchRequest.fetchLimit = 1
        let predicate = NSPredicate(format: "(id == %@) AND (isAgency == %@)", NSNumber(value:id), NSNumber(value: false))
        fetchRequest.predicate = predicate
        let result = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        if result.count == 0
        {
            return nil
        }
        return result.first!
    }
    
    class func getAllAgencies() -> [Agency]?
    {
        let fetchRequest:NSFetchRequest<Agency> = Agency.fetchRequest()
        let predicate = NSPredicate(format: "isAgency == %@",  NSNumber(value: true))
        fetchRequest.predicate = predicate
        return  try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)

    }
    
    class func getNewAgencyID() -> Int64
    {
        let fetchRequest:NSFetchRequest<Agency> = Agency.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let highest = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest).first
        if highest == nil
        {
            return 1
        }
        return Int((highest?.id)!) + 1
    }


    class func all() -> [Agency]? {
        let fetchRequest:NSFetchRequest<Agency> = Agency.fetchRequest()
        return try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
    }

    func encode() -> [String: Any?] {
        return [
            "address1": address1,
            "address2": address2,
            "contact": contact,
            "email": email,
            "location": location,
            "name": name,
            "phone": phone,
            "postcode": postcode,
            "isAgency": isAgency
        ]
    }

    class func decode(data: [[String: Any]]) {

    }
}
