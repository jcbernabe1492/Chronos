//
//  BottomTableViewDelegate.swift
//  Kronos
//
//  Created by Wee, David G. on 10/29/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit


class BottomTableViewDelegate:NSObject, UITableViewDataSource, UITableViewDelegate
{
    var viewController:ArchiveViewController!
    var data:NSArray?
    var secondaryData:NSArray?
    var editing = false
    var toDeleteSet:Set<Int> = Set<Int>()
    
    var highest = NSNumber(value: 0)
    
    init(controller:UIViewController)
    {
        viewController = controller as! ArchiveViewController
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewController.selectedTask != nil && viewController.selectedStatus == .TASK{ return 8 }
        return (data?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewController.selectedStatus == .AGENCY || viewController.selectedStatus == .CLIENT
        {
            return getAgencyCell(tableView: tableView, indexPath: indexPath  )
        }
        else if viewController.selectedStatus == .PROJECT
        {
            return getProjectCell(tableView: tableView, indexPath: indexPath)
        }
        else if viewController.selectedStatus == .TASK
        {
            return getTaskCell(tableView: tableView, indexPath: indexPath)
        }
        return UITableViewCell()
    }
    
    func getTaskCell(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell
    {
        if viewController.selectedTask != nil{
            let task = StageTask.getStageTask(forId: NSNumber(value: viewController.selectedTask!).intValue)
            let job = JobTimer.getTimerWithTask(id: Int(NSNumber(value: viewController.selectedTask!)))
            let invoice = Invoice.getInvoiceWith(jobId: (job?.id)!)
            let project = Project.getProject(forId: (task?.projectId.intValue)!)
            switch indexPath.row
            {
            case 0:
                let cell:InvoiceStatusCell = tableView.dequeueReusableCell(withIdentifier: "InvoiceStatus") as! InvoiceStatusCell
                if invoice?.status == "DRAFT" {
                    cell.draftBtn.alpha = 1.0
                    cell.draftBtn.setTitleColor(UIColor.white, for: .normal)
                }
                else if invoice?.status == "INVOICED"
                {
                    cell.invoicedBtn.alpha = 1.0
                    cell.invoicedBtn.setTitleColor(UIColor.invoicedColor(), for: .normal)
                }
                else if invoice?.status == "OVERDUE"
                {
                    cell.overdueBtn.alpha = 1.0
                    cell.overdueBtn.setTitleColor(UIColor.invoicedOverdueColor(), for: .normal)
                }
                else if invoice?.status == "CRITICAL"
                {
                    cell.criticalBtn.alpha = 1.0
                    cell.criticalBtn.setTitleColor(UIColor.invoicedCriticalColor(), for: .normal)
                }
                else
                {
                    cell.clearedBtn.alpha = 1.0
                    cell.clearedBtn.setTitleColor(UIColor.invoicedClearedColor(), for: .normal)
                }
                
                return cell
            case 1:
                let cell:TwoLabelCell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelCell") as! TwoLabelCell
                cell.leftLabel.text = "FEE EARNED"
                let fee = FeeRates.getRateWithId(id: (task?.feeRate.intValue)!)
                let feeEared = fee.getRatePerMinute() * (job?.timeSpent.doubleValue)! / 60
                cell.rightLabel.text = String(format:"$%.2f", feeEared)
                cell.set(stack: false)
                cell.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
                return cell
            case 2:
                let cell:TwoLabelCell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelCell") as! TwoLabelCell
                cell.leftLabel.text = "TOTAL HOURS"
                cell.set(stack: false)
                cell.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
                let hours = ArchiveUtils.getHoursWorked(task: (task?.id)!)
                cell.rightLabel.text = "\(hours.0) HRS   \(hours.1) MIN"
                return cell
            case 3:
                let cell:TwoLabelCell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelCell") as! TwoLabelCell
                cell.leftLabel.text = "TOTAL DAYS"
                cell.set(stack: false)
                cell.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
                let hours = ArchiveUtils.getDaysWorked(task: (task?.id)!)
                cell.rightLabel.text = "\(hours) DAYS"
                return cell
            case 4:
                let cell:TwoLabelCell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelCell") as! TwoLabelCell
                cell.leftLabel.text = "ALLOCATED TASK TIME"
                cell.set(stack: false)
                cell.rightLabel.text = "\(task!.allocatedTaskTime.intValue) DAYS"
                cell.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
                return cell
            case 5:
                let cell:TwoLabelCell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelCell") as! TwoLabelCell
                cell.leftLabel.text = "ALLOCATED PROJECT TIME"
                cell.set(stack: false)
                cell.rightLabel.text = "\(project!.allocatedProjectTime.intValue) DAYS"
                cell.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
                return cell
            case 6:
                let cell:TwoLabelCell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelCell") as! TwoLabelCell
                cell.leftLabel.text = "START DATE"
                cell.set(stack: false)
                cell.rightLabel.text = "\((task?.startDate as! Date).simpleDateString())"
                cell.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
                return cell
            case 7:
                let cell:TwoLabelCell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelCell") as! TwoLabelCell
                cell.leftLabel.text = "LAST DAY WORKED"
                cell.set(stack: false)
                cell.rightLabel.text = "\((task?.startDate as! Date).simpleDateString())"
                cell.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
                return cell
            default:
                break
            }

            return UITableViewCell()
        }
        else
        {
            let cell:UITableViewCell?
            let task = StageTask.getStageTask(forId: (data?[indexPath.row] as! NSNumber).intValue)
            if viewController.buttonStatus == .INVOICE_STATUS
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell")
                let invoices = ArchiveUtils.getInvoiceStatus(task: (task?.id.intValue)!)
                (cell as! StatusCell).setInvoices(invoices)
                (cell as! StatusCell).setIsEditing(editing: editing)
                (cell as! StatusCell).set(stack: false)
                (cell as! StatusCell).titleLabel.text = task?.name
            
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelCell")
                (cell as! TwoLabelCell).set(stack: true)
                (cell as! TwoLabelCell).set(stack: false)
                (cell as! TwoLabelCell).leftLabel.text = task?.name
  

                (cell as! TwoLabelCell).setIsEditing(editing: editing)
                if viewController.buttonStatus == .INCOME
                {
                    let num = ArchiveUtils.getEarned(task: (task?.id)!)
                    (cell as! TwoLabelCell).rightLabel.text = String(format: "$%.2f", num)

                }
                else if viewController.buttonStatus == .NUMBER_OF_PROJECTS
                {
                    (cell as! TwoLabelCell).rightLabel.text = "1"
                }
                else if viewController.buttonStatus == .DAYS_WORKED
                {
                    let num = ArchiveUtils.getDaysWorked(task: (task?.id)!)
                    (cell as! TwoLabelCell).rightLabel.text = "\(num) Days"

                }
                else if viewController.buttonStatus == .TOTAL_HOURS_WORKED
                {
                    let time = ArchiveUtils.getHoursWorked(task: (task?.id)!)
                    (cell as! TwoLabelCell).rightLabel.text = "\(time.0) HRS   \(time.1) MIN"
                }
            }
            cell?.selectionStyle = .none
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            cell?.backgroundColor = UIColor.cellBackgroundColor()
            return cell!
        }
    }

    


    func getAgencyCell(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell
    {
        if viewController.cellSelected
        {
            return UITableViewCell()
        }
        else
        {
            let cell:UITableViewCell?
            let agency = Agency.getAgency(forId: (data?[indexPath.row] as! NSNumber).intValue)
            if viewController.buttonStatus == .INVOICE_STATUS
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell")
                let invoices = ArchiveUtils.getInvoicesStatus(agency: (agency?.id.intValue)!)
                (cell as! StatusCell).setInvoices(invoices)
                (cell as! StatusCell).setIsEditing(editing: editing)
                
                if viewController.selectedStatus == .CLIENT && viewController.selectedAgency == nil
                {
                    (cell as! StatusCell).set(stack: true)
                    (cell as! StatusCell).stackClient.text = "\(agency!.name!)"
                    let a = Agency.getAgency(forId: (secondaryData?[indexPath.row] as! NSNumber).intValue)
                    (cell as! StatusCell).stackAgency.text = "\(a!.name!)"
                }
                else
                {
                    (cell as! StatusCell).set(stack: false)
                    (cell as! StatusCell).titleLabel.text = agency?.name
                }
                
                let num = invoices.0 + invoices.1 + invoices.2 + invoices.3
                if NSNumber(value:num).doubleValue >= highest.doubleValue && viewController.bottomView != nil
                {
                    viewController.bottomViewLabel?.text = "MOST INVOICED FOR: \(agency!.name!)"
                }
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelCell")
                if viewController.selectedStatus == .CLIENT && viewController.selectedAgency == nil
                {
                    (cell as! TwoLabelCell).set(stack: true)
                    (cell as! TwoLabelCell).stackClient.text = "\(agency!.name!)"
                    let a = Agency.getAgency(forId: (secondaryData?[indexPath.row] as! NSNumber).intValue)
                    (cell as! TwoLabelCell).stackAgency.text = "\(a!.name!)"
                }
                else
                {
                     (cell as! TwoLabelCell).set(stack: false)
                    (cell as! TwoLabelCell).leftLabel.text = agency?.name
                }
                (cell as! TwoLabelCell).setIsEditing(editing: editing)
                if viewController.buttonStatus == .INCOME
                {
                    let num = ArchiveUtils.getEarned(agency: (agency?.id)!, archived:true)
                    (cell as! TwoLabelCell).rightLabel.text = String(format: "$%.2f", num)
                    if NSNumber(value:num).doubleValue >= highest.doubleValue && viewController.bottomView != nil
                    {
                        viewController.bottomViewLabel?.text = "MOST EARNED FOR: \(agency!.name!)"
                    }
                }
                else if viewController.buttonStatus == .NUMBER_OF_PROJECTS
                {
                    let num = ArchiveUtils.getProjectWorked(agency: (agency?.id)!, archived:true)
                    (cell as! TwoLabelCell).rightLabel.text = "\(num)"
                    if NSNumber(value:num).doubleValue >= highest.doubleValue && viewController.bottomView != nil
                    {
                        viewController.bottomViewLabel?.text = "MOST PROJECTS WORKED FOR: \(agency!.name!)"
                    }
                }
                else if viewController.buttonStatus == .DAYS_WORKED
                {
                    let num = ArchiveUtils.getDaysWorked(agency: (agency?.id)!, archived:true)
                    (cell as! TwoLabelCell).rightLabel.text = "\(num) Days"
                    if NSNumber(value:num).doubleValue >= highest.doubleValue && viewController.bottomView != nil
                    {
                        viewController.bottomViewLabel?.text = "MOST DAYS WORKED FOR: \(agency!.name!)"
                    }
                }
                else if viewController.buttonStatus == .TOTAL_HOURS_WORKED
                {
                    let time = ArchiveUtils.getHoursWorked(agency: (agency?.id)!, archived:true)
                    let num = time.0 + (time.1/60)
                    (cell as! TwoLabelCell).rightLabel.text = "\(time.0) HRS   \(time.1) MIN"
                    if NSNumber(value:num).doubleValue >= highest.doubleValue && viewController.bottomView != nil
                    {
                        viewController.bottomViewLabel?.text = "MOST HOURS WORKED FOR: \(agency!.name!)"
                    }
                }
            }
            cell?.selectionStyle = .none
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
              cell?.backgroundColor = UIColor.cellBackgroundColor()
            return cell!
        }
    }
    
    
    func getProjectCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell:UITableViewCell?
        let project = Project.getProject(forId: (data?[indexPath.row] as! NSNumber).intValue)
        if viewController.buttonStatus == .INVOICE_STATUS
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell")
            let invoices = ArchiveUtils.getInvoicesStatus(proj: (project?.id.intValue)!)
            (cell as! StatusCell).setInvoices(invoices)
            (cell as! StatusCell).setIsEditing(editing: editing)
            
            if viewController.selectedStatus == .PROJECT && viewController.selectedClient == nil
            {
                (cell as! StatusCell).set(stack: true)
            (cell as! StatusCell).stackClient.text = "\(project!.name!)"
                let a = Agency.getAgency(forId: (secondaryData?[indexPath.row] as! NSNumber).intValue)
                (cell as! StatusCell).stackAgency.text = "\(a!.name!)"
            }
            else
            {
                (cell as! StatusCell).set(stack: false)
                (cell as! StatusCell).titleLabel.text = project?.name
            }
            
            let num = invoices.0 + invoices.1 + invoices.2 + invoices.3
            if NSNumber(value:num).doubleValue >= highest.doubleValue && viewController.bottomView != nil
            {
                viewController.bottomViewLabel?.text = "MOST INVOICED: \(project!.name!)"
            }
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelCell")
            if viewController.selectedStatus == .PROJECT && viewController.selectedClient == nil
                {
                (cell as! TwoLabelCell).set(stack: true)
                (cell as! TwoLabelCell).stackClient.text = "\(project!.name!)"
                let a = Agency.getAgency(forId: (secondaryData?[indexPath.row] as! NSNumber).intValue)
                (cell as! TwoLabelCell).stackAgency.text = "\(a?.name ?? "N/A")"
            }
            else
            {
                (cell as! TwoLabelCell).set(stack: false)
                (cell as! TwoLabelCell).leftLabel.text = project?.name
            }
            (cell as! TwoLabelCell).setIsEditing(editing: editing)
            if viewController.buttonStatus == .INCOME
            {
                let num = ArchiveUtils.getEarned(project: (project?.id)!, archived:true)
                (cell as! TwoLabelCell).rightLabel.text = String(format: "$%.2f", num)
                if NSNumber(value:num).doubleValue >= highest.doubleValue && viewController.bottomView != nil
                {
                    viewController.bottomViewLabel?.text = "MOST EARNED FOR: \(project!.name!)"
                }
            }
            else if viewController.buttonStatus == .NUMBER_OF_PROJECTS
            {
                (cell as! TwoLabelCell).rightLabel.text = "N/A"
                if viewController.bottomView != nil
                {
                        viewController.bottomViewLabel?.text = "MOST PROJECTS WORKED FOR: N/A)"
                }
            }
            else if viewController.buttonStatus == .DAYS_WORKED
            {
                let num = ArchiveUtils.getDaysWorked(project: (project?.id)!, archived:true)
                (cell as! TwoLabelCell).rightLabel.text = "\(num) Days"
                if NSNumber(value:num).doubleValue >= highest.doubleValue && viewController.bottomView != nil
                {
                    viewController.bottomViewLabel?.text = "MOST DAYS WORKED FOR: \(project!.name!)"
                }
            }
            else if viewController.buttonStatus == .TOTAL_HOURS_WORKED
            {
                let time = ArchiveUtils.getHoursWorked(project: (project?.id)!, archived:true)
                let num = time.0 + (time.1/60)
                (cell as! TwoLabelCell).rightLabel.text = "\(time.0) HRS   \(time.1) MIN"
                if NSNumber(value:num).doubleValue >= highest.doubleValue && viewController.bottomView != nil
                {
                    viewController.bottomViewLabel?.text = "MOST HOURS WORKED FOR: \(project!.name!)"
                }
            }
        }
        cell?.selectionStyle = .none
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
          cell?.backgroundColor = UIColor.cellBackgroundColor()
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame:CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        header.backgroundColor = UIColor(red: 87/255, green: 88/255, blue: 91/255, alpha: 1)
        
