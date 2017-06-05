//
//  AddTimerPresenter.swift
//  Kronos
//
//  Created by Wee, David G. on 9/5/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

class AddTimerPresenter: NSObject, AddTimerPresenterProtocol
{
    weak var addTimerPresenterOutput: AddTimerOutputMethods?

    var interactor: AddTimerInteractorInput?
    var view: AddTimerViewControllerProtocol?
    var wireframe: AddTimerWireframeProtocol?

    var tableData:NSMutableArray?
    var currentSection:ExpandableItem?
    var selectedCell:UITableViewCell?
    
    var tempProject:Project?
    var tempTask:StageTask?
    var tempTimer:JobTimer?
    
    func viewDidLoad()
    {
        
        tableData = interactor?.getCellsForAddTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddTimerPresenter.keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddTimerPresenter.keyboardWasHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        setupTemps()

    }
    
    func setupTemps()
    {
        tempProject = Project.tempProject()
        tempTask = StageTask.tempStageTask()
        tempTask?.wasDeleted = false
        tempTask?.feeRate = NSNumber(value: Int(UserDefaults.standard.value(forKey: "defaultDayRate") as! String)!)
        tempTimer = JobTimer.tempTimer()
        tempTimer?.id = NSNumber(value: JobTimer.getNewTimerID())
    }
    
    
    //MARK: - UITableViewDelegate and Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentSection == .STAGE_TASK
        {
            return StageTask.getUniqueTaskNames().count
        }
        return tableData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if currentSection == nil
        {
            wireframe?.getHomeViewController().setSaveButtonEnabled(enabled: true)
        }
        else
        {
            wireframe?.getHomeViewController().setSaveButtonEnabled(enabled: false)
        }
        let cellInfo = tableData?[indexPath.row] as? NSDictionary
        var identifier = cellInfo?.value(forKey: "TYPE")
        if identifier == nil
        {
            identifier = "ENTER_TEXT"
        }
        let cell:UITableViewCell?
        if identifier as! String == "EXPANDABLE"
        {
            cell = tableView.dequeueReusableCell(withIdentifier: identifier as! String)
            (cell as! ExpandableCell).title?.text = cellInfo?.value(forKey: "TITLE") as? String
            
            if cellInfo?.value(forKey: "TEXT") as? String == "REQUIRED"
            {
                (cell as! ExpandableCell).subtitle?.textColor = UIColor.red
            }
            else
            {
                (cell as! ExpandableCell).subtitle?.textColor = UIColor.white
            }
            
            if cellInfo?.value(forKey: "TITLE") as? String == "AGENCY"
            {
                if (tempProject?.agencyId.int64Value)! > 0
                {
                    (cell as! ExpandableCell).subtitle?.text = interactor?.getAgency(forId: Int((tempProject?.agencyId)!))?.name
                }
                else
                {
                    (cell as! ExpandableCell).subtitle?.text = cellInfo?.value(forKey: "TEXT") as? String
                }
            }
            else if cellInfo?.value(forKey: "TITLE") as? String == "CLIENT"
            {
                if (tempProject?.clientId.int64Value)! > 0
                {
                    (cell as! ExpandableCell).subtitle?.text = interactor?.getAgency(forId: Int((tempProject?.clientId)!))?.name
                }
                else
                {
                    (cell as! ExpandableCell).subtitle?.text = cellInfo?.value(forKey: "TEXT") as? String
                }
            }
                
                
            else if cellInfo?.value(forKey: "TITLE") as? String == "PROJECT"
            {
                if (tempProject?.id.int64Value)! > 0
                {
                    (cell as! ExpandableCell).subtitle?.text = tempProject?.name
                    
                }
                else
                {
                    (cell as! ExpandableCell).subtitle?.text = cellInfo?.value(forKey: "TEXT") as? String
                    (cell as! ExpandableCell).checkText()
                }

                
            }
            else if cellInfo?.value(forKey: "TITLE") as? String == "STAGE / TASK"
            {
                if (tempTask?.id.int64Value)! > 0
                {
                    (cell as! ExpandableCell).subtitle?.text = tempTask?.name
                }
                else
                {
                    (cell as! ExpandableCell).subtitle?.text = cellInfo?.value(forKey: "TEXT") as? String
                    (cell as! ExpandableCell).checkText()
                }
            }

           
            (cell as! ExpandableCell).presenter = self
            if cellInfo?.value(forKey: "IMAGE") as! Bool == false
            {
                (cell as! ExpandableCell).plusImage?.isHidden = true
                (cell as! ExpandableCell).leadingSpace?.constant = -10
            }
            else
            {
                (cell as! ExpandableCell).plusImage?.isHidden = false
                (cell as! ExpandableCell).leadingSpace?.constant = 20
            }
            
        }
        else if identifier as! String == "OPTIONS"
        {

            
            cell = tableView.dequeueReusableCell(withIdentifier: identifier as! String)
            (cell as! AddTimerOptionCell).title?.text = cellInfo?.value(forKey: "TITLE") as? String
            if (cell as! AddTimerOptionCell).title?.text == "FEE RATE"
            {
                (cell as! AddTimerOptionCell).presenter = self
            }
            let options = cellInfo?.value(forKey: "OPTIONS") as? NSArray
            (cell as! AddTimerOptionCell).option1?.setTitle(options?[0] as? String, for: .normal)
            if tempTask?.feeRate == nil || (tempTask?.feeRate.intValue)! <= 9
            {
                (cell as! AddTimerOptionCell).option2?.setTitle(options?[1] as? String, for: .normal)
                (cell as! AddTimerOptionCell).setDefault()
            }else
            {
                let rate:FeeRates = FeeRates.getRateWithId(id: (tempTask?.feeRate.intValue)!)
                (cell as! AddTimerOptionCell).option2?.setTitle(rate.name, for: .normal)
            }
        }
        
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "ENTER_TEXT")
            if currentSection == .AGENCY || currentSection == .CLIENT
            {
                (cell as! AddTimerEnterTextCell).title?.text = (tableData?[indexPath.row] as! Agency).name
                (cell as! AddTimerEnterTextCell).enterText?.text = ""
                (cell as! AddTimerEnterTextCell).enterText?.isUserInteractionEnabled = false
            }
            else if currentSection == .PROJECT
            {
                (cell as! AddTimerEnterTextCell).title?.text = (tableData?[indexPath.row] as! Project).name
                (cell as! AddTimerEnterTextCell).enterText?.text = ""
                (cell as! AddTimerEnterTextCell).enterText?.isUserInteractionEnabled = false
             
            }
            else if currentSection == .STAGE_TASK
            {
                let stageTasks = StageTask.getUniqueTaskNames()
                let taskArray = Array(stageTasks)
                (cell as! AddTimerEnterTextCell).title?.text = taskArray[indexPath.row]
                (cell as! AddTimerEnterTextCell).enterText?.text = ""
                (cell as! AddTimerEnterTextCell).enterText?.isUserInteractionEnabled = false
                
            }
            else if currentSection == .FEES
            {
                let rate:FeeRates = tableData?[indexPath.row] as! FeeRates
                (cell as! AddTimerEnterTextCell).title?.text = rate.name
                (cell as! AddTimerEnterTextCell).enterText?.text = "\(rate.fee)"
                (cell as! AddTimerEnterTextCell).enterText?.isUserInteractionEnabled = false
                
            }
            else
            {
                (cell as! AddTimerEnterTextCell).row = indexPath.row
                                (cell as! AddTimerEnterTextCell).enterText?.isUserInteractionEnabled = true
                (cell as! AddTimerEnterTextCell).tableData = tableData
                (cell as! AddTimerEnterTextCell).title?.text = cellInfo?.value(forKey: "TITLE") as? String
                (cell as! AddTimerEnterTextCell).enterText?.text = cellInfo?.value(forKey: "TEXT") as? String
                (cell as! AddTimerEnterTextCell).presenter = self
                if cellInfo?.value(forKey: "TEXT") as? String == "REQUIRED"
                {
                    (cell as! AddTimerEnterTextCell).enterText?.textColor = UIColor.red
                }
                else
                {
                    (cell as! AddTimerEnterTextCell).enterText?.textColor = UIColor.white
                }
                
                if cellInfo?.value(forKey: "TITLE") as? String == "TASK ORDER"
                {
                    (cell as! AddTimerEnterTextCell).setUpPicker()
                }
                else
                {
                    (cell as! AddTimerEnterTextCell).enterText?.inputView = nil
                }
                
                if (cell as! AddTimerEnterTextCell).title?.text == "ALLOCATE PROJECT TIME" ||  (cell as! AddTimerEnterTextCell).title?.text == "ALLOCATE TASK TIME"
                {
                    (cell as! AddTimerEnterTextCell).setKeyboardNumeric()
                }else
                {
                    (cell as! AddTimerEnterTextCell).setKeyboardCharacters()
                }
            }
        }
        cell!.backgroundColor = UIColor.cellBackgroundColor()
        cell!.preservesSuperviewLayoutMargins = false
        cell!.separatorInset = UIEdgeInsets.zero
        cell!.layoutMargins = UIEdgeInsets.zero
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView(frame:CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 25))
        header.backgroundColor = UIColor.tableHeaderColor()
        
        let title  = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "NEW TIMER"
        if currentSection == .AGENCY
        {
            title.text = "NEW TIMER > SELECT AGENCY"
        }
        else if currentSection == .ADD_AGENCY
        {
            title.text = "NEW TIMER > ADD AGENCY"
        }
        else if currentSection == .CLIENT
        {
            title.text = "NEW TIMER > SELECT CLIENT"
        }
        else if currentSection == .ADD_CLIENT
        {
            title.text = "NEW TIMER > ADD CLIENT"
        }
        else if currentSection == .PROJECT
        {
            title.text = "NEW TIMER > SELECT PROJECT"
        }
        else if currentSection == .ADD_PROJECT
        {
            title.text = "NEW TIMER > ADD PROJECT"
        }
        else if currentSection == .STAGE_TASK
        {
            title.text = "NEW TIMER > SELECT TASK"
        }
        else if currentSection == .ADD_STAGE_TASK
        {
             title.text = "NEW TIMER > ADD TASK"
        }
        title.font = UIFont(name: "NeoSans-Medium", size: 10)
        title.textColor = UIColor.cellBackgroundColor()
        header.addSubview(title)
        header.addConstraint(NSLayoutConstraint(item: header, attribute: .leading, relatedBy: .equal, toItem: title, attribute: .leading, multiplier: 1.0, constant: -20.0))
        header.addConstraint(NSLayoutConstraint(item: header, attribute: .centerY, relatedBy: .equal, toItem: title, attribute: .centerY, multiplier: 1.0, constant: -1.0))
       header.addConstraint(NSLayoutConstraint(item: title, attribute: .width, relatedBy: .equal, toItem: header, attribute: .width, multiplier: 0.44, constant: 0.0))
        
        let btn = UIButton()
        btn.setImage(UIImage(named:"btn-x"), for: .normal)
        btn.addTarget(self, action: #selector(AddTimerPresenter.closeAddTimerView), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(btn)
        if currentSection != nil && (currentSection != .AGENCY && currentSection != .CLIENT && currentSection != .PROJECT && currentSection != .STAGE_TASK && currentSection != .FEES)
        {
             header.addConstraint(NSLayoutConstraint(item: btn, attribute: .trailing, relatedBy: .equal, toItem: header, attribute: .trailing, multiplier: 1.0, constant: -50))
        }
        else
        {
            header.addConstraint(NSLayoutConstraint(item: btn, attribute: .trailing, relatedBy: .equal, toItem: header, attribute: .trailing, multiplier: 1.0, constant: -20))
        }
        header.addConstraint(NSLayoutConstraint(item: btn, attribute: .centerY, relatedBy: .equal, toItem: header, attribute: .centerY, multiplier: 1.0, constant: 0))
        header.addConstraint(NSLayoutConstraint(item: btn, attribute: .top, relatedBy: .equal, toItem: header, attribute: .top, multiplier: 1.0, constant: 0))
        header.addConstraint(NSLayoutConstraint(item: btn, attribute: .bottom, relatedBy: .equal, toItem: header, attribute: .bottom, multiplier: 1.0, constant: 0))
        header.addConstraint(NSLayoutConstraint(item: btn, attribute: .width, relatedBy: .equal, toItem: btn, attribute: .height, multiplier: 1.0, constant: 0))
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
     
        if currentSection != nil && (currentSection != .AGENCY && currentSection != .CLIENT && currentSection != .PROJECT && currentSection != .STAGE_TASK && currentSection != .FEES)
        {
            let btn = UIButton()
            btn.setImage(UIImage(named:"btn-okay"), for: .normal)
            btn.addTarget(self, action: #selector(AddTimerPresenter.saveCurrent), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
            header.addSubview(btn)
            header.addConstraint(NSLayoutConstraint(item: btn, attribute: .trailing, relatedBy: .equal, toItem: header, attribute: .trailing, multiplier: 1.0, constant: -20))
            header.addConstraint(NSLayoutConstraint(item: btn, attribute: .centerY, relatedBy: .equal, toItem: header, attribute: .centerY, multiplier: 1.0, constant: 0))
            header.addConstraint(NSLayoutConstraint(item: btn, attribute: .top, relatedBy: .equal, toItem: header, attribute: .top, multiplier: 1.0, constant: 0))
            header.addConstraint(NSLayoutConstraint(item: btn, attribute: .bottom, relatedBy: .equal, toItem: header, attribute: .bottom, multiplier: 1.0, constant: 0))
            header.addConstraint(NSLayoutConstraint(item: btn, attribute: .width, relatedBy: .equal, toItem: btn, attribute: .height, multiplier: 1.0, constant: 0))
            btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            
        }
        else if currentSection == .AGENCY || currentSection == .CLIENT || currentSection == .PROJECT || currentSection == .STAGE_TASK
        {
            let btn = UIButton()
            btn.setImage(UIImage(named:"btn-add"), for: .normal)
            btn.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
            header.addSubview(btn)
            header.addConstraint(NSLayoutConstraint(item: btn, attribute: .trailing, relatedBy: .equal, toItem: header, attribute: .trailing, multiplier: 1.0, constant: -45))
            header.addConstraint(NSLayoutConstraint(item: btn, attribute: .centerY, relatedBy: .equal, toItem: header, attribute: .centerY, multiplier: 1.0, constant: 0))
            header.addConstraint(NSLayoutConstraint(item: btn, attribute: .top, relatedBy: .equal, toItem: header, attribute: .top, multiplier: 1.0, constant: 0))
            header.addConstraint(NSLayoutConstraint(item: btn, attribute: .bottom, relatedBy: .equal, toItem: header, attribute: .bottom, multiplier: 1.0, constant: 0))
            header.addConstraint(NSLayoutConstraint(item: btn, attribute: .width, relatedBy: .equal, toItem: btn, attribute: .height, multiplier: 1.0, constant: 0))
            btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
        
        return header
    }
    
    func addButtonPressed()
    {
        if currentSection == .AGENCY
        {
            expandToItem(cell: .ADD_AGENCY)
        }
        else if currentSection == .CLIENT
        {
            expandToItem(cell: .ADD_CLIENT)
        }
        else if currentSection == .PROJECT
        {
            expandToItem(cell: .ADD_PROJECT)
        }
        else if currentSection == .STAGE_TASK
        {
            expandToItem(cell: .ADD_STAGE_TASK)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if UIScreen().isiPhone6() || UIScreen().isiPhone6Plus()
        {
            return 35
        }
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    func selectedTableView(cell:UITableViewCell)
    {
        selectedCell = cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell is ExpandableCell
        {
            if (cell as! ExpandableCell).title?.text == "AGENCY"
            {
                expandToItem(cell: .AGENCY)
            }else if (cell as! ExpandableCell).title?.text == "CLIENT"
            {
                expandToItem(cell: .CLIENT)
            }else if (cell as! ExpandableCell).title?.text == "PROJECT"
            {
                expandToItem(cell: .PROJECT)
            }else if (cell as! ExpandableCell).title?.text == "STAGE / TASK"
            {
                expandToItem(cell: .STAGE_TASK)
            }
            wireframe?.getHomeViewController().setSaveButtonEnabled(enabled: false)
        }
        else if cell is AddTimerOptionCell
        {
                expandToItem(cell: .FEES)
                wireframe?.getHomeViewController().setSaveButtonEnabled(enabled: false)
            
        }
        else
        {
            if currentSection == .AGENCY
            {
                let id = (tableData?[indexPath.row] as! Agency).id
                tempProject?.agencyId = id
                closeAddTimerView()
            }
            if currentSection == .CLIENT
            {
                let id = (tableData?[indexPath.row] as! Agency).id
                tempProject?.clientId = id
                closeAddTimerView()
            }
            if currentSection == .PROJECT
            {
                let id = (tableData?[indexPath.row] as! Project).id
                let agencyId = (tableData?[indexPath.row] as! Project).agencyId
                let clientId = (tableData?[indexPath.row] as! Project).clientId
                tempTask?.projectId = id
                tempProject?.id = id
                tempProject?.name = (tableData?[indexPath.row] as! Project).name
                tempProject?.agencyId = agencyId
                tempProject?.clientId = clientId
                
                closeAddTimerView()
            }
            if currentSection == .STAGE_TASK
            {
                let taskArray = Array(StageTask.getUniqueTaskNames())
                let name = taskArray[indexPath.row]
                tempTask?.id = NSNumber(value: StageTask.getNextStageTaskId())
                tempTask?.name = name
                tempTask?.order = (tableData?[indexPath.row] as! StageTask).order
                closeAddTimerView()
            }
            if currentSection == .FEES
            {
                tempTask?.feeRate = (tableData?[indexPath.row] as! FeeRates).id
                closeAddTimerView()
            }
        }
    }

    func canSaveTimer() -> Bool  {
        if tempProject?.id == 0 || tempTask?.id == 0
        {
            let alert = UIAlertController(title: "Fields Requiered", message: "Make sure all required feilds are filled", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(closeAction)
            (self.view as! UIViewController).present(alert, animated: true, completion: nil)
     
            return false
        }
        else
        {
            if tempProject?.agencyId == 0
            {
                tempProject?.agencyId = -1
            }
            if tempProject?.clientId == 0
            {
                tempProject?.clientId = -1
            }
            
         
        
            tempTask?.startDate = NSDate()
            tempTimer?.timeSpent = NSNumber(value: 0.00)
            tempTask?.projectId = (tempProject?.id)!

            let allocatedTaskTime = (tableData?[5] as! NSDictionary).value(forKey: "TEXT") as! String
            if allocatedTaskTime != "HOURS"
            {

                tempTask?.allocatedTaskTime = NSNumber(value: Int(allocatedTaskTime)!)
            }
            tempTimer?.stageTaskId = (tempTask?.id)!
            
            DataController.sharedInstance.addJobTimer(tempTimer: tempTimer!)
          
            DataController.sharedInstance.addStageTask(tempStageTask: tempTask!)
            if let p = Project.getProject(forId: (tempProject?.id.intValue)!)
            {
                if allocatedTaskTime != "HOURS"
                {
                    if tempProject?.allocatedProjectTime != nil
                    {
                        p.allocatedProjectTime = NSNumber(value: p.allocatedProjectTime.intValue + Int(allocatedTaskTime)!)
                    }else {
                        p.allocatedProjectTime = NSNumber(value: Int(allocatedTaskTime)!)
                    }
                }
            }
            else
            {
                if allocatedTaskTime != "HOURS"
                {
                    tempProject?.allocatedProjectTime = NSNumber(value: Int(allocatedTaskTime)!)
                }
                DataController.sharedInstance.addProject(tempProject: tempProject!)
            }
            UserDefaults.standard.set(tempTimer?.id, forKey: CURRENT_JOB_TIMER)
            var recentArray = UserDefaults.standard.value(forKey: RECENT_TASKS) as! Array<Int>
            if recentArray.count == 6
            {
                recentArray.removeAndShift(value: tempTask?.id as! Int)
            }
            else
            {
                recentArray.append(tempTask?.id as! Int)
            }
            UserDefaults.standard.setValue(recentArray, forKey: RECENT_TASKS)

            return true
        }
    }
    
    
    func saveCurrent()
    {
        view?.endTableEditing()
        if currentSection == .ADD_AGENCY || currentSection == .ADD_CLIENT
        {
            if (tableData?[0] as! NSDictionary).value(forKey: "TEXT") as? String == "REQUIRED"
            {
                let alert = UIAlertController(title: "Fields Requiered", message: "Make sure all required feilds are filled", preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alert.addAction(closeAction)
                (self.view as! UIViewController).present(alert, animated: true, completion: nil)
                return
            }
            else
            {
                let tempAgency = Agency.tempAgency()
                tempAgency.name = (tableData?[0] as! NSDictionary).value(forKey: "TEXT") as? String
                tempAgency.location = (tableData?[1] as! NSDictionary).value(forKey: "TEXT") as? String
                tempAgency.address1 = (tableData?[2] as! NSDictionary).value(forKey: "TEXT") as? String
                tempAgency.address2 = (tableData?[3] as! NSDictionary).value(forKey: "TEXT") as? String
                tempAgency.postcode = (tableData?[4] as! NSDictionary).value(forKey: "TEXT") as? String
                tempAgency.contact = (tableData?[5] as! NSDictionary).value(forKey: "TEXT") as? String
                tempAgency.phone = (tableData?[6] as! NSDictionary).value(forKey: "TEXT") as? String
                tempAgency.email = (tableData?[7] as! NSDictionary).value(forKey: "TEXT") as? String
                tempAgency.isAgency = false
                tempAgency.id = NSNumber(value: Agency.getNewAgencyID())
                if currentSection == .ADD_AGENCY
                {
                    tempAgency.isAgency = true
                    if DataController.sharedInstance.addAgency(tempAgency: tempAgency, isAgency: true) != true {
                        
                        let alertController = UIAlertController.init(title: "Agency Name Exists", message: "\(tempAgency.name!) already exists. Please enter a different name.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: nil))
                        
                        addTimerPresenterOutput?.showAlertController(alertController: alertController)
                        
                        return
                    }
                    
                    tempProject?.agencyId = tempAgency.id
                }
                else
                {
                    if DataController.sharedInstance.addAgency(tempAgency: tempAgency, isAgency: false) != true {
                        let alertController = UIAlertController.init(title: "Client Name Exists", message: "\(tempAgency.name!) already exists. Please enter a different name.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: nil))
                        
                        addTimerPresenterOutput?.showAlertController(alertController: alertController)
                        
                        return
                    }
                    
                    tempProject?.clientId = tempAgency.id
                }
                
                
            }
        }
        else if currentSection == .ADD_PROJECT
        {
            if (tableData?[0] as! NSDictionary).value(forKey: "TEXT") as? String == "REQUIRED"
            {
                let alert = UIAlertController(title: "Fields Requiered", message: "Make sure all required feilds are filled", preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alert.addAction(closeAction)
                (self.view as! UIViewController).present(alert, animated: true, completion: nil)
                return
            }
            else
            {
                let projectNameInput = (tableData?[0] as! NSDictionary).value(forKey: "TEXT") as? String
                
                if DataController.sharedInstance.verifyProjectNameIsUnique(name: projectNameInput!) != true {
                    let alertController = UIAlertController.init(title: "Project Name Exists", message: "\(projectNameInput!) already exists. Please enter a different name.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: nil))
                    
                    addTimerPresenterOutput?.showAlertController(alertController: alertController)
                    
                    return
                }
                
                tempProject?.id = NSNumber(value: Project.getNewProjectID())
                tempProject?.name = projectNameInput
                
                let dayLengthNum = Int(UserDefaults.standard.value(forKey: "workHoursPerDay") as! String)
                if dayLengthNum != nil{
                    tempProject?.dayLength = NSNumber(value: dayLengthNum!)
                }
                else
                {
                    tempProject?.dayLength = NSNumber(value: 8)
                }
            }
        }
        else if currentSection == .ADD_STAGE_TASK
        {
            if (tableData?[0] as! NSDictionary).value(forKey: "TEXT") as? String == "REQUIRED"
            {
                let alert = UIAlertController(title: "Fields Requiered", message: "Make sure all required feilds are filled", preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alert.addAction(closeAction)
                (self.view as! UIViewController).present(alert, animated: true, completion: nil)
                return
            }
            else
            {
                let taskNameInput = (tableData?[0] as! NSDictionary).value(forKey: "TEXT") as? String
                
                if DataController.sharedInstance.verifyTaskNameIsUnique(name: taskNameInput!) != true {
                    let alertController = UIAlertController.init(title: "Task Name Exists", message: "\(taskNameInput!) already exists. Please enter a different name.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: nil))
                    
                    addTimerPresenterOutput?.showAlertController(alertController: alertController)
                    
                    return
                }
                
                tempTask?.name = taskNameInput
                let stringValue = (tableData?[1] as! NSDictionary).value(forKey: "TEXT") as! String
                if stringValue != "SELECT"
                {
                    tempTask?.order = NSNumber(value: Int(((tableData?[1] as! NSDictionary).value(forKey: "TEXT") as? String)!)!)
                }
                tempTask?.id = NSNumber(value:  StageTask.getNextStageTaskId())
            }
        }
        
        closeAddTimerView()
    }
    
    
    @IBAction func closeAddTimerView()
    {
        if currentSection != nil
        {
            tableData = interactor?.getCellsForAddTimer()
            currentSection = nil
            view?.reloadTable()
            
        }
        else
        {
            wireframe!.closeTimer()
        }
    }
    
    
    func expandToItem(cell: ExpandableItem) {
        if cell == .ADD_AGENCY
        {
            tableData = interactor?.getCellsForExpandable(section: 0)
            currentSection = .ADD_AGENCY
        }
        else if cell == .ADD_CLIENT
        {
            tableData = interactor?.getCellsForExpandable(section: 1)
            currentSection = .ADD_CLIENT
        }
        else if cell == .AGENCY
        {
            tableData = DataController.sharedInstance.getAllAgencies()
            currentSection = .AGENCY
        }
        else if cell == .CLIENT
        {
            tableData = DataController.sharedInstance.getAllClients()
            currentSection = .CLIENT
        }
        else if cell == .ADD_PROJECT
        {
            tableData = interactor?.getCellsForExpandable(section: 2)
            currentSection = .ADD_PROJECT
        }
        else if cell == .PROJECT
        {
            tableData = DataController.sharedInstance.getAllProjects()
            currentSection = .PROJECT
        }
        else if cell == .ADD_STAGE_TASK
        {
            tableData = interactor?.getCellsForExpandable(section: 3)
            currentSection = .ADD_STAGE_TASK
        }
        else if cell == .FEES
        {
            tableData = NSMutableArray(array: FeeRates.getCustomRates())
            tableData?.addObjects(from: FeeRates.getDefaultRates())
            currentSection = .FEES
        }
        else
        {
            tableData = DataController.sharedInstance.getAllProjectTasks()
            currentSection = .STAGE_TASK
        }
        
        view?.reloadTable()
    }
    
    
    
    
    func keyboardWasShown(notif:Notification)
    {
        let info = notif.userInfo
        let size = (info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        view?.moveTableView(size: size.height + 120, cell:selectedCell)
    }
    
    func keyboardWasHidden(notif:Notification)
    {
         view?.moveTableView(size: 0, cell: nil)
    }
    
}


