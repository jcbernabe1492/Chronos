//
//  File.swift
//  Kronos
//
//  Created by Wee, David G. on 11/29/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit


enum TEXT_COLOR_TYPE
{
    case LIGHT
    case MEDIUM
    case DARK
}

class InvoicePDF:NSObject
{
    var fileName:String!
    
    func createPDF(name:String, time:Bool, pages:Int, data:NSDictionary) -> PDFPath
    {

        UIGraphicsBeginPDFContextToFile(getPDFFileName(name), CGRect.zero, nil)
        UIGraphicsBeginPDFPageWithInfo(CGRect(x:0, y:0, width:612, height:792), nil);
      
        var titlePage = Bundle.main.path(forResource: "Title_Page_Time", ofType: "pdf")
        if time == false
        {
            titlePage = Bundle.main.path(forResource: "Title_Page_No_Time", ofType: "pdf")
        }
        
        let pdfImage = self.drawToImage(pdf: URL(fileURLWithPath: titlePage!))
        pdfImage?.draw(at: CGPoint(x: 0, y: -50))
        drawData(data: data, page:0)
        
        if pages > 1
        {
            for i in 1...pages - 1
            {
                let page2 = Bundle.main.path(forResource: "More_Page_Time", ofType: "pdf")
                let pageTwoImage = self.drawToImage(pdf: URL(fileURLWithPath: page2!))
                    UIGraphicsBeginPDFPageWithInfo(CGRect(x:0, y:0, width:612, height:792), nil);
                pageTwoImage?.draw(at: CGPoint(x: 0, y: -50))
                drawData(data:data, page:i)
            }
        }
        
        
        UIGraphicsEndPDFContext()
        
        return getPDFFileName(name)
    }
    
