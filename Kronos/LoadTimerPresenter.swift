//
//  LoadTimerPresenter.swift
//  Kronos
//
//  Created by Wee, David G. on 9/12/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

class LoadTimerPresenter:NSObject, LoadTimerPresenterProtocol
{
    var view: LoadTimerViewControllerProtocol?
    var interactor: LoadTimerInteractorProtocol?
    var wireframe: LoadTImerWireframeProtocol?
    var trashView:UIView?
    
    var tableData:NSArray?
    var selectedProjectId:Int?
    var isEditing:Bool = false
    var editProjectTableView:UITableView?
    var projectPresenter:EditProjectPresenter?
    var keyboardCell:UITableViewCell?
    
    func viewDidLoad() {
        
        tableData = interactor?.getRecentTasks()

    }
    
    //MARK: - UITableViewDelegate and Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func reloadData(tab:TAB)
    {
        if editProjectTableView != nil
        {
            editProjectTableView?.removeFromSuperview()
            editProjectTableView = nil
        }

        if tab == .TASKS
        {
            tableData = interactor?.getAllTasksForProject(id: selectedProjectId!)
            let newTableData = NSMutableArray()
            for tasks in tableData!
            {
                let timer = JobTimer.getTimerWithTask(id: (tasks as! StageTask).id.intValue)
                if !(tasks as! StageTask).wasDeleted && !(tasks as! StageTask).archived && !Invoice.timerHasBeenInvoiced(timer: timer!.id.intValue){
                    newTableData.add(tasks)
                }
            }
            tableData = newTableData
        }
        else if tab == .PROJECTS
        {
            tableData = interactor?.getAllProjects().reversed() as NSArray?
            var newData = Array<Project>()
            for project in tableData!
            {
                var finalTasks:[StageTask] = []
                let tasks = StageTask.getAllTasksFor(project: (project as! Project).id)
                for t in tasks!
                {
                    let timer = JobTimer.getTimerWithTask(id: t.id.intValue)
                    if !Invoice.timerHasBeenInvoiced(timer: timer?.id as! Int)
                    {
                        finalTasks.append(t)
                    }
                }
                if finalTasks.count != 0
                {
                    newData.append(project as! Project)
                }
            }
            tableData = NSArray(array: newData)
        }
        else
        {
            tableData = interactor?.getRecentTasks()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if view?.selected == .RECENT
        {
            return min(6, (tableData?.count)!)
        }
        return (tableData?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ProjectCell = tableView.dequeueReusableCell(withIdentifier: "PROJECT_CELL") as! ProjectCell
        let object = tableData?[indexPath.row]
        view?.hideButtons(active: false)
        if object is StageTask
        {
            if view?.selected == .TASKS
            {
                cell.textLabel?.text = (object as! StageTask).name
                cell.textLabel?.font = UIFont().boldFont()
                view?.hideButtons(active: true)
                cell.projectNameLabel?.isHidden = true
                cell.clientNameLabel?.isHidden = true
                cell.textLabel?.isHidden = false
                cell.textLabel?.textColor = UIColor.white
            }
            else
            {
                cell.projectNameLabel?.text = Project.getProject(forId:(object as! StageTask).projectId.intValue)?.name
                cell.clientNameLabel?.text = (object as! StageTask).name
                cell.projectNameLabel?.font = UIFont().boldFont()
                cell.clientNameLabel?.font = UIFont().normalFont()
                cell.projectNameLabel?.isHidden = false
                cell.clientNameLabel?.isHidden = false
                cell.textLabel?.isHidden = true
            }
        }
        else if object is Project
        {
            cell.projectNameLabel?.text = (object as! Project).name
            cell.projectNameLabel?.isHidden = false
            cell.clientNameLabel?.isHidden = false
            cell.textLabel?.isHidden = true
            cell.projectNameLabel?.font = UIFont().boldFont()
            cell.clientNameLabel?.font = UIFont().normalFont()
            if let clientName = Agency.getClient(forId: (object as! Project).clientId.intValue)?.name
            {
                cell.clientNameLabel?.text = clientName
            }
            else
            {
                cell.clientNameLabel?.text = "Not Available"
            }
        }
        if isEditing
        {
            cell.stackViewLeading?.constant = 40
            cell.selectCellImageView?.isHidden = false
        }
        else
        {
            cell.stackViewLeading?.constant = 20
            cell.selectCellImageView?.isHidden = true
        }
        cell.tag = indexPath.row
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if view?.selected == .RECENT || view?.selected == .PROJECTS
        {
            if isEditing
            {
                if view?.selected == .RECENT
                {
                    if editProjectTableView == nil {
                        showEditProjectView(task: tableData?.object(at: indexPath.row) as! StageTask,index: indexPath)
                    }
                }
                else {
                    let cell: ProjectCell = tableView.cellForRow(at: indexPath) as! ProjectCell
                    cell.dotPressed()
                }
            }

            else
            {
                if view?.selected == .PROJECTS
                {
                    selectedProjectId = (tableData?[indexPath.row] as! Project).id.intValue
                    view?.tasksSelected()
                }
                else
                {
                    let project = JobTimer.getTimerWithTask(id: Int((tableData![indexPath.row] as! StageTask).id))
                    
                    var recentArray = UserDefaults.standard.value(forKey: RECENT_TASKS) as! Array<Int>
                    if recentArray.contains((project?.id.intValue)!)
                    {
                        recentArray.removeValue(value: (project?.id.intValue)!)
                    }
                    if recentArray.count == 6
                    {
                        recentArray.removeAndShift(value: project?.id as! Int)
                    }
                    else
                    {
                        recentArray.append(project?.id as! Int)
                    }
                    UserDefaults.standard.setValue(recentArray, forKey: RECENT_TASKS)
                    
                    wireframe?.closeWithNewProjectSelected(id: (project?.id)!)
                }
            }
        }
        else
        {
            let task = tableData?[indexPath.row] as! StageTask
            let timer = JobTimer.getTimerWithTask(id: task.id.intValue)
            
            var recentArray = UserDefaults.standard.value(forKey: RECENT_TASKS) as! Array<Int>
            
            if recentArray.contains((timer?.id.intValue)!)
            {
                recentArray.removeValue(value: (timer?.id.intValue)!)
            }
            
            if recentArray.count == 6
            {
                recentArray.removeAndShift(value: timer?.id as! Int)
            }
            else
            {
                recentArray.append(timer?.id as! Int)
            }
            UserDefaults.standard.setValue(recentArray, forKey: RECENT_TASKS)
            
            wireframe?.closeWithNewProjectSelected(id: (timer?.id)!)
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if view?.selected == .TASKS
        {
            return 30
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if view?.selected == .TASKS
        {
            let project = Project.getProject(forId: selectedProjectId!)
            let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
            header.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
            let titleLabel = UILabel()
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.text = project?.name
            titleLabel.font = UIFont().boldFont()
            titleLabel.textColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0)
            header.addSubview(titleLabel)
            header.addConstraint(NSLayoutConstraint(item: header, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            header.addConstraint(NSLayoutConstraint(item: header, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1.0, constant: -20.0))
            
            return header
        }
        return UIView(frame: CGRect.zero)
    }
    
    func editingPressed(editing: Bool) {
        isEditing = editing
    }
    
    func trashButtonClicked() {
        if trashView == nil{
            trashView = UIView()
            trashView?.translatesAutoresizingMaskIntoConstraints = false
            trashView?.backgroundColor = UIColor.clear
            
            let trashViewTop = UIView()
            trashViewTop.tag = 3
            trashViewTop.translatesAutoresizingMaskIntoConstraints = false
            trashViewTop.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
            trashView?.addSubview(trashViewTop)
            trashView?.addConstraint(NSLayoutConstraint(item: trashView! , attribute: .centerX, relatedBy: .equal, toItem: trashViewTop, attribute: .centerX, multiplier: 1.0, constant: 0.0))
            trashView?.addConstraint(NSLayoutConstraint(item: trashView!, attribute: .bottom, relatedBy: .equal, toItem: trashViewTop, attribute: .bottom, multiplier: 1.0, constant: 0.0))
            trashView?.addConstraint(NSLayoutConstraint(item: trashView!, attribute: .width, relatedBy: .equal, toItem: trashViewTop, attribute: .width, multiplier: 1.0, constant: 0.0))
            trashView?.addConstraint(NSLayoutConstraint(item: trashViewTop, attribute: .height, relatedBy: .equal, toItem: trashView, attribute: .height, multiplier: 0.3, constant: 0.0))
            
            let trashTopLabel = UILabel()
            trashTopLabel.translatesAutoresizingMaskIntoConstraints = false
            trashTopLabel.text = "DELETE SELECTED JOBS"
            trashTopLabel.font = UIFont(name: "Neo Sans", size: 12)
            trashTopLabel.textColor = UIColor.white
            trashTopLabel.textAlignment = .center
            trashViewTop.addSubview(trashTopLabel)
            trashViewTop.addConstraint(NSLayoutConstraint(item: trashViewTop, attribute: .top, relatedBy: .equal, toItem: trashTopLabel, attribute: .top, multiplier: 1.0, constant: -20))
            trashViewTop.addConstraint(NSLayoutConstraint(item: trashViewTop, attribute: .centerX, relatedBy: .equal, toItem: trashTopLabel, attribute: .centerX, multiplier: 1.0, constant: 0))
            trashViewTop.addConstraint(NSLayoutConstraint(item: trashViewTop, attribute: .width, relatedBy: .equal, toItem: trashTopLabel, attribute: .width, multiplier: 1.0, constant: 10))
            
            
            let trashBottomLabel = UILabel()
            trashBottomLabel.translatesAutoresizingMaskIntoConstraints = false
            let attrString = NSMutableAttributedString(string: "IMPORTANT: DELETED JOBS CANNOT BE RECOVERED")
            
            attrString.addAttributes([NSFontAttributeName: UIFont(name:"Neo Sans", size:12)!, NSForegroundColorAttributeName:UIColor.white], range: NSMakeRange(10, attrString.length-10))
            let font = UIFont(name: "NeoSans-Medium", size: 12)
       
            attrString.addAttributes([NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:font!], range: NSMakeRange(0, 10))
            trashBottomLabel.attributedText = attrString
            trashBottomLabel.textAlignment = .center
            trashViewTop.addSubview(trashBottomLabel)
            trashViewTop.addConstraint(NSLayoutConstraint(item: trashViewTop, attribute: .bottom, relatedBy: .equal, toItem: trashBottomLabel, attribute: .bottom, multiplier: 1.0, constant: 20))
            trashViewTop.addConstraint(NSLayoutConstraint(item: trashViewTop, attribute: .centerX, relatedBy: .equal, toItem: trashBottomLabel, attribute: .centerX, multiplier: 1.0, constant: 0))
            trashViewTop.addConstraint(NSLayoutConstraint(item: trashViewTop, attribute: .width, relatedBy: .equal, toItem: trashBottomLabel, attribute: .width, multiplier: 1.0, constant: 10))
            
            let cancelButton = UIButton()
            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.setImage(UIImage(named:"btn-cancel-red"), for: .normal)
            trashViewTop.addSubview(cancelButton)
            trashViewTop.addConstraint(NSLayoutConstraint(item: trashViewTop, attribute: .centerY, relatedBy: .equal, toItem: cancelButton, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            trashViewTop.addConstraint(NSLayoutConstraint(item: trashViewTop, attribute: .centerX, relatedBy: .equal, toItem: cancelButton, attribute: .trailing, multiplier: 1.0, constant: 5.0))
            trashViewTop.addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 75.0))
            trashViewTop.addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 75.0))
            cancelButton.addTarget(self, action: #selector(LoadTimerPresenter.trashCancelbuttonClicked), for: .touchUpInside)
            
            let deleteButton = UIButton()
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            deleteButton.setImage(UIImage(named:"btn-delete-green"), for: .normal)
            trashViewTop.addSubview(deleteButton)
            trashViewTop.addConstraint(NSLayoutConstraint(item: trashViewTop, attribute: .centerY, relatedBy: .equal, toItem: deleteButton, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            trashViewTop.addConstraint(NSLayoutConstraint(item: trashViewTop, attribute: .centerX, relatedBy: .equal, toItem: deleteButton, attribute: .leading, multiplier: 1.0, constant: -5.0))
            trashViewTop.addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 75.0))
            trashViewTop.addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 75.0))
            deleteButton.addTarget(self, action: #selector(LoadTimerPresenter.trashOkayButtonClicked), for: .touchUpInside)
            
            wireframe?.showOnScreen(view: trashView!)
            
        }else
        {
            trashView?.removeFromSuperview()
            trashView = nil
        }
    }
        
    func trashOkayButtonClicked()
    {
        var toDeleteArray:NSMutableArray?
        toDeleteArray = view?.tableViewCells()
        DispatchQueue.main.async {
            for cell in toDeleteArray!
            {
                self.interactor?.delete(jobs: [self.tableData?.object(at: (cell as! ProjectCell).tag)])
            }
        }
        let topView = trashView?.viewWithTag(3)
        for s in (topView?.subviews)!
        {
            s.removeFromSuperview()
        }
        
        let jobsDeletedLabel = UILabel()
        jobsDeletedLabel.translatesAutoresizingMaskIntoConstraints = false
        jobsDeletedLabel.font = UIFont(name: "NeoSans-Medium", size: 12)
        jobsDeletedLabel.textColor = UIColor.white
        jobsDeletedLabel.text = "JOBS DELETED"
        topView?.addSubview(jobsDeletedLabel)
        topView?.addConstraint(NSLayoutConstraint(item: topView!, attribute: .centerX, relatedBy: .equal, toItem: jobsDeletedLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        topView?.addConstraint(NSLayoutConstraint(item: topView!, attribute: .top, relatedBy: .equal, toItem: jobsDeletedLabel, attribute: .top, multiplier: 1.0, constant: -20.0))
        
        let deletedIcon = UIImageView(image: UIImage(named:"icn-deleted-trash"))
        deletedIcon.translatesAutoresizingMaskIntoConstraints = false
        topView?.addSubview(deletedIcon)
        topView?.addConstraint(NSLayoutConstraint(item: topView!, attribute: .centerX, relatedBy: .equal, toItem: deletedIcon, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        topView?.addConstraint(NSLayoutConstraint(item: topView!, attribute: .centerY, relatedBy: .equal, toItem: deletedIcon, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        topView?.addConstraint(NSLayoutConstraint(item: deletedIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 75.0))
        topView?.addConstraint(NSLayoutConstraint(item: deletedIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 75.0))
        
        
        let delay = DispatchTime.now() + .seconds(1)
        
        DispatchQueue.main.asyncAfter(deadline: delay, execute: {
            self.trashView?.removeFromSuperview()
            self.trashView = nil
            self.view?.itemsDeleted()
            self.checkForDeletedTask()
        })
        isEditing = false
        self.reloadData(tab: (view?.selected)!)
        view?.editingPressed()
        view?.reloadTable()
        
    }
    
    
    
    func showEditProjectView(task:StageTask, index:IndexPath)
    {
        editProjectTableView = UITableView()
        let v = UIView(frame: CGRect(x: 0, y: 0, width: (editProjectTableView?.frame.size.width)! , height: 0.5))
        v.backgroundColor = UIColor.white
        
        editProjectTableView?.tableFooterView = v
        projectPresenter = EditProjectPresenter()
        
        projectPresenter?.addNotifications()
        projectPresenter?.loadTimerPresenter = self
        editProjectTableView?.delegate = projectPresenter
        editProjectTableView?.dataSource = projectPresenter
        projectPresenter?.view = editProjectTableView
        projectPresenter?.loadTimerView = view
        projectPresenter?.tableData = task
        tableData = [task]
        
        view?.showEditProject(index: index, view: editProjectTableView!)
    }
    

    func checkForDeletedTask()
    {
        if let currentTimer = UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER)
        {
            let job = JobTimer.getTimerWith(id: currentTimer as! Int)
            if job == nil
            {
                UserDefaults.standard.removeObject(forKey: CURRENT_JOB_TIMER)
                return
            }
            let task = StageTask.getStageTask(forId: (job?.stageTaskId.intValue)!)
            if  (task?.wasDeleted)!
            {
                UserDefaults.standard.removeObject(forKey: CURRENT_JOB_TIMER)
            }
        }
    }
    
    
    func trashCancelbuttonClicked()
    {
        trashView?.removeFromSuperview()
        trashView = nil
    }
    
    
    func doneEditing()
    {
        view?.editingPressed()
    }



    
    
    
}
