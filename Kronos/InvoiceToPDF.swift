//
//  InvoiceToPDF.swift
//  Kronos
//
//  Created by Wee, David G. on 12/4/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation


typealias PDFPath = String

struct InvoiceToPDF
{
    var invoice:Invoice!
    
    mutating func createPDFFrom(_ invoice: Invoice, address:String) -> PDFPath
    {
        self.invoice = invoice
        let pdfDictionary = ["agencyDetails":getAgencydetails(address),
                             "jobDetails": getJobDetails(),
                             "invoiceDetails": getInvoiceSummary(),
                             "bankingInfo" : getBankingInfo(),
                             "daysWorked": getDatesWorked(),
                             "additionalFees": getAdditionalFees(),
                             "contactDetails":getContactDetails(),
                             "noDaysWorked": getNoDatesValues()]
        
        let pdfHanlder = InvoicePDF()
        let time = UserDefaults.standard.value(forKey: "includeThingsOnInvoice") as! Bool
        let timer = JobTimer.getTimerWith(id: invoice.timerID.intValue)
        var pages  = 1
        if time == true
        {
            pages = (CalendarDay.getCalenderDaysWith(taskId: timer!.stageTaskId.intValue).count / 12) + 1
        }
        
        return pdfHanlder.createPDF(name: "Invoice - \(invoice.refNumber!)", time: time, pages: pages, data: NSDictionary(dictionary: pdfDictionary))
    }
    
    private func getAgencydetails(_ address:String) -> NSDictionary
    {
        let timer = JobTimer.getTimerWith(id: invoice.timerID.intValue)!
        let task = StageTask.getStageTask(forId: timer.stageTaskId.intValue)!
        let project = Project.getProject(forId: task.projectId.intValue)!
        let agency:Agency!
    
        if project.agencyId.intValue < 0 {
            var returnInfoDict = [String:String]()
            returnInfoDict["name"] = ""
            returnInfoDict["country"] = ""
            returnInfoDict["street"] = ""
            returnInfoDict["zip"] = ""
            returnInfoDict["contact"] = ""
            returnInfoDict["phone"] = ""
            return NSDictionary(dictionary: returnInfoDict)
        }
        
        if address == "agency"
        {
            agency = Agency.getAgency(forId: project.agencyId.intValue)!
        }else
        {
            agency = Agency.getClient(forId: project.clientId.intValue)
        }
        
        var returnInfoDict = [String:String]()
        
        returnInfoDict["name"] = agency.name
        
        if agency.location != "OPTIONAL" {
            returnInfoDict["country"] = agency.location
        }else { returnInfoDict["country"] = "" }
        
        if agency.address1 != "OPTIONAL" {
            returnInfoDict["street"] = agency.address1
        }else { returnInfoDict["street"] = "" }
        
        if agency.postcode != "OPTIONAL" {
            returnInfoDict["zip"] = agency.postcode
        }else { returnInfoDict["zip"] = "" }
        
        if agency.contact != "OPTIONAL" {
            returnInfoDict["contact"] = agency.contact
        }else { returnInfoDict["contact"] = "" }
        
        if agency.phone != "OPTIONAL" {
            returnInfoDict["phone"] = agency.phone
        }else { returnInfoDict["phone"] = "" }
        
        return NSDictionary(dictionary: returnInfoDict)
    }
    
    private func getJobDetails() -> NSDictionary
    {
        var returnInfoDict = [String:String]()
        
        returnInfoDict["ref"] = invoice.refNumber
        
        let timer = JobTimer.getTimerWith(id: invoice.timerID.intValue)!
        let task = StageTask.getStageTask(forId: timer.stageTaskId.intValue)!
        
        returnInfoDict["task"] = task.name
        
        let project = Project.getProject(forId: task.projectId.intValue)!
        
        returnInfoDict["project"] = project.name
        
        if let agency = Agency.getAgency(forId: project.agencyId.intValue) {
            returnInfoDict["agency"] = agency.name
        }
        
        if let client = Agency.getClient(forId: project.clientId.intValue) {
            returnInfoDict["client"] = client.name
        }
        
        return NSDictionary(dictionary: returnInfoDict)
    }
    
