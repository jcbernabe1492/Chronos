//
//  ArchiveViewController.swift
//  Kronos
//
//  Created by Wee, David G. on 10/27/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit


enum Status {
    case FullYear
    case FullHistory
}

enum ButtonStatus
{
    case NUMBER_OF_PROJECTS
    case INVOICE_STATUS
    case INCOME
    case TOTAL_HOURS_WORKED
    case DAYS_WORKED
}

enum Tab {
    case AGENCY
    case CLIENT
    case PROJECT
    case TASK
}


class ArchiveViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var agencyBtn:UIButton!
    @IBOutlet var clientBtn:UIButton!
    @IBOutlet var projectBtn:UIButton!
    @IBOutlet var taskBtn:UIButton!
    @IBOutlet var topConstraint:NSLayoutConstraint!
    @IBOutlet var topTableViewHeight:NSLayoutConstraint!
    @IBOutlet var bottomTableViewBottom:NSLayoutConstraint!
    
    @IBOutlet var topTableView:UITableView!
    @IBOutlet var bottomTableView:UITableView!
    
    @IBOutlet var numberOfProjects:UIButton!
    @IBOutlet var invoiceStatus:UIButton!
    @IBOutlet var incomeEarned:UIButton!
    @IBOutlet var hoursWorked:UIButton!
    @IBOutlet var daysWorked:UIButton!
    
    @IBOutlet weak var bottomScrollHolder: UIView!
    @IBOutlet weak var bottomScrollView: UIScrollView!
    @IBOutlet weak var bottomScrollContentView: UIView!
    @IBOutlet weak var numberOfProjectsTable: UITableView!
    @IBOutlet weak var invoiceStatusTable: UITableView!
    @IBOutlet weak var incomeEarnedTable: UITableView!
    @IBOutlet weak var hoursWorkedTable: UITableView!
    @IBOutlet weak var daysWorkedTable: UITableView!
    @IBOutlet weak var centerBarLabel: UILabel!
    
    @IBOutlet var trashButton:UIButton!
    @IBOutlet var editButtin:UIButton!
    @IBOutlet var unarchiveButton:UIButton!
    
    @IBOutlet weak var topTablesScrollView: UIScrollView!
    
    var archiveStatus:Status = .FullYear
    var buttonStatus:ButtonStatus = .INCOME
    var selectedTab:UIButton!
    var tabSelected = false
    var cellSelected = false
    var selectedStatus:Tab = .AGENCY
    
    var selectedAgency:Int?
    var selectedClient:Int?
    var selectedProject:Int?
    var selectedTask:Int?
    
    var bottomView:UIView?
    var bottomViewLabel:UILabel?
    
    var actionView:UIView?
    var action:String?
    
    var touchedOnce:Bool = false
    
    var topTableViewDelegate:TopTableViewDelegate!
    var bottomtTableViewDelegate:BottomTableViewDelegate!
    
    var homeArchiveButton: UIButton!
    
    var edit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //topConstraint.constant = -20
        
        agencyBtn.titleLabel?.font = UIFont().headerFont()
        agencyBtn.backgroundColor = UIColor.tabSelectedYellow()
        selectedTab = agencyBtn
        clientBtn.titleLabel?.font = UIFont().headerFont()
        projectBtn.titleLabel?.font = UIFont().headerFont()
        taskBtn.titleLabel?.font = UIFont().headerFont()
        
        agencyBtn.setTitleColor(UIColor.cellBackgroundColor(), for: .normal)
        clientBtn.setTitleColor(UIColor.cellBackgroundColor(), for: .normal)
        projectBtn.setTitleColor(UIColor.cellBackgroundColor(), for: .normal)
        taskBtn.setTitleColor(UIColor.white, for: .normal)
        taskBtn.alpha = 0.6
        topTableView.backgroundColor = UIColor.cellBackgroundColor()
        bottomTableView.backgroundColor = UIColor.cellBackgroundColor()
        topTableViewDelegate = TopTableViewDelegate(controller: self)
        bottomtTableViewDelegate = BottomTableViewDelegate(controller: self)
        topTableView.delegate = topTableViewDelegate
        topTableView.dataSource = topTableViewDelegate
        bottomTableView.delegate = bottomtTableViewDelegate
        bottomTableView.dataSource = bottomtTableViewDelegate
        topTableViewDelegate.bottomTable = bottomtTableViewDelegate
        
        agencyTabPressed()
        
        incomeEarnedClicked(btn: UIButton())

        let v = UIView(frame: CGRect(x: 0, y: 0, width: (bottomTableView?.frame.size.width)! , height: 0.5))
        v.backgroundColor = UIColor.black
        bottomTableView?.tableFooterView = v

        numberOfProjects.imageView?.contentMode = .scaleAspectFit
        invoiceStatus.imageView?.contentMode = .scaleAspectFit
        incomeEarned.imageView?.contentMode = .scaleAspectFit
        hoursWorked.imageView?.contentMode = .scaleAspectFit
        daysWorked.imageView?.contentMode = .scaleAspectFit
        
        trashButton.imageView?.contentMode = .scaleAspectFit
        editButtin.imageView?.contentMode = .scaleAspectFit
        unarchiveButton.imageView?.contentMode = .scaleAspectFit

        NotificationCenter.default.addObserver(self, selector: #selector(ArchiveViewController.changeArchiveStatus(notif:)), name: NSNotification.Name(rawValue: "kChangeArchiveStatus"), object: nil)
        
        // Do any additional setup after loading the view.
        
        bottomScrollHolder.backgroundColor = UIColor.cellBackgroundColor()
        
        
        numberOfProjects.setImage(UIImage(named:"btn-number-projects")?.withRenderingMode(.alwaysTemplate), for: .normal)
        invoiceStatus.setImage(UIImage(named:"btn-invoice-status")?.withRenderingMode(.alwaysTemplate), for: .normal)
        incomeEarned.setImage(UIImage(named:"btn-income-earned")?.withRenderingMode(.alwaysTemplate), for: .normal)
        hoursWorked.setImage(UIImage(named:"btn-hours-worked")?.withRenderingMode(.alwaysTemplate), for: .normal)
        daysWorked.setImage(UIImage(named:"btn-days-worked")?.withRenderingMode(.alwaysTemplate), for: .normal)
        numberOfProjects.setImage(UIImage(named:"btn-number-projects-selected")?.withRenderingMode(.alwaysTemplate), for: .selected)
        invoiceStatus.setImage(UIImage(named:"btn-invoice-status-selected")?.withRenderingMode(.alwaysTemplate), for: .selected)
        incomeEarned.setImage(UIImage(named:"btn-income-earned-selected")?.withRenderingMode(.alwaysTemplate), for: .selected)
        hoursWorked.setImage(UIImage(named:"btn-hours-worked-selected")?.withRenderingMode(.alwaysTemplate), for: .selected)
        daysWorked.setImage(UIImage(named:"btn-days-worked-selected")?.withRenderingMode(.alwaysTemplate), for: .selected)
        
        setButtonsNormal()
        
        incomeEarned.isSelected = true
        incomeEarned.tintColor = UIColor.white
        
        numberOfProjectsTable.delegate = bottomtTableViewDelegate
        numberOfProjectsTable.dataSource = bottomtTableViewDelegate
        incomeEarnedTable.delegate = bottomtTableViewDelegate
        incomeEarnedTable.dataSource = bottomtTableViewDelegate
        invoiceStatusTable.delegate = bottomtTableViewDelegate
        invoiceStatusTable.dataSource = bottomtTableViewDelegate
        hoursWorkedTable.delegate = bottomtTableViewDelegate
        hoursWorkedTable.dataSource = bottomtTableViewDelegate
        daysWorkedTable.delegate = bottomtTableViewDelegate
        daysWorkedTable.dataSource = bottomtTableViewDelegate
        
        trashButton.alpha = 0.5
        trashButton.isHidden = false
        editButtin.isHidden = false

    }
    
    func initialTablesLoad() {
        
    }
    
    func reloadBottomTablesWithData(data: Array<NSNumber>) {
        
        bottomtTableViewDelegate.data = NSArray(array: data)
        
        reloadBottomTables()
    }
    
    func reloadBottomTables() {
        numberOfProjectsTable.reloadData()
        invoiceStatusTable.reloadData()
        incomeEarnedTable.reloadData()
        hoursWorkedTable.reloadData()
        daysWorkedTable.reloadData()
    }
    
    func changeArchiveStatus(notif:NSNotification)
    {
        let userInfo = notif.userInfo
        
        if (userInfo?["button"] as! String) == "FULL_HISTORY"
        {
            archiveStatus = .FullHistory
            homeArchiveButton.setImage(UIImage(named:"btn-archive-pressed-bottom"), for: .normal)
            
        } else {
            archiveStatus = .FullYear
            homeArchiveButton.setImage(UIImage(named:"btn-archive-pressed"), for: .normal)
        }
        
        if selectedStatus == .AGENCY { agencyTabPressed() }
        if selectedStatus == .CLIENT { clientTabPressed() }
        if selectedStatus == .PROJECT { projectTabPressed() }
        if selectedStatus == .TASK { taskTabPressed() }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func agencyTabPressed()
    {
        bottomScrollView.isScrollEnabled = true;
        selectedTask = nil
        
        changeButtonColor(btn: agencyBtn)
        selectedStatus = .AGENCY
        taskBtn.setTitleColor(UIColor.white, for: .normal)
        taskBtn.alpha = 0.6
        setButtonsActive(active: true)
        
        if cellSelected {
            
        } else {
            let data:Array<NSNumber>?
            
            if archiveStatus == .FullHistory {
                data = ArchiveUtils.getAgencies(thisYear: false)
            } else {
                data = ArchiveUtils.getAgencies(thisYear: true)
            }
            
            bottomtTableViewDelegate.data = NSArray(array: data!)
            
            selectedClient = nil
            selectedAgency = nil
        }
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        topTableViewHeight.constant = 45
        
        if touchedOnce
        {
            topConstraint.constant = 0
        }else
        {
            touchedOnce = true
        }
        
        showBottomView()
        
        //bottomTableView.reloadData()
        reloadBottomTables()
        
        topTableView.reloadData()
    }
    
    @IBAction func clientTabPressed()
    {
        bottomScrollView.isScrollEnabled = true;
        selectedTask = nil
        
        changeButtonColor(btn: clientBtn)
        selectedStatus = .CLIENT
        setButtonsActive(active: true)
        taskBtn.setTitleColor(UIColor.white, for: .normal)
        taskBtn.alpha = 0.6
        if cellSelected
        {
            
            let data:Array<NSNumber>?
            if archiveStatus == .FullHistory
            {
                data = ArchiveUtils.getClientsWith(agency: selectedAgency!, thisYear: false)
            }
            else { data = ArchiveUtils.getClientsWith(agency: selectedAgency!, thisYear: false) }
            
            bottomtTableViewDelegate.data = NSArray(array: data!)
            
            if bottomView != nil
            {
                bottomView?.removeFromSuperview()
            }
        }
        else
        {
            let data:(Array<NSNumber>, Array<NSNumber>)?
            if archiveStatus == .FullHistory
            {
                data = ArchiveUtils.getClients(thisYear: false)
            }
            else { data = ArchiveUtils.getClients(thisYear: false) }
            showBottomView()
            bottomtTableViewDelegate.data =  NSArray(array: (data?.0)!)
            bottomtTableViewDelegate.secondaryData = NSArray(array: (data?.1)!)
            selectedClient = nil
            selectedAgency = nil
        }
        topTableViewHeight.constant = 45

        topConstraint.constant = 0
    
        
        topTableViewDelegate.cellselected = cellSelected
        cellSelected = false
        topTableView.reloadData()

        reloadBottomTables()
        //bottomTableView.reloadData()
   

    }
    
    @IBAction func projectTabPressed()
    {
        bottomScrollView.isScrollEnabled = true;
        selectedTask = nil
        
        changeButtonColor(btn: projectBtn)
        selectedStatus = .PROJECT
        setButtonsActive(active: true)
        selectedTask = nil 
        taskBtn.setTitleColor(UIColor.white, for: .normal)
        taskBtn.alpha = 0.6
        if cellSelected && selectedClient != nil
        {
            let data:Array<NSNumber>?
            if archiveStatus == .FullHistory
            {
                data = ArchiveUtils.getProjectsWith(client: selectedClient!, thisYear: false)
            }
            else { data = ArchiveUtils.getProjectsWith(client: selectedClient!, thisYear: true)}
            
            bottomtTableViewDelegate.data = NSArray(array: data!)
            
            if bottomView != nil
            {
                bottomView?.removeFromSuperview()
            }
            if selectedAgency != nil
            {
                topTableViewHeight.constant = 85
            }
        }
        else
        {
            topTableViewHeight.constant = 45


                topConstraint.constant = 0

            let data:(Array<NSNumber>, Array<NSNumber>)?
            if archiveStatus == .FullHistory
            {
                data = ArchiveUtils.getProjects(thisYear: false)
            }
            else { data = ArchiveUtils.getProjects(thisYear: true) }
            showBottomView()
            bottomtTableViewDelegate.data =  NSArray(array: (data?.0)!)
            bottomtTableViewDelegate.secondaryData = NSArray(array: (data?.1)!)
            selectedClient = nil
            selectedAgency = nil
        }

        topTableViewDelegate.cellselected = cellSelected
        cellSelected = false
        topTableView.reloadData()
        //bottomTableView.reloadData()
        
        reloadBottomTables()
    }
    
    @IBAction func taskTabPressed()
    {
        bottomScrollView.isScrollEnabled = true;
        
        setButtonsActive(active: true)
        if cellSelected
        {
            
            changeButtonColor(btn: taskBtn)
            selectedStatus = .TASK
            let data:Array<NSNumber>?
            if archiveStatus == .FullHistory
            {
                data = ArchiveUtils.getTaskswith(project: selectedProject!, thisYear: false)
            }
            else {  data = ArchiveUtils.getTaskswith(project: selectedProject!, thisYear: true) }
            
            bottomtTableViewDelegate.data = NSArray(array: data!)
            
            if bottomView != nil
            {
                bottomView?.removeFromSuperview()
            }
            if selectedAgency != nil && selectedClient != nil
            {
                topTableViewHeight.constant = 130
            }else if selectedAgency == nil && selectedClient != nil
            {
                 topTableViewHeight.constant = 85
            }

            taskBtn.setTitleColor(projectBtn.titleLabel?.textColor, for: .normal) 

            topConstraint.constant = 0

            taskBtn.alpha = 1.0
            topTableViewDelegate.cellselected = cellSelected
            cellSelected = false
            topTableView.reloadData()
            //bottomTableView.reloadData()
            reloadBottomTables()
        }

    }
    
// MARK: - Update Action Buttons
    
    func initButtonsOnly()
    {
        //titleLabel.isHidden = true
        trashButton.isHidden = false
        editButtin.isHidden = false
        unarchiveButton.isHidden = true
        
    }
    
    func showUnarchiveButton()
    {
        unarchiveButton.isHidden = false
        unarchiveButton.alpha = 0.5
    }
    
    func hideButtons()
    {
        //titleLabel.isHidden = false
        trashButton.isHidden = true
        editButtin.isHidden = true
        unarchiveButton.isHidden = true
    }
    
// MARK: - Action Buttons Functions
    
    @IBAction func unarchivePressed()
    {
        if (topTableViewDelegate?.isEditing)!
        {
            deleteActionButtonPressed(action: "unarchive")
            setEditing()
        }
    }
    
    @IBAction func trashButtonPressed()
    {
        if (topTableViewDelegate?.isEditing)!
        {
            deleteActionButtonPressed(action: "delete")
            setEditing()
        }
    }
    
    @IBAction func setEditing()
    {
        if !edit
        {
            trashButton.setImage(UIImage(named:"btn-trash-selected"), for: .normal)
            unarchiveButton.setImage(UIImage(named: "btn-unarchive-selected"), for: .normal)
            edit = true
            trashButton.alpha = 1.0
            unarchiveButton.alpha = 1.0
        }
        else
        {
            trashButton.setImage(UIImage(named:"btn-trash"), for: .normal)
            unarchiveButton.setImage(UIImage(named: "btn-unarchive"), for: .normal)
            edit = false
            trashButton.alpha = 0.5
            unarchiveButton.alpha = 0.5
        }
        topTableViewDelegate?.setIsEditing(editing: edit)
    }
    
// MARK: - View Task Details
    func viewTaskDetails()
    {
        setButtonsActive(active: false)
        topTableView.reloadData()
        //bottomTableView.reloadData()
        reloadBottomTables()
        cellSelected = false
        
        bottomScrollView.isScrollEnabled = false;
    }
    
    func setButtonsActive(active:Bool)
    {
        if !active
        {
            incomeEarned.alpha = 0.3
            invoiceStatus.alpha = 0.3
            daysWorked.alpha = 0.3
            hoursWorked.alpha = 0.3
            numberOfProjects.alpha = 0.3
            
        }
        else
        {
            incomeEarned.alpha = 1
            invoiceStatus.alpha = 1
            numberOfProjects.alpha = 1
            daysWorked.alpha = 1
            hoursWorked.alpha = 1
        }
    }
    
    
    func changeButtonColor(btn:UIButton)
    {
        selectedTab.backgroundColor = UIColor.clear
        selectedTab = btn
        selectedTab.backgroundColor = UIColor.tabSelectedYellow()
    }
    

// MARK: - Five Buttons Functions
    @IBAction func numberProjectsClicked(btn:UIButton)
    {
        scrollBottomToPage(page: 0)
    }
    
    @IBAction func invoiceStatusClicked(btn:UIButton)
    {
        scrollBottomToPage(page: 1)
    }
    
    @IBAction func incomeEarnedClicked(btn:UIButton)
    {
        scrollBottomToPage(page: 2)
    }
    
    @IBAction func hoursWorkedClicked(btn:UIButton)
    {
        scrollBottomToPage(page: 3)
    }
    
    @IBAction func daysWorkedClicked(btn:UIButton)
    {
        scrollBottomToPage(page: 4)
    }
    
    func scrollBottomToPage(page: CGFloat) {
        self.bottomScrollView.setContentOffset(CGPoint(x: self.bottomScrollView.bounds.size.width*page, y: 0), animated: true)
    }
    
// MARK: - Set Buttons to Normal
    func setButtonsNormal()
    {
        numberOfProjects.isSelected = false
        invoiceStatus.isSelected = false
        incomeEarned.isSelected = false
        hoursWorked.isSelected = false
        daysWorked.isSelected = false
        
        numberOfProjects.tintColor = UIColor(red: 34/255, green: 31/255, blue: 31/255, alpha: 1.0)
        invoiceStatus.tintColor = UIColor(red: 34/255, green: 31/255, blue: 31/255, alpha: 1.0)
        incomeEarned.tintColor = UIColor(red: 34/255, green: 31/255, blue: 31/255, alpha: 1.0)
        hoursWorked.tintColor = UIColor(red: 34/255, green: 31/255, blue: 31/255, alpha: 1.0)
        daysWorked.tintColor = UIColor(red: 34/255, green: 31/255, blue: 31/255, alpha: 1.0)
    }
    
// MARK: - Show Bottom View
    func showBottomView()
    {
        if bottomView != nil
        {
            bottomView?.removeFromSuperview()
        }
        bottomView = UIView()
        bottomView?.backgroundColor = UIColor(red: 34/255, green: 31/255, blue: 31/255, alpha: 1.0)
        bottomView?.translatesAutoresizingMaskIntoConstraints = false
        
        bottomViewLabel = UILabel()
        bottomViewLabel?.translatesAutoresizingMaskIntoConstraints = false
        bottomViewLabel?.font = UIFont().boldFont()
        bottomViewLabel?.textColor = UIColor.white
        bottomViewLabel?.alpha = 0.5
        
        bottomView?.addSubview(bottomViewLabel!)
        bottomView?.addConstraint(NSLayoutConstraint(item: bottomView!, attribute: .centerY, relatedBy: .equal, toItem: bottomViewLabel!, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        bottomView?.addConstraint(NSLayoutConstraint(item: bottomView!, attribute: .leading, relatedBy: .equal, toItem: bottomViewLabel!, attribute: .leading, multiplier: 1.0, constant: -20.0))
        
        bottomTableViewBottom.constant = 35
        view.addSubview(bottomView!)

        view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .leading, relatedBy: .equal, toItem: bottomView, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: bottomView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: bottomView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: bottomTableView, attribute: .bottom, relatedBy: .equal, toItem: bottomView, attribute: .top, multiplier: 1.0, constant: 0.0))
        
    }
    
    
    
    func deleteActionButtonPressed(action:String) {
        
        self.action = action
        actionView = UIView()
        actionView?.translatesAutoresizingMaskIntoConstraints = false
        actionView?.backgroundColor = UIColor.clear
        
        let archiveViewTop = UIView()
        archiveViewTop.tag = 3
        archiveViewTop.translatesAutoresizingMaskIntoConstraints = false
        archiveViewTop.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        actionView?.addSubview(archiveViewTop)
        actionView?.addConstraint(NSLayoutConstraint(item: actionView! , attribute: .centerX, relatedBy: .equal, toItem: archiveViewTop, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        actionView?.addConstraint(NSLayoutConstraint(item: actionView!, attribute: .bottom, relatedBy: .equal, toItem: archiveViewTop, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        actionView?.addConstraint(NSLayoutConstraint(item: actionView!, attribute: .width, relatedBy: .equal, toItem: archiveViewTop, attribute: .width, multiplier: 1.0, constant: 0.0))
        actionView?.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .height, relatedBy: .equal, toItem: actionView, attribute: .height, multiplier: 0.3, constant: 0.0))
        
        let archiveTopLabel = UILabel()
        archiveTopLabel.translatesAutoresizingMaskIntoConstraints = false
        if action == "unarchive"
        {
            archiveTopLabel.text = "UN-ARCHIVE SELECTED"
        }
        else
        {
            archiveTopLabel.text = "DELETE SELECTED"
        }
        archiveTopLabel.font = UIFont(name: "Neo Sans", size: 12)
        archiveTopLabel.textColor = UIColor.white
        archiveTopLabel.textAlignment = .center
        archiveViewTop.addSubview(archiveTopLabel)
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .top, relatedBy: .equal, toItem: archiveTopLabel, attribute: .top, multiplier: 1.0, constant: -20))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .centerX, relatedBy: .equal, toItem: archiveTopLabel, attribute: .centerX, multiplier: 1.0, constant: 0))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .width, relatedBy: .equal, toItem: archiveTopLabel, attribute: .width, multiplier: 1.0, constant: 10))
        
        
        let trashBottomLabel = UILabel()
        trashBottomLabel.translatesAutoresizingMaskIntoConstraints = false
        trashBottomLabel.numberOfLines = 3
        var attrString:NSMutableAttributedString!
        if action == "unarchive"
        {
             attrString = NSMutableAttributedString(string: "NOTE:\n\n Un-Archiving will unarchive all sub attriubutes")
        }else{
            attrString = NSMutableAttributedString(string: "NOTE:\n\n Deleting will delete all sub attriubutes")
        }
        
        attrString.addAttributes([NSFontAttributeName: UIFont(name:"Neo Sans", size:12)!, NSForegroundColorAttributeName:UIColor.white], range: NSMakeRange(6, attrString.length-6))
        let font = UIFont(name: "NeoSans-Medium", size: 13)
        
        attrString.addAttributes([NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:font!], range: NSMakeRange(0,6))
        trashBottomLabel.attributedText = attrString
        trashBottomLabel.textAlignment = .center
        archiveViewTop.addSubview(trashBottomLabel)
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .bottom, relatedBy: .equal, toItem: trashBottomLabel, attribute: .bottom, multiplier: 1.0, constant:20))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .centerX, relatedBy: .equal, toItem: trashBottomLabel, attribute: .centerX, multiplier: 1.0, constant: 0))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .width, relatedBy: .equal, toItem: trashBottomLabel, attribute: .width, multiplier: 1.0, constant: 75))
        
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(UIImage(named:"btn-cancel-red"), for: .normal)
        archiveViewTop.addSubview(cancelButton)
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .centerY, relatedBy: .equal, toItem: cancelButton, attribute: .centerY, multiplier: 1.0, constant: 10.0))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .centerX, relatedBy: .equal, toItem: cancelButton, attribute: .trailing, multiplier: 1.0, constant: 5.0))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 75.0))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 75.0))
        cancelButton.addTarget(self, action: #selector(actionButtonNoPressed), for: .touchUpInside)
        
        let deleteButton = UIButton()
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setImage(UIImage(named:"btn-archive-yes"), for: .normal)
        archiveViewTop.addSubview(deleteButton)
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .centerY, relatedBy: .equal, toItem: deleteButton, attribute: .centerY, multiplier: 1.0, constant: 10.0))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .centerX, relatedBy: .equal, toItem: deleteButton, attribute: .leading, multiplier: 1.0, constant: -5.0))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 75.0))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 75.0))
        deleteButton.addTarget(self, action: #selector(actionButtonYesPressed), for: .touchUpInside)
        
        ArchiveWireframe.showOnScreen(view: actionView!)
    }
    
    func actionButtonYesPressed()
    {
        let topView = actionView?.viewWithTag(3)
        for s in (topView?.subviews)!
        {
            s.removeFromSuperview()
        }
        
        let jobsDeletedLabel = UILabel()
        jobsDeletedLabel.translatesAutoresizingMaskIntoConstraints = false
        jobsDeletedLabel.font = UIFont(name: "NeoSans-Medium", size: 12)
        jobsDeletedLabel.textColor = UIColor.white
        if action == "unarchive"
        { jobsDeletedLabel.text = "ITEMS UNARCHIVED" }
        else { jobsDeletedLabel.text = "ITEMS DELTETED" }
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
        
        if action == "unarchive" {
            bottomtTableViewDelegate.unarhiveSelected()
        }
        else {
            bottomtTableViewDelegate.deleteSelected()
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: delay, execute: {
            self.actionView?.removeFromSuperview()
            self.actionView = nil
            self.cellSelected = true
            if self.selectedStatus == .PROJECT { self.projectTabPressed() }
            if self.selectedStatus == .CLIENT { self.clientTabPressed() }
            if self.selectedStatus == .PROJECT { self.projectTabPressed() }
            if self.selectedStatus == .TASK { self.taskTabPressed() }
            self.cellSelected = false
            self.agencyTabPressed()
        })


    }
    
    func actionButtonNoPressed()
    {
        actionView?.removeFromSuperview()
    }
    
