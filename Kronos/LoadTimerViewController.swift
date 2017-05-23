 //
//  LoadTimerViewController.swift
//  Kronos
//
//  Created by Wee, David G. on 9/12/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit


enum TAB{
    case RECENT
    case PROJECTS
    case TASKS
}
class LoadTimerViewController: UIViewController, LoadTimerViewControllerProtocol {

    var presenter: LoadTimerPresenterProtocol?
    @IBOutlet var recentButton:UIButton?
    @IBOutlet var projectButton:UIButton?
    @IBOutlet var tableView:UITableView?
    @IBOutlet var trashButton:UIButton?
    @IBOutlet var taskTab:UIButton?
    
    var selected:TAB?
    var selectedButton: UIButton?
    var isBeingEdited: Bool = false
    var isBeingDeleted: Bool = false
    var keyboardShown = false
    @IBOutlet var editButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedButton = recentButton
        tableView?.delegate = presenter
        tableView?.dataSource = presenter
        presenter?.viewDidLoad()
        selected = .RECENT
        tableView?.backgroundColor = UIColor.cellBackgroundColor()
        let v = UIView(frame: CGRect(x: 0, y: 0, width: (tableView?.frame.size.width)! , height: 0.5))
        v.backgroundColor = UIColor.black
        tableView?.tableFooterView = v
        // Do any additional setup after loading the view.
        recentButton?.titleLabel?.font = UIFont().headerFont()
        projectButton?.titleLabel?.font = UIFont().headerFont()
        taskTab?.titleLabel?.font = UIFont().headerFont()
        taskTab?.setTitleColor(UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 0.5), for: .normal)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tabPressed(btn:UIButton)
    {
        selectedButton?.backgroundColor = UIColor.clear
        selectedButton = btn
        selectedButton?.backgroundColor = UIColor.tabSelectedYellow()
        if btn.titleLabel?.text == "RECENT"
        {
            selected = .RECENT
        }
        else if btn.titleLabel?.text == "PROJECT"
        {
            selected = . PROJECTS
        }
        else
        {
            selected = .TASKS
        }
        presenter?.reloadData(tab: selected!)
        tableView?.reloadData()
        taskTab?.titleLabel?.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 0.5)
    }
    
    @IBAction func editingButtonPressed(btn:UIButton)
    {
        if isBeingEdited
        {
            presenter?.editingPressed(editing: false)
            btn.setImage(UIImage(named:"btn-edit"), for: .normal)
            trashButton?.setImage(UIImage(named:"btn-trash-disabled"), for: .normal)
            isBeingEdited = false
        }
        else
        {
            presenter?.editingPressed(editing: true)
            btn.setImage(UIImage(named:"btn-x"), for: .normal)
            isBeingEdited = true
            trashButton?.setImage(UIImage(named:"btn-trash-selected"), for: .normal)
            
        }
        presenter?.reloadData(tab: selected!)
        tableView?.reloadData()
    }
    
    func editingPressed()
    {
        editButton?.setImage(UIImage(named:"btn-edit"), for: .normal)
        trashButton?.setImage(UIImage(named:"btn-trash-disabled"), for: .normal)
        isBeingEdited = false
    }
    
    @IBAction func trashButtonPressed()
    {
        if isBeingEdited
        {
           presenter?.trashButtonClicked()
        }
    }
    
    func itemsDeleted() {
        presenter?.reloadData(tab: selected!)
        tableView?.reloadData()
    }
    
    func tableViewCells() -> NSMutableArray! {
        let array = NSMutableArray()
        for x in 0...Int((tableView?.numberOfRows(inSection: 0))!-1)
        {
            let cell:ProjectCell = tableView?.cellForRow(at: IndexPath(row: x, section: 0) as IndexPath) as! ProjectCell
            if cell.isPicked
            {
                array.add(cell)
            }
        }
        return array
    }

    
    func showEditProject(index: IndexPath, view:UITableView) {
        tableView?.reloadData()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        view.separatorColor = UIColor.white
    
        self.view.addSubview(view)
        let top = NSLayoutConstraint(item: tableView!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier:1.0 , constant: -60.0)
        top.identifier = "top"
        self.view.addConstraint(top)
        let bottom = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier:1.0 , constant:  10.0)
        bottom.identifier = "bottom"
        self.view.addConstraint(bottom)
        self.view.addConstraint(NSLayoutConstraint(item: tableView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier:1.0 , constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: tableView!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier:1.0 , constant: 0.0))
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        view.layoutIfNeeded()

    }
    
    func tasksSelected() {
        selected = .TASKS
        selectedButton?.backgroundColor = UIColor.clear
        selectedButton = taskTab
        selectedButton?.backgroundColor = UIColor.tabSelectedYellow()
        presenter?.reloadData(tab: .TASKS)
        tableView?.reloadData()
        taskTab?.titleLabel?.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
        
    }
    
    func reloadTable()
    {
        presenter?.reloadData(tab: selected!)
        tableView?.reloadData()
    }
    
    func hideButtons(active: Bool) {
        trashButton?.isHidden = active
        editButton?.isHidden = active
    }
    
    func moveTable(up: Bool, keyboardSize:CGFloat) {
        

    }


}