    private func getInvoiceSummary() -> NSDictionary
    {
        let timer = JobTimer.getTimerWith(id: invoice.timerID.intValue)!
        
        var returnInfoDict = [String:String]()
        
        if invoice.issueDate == nil
        {
            returnInfoDict["issued"] = "--/--/--"
        }
        else
        {
            returnInfoDict["issued"] = invoice.issueDate
        }
        let vals = InvoiceUtils.getDaysHoursMinutesFor(timer: timer)
        returnInfoDict["days"] = "\(vals.0)"
        returnInfoDict["hours"] = "\(vals.1)"
        returnInfoDict["minutes"] =  "\(vals.2)"
        
        if invoice.dueDate == nil
        {
            returnInfoDict["dueDate"] = "--/--/--"
        }
        else
        {
            returnInfoDict["dueDate"] = invoice.dueDate
        }
        returnInfoDict["totalDue"] = "\(invoice.totalDue.intValue)"
        
        
        return NSDictionary(dictionary: returnInfoDict)
    }
    
    private func getBankingInfo() -> NSDictionary
    {
        let bankingInfo = (getInvoiceCells()[0] as! NSDictionary)["ACCOUNT DETAILS"] as! NSArray
        let accountName = (bankingInfo[0] as! NSDictionary)["SUBTITLE"] as! String
        let bankName = (bankingInfo[1] as! NSDictionary)["SUBTITLE"] as! String
        let iban = (bankingInfo[3] as! NSDictionary)["SUBTITLE"] as! String
        let swiftCode = (bankingInfo[5] as! NSDictionary)["SUBTITLE"] as! String
        let accountNumber = (bankingInfo[2] as! NSDictionary)["SUBTITLE"] as! String
        let sortCode = (bankingInfo[4] as! NSDictionary)["SUBTITLE"] as! String
        
        var returnInfoDict = [String:String]()
        returnInfoDict["accountName"] = accountName
        returnInfoDict["bank"] = bankName
        returnInfoDict["iban"] = iban
        returnInfoDict["swiftCode"] = swiftCode
        returnInfoDict["accountNumber"] = accountNumber
        returnInfoDict["sortCode"] = sortCode
        
        return NSDictionary(dictionary: returnInfoDict)
        
    }
    
    private func getInvoiceCells() -> NSArray {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.appending("/Invoices.plist")
        let array = NSArray(contentsOfFile: path)
        return array!
    }
    
    private func getDatesWorked() -> NSDictionary
    {
        let timer = JobTimer.getTimerWith(id: invoice.timerID.intValue)!
    
        let task = StageTask.getStageTask(forId: timer.stageTaskId.intValue)!
        let fee = FeeRates.getRateWithId(id: task.feeRate.intValue)
        
        
        var returnInfoDict = [String:Any]()
        
        let daysWorkedArray = CalendarDay.getCalenderDaysWith(taskId: task.id.intValue)
        
        let hoursWorked = ArchiveUtils.getHoursWorked(task: task.id).0
        returnInfoDict["daysWorked"] = daysWorkedArray
        returnInfoDict["hoursWorked"] = "\(hoursWorked)"
        returnInfoDict["feeForHoursWorked"] = String(format:"%.2f", (fee.getRatePerMinute()*60) * Double(hoursWorked))
        
        return NSDictionary(dictionary: returnInfoDict)
    }
    