    private func getPDFFileName(_ name:String) -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]   as String
        let path = paths.appending("/Invoices/\(name).pdf")
        return path
    }
    
    private func drawToImage(pdf:URL) -> UIImage?
    {
        guard let document = CGPDFDocument(pdf as CFURL) else { return nil}
        guard let page = document.page(at: 1) else{ return nil}
        
        let pageRect = page.getBoxRect(.mediaBox)
        let pageSize = pageRect.size
        
        UIGraphicsBeginImageContext(pageSize)
        let context = UIGraphicsGetCurrentContext()
        context?.interpolationQuality = .high
        UIColor.white.set()
        context?.fill(pageRect)
        context?.translateBy(x: 0.0, y: pageSize.height)
        context?.scaleBy(x: 1, y: -1)
        context?.saveGState()
        context?.drawPDFPage(page)
        context?.restoreGState()

        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
    
    
    private func drawData(data:NSDictionary, page:Int)
    {
        if page == 0
        {
            self.addAgencyDetails(agencyDetails: data.value(forKey: "agencyDetails") as! NSDictionary)
            self.addJobDetails(jobDetails: data.value(forKey: "jobDetails") as! NSDictionary)
        }
        
        if UserDefaults.standard.value(forKey: "includeThingsOnInvoice") as! Bool
        {
            self.addDatesWorked(daysWorkedData: data.value(forKey: "daysWorked") as! NSDictionary, page:page)
            self.addAdditionalFees(additionalFeeData: data.value(forKey: "additionalFees") as! NSDictionary)
            if page == 0
            {
                self.addInvoiceSummmaryTime(invoiceDetails: data.value(forKey: "invoiceDetails") as! NSDictionary)
            }
        }else
        {
            addNoDaysWorked(data: data.value(forKey: "noDaysWorked") as! NSDictionary)
            self.addInvoiceSummmaryNoTime(invoiceDetails: data.value(forKey: "invoiceDetails") as! NSDictionary)
        }
      
        
        self.addbankingInfo(bankingInfo: data.value(forKey: "bankingInfo") as! NSDictionary, page:page)
        
        self.addContactdetails(contactDetailData: data.value(forKey: "contactDetails") as! NSDictionary, page:page)
    }

    
    private func addAgencyDetails(agencyDetails:NSDictionary)
    {
        let name = agencyDetails.value(forKey: "name") as! String

        let street = agencyDetails.value(forKey: "street") as! String
        let country = agencyDetails.value(forKey: "country") as! String
        let zip = agencyDetails.value(forKey: "zip") as! String
        
        let contact = agencyDetails.value(forKey: "contact") as! String
        let phone = agencyDetails.value(forKey: "phone") as! String

        self.createTextRect(frame: CGRect(x: 52 , y: 85, width: 200, height: 15), text: name, size: 8, textColorType: .LIGHT )

        self.createTextRect(frame: CGRect(x: 52 , y: 95, width: 200, height: 15), text: country, size: 8, textColorType: .LIGHT )

        self.createTextRect(frame: CGRect(x: 52 , y: 115, width: 200, height: 15), text: "ADDRESS", size: 8, textColorType: .LIGHT )

        self.createTextRect(frame: CGRect(x: 52 , y: 125, width: 200, height: 15), text: street, size: 8, textColorType: .LIGHT )

        
        self.createTextRect(frame: CGRect(x: 52 , y: 145, width: 200, height: 15), text: country, size: 8, textColorType: .LIGHT )
        
        self.createTextRect(frame: CGRect(x: 52 , y: 155, width: 200, height: 15), text: zip, size: 8, textColorType: .LIGHT )
        
        self.createTextRect(frame: CGRect(x: 52 , y: 175, width: 200, height: 15), text: contact, size: 8, textColorType: .LIGHT )
        
        self.createTextRect(frame: CGRect(x: 52 , y: 185, width: 200, height: 15), text: phone, size: 8, textColorType: .LIGHT )
        
    }
    
    private func addJobDetails(jobDetails:NSDictionary)
    {
        let ref = jobDetails.value(forKey: "ref") as! String
        
        var agencyName = ""
        if jobDetails.value(forKey: "agency") != nil {
            agencyName = jobDetails.value(forKey: "agency") as! String
        }
        
        var client = ""
        if jobDetails.value(forKey: "client") != nil {
            client = jobDetails.value(forKey: "client") as! String
        }
        
        let project = jobDetails.value(forKey: "project") as! String
        
        let task = jobDetails.value(forKey: "task") as! String
        
        self.createTextRect(frame: CGRect(x: 232 , y: 85, width: 200, height: 15), text: "REF: \(ref)", size: 8.0, textColorType: .LIGHT)
        self.createTextRect(frame: CGRect(x: 232 , y: 105, width: 200, height: 15), text: "AGENCY", size: 8.0, textColorType: .LIGHT)
        self.createTextRect(frame: CGRect(x: 232 , y: 115, width: 200, height: 15), text: agencyName, size: 8.0, textColorType: .LIGHT)
        self.createTextRect(frame: CGRect(x: 232 , y: 135, width: 200, height: 15), text: "CLIENT", size: 8.0, textColorType: .LIGHT)
        self.createTextRect(frame: CGRect(x: 232 , y: 145, width: 200, height: 15), text: client, size: 8.0, textColorType: .LIGHT)
        self.createTextRect(frame: CGRect(x: 232 , y: 165, width: 200, height: 15), text: "PROJECT", size: 8.0, textColorType: .LIGHT)
        self.createTextRect(frame: CGRect(x: 232 , y: 175, width: 200, height: 15), text: project, size: 8.0, textColorType: .LIGHT)
        self.createTextRect(frame: CGRect(x: 232 , y: 195, width: 200, height: 15), text: "TASK", size: 8.0, textColorType: .LIGHT)
        self.createTextRect(frame: CGRect(x: 232 , y: 205, width: 200, height: 15), text: task, size: 8.0, textColorType: .LIGHT)
    }
    
    private func addInvoiceSummmaryTime(invoiceDetails:NSDictionary)
    {
        let issued = invoiceDetails.value(forKey: "issued") as! String
        let daysWorked = invoiceDetails.value(forKey: "days") as! String
        let hoursWorked = invoiceDetails.value(forKey: "hours") as! String
        let minutesWorked = invoiceDetails.value(forKey: "minutes") as! String
        let dueDate = invoiceDetails.value(forKey: "dueDate") as! String
        let totalDue = invoiceDetails.value(forKey: "totalDue") as! String
        
        self.createTextRect(frame: CGRect(x: 445 , y: 86, width: 200, height: 15), text: issued, size: 8.0, textColorType: .DARK)
        self.createTextRect(frame: CGRect(x: 412 , y: 115, width: 200, height: 25), text: String(format:"%.2d", Int(daysWorked)!), size: 20.0, textColorType: .DARK)
        self.createTextRect(frame: CGRect(x: 438 , y: 123, width: 200, height: 25), text: "D", size: 10.0, textColorType: .DARK)
        
        self.createTextRect(frame: CGRect(x: 450 , y: 115, width: 200, height: 25), text:String(format:"%.2d", Int(hoursWorked)!), size: 20.0, textColorType: .DARK)
        self.createTextRect(frame: CGRect(x: 478 , y: 123, width: 200, height: 25), text: "H", size: 10.0, textColorType: .DARK)
        
        self.createTextRect(frame: CGRect(x: 490 , y: 115, width: 200, height: 25), text:String(format:"%.2d", Int(minutesWorked)!), size: 20.0, textColorType: .DARK)
        self.createTextRect(frame: CGRect(x: 518 , y: 123, width: 200, height: 25), text: "M", size: 10.0, textColorType: .DARK)
        
        self.createTextRect(frame: CGRect(x: 412 , y: 155, width: 200, height: 25), text: dueDate, size: 20.0, textColorType: .DARK)
        
        self.createTextRect(frame: CGRect(x: 412 , y: 192, width: 200, height: 25), text: totalDue, size: 20.0, textColorType: .DARK)
        
    }
    
    private func addInvoiceSummmaryNoTime(invoiceDetails:NSDictionary)
    {
        let issued = invoiceDetails.value(forKey: "issued") as! String
        let dueDate = invoiceDetails.value(forKey: "dueDate") as! String
        let totalDue = invoiceDetails.value(forKey: "totalDue") as! String
        
        self.createTextRect(frame: CGRect(x: 410 , y: 95, width: 200, height: 25), text: issued, size: 22.0, textColorType: .DARK)

        self.createTextRect(frame: CGRect(x: 410 , y: 145, width: 200, height: 25), text: dueDate, size: 22.0, textColorType: .DARK)
    
        self.createTextRect(frame: CGRect(x: 410 , y: 190, width: 200, height: 25), text: totalDue, size: 22.0, textColorType: .DARK)
    }
    
    
    func addbankingInfo(bankingInfo:NSDictionary, page:Int)
    {
        let accountName = bankingInfo.value(forKey: "accountName") as! String
        let bank = bankingInfo.value(forKey: "bank") as! String
        let ibanNum = bankingInfo.value(forKey: "iban") as! String
        
        let swiftCode = bankingInfo.value(forKey: "swiftCode") as! String
        let accountNum = bankingInfo.value(forKey: "accountNumber") as! String
        let sortCode = bankingInfo.value(forKey: "sortCode") as! String
        
        var pageY = 265
        if page > 0
        {
            pageY = 87
        }
        self.createTextRect(frame: CGRect(x: 51 , y: pageY, width: 200, height: 15), text: accountName, size: 8.0, textColorType: .MEDIUM)
        
        self.createTextRect(frame: CGRect(x: 144, y: pageY, width: 200, height: 15), text: bank, size: 8.0, textColorType: .MEDIUM)
        
        self.createTextRect(frame: CGRect(x: 243 , y: pageY, width: 200, height: 15), text: ibanNum, size: 8.0, textColorType: .MEDIUM)
        
        self.createTextRect(frame: CGRect(x: 365 , y: pageY, width: 200, height: 15), text: swiftCode, size: 8.0, textColorType: .MEDIUM)
    
        self.createTextRect(frame: CGRect(x: 434 , y: pageY, width: 200, height: 15), text: accountNum, size: 8.0, textColorType: .MEDIUM)
        
        self.createTextRect(frame: CGRect(x: 508 , y: pageY, width: 200, height: 15), text: sortCode, size: 8.0, textColorType: .MEDIUM)
    }
    

    
    
    func addDatesWorked(daysWorkedData:NSDictionary, page:Int)
    {
     
        let totalHoursWorked = daysWorkedData.value(forKey: "hoursWorked") as! String
        let feeForHours = daysWorkedData.value(forKey: "feeForHoursWorked") as! String
        
        let daysWorked = daysWorkedData.value(forKey: "daysWorked") as! [CalendarDay]
        
        var count = 0
        var column = 0
        
        var totalCount = 0
        var startY = 350
        if page > 0
        {
            startY = 170
        }
        
        
        
        for day in daysWorked
        {
            if totalCount < page * 23
            {
                totalCount = totalCount + 1
                continue
            }
            
            var amount = 12
            if page > 0
            {
                amount = 21
            }
         
            if column == 1 && count == amount - 1
            {
                self.createTextRect(frame: CGRect(x: 178 + (column * 190) , y: startY + (20 * count), width: 200, height: 15), text: "CONTINUED ON FOLLOWING PAGE >", size: 8.0, textColorType: .LIGHT)
                break
            }
            
            self.createTextRect(frame: CGRect(x: 178 + (column * 190) , y: startY + (20 * count), width: 65, height: 15), text: (day.date as! Date).simpleDateString(), size: 8.0, textColorType: .LIGHT)
            
            self.createTextRect(frame: CGRect(x: 246 + (column * 190) , y: startY + (20 * count), width: 200, height: 15), text: String(format:"%.2f", (day.timeWorked/60.0/60.0)), size: 8.0, textColorType: .LIGHT)
            
            let task = StageTask.getStageTask(forId: day.taskId.intValue)!
            let fee = FeeRates.getRateWithId(id: task.feeRate.intValue)
            
            self.createTextRect(frame: CGRect(x: 305 + (column * 188) , y: startY + (20 * count), width: 200, height: 15), text: String(format:"%.2f", (day.timeWorked/60) * fee.getRatePerMinute()), size: 8.0, textColorType: .LIGHT)
            
            count = count + 1
         
            if count == amount && column == 0
            {
                column = 1
                count = 0
            }
        }
        
        
        self.createTextRect(frame: CGRect(x: 269 , y: 597, width: 200, height: 15), text: totalHoursWorked, size: 8.0, textColorType: .DARK)
        self.createTextRect(frame: CGRect(x: 470 , y: 597, width: 200, height: 15), text: feeForHours, size: 8.0, textColorType: .DARK)
    }
    
    func addNoDaysWorked(data: NSDictionary)
    {
        let workDayLength = data["workdayLength"] as! String
        let calenderDaysWorked = data["daysWorked"] as! String
        let feePerDay = data["feePerDay"] as! String
        let additionalFeesFor = data["additionalFeesFor"] as! String
        let paymentTerms = data["paymentTerms"] as! String
        let workingDaysWorked = data["workingDaysWorked"] as! String
        let totalHoursWorked = data["totalHoursWorked"] as! String
        let feeForHour = data["feeForHours"] as! String
        let additionalFees = data["additionalFees"] as! String
        let totalDue = data["totalDue"] as! String
        let currency = data["currency"] as! String
        
        
        self.createTextRect(frame: CGRect(x: 165 , y: 324, width: 200, height: 15), text: workDayLength, size: 18.0, textColorType: .MEDIUM)
        self.createTextRect(frame: CGRect(x: 365 , y: 322, width: 200, height: 15), text: workingDaysWorked, size: 18.0, textColorType: .DARK)
        
        self.createTextRect(frame: CGRect(x: 165 , y: 400, width: 200, height: 15), text: calenderDaysWorked, size: 18.0, textColorType: .MEDIUM)
        self.createTextRect(frame: CGRect(x: 365 , y: 400, width: 200, height: 15), text: totalHoursWorked, size: 18.0, textColorType: .DARK)
        
        self.createTextRect(frame: CGRect(x: 165 , y: 482, width: 200, height: 15), text: feePerDay, size: 18.0, textColorType: .MEDIUM)
        self.createTextRect(frame: CGRect(x: 365 , y: 482, width: 200, height: 15), text: feeForHour, size: 18.0, textColorType: .DARK)
        
        self.createTextRect(frame: CGRect(x: 165 , y: 560, width: 200, height: 1100), text: additionalFees, size: 18.0, textColorType: .MEDIUM)
        self.createTextRect(frame: CGRect(x: 365 , y: 560, width: 200, height: 15), text: additionalFeesFor, size: 18.0, textColorType: .DARK)
        
        self.createTextRect(frame: CGRect(x: 165 , y: 653, width: 200, height: 1100), text: paymentTerms, size: 18.0, textColorType: .MEDIUM)
        self.createTextRect(frame: CGRect(x: 365 , y: 653, width: 200, height: 15), text: totalDue, size: 18.0, textColorType: .DARK)
        
        self.createTextRect(frame: CGRect(x: 365 , y: 700, width: 200, height: 25), text: "(\(currency))", size: 18.0, textColorType: .DARK)
    }
    
    
    func addAdditionalFees(additionalFeeData:NSDictionary)
    {
        let feePerDay = additionalFeeData.value(forKey: "feePerDay") as! String
        let dayLength = additionalFeeData.value(forKey: "dayLength") as! String
        let additionalFees = additionalFeeData.value(forKey: "additionalFees") as! String
        let paymentTerms = additionalFeeData.value(forKey: "paymentTerms") as! String
        let additionalFeesDesc = additionalFeeData.value(forKey: "additionalFeesDescription") as! String
        let totalDueAmount = additionalFeeData.value(forKey: "totalDueAmount") as! String
        let totalDueCurrency = additionalFeeData.value(forKey: "totalDueCurrency") as! String
        
        self.createTextRect(frame: CGRect(x: 178 , y: 638, width: 200, height: 15), text: feePerDay, size: 8.0, textColorType: .MEDIUM)
        self.createTextRect(frame: CGRect(x: 245 , y: 638, width: 200, height: 15), text: dayLength, size: 8.0, textColorType: .MEDIUM)
        self.createTextRect(frame: CGRect(x: 470 , y: 627, width: 200, height: 15), text: additionalFees, size: 8.0, textColorType: .MEDIUM)
        self.createTextRect(frame: CGRect(x: 178 , y: 670, width: 150, height: 100), text: paymentTerms, size: 8.0, textColorType: .MEDIUM)

        self.createTextRect(frame: CGRect(x: 367 , y: 660, width: 150, height: 100), text: additionalFeesDesc, size: 8.0, textColorType: .MEDIUM)
        
       self.createTextRect(frame: CGRect(x: 410 , y: 708, width: 25, height: 15), text: totalDueCurrency, size: 8.0, textColorType: .DARK)
        self.createTextRect(frame: CGRect(x: 367 , y: 718, width: 200, height: 15), text: totalDueAmount, size: 15.0, textColorType: .DARK)

    }
    
    func addContactdetails(contactDetailData:NSDictionary, page:Int)
    {
        let name = contactDetailData["name"] as! String
        let email = contactDetailData["email"] as! String
        let phone = contactDetailData["phone"] as! String
        let address = contactDetailData["address"] as! String
        let country = contactDetailData["country"] as! String
        let city = contactDetailData["city"] as! String
        let zip = contactDetailData["zip"] as! String
        let url = contactDetailData["url"] as! String

        var pageY = 430
        if page > 0
        {
            pageY = 255
        }
        
        self.createTextRect(frame: CGRect(x: 36 , y: pageY, width: 75, height: 15), text: name, size: 8.0, textColorType: .LIGHT)
        self.createTextRect(frame: CGRect(x: 36 , y: pageY+20, width: 75, height: 15), text: email, size: 8.0, textColorType: .LIGHT)
        self.createTextRect(frame: CGRect(x: 36 , y: pageY+30, width: 75, height: 15), text: phone, size: 8.0, textColorType: .LIGHT)
        self.createTextRect(frame: CGRect(x: 36 , y: pageY+40, width: 75, height: 15), text: url, size: 8.0, textColorType: .LIGHT)
        self.createTextRect(frame: CGRect(x: 36 , y: pageY+70, width: 75, height: 15), text: "ADDRESS", size: 8.0, textColorType: .LIGHT)
        self.createTextRect(frame: CGRect(x: 36 , y: pageY+80, width: 75, height: 15), text: address, size: 8.0, textColorType: .LIGHT)
        self.createTextRect(frame: CGRect(x: 36 , y: pageY+90, width: 75, height: 15), text: city, size: 8.0, textColorType: .LIGHT)
        self.createTextRect(frame: CGRect(x: 36 , y: pageY+100, width: 75, height: 15), text: country, size: 8.0, textColorType: .LIGHT)
        self.createTextRect(frame: CGRect(x: 36 , y: pageY+110, width: 75, height: 15), text: zip, size: 8.0, textColorType: .LIGHT)
    }
    
    
    
    
    private func createTextRect(frame:CGRect, text:String?, size:CGFloat, textColorType:TEXT_COLOR_TYPE)
    {
        let font = UIFont(name: "NeoSans-Medium", size: size)
        
        let textRect = frame
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = NSTextAlignment.left
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        var color = UIColor.black
        if textColorType == .LIGHT
        {
            color = UIColor.lightGray
        }
        else if textColorType == .MEDIUM
        {
             color = UIColor.gray
        }
        
        let textFontAttributes = [
            NSFontAttributeName: font!,
            NSForegroundColorAttributeName: color,
            NSParagraphStyleAttributeName: paragraphStyle
        ] as [String : Any]

        var txt:NSString!
        
        if text == nil
        {
            txt = ""
        }
        else
        {
            txt = text! as NSString
        }
        
        txt?.draw(in: textRect, withAttributes: textFontAttributes)
    }
    
}
