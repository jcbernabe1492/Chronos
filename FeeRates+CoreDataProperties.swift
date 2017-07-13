//
//  FeeRates+CoreDataProperties.swift
//  Kronos
//
//  Created by Wee, David G. on 10/20/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import CoreData


extension FeeRates {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeeRates> {
        return NSFetchRequest<FeeRates>(entityName: "FeeRates");
    }

    @NSManaged public var id: NSNumber
    @NSManaged public var name: String?
    @NSManaged public var hours: NSNumber
    @NSManaged public var fee: NSNumber
    @NSManaged public var custom: Bool
    @NSManaged public var timeInterval:String

    func encode() -> [String: Any?] {
        return [
            "name": name,
            "hours": hours,
            "fee": fee,
            "custom": custom,
            "timeinterval": timeInterval
        ]
    }

    class func decode(data: [[String: Any]]) {
        for f in data {
            if (f["fee"] as! Double) <= 0 {
                continue
            }
            let feeRate:FeeRates = NSEntityDescription.insertNewObject(forEntityName: "FeeRates", into: DataController.sharedInstance.managedObjectContext) as! FeeRates
            if let fee = FeeRates.getRateWithName(f["name"] as! String) {
                feeRate.id = fee.id
                DataController.sharedInstance.managedObjectContext.delete(fee)
            }
            else {
                feeRate.id = FeeRates.getNextFeeRate()
            }
            feeRate.fee = NSNumber(value: f["fee"] as! Double)
            feeRate.custom = f["custom"] as! Bool
            feeRate.name = f["name"] as! String?
            feeRate.timeInterval = "Hours"
            feeRate.hours = NSNumber(value: f["hours"] as! Int)
        }
        try! DataController.sharedInstance.managedObjectContext.save()
    }
    
    class func all() -> [FeeRates]? {
        let fetchRequest:NSFetchRequest<FeeRates> = FeeRates.fetchRequest()
        return try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
    }
    class func getNextFeeRate() -> NSNumber
    {
        let fetchRequest:NSFetchRequest<FeeRates> = FeeRates.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let highest = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest).first
        if highest == nil
        {
            return 1
        }
        return NSNumber(value: Int((highest?.id)!) + 1)
    }
    
    class func getRateWithId(id:Int) -> FeeRates
    {
        let fetchRequest:NSFetchRequest<FeeRates> = FeeRates.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        fetchRequest.predicate = predicate
        let array = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        return array[0]
    }
    class func getRateWithName(_ name: String) -> FeeRates? {
        let fetchRequest:NSFetchRequest<FeeRates> = FeeRates.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.predicate = predicate
        let array = try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
        return array[0]
    }

    class func getDefaultRates() -> [FeeRates]
    {
        let fetchRequest:NSFetchRequest<FeeRates> = FeeRates.fetchRequest()
        let predicate = NSPredicate(format: "custom == %@", NSNumber(value: false))
        fetchRequest.predicate = predicate
        return try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
    }
    
    class func getCustomRates() -> [FeeRates]
    {
        let fetchRequest:NSFetchRequest<FeeRates> = FeeRates.fetchRequest()
        let predicate = NSPredicate(format: "custom == %@", NSNumber(value: true))
        
        fetchRequest.predicate = predicate
        return try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
    }
    
    func getRatePerMinute() -> Double
    {
        if timeInterval == "hours"
        {
            return fee.doubleValue / hours.doubleValue / 60
        }
        else
        {
            //return (fee.doubleValue * hours.doubleValue) / 60
            return (fee.doubleValue/60) / hours.doubleValue
        }
    }


    
}