    private func getNoDatesValues() -> NSDictionary
    {
        let timer = JobTimer.getTimerWith(id: invoice.timerID.intValue)!
        let task = StageTask.getStageTask(forId: timer.stageTaskId.intValue)!
        let fee = FeeRates.getRateWithId(id: task.feeRate.intValue)
        
        var workDayLength = 8
        if let i = UserDefaults.standard.value(forKey: "workHoursPerDay") as? String
        {
            if let _ = Int(i)
            {
                workDayLength = Int(i)!
            }
        }
        
        let calendarDaysWorked = "\(CalendarDay.getCalenderDaysWith(taskId: task.id.intValue).count)"
        let feePerDay = "\(fee.getRatePerMinute() * Double(workDayLength*60))"
        let additionalFeesFor = "\(invoice.otherFees)"
        let paymentTerms = ""
        let workingDaysWorked = "\(calendarDaysWorked)"
        let totalHoursWorked = "\(InvoiceUtils.getTotalTimeWorked(task: task).0)"
        let feeForHour = "\(fee.getRatePerMinute() * 60)"
        let additionalFees = invoice.otherFeesFor
        let totalDue = "\(invoice.totalDue)"
        let currency = "\(invoice.currency)"
        
        var returnInfoDict = [String:String]()
        returnInfoDict["workdayLength"] = "\(workDayLength)"
        returnInfoDict["daysWorked"] = calendarDaysWorked
        returnInfoDict["feePerDay"] = feePerDay
        returnInfoDict["additionalFeesFor"] = additionalFeesFor
        returnInfoDict["paymentTerms"] = paymentTerms
        returnInfoDict["workingDaysWorked"] = workingDaysWorked
        returnInfoDict["totalHoursWorked"] = totalHoursWorked
        returnInfoDict["feeForHours"] = feeForHour
        returnInfoDict["additionalFees"] = additionalFees
        returnInfoDict["totalDue"] = totalDue
        returnInfoDict["currency"] = currency
        
        
        return NSDictionary(dictionary: returnInfoDict)
    }
    
    
    private func getAdditionalFees() -> NSDictionary
    {
        let timer = JobTimer.getTimerWith(id: invoice.timerID.intValue)!
        let task = StageTask.getStageTask(forId: timer.stageTaskId.intValue)!

        
        let fee = FeeRates.getRateWithId(id: task.feeRate.intValue)

        var returnInfoDict = [String:String]()
        var userDay = 8
        if let i = UserDefaults.standard.value(forKey: "workHoursPerDay") as? String
        {
            if let _ = Int(i)
            {
                userDay = Int(i)!
            }
        }
        returnInfoDict["feePerDay"] = String(format:"%.2f (%@)", (fee.getRatePerMinute()*60) * Double(userDay), invoice.currency)
        returnInfoDict["dayLength"] = "\(userDay)"
        returnInfoDict["additionalFees"] = "\(invoice.otherFees)"
        returnInfoDict["paymentTerms"] = ""
        returnInfoDict["additionalFeesDescription"] = invoice.otherFeesFor
        returnInfoDict["totalDueCurrency"] = "(\(invoice.currency))"
        returnInfoDict["totalDueAmount"] = "\(invoice.totalDue)"
        
        return NSDictionary(dictionary: returnInfoDict)
    }
    
    private func getContactDetails() -> NSDictionary
    {
        let userInfo = (getInvoiceCells()[0] as! NSDictionary)["PERSONAL INFO"] as! NSArray
        let name = (userInfo[0]as! NSDictionary)["SUBTITLE"] as! String
        let email = (userInfo[1]as! NSDictionary)["SUBTITLE"] as! String
        let phone = (userInfo[2]as! NSDictionary)["SUBTITLE"] as! String
        let address = (userInfo[4]as! NSDictionary)["SUBTITLE"] as! String
        let country = (userInfo[7]as! NSDictionary)["SUBTITLE"] as! String
        let city = (userInfo[6]as! NSDictionary)["SUBTITLE"] as! String
        let zip = (userInfo[3]as! NSDictionary)["SUBTITLE"] as! String
        let url = (userInfo[8]as! NSDictionary)["SUBTITLE"] as! String
        
        var returnInfoDict = [String:String]()
        returnInfoDict["name"] = name
        returnInfoDict["email"] = email
        returnInfoDict["phone"] = phone
        returnInfoDict["address"] = address
        returnInfoDict["city"] = city
        returnInfoDict["country"] = country
        returnInfoDict["zip"] = zip
        returnInfoDict["url"] = url
        
        return NSDictionary(dictionary: returnInfoDict)
    }
    
    
}
