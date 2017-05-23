//
//  Invoice+CoreDataProperties.swift
//  Kronos
//
//  Created by Wee, David G. on 9/7/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import CoreData

extension Invoice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Invoice> {
        return NSFetchRequest<Invoice>(entityName: "Invoice");
    }

    @NSManaged public var refNumber: String?
    @NSManaged public var id: NSNumber
    @NSManaged public var order: NSNumber
    @NSManaged public var timerID: NSNumber
    @NSManaged public var taskId: NSNumber
    @NSManaged public var status: String
    @NSManaged public var currency: String
    @NSManaged public var otherFees: NSNumber
    @NSManaged public var otherFeesFor: String
    @NSManaged public var dueDate: String?
    @NSManaged public var issueDate: String?
    @NSManaged public var totalDue: NSNumber
    @NSManaged public var archived:Bool
    


    func encode() -> [String: Any?] {
        return [
            "refNumber": refNumber,
            "order": order,
            "timerid": timerID,
            "taskid": taskId,
            "status": status,
            "currency": currency,
            "otherfees": otherFees,
            "otherfeesfor": otherFeesFor,
            "duedate": dueDate,
            "issuedate": issueDate,
            "totaldue": totalDue,
            "archvied": archived
        ]
    }

    class func all() -> [Invoice]? {
        let fetchRequest:NSFetchRequest<Invoice> = Invoice.fetchRequest()
        return try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
    }


    class func deleteAll() -> Bool
    {
        let fetchRequest:NSFetchRequest<Invoice> = Invoice.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do{
            try DataController.sharedInstance.managedObjectContext.execute(deleteRequest)
            return true
        }catch let error as NSError
        {
            print(error)
            return false
        }
    }
    
    class func delete(id:NSNumber)
    {
        let fetchRequest:NSFetchRequest<Invoice> = Invoice.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        
        let fetch = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest).first
        if fetch != nil
        {
            do{
                DataController.sharedInstance.managedObjectContext.delete(fetch!)
                try DataController.sharedInstance.managedObjectContext.save()
            }catch let error as NSError
            {
                print(error)
            }
        }
    }
    
    class func  getInvoiceWith(jobId:NSNumber) -> Invoice?
    {
        let fetchRequest:NSFetchRequest<Invoice> = Invoice.fetchRequest()
        fetchRequest.fetchLimit = 1
        let predicate = NSPredicate(format: "timerID == %@", jobId)
        fetchRequest.predicate = predicate
        return  try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest).first
   
    }
    
    class func getInvoiceWithId(id:Int) -> Invoice?
    {
        let fetchRequest:NSFetchRequest<Invoice> = Invoice.fetchRequest()
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
    class func getDrafts() -> [Invoice]
    {
        let fetchRequest:NSFetchRequest<Invoice> = Invoice.fetchRequest()
        let predicate = NSPredicate(format: "status == %@", "DRAFT")
        fetchRequest.predicate = predicate
        let result = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        var returnArray = Array<Invoice>()
        for i in result
        {
            if i.archived == false
            {
                returnArray.append(i)
            }
        }
        return returnArray
    }
    
    class func getCleared() -> [Invoice]
    {
        let fetchRequest:NSFetchRequest<Invoice> = Invoice.fetchRequest()
        let predicate = NSPredicate(format: "status == %@", "CLEARED")
        fetchRequest.predicate = predicate
        let result = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        var returnArray = Array<Invoice>()
        for i in result
        {
            if i.archived == false
            {
                returnArray.append(i)
            }
        }
        return returnArray
    }
    
    class func getSent() -> [Invoice]
    {
        let fetchRequest:NSFetchRequest<Invoice> = Invoice.fetchRequest()
       
        let predicate = NSPredicate(format: "(status == %@) ||(status == %@) ||(status == %@) ", "INVOICED", "OVERDUE", "CRITICAL")
        fetchRequest.predicate = predicate
        let result = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        var returnArray = Array<Invoice>()
        for i in result
        {
            if i.archived == false
            {
                returnArray.append(i)
            }
        }
        return returnArray
    }
    
    class func getArchived() -> [Invoice]
    {
        let fetchRequest:NSFetchRequest<Invoice> = Invoice.fetchRequest()
        
        let predicate = NSPredicate(format: "archived == %@", NSNumber(value:true))
        fetchRequest.predicate = predicate
        return  try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)

    }
    
    
    class func newInvoice() -> Invoice
    {
        let entityDesc = NSEntityDescription.entity(forEntityName: "Invoice", in: DataController.sharedInstance.managedObjectContext)
        let invoice = Invoice(entity: entityDesc!, insertInto: DataController.sharedInstance.managedObjectContext)
        return  invoice
    }

    
    
    class func getNewInvoiceID() -> Int64
    {
        let fetchRequest:NSFetchRequest<Invoice> = Invoice.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let highest = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest).first
        if highest == nil
        {
            return 1
        }

        return Int((highest?.id)!) + 1
    }
    
    class func timerHasBeenInvoiced(timer:Int) -> Bool
    {
        let fetchRequest:NSFetchRequest<Invoice> = Invoice.fetchRequest()
        fetchRequest.fetchLimit = 1
        let predicate = NSPredicate(format: "timerID == %@", NSNumber(value:timer))
        fetchRequest.predicate = predicate
        let array = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        return array.count > 0

    }
    
    
}
