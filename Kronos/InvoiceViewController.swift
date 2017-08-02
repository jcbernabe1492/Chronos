//
//  InvoiceViewController.swift
//  Kronos
//
//  Created by Wee, David G. on 10/18/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit
import MessageUI

let invoiceStatusArray = ["DRAFT", "INVOICED", "OVERDUE","CRITICAL", "CLEARED"]
let invoiceStatusImages = ["DRAFT":"invoice-status-draft", "INVOICED":"invoice-status-invoiced", "OVERDUE":"invoice-status-overdue", "CRITICAL":"invoice-status-critical", "CLEARED":"invoice-status-cleared"]

class InvoiceViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet var draftsButton:UIButton!
    @IBOutlet var sentButton:UIButton!
    @IBOutlet var clearedButton:UIButton!
    @IBOutlet var summaryButton:UIButton!
    @IBOutlet var timingsButton:UIButton!
    
    @IBOutlet var summaryView:UIView?
    @IBOutlet var draftLabel:UILabel?
    @IBOutlet var draftDot:UIView?
    
    @IBOutlet var invoicedLabel:UILabel?
    @IBOutlet var invoicedDot:UIView?
    
    @IBOutlet var overdueLabel:UILabel?
    @IBOutlet var overdueDot:UIView?
    
    @IBOutlet var criticalLabel:UILabel?
    @IBOutlet var criticalDot:UIView?
    
    @IBOutlet var clearedLabel:UILabel?
    @IBOutlet var clearedDot:UIView?
    
    @IBOutlet var tableBottom:NSLayoutConstraint!
    
    @IBOutlet var invoiceStatusBtn:UIButton?
    
    @IBOutlet var sentView:UIView?
    @IBOutlet var sentViewLbl1:UILabel?
    @IBOutlet var sentViewDot1:UIView?
    @IBOutlet var sentViewLbl2:UILabel?
    @IBOutlet var sentViewDot2:UIView?
    @IBOutlet var sentViewLbl3:UILabel?
    @IBOutlet var sentViewDot3:UIView?
    
    
    var drafts = DraftsPresenter()
    var summary = SummaryPresenter()
    var invoiceSelected:Invoice?
    var fromOtherTab = false
    var archiveView:UIView?
    
    var askSwitchValue:Bool = true
    var clientButton:UIButton!
    var agencyButton:UIButton!
    var selectedPDFAddress:String = "agency"
    
    @IBOutlet var stackView:UIView!
    
    @IBOutlet var tableView:UITableView!
    var selectedTab:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()


        let v = UIView(frame: CGRect(x: 0, y: 0, width: (tableView?.frame.size.width)! , height: 0.5))
        v.backgroundColor = UIColor.black
        tableView?.tableFooterView = v
        if invoiceSelected == nil {
            summaryButton.titleLabel?.alpha = 0.5
            timingsButton.titleLabel?.alpha = 0.5
        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.changeSection(section: selectedTab)
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func changeSection(section:Int)
    {
        selectedTab = section
        draftsButton.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
        sentButton.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
        clearedButton.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
        summaryButton.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
        timingsButton.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
        switch selectedTab {
        case 0:
            draftsButton.backgroundColor = UIColor.tabSelectedYellow()
            tableView.delegate = drafts
            tableView.dataSource = drafts
            drafts.invoices = Invoice.getDrafts()
            drafts.tableInvoiceStatus = .DRAFTS
            drafts.currntTableStatus = .INCOME
            drafts.view = self
            summaryView?.isHidden = true
            sentView?.isHidden = true
            tableBottom.constant = 0
            break
        case 1:
            sentButton.backgroundColor = UIColor.tabSelectedYellow()
            tableView.delegate = drafts
            tableView.dataSource = drafts
            drafts.invoices = Invoice.getSent()
            drafts.tableInvoiceStatus = .SENT
            drafts.currntTableStatus = .INVOICE_STATUS
            drafts.view = self
            showSentView()
               summaryView?.isHidden = true
            break
        case 2:
            clearedButton.backgroundColor = UIColor.tabSelectedYellow()
            tableView.delegate = drafts
            tableView.dataSource = drafts
            drafts.invoices = Invoice.getCleared()
            drafts.tableInvoiceStatus = .CLEARED
            drafts.currntTableStatus = .INCOME
            drafts.view = self
            tableBottom.constant = 0
            summaryView?.isHidden = true
            sentView?.isHidden = true
            break
        case 3:
            summaryButton.backgroundColor = UIColor.tabSelectedYellow()
            tableView.delegate = summary
            tableView.dataSource = summary
            if invoiceSelected != nil
            {
                summary.invoice = invoiceSelected
            }
            summary.fromOtherTab = fromOtherTab
            summary.initValues()
            showSummaryView()
            invoiceSelected = nil
            fromOtherTab = false
            summary.timings = false
            sentView?.isHidden = true
            break
        case 4:
            timingsButton.backgroundColor = UIColor.tabSelectedYellow()
            tableView.delegate = summary
            tableView.dataSource = summary
            if invoiceSelected != nil
            {
                summary.invoice = invoiceSelected
            }
            summaryView?.isHidden = true
            tableBottom.constant = 0
            summary.fromOtherTab = fromOtherTab
            summary.timings = true
            summary.initValues()
            invoiceSelected = nil
            fromOtherTab = false
            sentView?.isHidden = true
            break
        default:
            break
        }
        tableView.reloadData()
    }

    @IBAction func tabClicked(btn:UIButton)
    {
        if btn.tag == 3 || btn.tag == 4 {
            if summary.invoice == nil {
                return
            }
        }
        fromOtherTab = true
        self.changeSection(section: btn.tag)
        fromOtherTab = false
    }
    
    func showSentView()
    {
        sentView?.isHidden = false
        tableBottom.constant = 25
        
        sentViewDot1?.layer.cornerRadius = 5
        sentViewDot2?.layer.cornerRadius = 5
        sentViewDot3?.layer.cornerRadius = 5
        
        sentViewDot1?.backgroundColor = UIColor.invoicedColor()
        sentViewDot2?.backgroundColor = UIColor.invoicedOverdueColor()
        sentViewDot3?.backgroundColor = UIColor.invoicedCriticalColor()
        
        sentViewLbl1?.text = "INVOICED"
        sentViewLbl2?.text = "OVERDUE"
        sentViewLbl3?.text = "CRITICAL"
        
        sentViewLbl1?.textColor = UIColor.white
        sentViewLbl2?.textColor = UIColor.white
        sentViewLbl3?.textColor = UIColor.white

    }
    
    
    func showSummaryView()
    {
        summaryView?.isHidden = false
        summaryView?.layer.shadowColor = UIColor.black.cgColor
        summaryView?.layer.shadowOffset = CGSize(width: 0, height: -5)
        summaryView?.layer.shadowOpacity = 0.3
        summaryView?.layer.shadowRadius = 10.0
        tableBottom.constant = 100
        
        
        draftDot?.layer.borderWidth = 1
        draftDot?.layer.cornerRadius = 4
        draftLabel?.textColor = UIColor.white
        draftLabel?.font = UIFont(name: "NeoSans", size: 9)!
        

        invoicedDot?.layer.borderWidth = 1
        invoicedDot?.layer.cornerRadius = 4
        invoicedLabel?.textColor = UIColor.white
        invoicedLabel?.font = UIFont(name: "NeoSans", size: 9)!
        

        criticalDot?.layer.borderWidth = 1
        criticalDot?.layer.cornerRadius = 4
        criticalLabel?.textColor = UIColor.white
        criticalLabel?.font = UIFont(name: "NeoSans", size: 9)!
        
        
        overdueDot?.layer.borderWidth = 1
        overdueDot?.layer.cornerRadius = 4
        overdueLabel?.textColor = UIColor.white
        overdueLabel?.font = UIFont(name: "NeoSans", size: 9)!
        
        clearedDot?.layer.borderWidth = 1
        clearedDot?.layer.cornerRadius = 4
        clearedLabel?.textColor = UIColor.white
        clearedLabel?.font = UIFont(name: "NeoSans", size: 9)!
        setInvoiveStatus()
        

    }
    
    func setInvoiveStatus()
    {
            draftDot?.layer.borderColor = UIColor.white.cgColor
            draftDot?.backgroundColor = UIColor.clear
            invoicedDot?.layer.borderColor = UIColor.invoicedColor().cgColor
            overdueDot?.layer.borderColor = UIColor.invoicedOverdueColor().cgColor
            criticalDot?.layer.borderColor = UIColor.invoicedCriticalColor().cgColor
            clearedDot?.layer.borderColor = UIColor.invoicedClearedColor().cgColor
            
            if summary.invoice?.status == "DRAFT"
            {
//                draftDot?.backgroundColor = UIColor.clear
                draftLabel?.alpha = 1.0
            }
            else
            {
//                draftDot?.backgroundColor = UIColor.white
                draftLabel?.alpha = 0.3
            }
            if summary.invoice?.status == "INVOICED"
            {
                invoicedDot?.backgroundColor = UIColor.invoicedColor()
                //invoicedDot?.backgroundColor = UIColor.clear
                invoicedLabel?.alpha = 1.0
            }
            else
            {
                invoicedDot?.backgroundColor = UIColor.clear
                //invoicedDot?.backgroundColor = UIColor.invoicedColor()
                invoicedLabel?.alpha = 0.3
            }
            
            if summary.invoice?.status == "CRITICAL"
            {
                criticalDot?.backgroundColor = UIColor.invoicedCriticalColor()
                //criticalDot?.backgroundColor = UIColor.clear
                criticalLabel?.alpha = 1.0
            }
            else
            {
                criticalDot?.backgroundColor = UIColor.clear
                //criticalDot?.backgroundColor = UIColor.invoicedCriticalColor()
                criticalLabel?.alpha = 0.3
            }
            
            if summary.invoice?.status == "OVERDUE"
            {
                overdueDot?.backgroundColor = UIColor.invoicedOverdueColor()
                //overdueDot?.backgroundColor = UIColor.clear
                overdueLabel?.alpha = 1.0
            }
            else
            {
                overdueDot?.backgroundColor = UIColor.clear
                //overdueDot?.backgroundColor = UIColor.invoicedOverdueColor()
                overdueLabel?.alpha = 0.3
            }
            
            if summary.invoice?.status == "CLEARED"
            {
                clearedDot?.backgroundColor = UIColor.invoicedClearedColor()
                //clearedDot?.backgroundColor = UIColor.clear
                clearedLabel?.alpha = 1.0
            }
            else
            {
                clearedDot?.backgroundColor = UIColor.clear
                //clearedDot?.backgroundColor = UIColor.invoicedClearedColor()
                clearedLabel?.alpha = 0.3
            }
            if summary.invoice != nil
            {
                invoiceStatusBtn?.setImage(UIImage(named:invoiceStatusImages[(summary.invoice?.status)!]!), for: .normal)
            }
    }
    
    @IBAction func invoiceStatusButtonPressed()
    {
        if summary.invoice != nil
        {
            let index = invoiceStatusArray.index(of: summary.invoice!.status)
            if index == invoiceStatusArray.endIndex-1
            {
                summary.invoice?.status = invoiceStatusArray[0]
            }
            else
            {
                summary.invoice?.status = invoiceStatusArray[index! + 1]
            }
            try! DataController.sharedInstance.managedObjectContext.save()
            setInvoiveStatus()
        }
    }
    
    @IBAction func archiveButtonPressed()
    {
        archiveView = UIView()
        archiveView?.translatesAutoresizingMaskIntoConstraints = false
        archiveView?.backgroundColor = UIColor.clear
        
        let archiveViewTop = UIView()
        archiveViewTop.tag = 3
        archiveViewTop.translatesAutoresizingMaskIntoConstraints = false
        archiveViewTop.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        archiveView?.addSubview(archiveViewTop)
        archiveView?.addConstraint(NSLayoutConstraint(item: archiveView! , attribute: .centerX, relatedBy: .equal, toItem: archiveViewTop, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        archiveView?.addConstraint(NSLayoutConstraint(item: archiveView!, attribute: .bottom, relatedBy: .equal, toItem: archiveViewTop, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        archiveView?.addConstraint(NSLayoutConstraint(item: archiveView!, attribute: .width, relatedBy: .equal, toItem: archiveViewTop, attribute: .width, multiplier: 1.0, constant: 0.0))
        archiveView?.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .height, relatedBy: .equal, toItem: archiveView, attribute: .height, multiplier: 0.3, constant: 0.0))
        
        let archiveTopLabel = UILabel()
        archiveTopLabel.translatesAutoresizingMaskIntoConstraints = false
        archiveTopLabel.text = "ARCHIVE CURRENT JOB"
        archiveTopLabel.font = UIFont(name: "Neo Sans", size: 12)
        archiveTopLabel.textColor = UIColor.white
        archiveTopLabel.textAlignment = .center
        archiveViewTop.addSubview(archiveTopLabel)
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .top, relatedBy: .equal, toItem: archiveTopLabel, attribute: .top, multiplier: 1.0, constant: -20))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .centerX, relatedBy: .equal, toItem: archiveTopLabel, attribute: .centerX, multiplier: 1.0, constant: 0))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .width, relatedBy: .equal, toItem: archiveTopLabel, attribute: .width, multiplier: 1.0, constant: 10))
        
        
        let trashBottomLabel = UILabel()
        trashBottomLabel.translatesAutoresizingMaskIntoConstraints = false
        let attrString = NSMutableAttributedString(string: "NOTE:\n Jobs archived are automatically removed from INVOICES\nwith their invoice status changed to CLEARED.")
    
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0;
        attrString.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, attrString.length))
        
        let fontSize:CGFloat = UIScreen().isIphone5() ? 10.0 : 12.0
        attrString.addAttributes([NSFontAttributeName: UIFont(name:"Neo Sans", size:fontSize)!, NSForegroundColorAttributeName:UIColor.white], range: NSMakeRange(6, attrString.length-6))
        
        
        
        let font = UIFont(name: "NeoSans-Medium", size: fontSize)
        attrString.addAttributes([NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:font!], range: NSMakeRange(0,6))
        trashBottomLabel.attributedText = attrString

        trashBottomLabel.numberOfLines = 5
        trashBottomLabel.textAlignment = .center
        archiveViewTop.addSubview(trashBottomLabel)
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .bottom, relatedBy: .equal, toItem: trashBottomLabel, attribute: .bottom, multiplier: 1.0, constant:20))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .centerX, relatedBy: .equal, toItem: trashBottomLabel, attribute: .centerX, multiplier: 1.0, constant: 0))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .width, relatedBy: .equal, toItem: trashBottomLabel, attribute: .width, multiplier: 1.0, constant: 50))
        
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(UIImage(named:"btn-cancel-red"), for: .normal)
        archiveViewTop.addSubview(cancelButton)
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .centerY, relatedBy: .equal, toItem: cancelButton, attribute: .centerY, multiplier: 1.0, constant: 10.0))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .centerX, relatedBy: .equal, toItem: cancelButton, attribute: .trailing, multiplier: 1.0, constant: 5.0))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 65.0))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 65.0))
        cancelButton.addTarget(self, action: #selector(InvoiceViewController.cancelButtonPressed), for: .touchUpInside)
        
        let deleteButton = UIButton()
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setImage(UIImage(named:"btn-archive-yes"), for: .normal)
        archiveViewTop.addSubview(deleteButton)
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .centerY, relatedBy: .equal, toItem: deleteButton, attribute: .centerY, multiplier: 1.0, constant: 10.0))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: archiveViewTop, attribute: .centerX, relatedBy: .equal, toItem: deleteButton, attribute: .leading, multiplier: 1.0, constant: -5.0))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 65.0))
        archiveViewTop.addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 65.0))
        deleteButton.addTarget(self, action: #selector(InvoiceViewController.archivePressed), for: .touchUpInside)
        
        InvoiceWireframe.showOnScreen(view: archiveView!)

    }
    
    
    func cancelButtonPressed()
    {
        archiveView?.removeFromSuperview()
        archiveView = nil
    }
    
    func archivePressed()
    {
        let topView = archiveView?.viewWithTag(3)
        for s in (topView?.subviews)!
        {
            s.removeFromSuperview()
        }
        
        let jobsDeletedLabel = UILabel()
        jobsDeletedLabel.translatesAutoresizingMaskIntoConstraints = false
        jobsDeletedLabel.font = UIFont(name: "NeoSans-Medium", size: 12)
        jobsDeletedLabel.textColor = UIColor.white
        jobsDeletedLabel.text = "JOB ARCHIVED"
        topView?.addSubview(jobsDeletedLabel)
        topView?.addConstraint(NSLayoutConstraint(item: topView!, attribute: .centerX, relatedBy: .equal, toItem: jobsDeletedLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        topView?.addConstraint(NSLayoutConstraint(item: topView!, attribute: .top, relatedBy: .equal, toItem: jobsDeletedLabel, attribute: .top, multiplier: 1.0, constant: -20.0))
        
        let deletedIcon = UIImageView(image: UIImage(named:"btn-archive-yes"))
        deletedIcon.translatesAutoresizingMaskIntoConstraints = false
        topView?.addSubview(deletedIcon)
        topView?.addConstraint(NSLayoutConstraint(item: topView!, attribute: .centerX, relatedBy: .equal, toItem: deletedIcon, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        topView?.addConstraint(NSLayoutConstraint(item: topView!, attribute: .centerY, relatedBy: .equal, toItem: deletedIcon, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        topView?.addConstraint(NSLayoutConstraint(item: deletedIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 75.0))
        topView?.addConstraint(NSLayoutConstraint(item: deletedIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 75.0))
        
        let delay = DispatchTime.now() + .seconds(1)
        
        DispatchQueue.main.asyncAfter(deadline: delay, execute: {
            self.archiveView?.removeFromSuperview()
            self.archiveView = nil
            self.summary.invoice?.archived = true
            let timer = JobTimer.getTimerWith(id: (self.summary.invoice?.timerID.intValue)!)
            let i = Invoice.getInvoiceWith(jobId: timer!.id)
            Invoice.delete(id: i!.id)
            let task = StageTask.getStageTask(forId: (timer?.stageTaskId.intValue)!)
           
            var recentArray = UserDefaults.standard.value(forKey: RECENT_TASKS) as! Array<Int>
            if recentArray.contains((timer?.id.intValue)!)
            {
                for i in 0 ... (recentArray.count-1)
                {
                    if recentArray[i] == timer?.id.intValue
                    {
                        recentArray.remove(at: i)
                        break
                    }
                }
                UserDefaults.standard.setValue(recentArray, forKey: RECENT_TASKS)
            }
            task?.archived = true
            
            if UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) as? NSNumber == timer?.id{
                UserDefaults.standard.removeObject(forKey: CURRENT_JOB_TIMER)
            }
            
            try! DataController.sharedInstance.managedObjectContext.save()
            self.archiveView?.removeFromSuperview()
            self.summary.invoice = nil
            self.tableView.reloadData()
        })
    }
    
    
    @IBAction func pdfButtonPressed()
    {
        guard let _ = summary.invoice else {return}
        
        let pdfAskingView = UIView()
        pdfAskingView.translatesAutoresizingMaskIntoConstraints = false
        pdfAskingView.backgroundColor = UIColor(red: 50.0/250.0, green: 50.0/250.0, blue: 50.0/250.0, alpha: 1.0)
        view.addSubview(pdfAskingView)
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: pdfAskingView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: pdfAskingView, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: pdfAskingView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: pdfAskingView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIScreen.main.bounds.size.height/3))
        
        let topLabel = UILabel()
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.text = "ADDRESS INVOICE TO"
        topLabel.font = UIFont().boldFont()
        topLabel.textColor = UIColor.white
        pdfAskingView.addSubview(topLabel)
        view.addConstraint(NSLayoutConstraint(item: pdfAskingView, attribute: .top, relatedBy: .equal, toItem: topLabel, attribute: .top, multiplier: 1.0, constant: -10.0))
        view.addConstraint(NSLayoutConstraint(item: pdfAskingView, attribute: .centerX, relatedBy: .equal, toItem: topLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(UIImage(named:"btn-cancel-red"), for: .normal)
        cancelButton.contentMode = .scaleAspectFit
        cancelButton.addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal, toItem: cancelButton, attribute: .height, multiplier: 1.0, constant: 0.0))
        cancelButton.addTarget(self, action: #selector(closePDFView(btn:)), for: .touchUpInside)
        
        agencyButton = UIButton()
        agencyButton.translatesAutoresizingMaskIntoConstraints = false
        agencyButton.setImage(UIImage(named:"agency-btn-selected"), for: .normal)
        agencyButton.contentMode = .scaleAspectFit
        agencyButton.addConstraint(NSLayoutConstraint(item: agencyButton, attribute: .width, relatedBy: .equal, toItem: agencyButton, attribute: .height, multiplier: 1.0, constant: 0.0))
          agencyButton.addTarget(self, action: #selector(agencyButtonClicked), for: .touchUpInside)
        
        clientButton = UIButton()
        clientButton.translatesAutoresizingMaskIntoConstraints = false
        clientButton.setImage(UIImage(named:"client-btn"), for: .normal)
        clientButton.contentMode = .scaleAspectFit
        clientButton.addConstraint(NSLayoutConstraint(item: clientButton, attribute: .width, relatedBy: .equal, toItem: clientButton, attribute: .height, multiplier: 1.0, constant: 0.0))
          clientButton.addTarget(self, action: #selector(clientButtonClicked), for: .touchUpInside)
        
        let emailPDFButton = UIButton()
        emailPDFButton.translatesAutoresizingMaskIntoConstraints = false
        emailPDFButton.setImage(UIImage(named:"email-pdf-btn"), for: .normal)
        emailPDFButton.contentMode = .scaleAspectFit
        emailPDFButton.addConstraint(NSLayoutConstraint(item: emailPDFButton, attribute: .width, relatedBy: .equal, toItem: emailPDFButton, attribute: .height, multiplier: 1.0, constant: 0.0))
        emailPDFButton.addTarget(self, action: #selector(pdfEmailButtonPressed), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [cancelButton, agencyButton, clientButton, emailPDFButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.spacing = 5.0
        stack.alignment = .center
        pdfAskingView.addSubview(stack)
        view.addConstraint(NSLayoutConstraint(item: topLabel, attribute: .bottom, relatedBy: .equal, toItem: stack, attribute: .top, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: pdfAskingView, attribute: .leading, relatedBy: .equal, toItem: stack, attribute: .leading, multiplier: 1.0, constant: -20.0))
        view.addConstraint(NSLayoutConstraint(item: pdfAskingView, attribute: .trailing, relatedBy: .equal, toItem: stack, attribute: .trailing, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: stack, attribute: .height, relatedBy: .equal, toItem: pdfAskingView, attribute: .height, multiplier: 0.5, constant: 0.0))
        
        let agencyLabel = UILabel()
        agencyLabel.text = "AGENCY"
        agencyLabel.textColor = UIColor.white
        agencyLabel.font = UIFont().boldFont()
        agencyLabel.translatesAutoresizingMaskIntoConstraints = false
        agencyLabel.textAlignment = .center
        pdfAskingView.addSubview(agencyLabel)
        view.addConstraint(NSLayoutConstraint(item: agencyButton, attribute: .bottom, relatedBy: .equal, toItem: agencyLabel, attribute: .top, multiplier: 1.0, constant: -5.0))
        view.addConstraint(NSLayoutConstraint(item: agencyButton, attribute: .centerX, relatedBy: .equal, toItem: agencyLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        
        let clientLabel = UILabel()
        clientLabel.text = "CLIENT"
        clientLabel.textColor = UIColor.white
        clientLabel.font = UIFont().boldFont()
        clientLabel.translatesAutoresizingMaskIntoConstraints = false
        clientLabel.textAlignment = .center
        pdfAskingView.addSubview(clientLabel)
        view.addConstraint(NSLayoutConstraint(item: clientButton, attribute: .bottom, relatedBy: .equal, toItem: clientLabel, attribute: .top, multiplier: 1.0, constant: -5.0))
        view.addConstraint(NSLayoutConstraint(item: clientButton, attribute: .centerX, relatedBy: .equal, toItem: clientLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
      
        
        let emailLabel = UILabel()
        emailLabel.text = "EMAIL PDF"
        emailLabel.textColor = UIColor.white
        emailLabel.font = UIFont().boldFont()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.textAlignment = .center
        pdfAskingView.addSubview(emailLabel)
        view.addConstraint(NSLayoutConstraint(item: emailPDFButton, attribute: .bottom, relatedBy: .equal, toItem: emailLabel, attribute: .top, multiplier: 1.0, constant: -5.0))
        view.addConstraint(NSLayoutConstraint(item: emailPDFButton, attribute: .centerX, relatedBy: .equal, toItem: emailLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor.white
        pdfAskingView.addSubview(separatorView)
        
        view.addConstraint(NSLayoutConstraint(item: pdfAskingView, attribute: .leading, relatedBy: .equal, toItem: separatorView, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: pdfAskingView, attribute: .trailing, relatedBy: .equal, toItem: separatorView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: separatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 2.0))
        view.addConstraint(NSLayoutConstraint(item: agencyLabel, attribute: .bottom, relatedBy: .equal, toItem: separatorView, attribute: .top, multiplier: 1.0, constant: -20.0))
        
        
        let bottomLabel = UILabel()
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.text = "Auto change INVOICE STATUS to INVOICED"
        bottomLabel.textColor = UIColor.white
        bottomLabel.font = UIFont().boldFont()
        
        pdfAskingView.addSubview(bottomLabel)
        view.addConstraint(NSLayoutConstraint(item: pdfAskingView, attribute: .leading, relatedBy: .equal, toItem: bottomLabel, attribute: .leading, multiplier: 1.0, constant: -10.0))
        view.addConstraint(NSLayoutConstraint(item: pdfAskingView, attribute: .bottom, relatedBy: .equal, toItem: bottomLabel, attribute: .bottom, multiplier: 1.0, constant: 25.0))
        
        let askingSwitch = UISwitch()
        askingSwitch.translatesAutoresizingMaskIntoConstraints = false
        askingSwitch.isOn = true
        pdfAskingView.addSubview(askingSwitch)
        view.addConstraint(NSLayoutConstraint(item: bottomLabel, attribute: .centerY, relatedBy: .equal, toItem: askingSwitch, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: pdfAskingView, attribute: .trailing, relatedBy: .equal, toItem: askingSwitch, attribute: .trailing, multiplier: 1.0, constant:20.0))
        askingSwitch.addTarget(self, action: #selector(askSwitchChanged(s:)), for: .valueChanged)
        
    }
    
    func askSwitchChanged(s:UISwitch){
        askSwitchValue = s.isOn
    }
    
    func closePDFView(btn:UIButton)
    {
        btn.superview!.superview!.removeFromSuperview()
    }
    
    func clientButtonClicked()
    {
        clientButton.setImage(UIImage(named:"client-btn-selected"), for: .normal)
        agencyButton.setImage(UIImage(named:"agency-btn"), for: .normal)
        selectedPDFAddress = "client"
    }
    
    func agencyButtonClicked()
    {
        agencyButton.setImage(UIImage(named:"agency-btn-selected"), for: .normal)
        clientButton.setImage(UIImage(named:"client-btn"), for: .normal)
        selectedPDFAddress = "agency"
    }
    func pdfEmailButtonPressed(btn:UIButton)
    {
         guard let invoice = summary.invoice else {return}
         var creator = InvoiceToPDF()
         let path = creator.createPDFFrom(invoice, address: selectedPDFAddress)
         let mailController = configureMailController(pdfInvoicePath: path)
         if MFMailComposeViewController.canSendMail()
         {
            self.present(mailController, animated: true, completion: nil)
         }
        btn.superview!.superview!.removeFromSuperview()
        
        if askSwitchValue == true
        {
            summary.invoice?.status = "INVOICED"
            try! DataController.sharedInstance.managedObjectContext.save()
            setInvoiveStatus()
        }
 
    }
    private func configureMailController(pdfInvoicePath:PDFPath) -> MFMailComposeViewController
    {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        
        mailComposer.setSubject("Invoice:")
        let pdfData = try! Data(contentsOf: URL(fileURLWithPath: pdfInvoicePath))
        mailComposer.addAttachmentData(pdfData, mimeType: "pdf", fileName: "Invoice.pdf")
        return mailComposer
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
