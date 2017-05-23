//
//  DaysWorked+CoreDataProperties.swift
//  Kronos
//
//  Created by Wee, David G. on 9/7/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import CoreData

extension DaysWorked {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DaysWorked> {
        return NSFetchRequest<DaysWorked>(entityName: "DaysWorked");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var timerWorked: Float
    @NSManaged public var feePerDay: Double



    func encode() -> [String: Any?] {
        return [
            "date": date?.toString(),
            "timerWorked": timerWorked,
            "feeperday": feePerDay
        ]
    }

    class func all() -> [DaysWorked]? {
        let fetchRequest:NSFetchRequest<DaysWorked> = DaysWorked.fetchRequest()
        return try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
    }



}
