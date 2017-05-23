//
//  DraftsPresenter.swift
//  Kronos
//
//  Created by Wee, David G. on 10/18/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

enum tableStatus:String
{
    case DAYS_WORKED = "TOTAL DAYS"
    case INCOME = "TOTAL INCOME"
    case HOURS_WORKED = "TOTAL HOURS"
    case INVOICE_STATUS = "INVOICE STATUS"
}


enum TableInvoice:String{
    case DRAFTS = "DRAFTS"
    case SENT = "SENT"
    case CLEARED = "CLEARED"
}

class DraftsPresenter:NSObject, UITableViewDelegate, UITableViewDataSource
{
    var currntTableStatus:tableStatus = .INCOME
    var view:InvoiceViewController?
    var invoices:[Invoice]!
    var tableInvoiceStatus:TableInvoice!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DratftsCell = tableView.dequeueReusableCell(withIdentifier: "DraftsCell") as! DratftsCell
        let timer = JobTimer.getTimerWith(id: invoices[indexPath.row].timerID.intValue)
        let task = StageTask.getStageTask(forId: (timer?.stageTaskId.intValue)!)
        let project = Project.getProject(forId: (task?.projectId.intValue)!)
        
        cell.leftBottomLabel.text = task?.name
        cell.leftTopLabel.text = project?.name
        cell.invoiceStatusView.isHidden = true
        cell.rightBottomLabel.isHidden = false
        cell.rightTopLabel.isHidden = false

        if currntTableStatus == .INCOME
        {
            let minPerRate = FeeRates.getRateWithId(id: (task?.feeRate.intValue)!).getRatePerMinute()
            let taskIncome = (JobTimer.getTimerWithTask(id: (task?.id.intValue)!)?.timeSpent.doubleValue)! / 60 * minPerRate
            cell.rightBottomLabel.text = "$\(String(format:"%.2f", taskIncome))"
        
            cell.rightTopLabel.text = "$\(String(format:"%.2f", InvoiceUtils.getTotalForProject(projectId: (project?.id.intValue)!)))"
            cell.hourLabelTop.isHidden = true
            cell.hourLabelBottom.isHidden = true
            
        }
        else if currntTableStatus == .HOURS_WORKED
        {
            let tasktime = InvoiceUtils.getTotalTimeWorked(task: task!)
            cell.rightBottomLabel.text = "\(tasktime.1) MIN"
            cell.hourLabelBottom.text = "\(tasktime.0) HR"
            let projectTime = InvoiceUtils.getTotalTimeWorked(project: project!)
            cell.rightTopLabel.text = "\(projectTime.1) MIN"
            cell.hourLabelTop.text = "\(projectTime.0) HR"
            cell.hourLabelTop.isHidden = false
            cell.hourLabelBottom.isHidden = false
        }
        else if currntTableStatus == .DAYS_WORKED
        {
            cell.rightBottomLabel.text = String(format:"%.2f DAYS", InvoiceUtils.getNumberOfDaysWorked(task: task!))
            cell.rightTopLabel.text = String(format:"%.2f DAYS", InvoiceUtils.getNumberOfDaysWorked(project: project!))
            cell.hourLabelTop.isHidden = true
            cell.hourLabelBottom.isHidden = true
        }
        else
        {
            cell.rightBottomLabel.isHidden = true
            cell.rightTopLabel.isHidden = true
            cell.invoiceStatusView.isHidden = false
            cell.invoiceStatusView.layer.cornerRadius = 15/2
            cell.hourLabelTop.isHidden = true
            cell.hourLabelBottom.isHidden = true
            if invoices[indexPath.row].status == "INVOICED"
            {
                cell.invoiceStatusView.backgroundColor = UIColor.invoicedColor()
            }
            else if invoices[indexPath.row].status == "OVERDUE"
            {
                cell.invoiceStatusView.backgroundColor = UIColor.invoicedOverdueColor()
            }
            else
            {
                cell.invoiceStatusView.backgroundColor = UIColor.invoicedCriticalColor()
            }
            
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame:CGRect(x: 0, y: 0, width: tableView.frame.size.width
            , height: 200 ))
        let titleLabel = UILabel()
        headerView.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont().headerFont()
        titleLabel.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
        titleLabel.text = "PROJECT / TASK"
        headerView.addSubview(titleLabel)
        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1.0, constant: -20.0))
        
        let subtitleLabel = UILabel()
        subtitleLabel.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont().headerFont()
        subtitleLabel.text = currntTableStatus.rawValue
        headerView.addSubview(subtitleLabel)
        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .centerY, relatedBy: .equal, toItem: subtitleLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: subtitleLabel, attribute: .trailing, multiplier: 1.0, constant: 20.0))
        
        var buttonArray = Array<UIButton>()
        
        var btnImageArray = ["btn-income-earned", "btn-hours-worked", "btn-days-worked"]
        if currntTableStatus == .INCOME
        {
            btnImageArray = ["btn-income-earned-selected", "btn-hours-worked", "btn-days-worked"]
        }
        else if currntTableStatus == .HOURS_WORKED
        {
            btnImageArray = ["btn-income-earned", "btn-hours-worked-selected", "btn-days-worked"]
        }
        else
        {
            btnImageArray = ["btn-income-earned", "btn-hours-worked", "btn-days-worked-selected"]
        }
        
        if tableInvoiceStatus == .SENT
        {
            btnImageArray.append("btn-invoice-status")
            if currntTableStatus == .INVOICE_STATUS
            {
                btnImageArray = ["btn-income-earned", "btn-hours-worked", "btn-days-worked", "btn-invoice-status-selected"]
            }
        }

        var count = 1
        for image in btnImageArray
        {
            let btn = UIButton()
            btn.tag = count
            count = count + 1
            btn.imageView?.contentMode = .scaleAspectFit
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.setImage(UIImage(named:image), for: .normal)
            buttonArray.append(btn)
            btn.addTarget(self, action: #selector(DraftsPresenter.buttonPressed(btn:)), for: .touchUpInside)
        }
        let stack = UIStackView(arrangedSubviews: buttonArray)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        if UIScreen().isiPhone6() || UIScreen().isiPhone6Plus() {
            stack.spacing = -2
        } else {
            stack.spacing = -10
        }

        headerView.addSubview(stack)
        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .centerX, relatedBy: .equal, toItem: stack, attribute: .centerX, multiplier: 1.0, constant: 0.0))
         headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .centerY, relatedBy: .equal, toItem: stack, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: stack, attribute: .height, multiplier: 1, constant: 0.0))
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if UIScreen().isiPhone6() || UIScreen().isiPhone6Plus()
        {
            return 30.93
        }
        else
        {
            return 26.04
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let invoice = invoices[indexPath.row]
        view?.invoiceSelected = invoice
        view?.fromOtherTab = true
        view?.changeSection(section: 3)
        view?.summaryButton.titleLabel?.alpha = 1.0
        view?.timingsButton.titleLabel?.alpha = 1.0

    }

    func buttonPressed(btn:UIButton)
    {
        if btn.tag == 1
        {
            currntTableStatus = .INCOME
        }
        else if btn.tag == 2
        {
            currntTableStatus = .HOURS_WORKED
        }
        else if btn.tag == 3
        {
            currntTableStatus = .DAYS_WORKED
        }
        else {
            currntTableStatus = .INVOICE_STATUS
        }
        view?.tableView.reloadData()
    }
}
