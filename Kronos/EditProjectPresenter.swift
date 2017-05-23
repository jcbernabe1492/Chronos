//
//  EditProjectPresenter.swift
//  Kronos
//
//  Created by Wee, David G. on 9/20/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

class EditProjectPresenter :NSObject,  EditProjectPresenterProtocol
{
    var view: UITableView?
    var tableData:StageTask?
    var fees:NSArray?
    var loadTimerView:LoadTimerViewControllerProtocol?
    var loadTimerPresenter:LoadTimerPresenter?
    
    
    var agencyName:UITextField?
    var clientName:UITextField?
    var projectName:UITextField?
    var stageTaskName:UITextField?
    var feeName:UITextField?
    var projectTime:UITextField?
    var taskTime:UITextField?
    var referenceName:UITextField?
    
    var defualtButton:UIButton?
    var customButton:UIButton?
    
    var tempAgencyName = ""
    var tempClientName = ""
    var tempProjectName = ""
    var tempStageTaskName = ""
    var tempFeeRate = ""
    var tempProjectTime = ""
    var tempTaskTime = ""
    var tempReference = ""
    
    
    func addNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(AddTimerPresenter.keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddTimerPresenter.keyboardWasHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fees != nil
        {
            return (fees?.count)!-1
        }
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell?

        if fees != nil
        {
            cell = UITableViewCell()
            let feeRate = fees?[indexPath.row] as! FeeRates
            cell?.textLabel?.text = feeRate.name!
            cell?.textLabel?.font = UIFont().normalFont()
            cell?.backgroundColor = UIColor.black
            cell?.textLabel?.textColor = UIColor.white
            cell?.selectionStyle = .none
            
        }
        else
        {
            switch (indexPath.row)
            {
            case 0:
                var projectAgencyName:String = "Agency Name"
                let project = Project.getProject(forId: (tableData?.projectId.intValue)!)
                if let agency = Agency.getAgency(forId: project?.agencyId as! Int)
                {
                    projectAgencyName = agency.name!
                    tempAgencyName = agency.name!
                }
                cell = createTextCell(title: "AGENCY", enterText: projectAgencyName)
                agencyName = (cell as! AddTimerEnterTextCell).enterText
                (cell as! AddTimerEnterTextCell).setKeyboardCharacters()
                break
            case 1:
                var projectClientName:String = "Client Name"
                let project = Project.getProject(forId: (tableData?.projectId.intValue)!)
                if let client = Agency.getClient(forId: project?.clientId as! Int)
                {
                    projectClientName = client.name!
                    tempClientName = client.name!
                }
            
                cell = createTextCell(title: "CLIENT", enterText: projectClientName)
                (cell as! AddTimerEnterTextCell).row = indexPath.row
                clientName = (cell as! AddTimerEnterTextCell).enterText
                (cell as! AddTimerEnterTextCell).setKeyboardCharacters()
                break
            case 2:
       
                let project = Project.getProject(forId: (tableData?.projectId.intValue)!)
                cell = createTextCell(title: "PROJECT", enterText: (project?.name)!)
                tempProjectName = (project?.name)!
                projectName = (cell as! AddTimerEnterTextCell).enterText
                (cell as! AddTimerEnterTextCell).row = indexPath.row
                (cell as! AddTimerEnterTextCell).setKeyboardCharacters()
                break
            case 3:
                cell = createTextCell(title: "STAGE / TASK", enterText: (tableData?.name)!)
                tempStageTaskName = (tableData?.name)!
                stageTaskName = (cell as! AddTimerEnterTextCell).enterText
                (cell as! AddTimerEnterTextCell).setKeyboardCharacters()
                (cell as! AddTimerEnterTextCell).row = indexPath.row
                break
            case 4:
            
                cell = AddTimerOptionCell()
                cell?.backgroundColor = UIColor.black
                let title = UILabel(medium: false)
                title.translatesAutoresizingMaskIntoConstraints = false
                title.textColor = UIColor.white
                title.text = "FEE RATE"
                cell?.addSubview(title)
                cell?.addConstraint(NSLayoutConstraint(item: cell!, attribute: .centerY, relatedBy: .equal, toItem: title, attribute: .centerY, multiplier: 1.0, constant: 0.0))
                cell?.addConstraint(NSLayoutConstraint(item: cell!, attribute: .leading, relatedBy: .equal, toItem: title, attribute: .leading, multiplier: 1.0, constant: -20.0))
                
            
                let customOption = UIButton(medium: true)
    
               
                customOption.translatesAutoresizingMaskIntoConstraints = false
                if tableData?.feeRate == -1
                {
                    customOption.setTitle("CUSTOM", for: .normal)
                }
                else
                {
                    let fee = FeeRates.getRateWithId(id: (tableData?.feeRate.intValue)!)
                    customOption.setTitle(fee.name, for: .normal)
                    
                }
                customOption.titleLabel?.textColor = UIColor.white
                customOption.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                cell?.addSubview(customOption)
                cell?.addConstraint(NSLayoutConstraint(item: cell!, attribute: .centerY, relatedBy: .equal, toItem: customOption, attribute: .centerY, multiplier: 1.0, constant: 0.0))
                cell?.addConstraint(NSLayoutConstraint(item: cell!, attribute: .trailing, relatedBy: .  equal, toItem: customOption, attribute: .trailing, multiplier: 1.0, constant: 20.0))
                customOption.addTarget(self, action: #selector(EditProjectPresenter.customButtonPressed), for: .touchUpInside)
                self.customButton = customOption
                let defaultOption = UIButton(medium: false)
      
                defaultOption.translatesAutoresizingMaskIntoConstraints = false
                defaultOption.setTitle("DEFAULT", for: .normal)
                defaultOption.titleLabel?.textColor = UIColor.white
                defaultOption.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                cell?.addSubview(defaultOption)
                cell?.addConstraint(NSLayoutConstraint(item: cell!, attribute: .centerY, relatedBy: .equal, toItem: defaultOption, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            
                cell?.addConstraint(NSLayoutConstraint(item: customOption, attribute: .leading, relatedBy: .equal, toItem: defaultOption, attribute: .trailing, multiplier: 1.0, constant: 20.0))
            
                (cell as! AddTimerOptionCell).title = title
                (cell as! AddTimerOptionCell).option1 = defaultOption
                (cell as! AddTimerOptionCell).option2 = customOption
                defaultOption.addTarget(self, action: #selector(EditProjectPresenter.defaultButtonPressed), for: .touchUpInside)
                self.defualtButton = defaultOption
            
                if tableData?.feeRate == -1
                {
                    defaultOption.backgroundColor = UIColor.white
                    defaultOption.setTitleColor(UIColor.black, for: .normal)
                }
                else
                {
                    customOption.backgroundColor = UIColor.white
                    customOption.setTitleColor(UIColor.black, for: .normal)
                }
                cell?.selectionStyle = .none
                break
            case 5:

                let project = Project.getProject(forId: (tableData?.projectId.intValue)!)
                cell = createTextCell(title: "ALLOCATE PROJECT TIME", enterText: "\(project!.allocatedProjectTime) HOURS")
                tempProjectTime = "\(project!.allocatedProjectTime)"
                projectTime = (cell as! AddTimerEnterTextCell).enterText
                (cell as! AddTimerEnterTextCell).setKeyboardNumeric()
                (cell as! AddTimerEnterTextCell).row = indexPath.row
                break
            case 6:

                cell = createTextCell(title: "ALLOCATE TASK TIME", enterText: "\(tableData!.allocatedTaskTime) HOURS")
            
                taskTime = (cell as! AddTimerEnterTextCell).enterText
                tempTaskTime = "\(tableData!.allocatedTaskTime)"
                (cell as! AddTimerEnterTextCell).setKeyboardNumeric()
                (cell as! AddTimerEnterTextCell).row = indexPath.row
                break
            case 7:
                var ref = "ENTER HERE"
                if let referene  = tableData?.reference
                {
                    if referene != ""
                    {
                        ref = referene
                    }
                }
                cell = createTextCell(title: "REFERENCE", enterText: ref)
                referenceName = (cell as! AddTimerEnterTextCell).enterText
                (cell as! AddTimerEnterTextCell).setKeyboardCharacters()
                (cell as! AddTimerEnterTextCell).row = indexPath.row
            default:
                cell = UITableViewCell()
            }
        }
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
        
        return cell!
    }
    
    func createTextCell(title:String, enterText:String) -> AddTimerEnterTextCell
    {
        let cell = AddTimerEnterTextCell()
        let titleLabel = UILabel(medium:false)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        
        titleLabel.textColor = UIColor.white
        cell.addSubview(titleLabel)
        cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1.0, constant: -20.0))
        cell.backgroundColor = UIColor.clear
        cell.title = titleLabel
        let enterTextField = UITextField()
        enterTextField.translatesAutoresizingMaskIntoConstraints = false
        enterTextField.text = enterText
        enterTextField.font = UIFont().boldFont()
        enterTextField.textColor = UIColor.white
        enterTextField.borderStyle = .none
        cell.addSubview(enterTextField)
        cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: enterTextField, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .trailing, relatedBy: .equal, toItem: enterTextField, attribute: .trailing, multiplier: 1.0, constant: 20.0))
        cell.addConstraint(NSLayoutConstraint(item: enterTextField, attribute: .width, relatedBy: .equal, toItem: cell, attribute: .width, multiplier: 0.5, constant: 0.0))
        enterTextField.textAlignment = .right
        cell.enterText = enterTextField
        cell.selectionStyle = .none
        cell.setupIfNeeded()
        cell.fromOtherModule = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame:CGRect.zero)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if fees != nil
        {
            let feerate = fees![indexPath.row] as! FeeRates
            tableData?.feeRate = feerate.id
            try! DataController.sharedInstance.managedObjectContext.save()
            fees = nil
            view?.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        header.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "EDIT JOB INFO"
        titleLabel.font = UIFont().headerFont()
        titleLabel.textColor = UIColor.cellBackgroundColor()
        header.addSubview(titleLabel)
        header.addConstraint(NSLayoutConstraint(item: header, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        header.addConstraint(NSLayoutConstraint(item: header, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1.0, constant: -20.0))
        
        let okayButton = UIButton()
        okayButton.translatesAutoresizingMaskIntoConstraints = false
        okayButton.setImage(UIImage(named:"btn-okay"), for: .normal)
        header.addSubview(okayButton)
        header.addConstraint(NSLayoutConstraint(item: header, attribute: .centerY, relatedBy: .equal, toItem: okayButton, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        header.addConstraint(NSLayoutConstraint(item: header, attribute: .trailing, relatedBy: .equal, toItem: okayButton, attribute: .trailing, multiplier: 1.0, constant: 20.0))
        header.addConstraint(NSLayoutConstraint(item: okayButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0))
        header.addConstraint(NSLayoutConstraint(item: okayButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0))
        
        okayButton.addTarget(self, action: #selector(EditProjectPresenter.okayButtonPressed), for: .touchUpInside)
        
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(UIImage(named:"btn-x"), for: .normal)
        header.addSubview(cancelButton)
        header.addConstraint(NSLayoutConstraint(item: header, attribute: .centerY, relatedBy: .equal, toItem: cancelButton, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        header.addConstraint(NSLayoutConstraint(item: okayButton, attribute: .leading, relatedBy: .equal, toItem: cancelButton, attribute: .trailing, multiplier: 1.0, constant: 10.0))
        header.addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0))
        header.addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0))
        cancelButton.addTarget(self, action: #selector(EditProjectPresenter.cancelButtonPressed), for: .touchUpInside)
        
        
        return header
        
    }
    
    func okayButtonPressed()
    {
        let project = Project.getProject(forId: (tableData?.projectId.intValue)!)
        let agency = Agency.getAgency(forId: (project?.agencyId.intValue)!)
        let client = Agency.getClient(forId: (project?.clientId.intValue)!)
        
        let task = tableData
       
        if tempAgencyName != "Agency Name"
        {
            if agency == nil
            {
                let tempAgency = Agency.tempAgency()
                tempAgency.id = NSNumber(value: Agency.getNewAgencyID())
                tempAgency.name = agencyName?.text
                tempAgency.isAgency = true
                DataController.sharedInstance.addAgency(tempAgency: tempAgency, isAgency: true)
                project?.agencyId = tempAgency.id
               
            }
            else if agency?.name != agencyName?.text
            {
                agency?.name = agencyName?.text
            }
        }
        
        if tempClientName != "Client Name"
        {
            if client == nil
            {
                let tempClient = Agency.tempAgency()
                tempClient.id = NSNumber(value: Agency.getNewAgencyID())
                tempClient.name = clientName?.text
                tempClient.isAgency = false
                DataController.sharedInstance.addAgency(tempAgency: tempClient, isAgency: false)
                project?.clientId = tempClient.id
                
            }
            else if client?.name != clientName?.text
            {
                client?.name = clientName?.text
            }
        }

        if project?.name != projectName?.text!
        {
            project?.name = projectName?.text
        }
        if task?.name != stageTaskName?.text
        {
            task?.name = stageTaskName?.text
        }
        
        if project?.allocatedProjectTime != NSNumber(value: Int((projectTime?.text?.components(separatedBy: " ").first)!)!)
        {
            project?.allocatedProjectTime = NSNumber(value: Int((projectTime?.text?.components(separatedBy: " ").first)!)!)
        }
        
        if task?.allocatedTaskTime != NSNumber(value: Int((taskTime?.text?.components(separatedBy: " ").first)!)!)
        {
            task?.allocatedTaskTime = NSNumber(value: Int((taskTime?.text?.components(separatedBy: " ").first)!)!)
        }
        
        if task?.reference == nil || task?.reference != referenceName?.text
        {
            task?.reference = (referenceName?.text)!
        }
        try! DataController.sharedInstance.managedObjectContext.save()
        cancelButtonPressed()
    }
    
    func cancelButtonPressed()
    {
        loadTimerPresenter?.isEditing = false
        loadTimerPresenter?.doneEditing()
        view?.removeFromSuperview()
        view = nil
        loadTimerView?.reloadTable()
    }
    
    func customButtonPressed()
    {
        defualtButton?.backgroundColor = UIColor.clear
        defualtButton?.setTitleColor(UIColor.white, for: .normal)
        customButton?.backgroundColor = UIColor.white
        customButton?.setTitleColor(UIColor.black, for: .normal)
        fees = getFeeCells()
        view?.reloadData()
    }
    
    func defaultButtonPressed()
    {
        customButton?.backgroundColor = UIColor.clear
        customButton?.setTitleColor(UIColor.white, for: .normal)
        defualtButton?.backgroundColor = UIColor.white
        defualtButton?.setTitleColor(UIColor.black, for: .normal)
        let feeRate = FeeRates.getRateWithId(id: Int(UserDefaults.standard.value(forKey: "defaultDayRate") as! String)!)
        tableData?.feeRate = feeRate.id
        try! DataController.sharedInstance.managedObjectContext.save()
        fees = nil
    }
    
    func getFeeCells() -> NSMutableArray {
        var feeRates = FeeRates.getDefaultRates()
        feeRates.append(contentsOf: FeeRates.getCustomRates())
        return NSMutableArray(array: feeRates)
    }
    
    
    func keyboardWasShown(notif:Notification)
    {
        let info = notif.userInfo
        let size = (info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        loadTimerView?.moveTable(up: true, keyboardSize: size.height)

        loadTimerPresenter?.editProjectTableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 400, right: 0)
    }
    
    func keyboardWasHidden(notif:Notification)
    {
        loadTimerView?.moveTable(up: false, keyboardSize: 0)
        loadTimerPresenter?.editProjectTableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    
    
}