// MARK: - UIScrollView Delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handleScrollActions(scrollView: scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        handleScrollActions(scrollView: scrollView)
    }
    
    func handleScrollActions(scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        setCenterLabelTextAtPage(pageNumber: Int(pageNumber))
        
        
        switch pageNumber {
        case 0: scrollToNumberOfProjects()
        case 1: scrollToInvoiceStatus()
        case 2: scrollToIncomeEarned()
        case 3: scrollToHoursWorked()
        case 4: scrollToDaysWorked()
            
        default:
            break
        }
    }
    
    func setCenterLabelTextAtPage(pageNumber: Int) {
        switch pageNumber {
        case 0: centerBarLabel.text = "Total Projects"
        case 1: centerBarLabel.text = "Invoice Status"
        case 2: centerBarLabel.text = "Total Earned"
        case 3: centerBarLabel.text = "Total Hours"//"Total Hours Worked"
        case 4: centerBarLabel.text = "Total Days"//"Total Days Worked"
            
        default:
            break
        }
    }
    
    func scrollToNumberOfProjects() {
        setButtonsNormal()
        
        buttonStatus = .NUMBER_OF_PROJECTS
        //bottomTableView.reloadData()
        reloadBottomTables()
        
        numberOfProjects.isSelected = true
        numberOfProjects.tintColor = UIColor.white
    }
    
    func scrollToInvoiceStatus() {
        setButtonsNormal()
        
        buttonStatus = .INVOICE_STATUS
        //bottomTableView.reloadData()
        reloadBottomTables()
        
        invoiceStatus.isSelected = true
        invoiceStatus.tintColor = UIColor.white
    }
    
    func scrollToIncomeEarned() {
        setButtonsNormal()
        
        buttonStatus = .INCOME
        //bottomTableView.reloadData()
        reloadBottomTables()
        
        incomeEarned.isSelected = true
        incomeEarned.tintColor = UIColor.white
    }
    
    func scrollToHoursWorked() {
        setButtonsNormal()
        
        buttonStatus = .TOTAL_HOURS_WORKED
        //bottomTableView.reloadData()
        reloadBottomTables()
        
        hoursWorked.isSelected = true
        hoursWorked.tintColor = UIColor.white
    }
    
    func scrollToDaysWorked() {
        setButtonsNormal()
        
        buttonStatus = .DAYS_WORKED
        //bottomTableView.reloadData()
        reloadBottomTables()
        
        daysWorked.isSelected = true
        daysWorked.tintColor = UIColor.white
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