        let label = UILabel()
        label.font = UIFont().normalFont()
        label.textColor = UIColor.white
        if viewController.buttonStatus == .INCOME
        {
            label.text = "Total Income Earned"
        }
        if viewController.buttonStatus == .NUMBER_OF_PROJECTS
        {
            label.text = "Total Number of Projects"
        }
        if viewController.buttonStatus == .INVOICE_STATUS
        {
            label.text = "Invoice Status"
        }
        if viewController.buttonStatus == .TOTAL_HOURS_WORKED
        {
            label.text = "Total Hours Worked"
        }
        if viewController.buttonStatus == .DAYS_WORKED
        {
            label.text = "Total Days Worked"
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(label)
        header.addConstraint(NSLayoutConstraint(item: header, attribute: .centerY, relatedBy: .equal, toItem: label, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        header.addConstraint(NSLayoutConstraint(item: header, attribute: .trailing, relatedBy: .equal, toItem: label, attribute: .trailing, multiplier: 1.0, constant: 20.0))
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if editing
        {
            if cell is TwoLabelCell
            {
                (cell as! TwoLabelCell).selected()
            }
            else if cell is StatusCell
            {
                (cell as! StatusCell).selected()
            }
            if toDeleteSet.contains(indexPath.row) { toDeleteSet.remove(indexPath.row) }
            else
            {
                toDeleteSet.insert(indexPath.row)
            }
        }
        else
        {
            let agency = Agency.getAgency(forId: (data?[indexPath.row] as! NSNumber).intValue)
            viewController.cellSelected = true
            if viewController.selectedStatus == .AGENCY
            {
                viewController.selectedAgency = agency?.id.intValue
                viewController.clientTabPressed()
                
            }
            else if viewController.selectedStatus == .CLIENT
            {
                viewController.selectedClient = agency?.id.intValue
                viewController.projectTabPressed()
            }
            else if viewController.selectedStatus == .PROJECT
            {
                let project = Project.getProject(forId: (data?[indexPath.row] as! NSNumber).intValue)
                viewController.selectedProject = project?.id.intValue
                viewController.taskTabPressed()
            }
            else if viewController.selectedStatus == .TASK
            {
                let task = StageTask.getStageTask(forId:  (data?[indexPath.row] as! NSNumber).intValue)
                viewController.selectedTask = task?.id.intValue
                viewController.viewTaskDetails()
            }
        }
    }
    
    
    func unarhiveSelected()
    {
        for d in toDeleteSet
        {
            if viewController.selectedStatus == .PROJECT
            {
                let project = Project.getProject(forId: (data?[d] as! NSNumber).intValue)
                let tasks = StageTask.getAllArchivedTasksFor(project: (project?.id)!)
                project?.archived = false
                for t in tasks!
                {
                    t.archived = false
                    let timer = JobTimer.getTimerWithTask(id: t.id.intValue)
                    let invoice = Invoice.getInvoiceWith(jobId: (timer?.id)!)
                    if invoice != nil {
                        DataController.sharedInstance.managedObjectContext.delete(invoice!)

                    }
                     try! DataController.sharedInstance.managedObjectContext.save()
                    }
            }
            else
            {
                let task = StageTask.getStageTask(forId:(data?[d] as! NSNumber).intValue)
                task?.archived = false
                try! DataController.sharedInstance.managedObjectContext.save()
            }
        }
    }

    func deleteSelected()
    {
        for d in toDeleteSet
        {
            if viewController.selectedStatus == .AGENCY
            {
                let agency = Agency.getAgency(forId: (data?[d] as! NSNumber).intValue)
                let clients = ArchiveUtils.getClientsWith(agency: (agency?.id.intValue)!, thisYear: false)
                for c in clients
                {
                    let projects = ArchiveUtils.getProjectsWith(client: c.intValue, thisYear: false)
                    for p in projects
                    {
                        let tasks = ArchiveUtils.getTaskswith(project: p.intValue, thisYear: false)
                        for t in tasks
                        {
                            let task = StageTask.getStageTask(forId: t.intValue)
                            task?.archived = false
                            task?.wasDeleted = true
                        }
                    }
                }
            }
            else if viewController.selectedStatus == .CLIENT
            {
                let client = Agency.getClient(forId: (data?[d] as! NSNumber).intValue)
                let projects = ArchiveUtils.getProjectsWith(client: (client?.id.intValue)!, thisYear: false)
                for p in projects
                {
                    let tasks = ArchiveUtils.getTaskswith(project: p.intValue, thisYear: false)
                    for t in tasks
                    {
                        let task = StageTask.getStageTask(forId: t.intValue)
                        task?.wasDeleted = true
                        task?.archived = false
                    }
                }
            }
            else if viewController.selectedStatus == .PROJECT
            {
                let project = Project.getProject(forId: (data?[d] as! NSNumber).intValue)
                let tasks = ArchiveUtils.getTaskswith(project: (project?.id.intValue)!, thisYear: false)
                for t in tasks
                {
                    let task = StageTask.getStageTask(forId: t.intValue)
                    task?.wasDeleted = true
                    task?.archived = false
                }
            }
            else {
                let task = StageTask.getStageTask(forId: (data?[d] as! NSNumber).intValue)
                task?.wasDeleted = true
                task?.archived = false
            }
        }
        
      try!  DataController.sharedInstance.managedObjectContext.save()
    }
    
}
