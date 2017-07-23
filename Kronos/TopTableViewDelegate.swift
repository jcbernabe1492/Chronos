//
//  TopTableViewDelegate.swift
//  Kronos
//
//  Created by Wee, David G. on 10/29/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit


class TopTableViewDelegate:NSObject, UITableViewDataSource, UITableViewDelegate
{
    
    var viewController : ArchiveViewController!
    var bottomTable:BottomTableViewDelegate?
    var cellselected = false
    var isEditing = false
    init(controller:UIViewController)
    {
        viewController = controller as! ArchiveViewController
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewController.selectedStatus == .AGENCY
        {
            tableView.isScrollEnabled = false
            return 1
        }else if viewController.selectedStatus == .CLIENT
        {
            tableView.isScrollEnabled = false
            return 1
        }else if viewController.selectedStatus == .PROJECT
        {
            tableView.isScrollEnabled = false
            if viewController.selectedAgency == nil { return 1 }
            return 2
        }
        else if viewController.selectedStatus == .TASK
        {
            if viewController.selectedClient == nil && viewController.selectedAgency == nil{
                return 1
            }
            else if viewController.selectedAgency == nil
            {
                return 2
            }
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewController.selectedStatus == .AGENCY || cellselected == false { return getCellForAgencyTab(tableView: tableView) }
        if viewController.selectedStatus == .CLIENT { return getCellForClientTab(tableView: tableView) }
        if viewController.selectedStatus == .PROJECT { return getCellForProjectTab(tableView: tableView, indexPath: indexPath) }
        if viewController.selectedStatus == .TASK { return getCellForTaskTab(tableView: tableView, indexPath: indexPath) }
        
        return UITableViewCell()
    }
    
    func getCellForAgencyTab(tableView:UITableView) -> UITableViewCell
    {
        if viewController.cellSelected
        {
            return UITableViewCell()
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
            
            (cell as! HeaderCell).table = self
            (cell as! HeaderCell).initButtonsOnly()
            viewController.initButtonsOnly()
            
            if viewController.selectedStatus == .PROJECT || viewController.selectedStatus == .TASK
            {
                //(cell as! HeaderCell).showUnarchiveButton()
                viewController.showUnarchiveButton()
            }
            cell?.selectionStyle = .none
            return cell!
        }
    }
    func getCellForClientTab(tableView:UITableView) -> UITableViewCell
    {
        let cell = getCellForAgencyTab(tableView: tableView)
        let agency = Agency.getAgency(forId: viewController.selectedAgency!)
        (cell as! HeaderCell).titleLabel.text = "\(agency!.name!)"
        (cell as! HeaderCell).titleLabel.isHidden = false
        (cell as! HeaderCell).status = .AGENCY
        cell.selectionStyle = .none
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func getCellForProjectTab(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
        (cell as! HeaderCell).table = self
        if indexPath.row == 0
        {
            if viewController.selectedClient == nil
            {
                return getCellForAgencyTab(tableView: tableView)
            }
            if tableView.numberOfRows(inSection: 0) == 2
            {
                (cell as! HeaderCell).hideButtons()
                viewController.hideButtons()
                
                let agency = Agency.getAgency(forId: viewController.selectedAgency!)
                (cell as! HeaderCell).titleLabel.text = "\(agency!.name!)"
                (cell as! HeaderCell).status = .AGENCY
            }else
            {
                (cell as! HeaderCell).initButtonsOnly()
                viewController.initButtonsOnly()
                
                (cell as! HeaderCell).titleLabel.isHidden = false
                let agency = Agency.getAgency(forId: viewController.selectedClient!)
                (cell as! HeaderCell).titleLabel.text = "\(agency!.name!)"
                (cell as! HeaderCell).status = .CLIENT
            }
        }
        else
        {
            (cell as! HeaderCell).initButtonsOnly()
            viewController.initButtonsOnly()
            
            //(cell as! HeaderCell).showUnarchiveButton()
            viewController.showUnarchiveButton()
            
            (cell as! HeaderCell).titleLabel.isHidden = false
            let agency = Agency.getAgency(forId: viewController.selectedClient!)
            (cell as! HeaderCell).titleLabel.text = "\(agency!.name!)"
            (cell as! HeaderCell).status = .CLIENT
        }
        
        cell?.selectionStyle = .none
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
        return cell!
    }
    
    func getCellForTaskTab(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
        (cell as! HeaderCell).table = self
        if indexPath.row == 0
        {
            if viewController.selectedAgency != nil
            {
                let agency = Agency.getAgency(forId: viewController.selectedAgency!)
                
                (cell as! HeaderCell).hideButtons()
                viewController.hideButtons()
                
                (cell as! HeaderCell).titleLabel.text = agency?.name
                (cell as! HeaderCell).status = .AGENCY
            }
            else if viewController.selectedClient != nil
            {
                let agency = Agency.getAgency(forId: viewController.selectedClient!)
                
                (cell as! HeaderCell).hideButtons()
                viewController.hideButtons()
                
                (cell as! HeaderCell).titleLabel.text = agency?.name
                (cell as! HeaderCell).status = .CLIENT
            }
            else {
                let agency = Project.getProject(forId: viewController.selectedProject!)
                
                (cell as! HeaderCell).initButtonsOnly()
                viewController.initButtonsOnly()
                //(cell as! HeaderCell).showUnarchiveButton()
                viewController.showUnarchiveButton()
                
                (cell as! HeaderCell).titleLabel.isHidden = false
                (cell as! HeaderCell).titleLabel.text = agency?.name
                (cell as! HeaderCell).status = .PROJECT
            }
        }
        else if indexPath.row == 1
        {
             if viewController.selectedClient != nil && viewController.selectedAgency != nil
            {
                let agency = Agency.getAgency(forId: viewController.selectedClient!)
                
                (cell as! HeaderCell).hideButtons()
                viewController.hideButtons()
                
                (cell as! HeaderCell).titleLabel.text = agency?.name
                (cell as! HeaderCell).status = .CLIENT
            }
            else {
                let agency = Project.getProject(forId: viewController.selectedProject!)
                
                (cell as! HeaderCell).initButtonsOnly()
                viewController.initButtonsOnly()
                //(cell as! HeaderCell).showUnarchiveButton()
                viewController.showUnarchiveButton()
                
                (cell as! HeaderCell).titleLabel.isHidden = false
                (cell as! HeaderCell).titleLabel.text = agency?.name
                (cell as! HeaderCell).status = .PROJECT
            }
        }
        else
        {
            let agency = Project.getProject(forId: viewController.selectedProject!)
            
            (cell as! HeaderCell).initButtonsOnly()
            viewController.initButtonsOnly()
            //(cell as! HeaderCell).showUnarchiveButton()
            viewController.showUnarchiveButton()
            
            (cell as! HeaderCell).titleLabel.isHidden = false
            (cell as! HeaderCell).titleLabel.text = agency?.name
            (cell as! HeaderCell).status = .PROJECT
        }
        
        cell?.selectionStyle = .none
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
        return cell!

    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame:CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 45
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:HeaderCell = tableView.cellForRow(at: indexPath) as! HeaderCell
        if cell.status == .AGENCY {
            if viewController.selectedAgency != nil {
                viewController.agencyTabPressed()
                viewController.selectedClient = nil
                viewController.selectedProject = nil
            }
        }
        else if cell.status == .CLIENT
        {
            if viewController.selectedClient != nil
            {
                viewController.cellSelected = true
                viewController.clientTabPressed()
                viewController.selectedProject = nil
            }
        }
        else if cell.status == .PROJECT
        {
            if viewController.selectedProject != nil
            {
                viewController.cellSelected = true
                viewController.projectTabPressed()
            }
        }
    }
    
    func setIsEditing(editing:Bool)
    {
        bottomTable?.editing = editing
        viewController.bottomTableView.reloadData()
        isEditing = editing
    }
    
    func deleteActionButtonPressed(action:String)
    {
        viewController.deleteActionButtonPressed(action: action)
    }
    
}
