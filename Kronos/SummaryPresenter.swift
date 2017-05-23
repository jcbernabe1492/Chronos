//
//  SummaryPresenter.swift
//  Kronos
//
//  Created by Wee, David G. on 10/21/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

class SummaryPresenter:NSObject, UITableViewDelegate, UITableViewDataSource
{
    
    var currentTimer:JobTimer?
    
    var task:StageTask!
    var project : Project!
    var agency : Agency!
    var client:Agency!
    var invoice:Invoice?
    var fromOtherTab = false
    var timings = false
    var timingsData:[CalendarDay] = []
  
    func initValues()
    {
        
        if invoice == nil && fromOtherTab == false
        {
            if UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) != nil
            {
                currentTimer = JobTimer.getTimerWith(id: UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) as! Int)
                task = StageTask.getStageTask(forId: (currentTimer?.stageTaskId.intValue)!)
                project = Project.getProject(forId: (task?.projectId.intValue)!)
                agency = Agency.getAgency(forId: project.agencyId.intValue)

                client = Agency.getClient(forId: project.clientId.intValue)
                invoice = Invoice.newInvoice()
                invoice?.id = NSNumber(value: Invoice.getNewInvoiceID())
                invoice?.timerID = (currentTimer?.id)!
                invoice?.refNumber = "Enter Reference"
                invoice?.issueDate = nil
                invoice?.dueDate = nil
                invoice?.status = "DRAFT"
                invoice?.archived = false
                try! DataController.sharedInstance.managedObjectContext.save()
            }
        }
        else if invoice != nil {
            currentTimer = JobTimer.getTimerWith(id: (invoice?.timerID.intValue)!)
            task = StageTask.getStageTask(forId: (currentTimer?.stageTaskId.intValue)!)
            project = Project.getProject(forId: (task?.projectId.intValue)!)
            agency = Agency.getAgency(forId: project.agencyId.intValue)
            client = Agency.getClient(forId: project.clientId.intValue)
        }
        
        if timings
        {
            if task != nil
            {
                timingsData = CalendarDay.getCalenderDaysWith(taskId: task.id.intValue)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !timings
        {
            return 10
        }
        else
        {
            if timingsData.count == 0
            {
                return 1
            }
            return timingsData.count + 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell = UITableViewCell()
      
        if timings
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "TimingCell")!
       
            if indexPath.row == 0
            {
                (cell as! TimingsCell).leftLabel.text = "DATES WORKED"
                (cell as! TimingsCell).middleLabel.text = "HOURS WORKED"
                (cell as! TimingsCell).rightLabel.text = "FEE PER DAY"
                cell.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
                (cell as! TimingsCell).leftLabel.font = UIFont().boldFont()
                (cell as! TimingsCell).rightLabel.font = UIFont().boldFont()
                (cell as! TimingsCell).middleLabel.font = UIFont().boldFont()
                (cell as! TimingsCell).leftLabel.textColor = UIColor.cellBackgroundColor()
                (cell as! TimingsCell).rightLabel.textColor = UIColor.cellBackgroundColor()
                (cell as! TimingsCell).middleLabel.textColor = UIColor.cellBackgroundColor()
            }
            else
            {
                let row = indexPath.row
                let num = row - 1
                var count = 0
                var day:CalendarDay = CalendarDay()
                for d in timingsData {
                    if count == num {
                        day = d
                    }
                    count += 1
                }
                let date = day.date as! Date
                (cell as! TimingsCell).leftLabel.text = "\(date.getMonth())/\(date.getDay())/\(date.getYear())"
                let min = (day.timeWorked)/60
                let hours = (day.timeWorked)/60/60
                (cell as! TimingsCell).middleLabel.text = String(format: "%.2f", hours)
                let task = StageTask.getStageTask(forId: (day.taskId.intValue))
                let fee = FeeRates.getRateWithId(id: (task?.feeRate.intValue)!)
                (cell as! TimingsCell).rightLabel.text = String(format:"%.2f", fee.getRatePerMinute() * min)
                cell.backgroundColor = UIColor.cellBackgroundColor()
                (cell as! TimingsCell).leftLabel.font = UIFont().boldFont()
                (cell as! TimingsCell).rightLabel.font = UIFont().boldFont()
                (cell as! TimingsCell).middleLabel.font = UIFont().boldFont()
                (cell as! TimingsCell).leftLabel.textColor = UIColor.white
                (cell as! TimingsCell).rightLabel.textColor = UIColor.white
                (cell as! TimingsCell).middleLabel.textColor = UIColor.white
                
                
                (cell as! TimingsCell).rightLabel.textAlignment = .right
                (cell as! TimingsCell).middleLabel.textAlignment = .right

            }
        }
        else
        {
            switch indexPath.row
            {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: "SummaryText")!
                (cell as! SummaryTextCell).titleLabel.text = "REF NO:"
                (cell as! SummaryTextCell).textfield.text = invoice?.refNumber
                break
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: "SummaryText")!
                (cell as! SummaryTextCell).titleLabel.text = "ISSUE DATE:"
                if invoice?.issueDate == nil
                {
                    (cell as! SummaryTextCell).textfield.text = "--/--/--"
                }else
                {
                    (cell as! SummaryTextCell).textfield.text = invoice?.issueDate
                }
                break
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: "SummaryText")!
                (cell as! SummaryTextCell).titleLabel.text = "DUE DATE:"
                if invoice?.dueDate == nil
                {
                    (cell as! SummaryTextCell).textfield.text = "--/--/--"
                }else
                {
                    (cell as! SummaryTextCell).textfield.text = invoice?.dueDate
                }
                break
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: "SummaryLabel")!
                (cell as! SummaryLabelCell).title.text = "TOTAL TIME"
                if invoice == nil
                {
                    (cell as! SummaryLabelCell).subTitle.text = "N/A"
                    break
                }
                let times = InvoiceUtils.getDaysHoursMinutesFor(timer: currentTimer!)
                
                (cell as! SummaryLabelCell).subTitle.text = String(format: "%02d DAYS    %02d HOURS    %02d MINS", times.0, times.1, times.2)
                break
            case 4:
                cell = tableView.dequeueReusableCell(withIdentifier: "SummaryLabel")!
                (cell as! SummaryLabelCell).title.text = "HOURS DAYS"
                var dayHours = Int(UserDefaults.standard.value(forKey: "workHoursPerDay") as! String)
                if dayHours == nil{dayHours = 8}
                (cell as! SummaryLabelCell).subTitle.text = "\(dayHours!)"
                break
            case 5:
                cell = tableView.dequeueReusableCell(withIdentifier: "SummaryLabel")!
                (cell as! SummaryLabelCell).title.text = "FEE DUE"
                if invoice == nil
                {
                    (cell as! SummaryLabelCell).subTitle.text = "N/A"
                    break
                }
                let minPerRate = FeeRates.getRateWithId(id: (task?.feeRate.intValue)!).getRatePerMinute()
                let taskIncome = (currentTimer?.timeSpent.doubleValue)! / 60 * minPerRate
                (cell as! SummaryLabelCell).subTitle.text = "$\(String(format:"%.2f", taskIncome))"
                break
            case 6:
                cell = tableView.dequeueReusableCell(withIdentifier: "SummaryText")!
                (cell as! SummaryTextCell).titleLabel.text = "OTHER FEES"
                var t = "N/A"
                if invoice != nil
                {
                    if invoice!.otherFees.doubleValue > 0.0
                    {
                        t = "\(invoice?.otherFees)"
                    }
                }
                (cell as! SummaryTextCell).textfield.text = t
                break
            case 7:
                cell = tableView.dequeueReusableCell(withIdentifier: "SummaryText")!
                (cell as! SummaryTextCell).titleLabel.text = "OTHER FEES FOR"
                var t = "N/A"
                if invoice != nil
                    {
                        if invoice?.otherFeesFor != ""
                        {
                            t = "\(invoice?.otherFeesFor)"
                        }
                }
                (cell as! SummaryTextCell).textfield.text = t
                break
            case 8:
                cell = tableView.dequeueReusableCell(withIdentifier: "SummaryText")!
                (cell as! SummaryTextCell).titleLabel.text = "TOTAL DUE"

                if invoice?.totalDue == 0 || invoice == nil
                {
                    (cell as! SummaryTextCell).textfield.text = "Enter final Invoice amount"
                }
                else
                {
                    (cell as! SummaryTextCell).textfield.text = "\(invoice!.totalDue)"
                }
                break
            case 9:
                cell = tableView.dequeueReusableCell(withIdentifier: "SummaryText")!
                (cell as! SummaryTextCell).titleLabel.text = "CURRENCY"
                if invoice?.currency == "" || invoice == nil
                {
                    (cell as! SummaryTextCell).textfield.text = "--"
                }
                else
                {
                    (cell as! SummaryTextCell).textfield.text = "\(invoice!.currency)"
                }
                break
                default:
                break
            }
            if cell is SummaryTextCell
            {
                (cell as! SummaryTextCell).invoice = invoice
                (cell as! SummaryTextCell).table = tableView
            }
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let agencyClientLabl = UILabel()
        agencyClientLabl.font = UIFont().normalFont()
        agencyClientLabl.textColor = UIColor.white

        
        let projectNameLabel = UILabel()

        projectNameLabel.font = UIFont().boldFont()
        projectNameLabel.textColor = UIColor.white
        
        let taskNameLabel = UILabel()
        taskNameLabel.textColor = UIColor.white
        taskNameLabel.font = UIFont().normalFont()
        if invoice != nil
        {
            taskNameLabel.text = "\(task.name!)"
             projectNameLabel.text = "\(project.name!)"
            var agencyText = "No Agency"
            var clientText = "No Client"
            if agency != nil{
                agencyText = "\(agency.name!)"
            }
            if client != nil
            {
                clientText = "\(client.name!)"
            }
             agencyClientLabl.text = "\(agencyText) / \(clientText)"
        }else
        {
            taskNameLabel.text = "NA"
            projectNameLabel.text = "NA"
            agencyClientLabl.text = "NA"
        }
        
        
        let stack = UIStackView(arrangedSubviews: [agencyClientLabl, projectNameLabel, taskNameLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        header.addSubview(stack)
        header.addConstraint(NSLayoutConstraint(item: header, attribute: .centerY, relatedBy: .equal, toItem: stack, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        header.addConstraint(NSLayoutConstraint(item: header, attribute: .leading, relatedBy: .equal, toItem: stack, attribute: .leading, multiplier: 1.0, constant: -20.0))
        
        header.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 75
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if timings {
            if indexPath.row == 0
            {
                if UIScreen().isiPhone6() || UIScreen().isiPhone6Plus()
                {
                    return 30.93
                }
                else
                {
                    return 26.04
                }
            }
        }
        return 40
    }
    
    


}
