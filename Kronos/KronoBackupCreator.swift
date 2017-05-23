//
//  KronoBackupCreator.swift
//  Kronos
//
//  Created by Wee, David G. on 2/13/17.
//  Copyright © 2017 davidwee. All rights reserved.
//

import Foundation
import MessageUI

class KronoBackupCreator:NSObject, MFMailComposeViewControllerDelegate
{
    class func createBackup() -> String?
    {
        let final:NSMutableArray = NSMutableArray()
        var feeRates: [String: [[String: Any?]]] = [: ]
        if let rates = FeeRates.all() {
            let encodedrates = rates.map {
                $0.encode()
            }
            feeRates["feeRates"] = encodedrates
            final.add(feeRates)
        }

        var agencies: [String: [[String: Any?]]] = [: ]
        if let a = Agency.all() {
            let encoded = a.map {
                $0.encode()
            }
            agencies["agencies"] = encoded
            final.add(agencies)
        }

        var projects: [String: [[String: Any?]]] = [: ]
        if let p = Project.all() {
            let encoeded = p.map {
                $0.encode()
            }
            projects["projects"] = encoeded
            final.add(projects)
        }

        var tasks: [String: [[String: Any?]]] = [: ]
        if let t = StageTask.all() {
            let encoded = t.map {
                $0.encode()
            }
            tasks["stageTasks"] = encoded
            final.add(tasks)
        }

        var calendar: [String: [[String: Any?]]] = [: ]
        if let calendarDates = CalendarDay.all() {
            let encoded = calendarDates.map {
                $0.encode()
            }
            calendar["calendarDates"] = encoded
            final.add(calendar)
        }

        var timers: [String: [[String: Any?]]] = [: ]
        if let t = JobTimer.all() {
            let encoeded = t.map {
                $0.encode()
            }
            timers["timers"] = encoeded
            final.add(timers)
        }

        var invoices: [String: [[String: Any?]]] = [: ]
        if let i = Invoice.all()
        {
            let encoded = i.map {
                $0.encode()
            }
            invoices["invoices"] = encoded
            final.add(invoices)
        }

        var timerArchive: [String: [[String: Any?]]] = [: ]
        if let t = TimerArchive.all() {
            let encoded = t.map {
                $0.encode()
            }
            timerArchive["timerArchive"] = encoded
            final.add(timerArchive)
        }

        var daysWorked: [String: [[String: Any?]]] = [: ]
        if let  d = DaysWorked.all() {

            let encoded = d.map {
                $0.encode()
            }
            daysWorked["daysWorked"] = encoded
            final.add(daysWorked)
        }




        let json = try! JSONSerialization.data(withJSONObject: final, options: .prettyPrinted)
    
        let tempDir = NSTemporaryDirectory().appending("UserBackup.kb")
        if FileManager.default.createFile(atPath: tempDir, contents: json, attributes: nil)
        {
            return tempDir
        }
        return nil
    }

    class func importData(_ data: NSArray) {
        for dict in data {
            if ((dict as! NSDictionary).allKeys.first as! String) == "feeRates" {
                FeeRates.decode(data: (dict as! Dictionary)["feeRates"]!)
            }
        }

    }

    class func emailBackup(_ b:String, delegate:MFMailComposeViewControllerDelegate) -> MFMailComposeViewController
    {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = delegate
        mailComposer.setSubject("User Backup Fro Krono")
        if let fileData = NSData(contentsOfFile: b)
        {
            mailComposer.addAttachmentData(fileData as Data, mimeType: "application/json", fileName: "UserBackup.csm")
        }
        return mailComposer
    }
}
