//
//  TimerArchive+CoreDataProperties.swift
//  Kronos
//
//  Created by Wee, David G. on 9/7/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import CoreData

extension TimerArchive {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimerArchive> {
        return NSFetchRequest<TimerArchive>(entityName: "TimerArchive");
    }

    @NSManaged public var timerID: NSNumber

    func encode() -> [String: Any?] {
        return ["timerid": timerID]
    }

    class func all() -> [TimerArchive]? {
        let fetchRequest:NSFetchRequest<TimerArchive> = TimerArchive.fetchRequest()
        return try! DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
    }


}
