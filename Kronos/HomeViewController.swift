//
//  HomeViewController.swift
//  Kronos
//
//  Created by Wee, David G. on 8/15/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController, HomeViewControllerProtocol, UIScrollViewDelegate {

    var presenter : HomePresenterProtocol?
    
    
    //Outlets
    @IBOutlet var timerTopLabels:UIStackView?
    @IBOutlet var bottomHeaderBar:UIView?
    @IBOutlet var topLabelButton:UIButton?
    @IBOutlet var topHeader:UIView?
    @IBOutlet var settingsButton:UIButton?
    @IBOutlet var addTimerButton:UIButton?
    @IBOutlet var loadTimerButton:UIButton?
    @IBOutlet var calenderButton:UIButton?
    @IBOutlet var invoiceButton:UIButton?
    @IBOutlet var invoicesButton:UIButton!
    @IBOutlet var invoiceButtonTitle:UILabel!
    
    @IBOutlet var helpButton:UIButton!
    
    @IBOutlet var archiveButton:UIButton!
    @IBOutlet var bottomHeaderLabel:UILabel!
    
    @IBOutlet var incomeEarnedButton:UIButton!
    @IBOutlet var hoursWorkedButton:UIButton!
    @IBOutlet var daysWorkedButton:UIButton!
    
    @IBOutlet var clientNameLabel:UILabel?
    @IBOutlet var projectNameLabel:UILabel?
    @IBOutlet var taskNameLabel: UILabel?
    @IBOutlet var allocatedForTaskName:UILabel?
    @IBOutlet var allocatedForTaskLabel:UILabel?
    @IBOutlet var hoursLabelTop:UILabel?
    @IBOutlet var clientValueLabel:UILabel!
    @IBOutlet var projectValueLabel:UILabel!
    @IBOutlet var taskValueLabel:UILabel!
    
    @IBOutlet var allocatedStack:UIStackView!
    @IBOutlet var dayTitleLabel:UILabel!
    @IBOutlet var taskDay:UILabel!
    @IBOutlet var projectDay:UILabel!
    @IBOutlet var projectTimeAlloc:UILabel!
    @IBOutlet var taskTimeAlloc:UILabel!
    
    @IBOutlet var thisYearButton:UIButton!
    @IBOutlet var fullHistoryButton:UIButton!
    @IBOutlet var minuteLabel:UILabel!
    @IBOutlet var hourLabel:UILabel!
    @IBOutlet var dayLabel:UILabel!
    
    @IBOutlet var pageScroller:UIPageControl!
    @IBOutlet var bottomBtnMoneyEarned:UIButton!
     @IBOutlet var bottomBtnTimeWorked:UIButton!
    @IBOutlet var bottomBtnDaysWorked:UIButton!
    var calenderActive = false
    var invoiceActive = false
    var invoiceAskView:UIView?
    var invoicesActive = false
    var archiveIsActive = false
    
    var bottomButtonSelected:UIButton?
    @IBOutlet var bottomTitleLabel:UILabel!
    
    @IBOutlet var animationView:UIView?
    
    var timerView1:TimerView?
    var timerView2:TimerView?
    var timerView3:TimerView?
    
    var addTimeTop:UIView?
    var addTimeBottom:UIView?
    
    var settingsSelected:Bool = false
    var addTimerSeleced:Bool = false
    var loadTimerSelected:Bool = false
    
    var timerScrollView:UIScrollView!
    var selectedTimer:TimerView!
    
    var page:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.checkTimer), name: Notification.Name(rawValue: "didBecomeActive"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.settingsDidChange), name: Notification.Name(rawValue: "kSettingsChangedNotificaiton"), object: nil)
        bottomButtonSelected = incomeEarnedButton
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.updateTopLabels), name: NSNotification.Name(rawValue: "kCheckTime"), object: nil)
        
        helpButton.isHidden = !(UserDefaults.standard.value(forKey: "helpButtonVIsability") as! Bool)
        // Do any additional setup after loading the view.

    }

    
    func settingsDidChange()
    {
         helpButton.isHidden = !(UserDefaults.standard.value(forKey: "helpButtonVIsability") as! Bool)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateHomeScreenValues()
    }
    
    func checkTimer(){
        timerView1?.checkCurrentTimerPosition()
        timerView2?.checkCurrentTimerPosition()
        timerView3?.checkCurrentTimerPosition()
    }

    func updateTopLogoImage(image: UIImage) {
        topLabelButton?.setImage(image, for: .normal)
    }
    
    
    func showScrollViewWithTimers(timer1:TimerView?, timer2:TimerView?, timer3:TimerView?)
    {
        timerScrollView = UIScrollView()
        timerScrollView.delegate = self
        timerScrollView.bounces = true
        
        
        self.timerView1 = timer1
        self.timerView2 = timer2
        self.timerView3 = timer3
        selectedTimer = timer1
        
        timerScrollView.translatesAutoresizingMaskIntoConstraints = false

        view.insertSubview(timerScrollView, belowSubview: topHeader!)
        
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: timerScrollView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: timerTopLabels!, attribute: .bottom, relatedBy: .equal, toItem: timerScrollView, attribute: .top, multiplier: 1.0, constant: -10.0))
        if UIScreen.device() == DEVICE.iphone_5
        {
            view.addConstraint(NSLayoutConstraint(item: bottomHeaderBar!, attribute: .top, relatedBy: .equal, toItem: timerScrollView, attribute: .bottom, multiplier: 1.0, constant: 20.0))
        }
        else
        {
            view.addConstraint(NSLayoutConstraint(item: bottomHeaderBar!, attribute: .top, relatedBy: .equal, toItem: timerScrollView, attribute: .bottom, multiplier: 1.0, constant: 35.0))
        }
        view.addConstraint(NSLayoutConstraint(item: timerScrollView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0.0))
        
        timerScrollView.isPagingEnabled = true
        automaticallyAdjustsScrollViewInsets = false
        timerScrollView.showsVerticalScrollIndicator = false
        timerScrollView.showsHorizontalScrollIndicator = false
        timerScrollView.bounces = true
        
        
        timerScrollView.contentSize = CGSize(width: (timerScrollView.bounds.size.width*3), height: timerScrollView.bounds.size.height-20)
        
        
        timerScrollView.addSubview(timer1!)
        
        timer1?.translatesAutoresizingMaskIntoConstraints = false
        timerScrollView.addConstraint(NSLayoutConstraint(item: timerScrollView, attribute: .centerX, relatedBy: .equal, toItem: timer1!, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        timerScrollView.addConstraint(NSLayoutConstraint(item: timerScrollView, attribute: .centerY, relatedBy: .equal, toItem: timer1!, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        timerScrollView.addConstraint(NSLayoutConstraint(item: timerScrollView, attribute: .height, relatedBy: .equal, toItem: timer1!, attribute: .height, multiplier: 1.0, constant: 0.0))
        
        timerScrollView.addConstraint(NSLayoutConstraint(item: timer1!, attribute: .width, relatedBy: .equal, toItem: timer1!, attribute: .height, multiplier: 1.0, constant: 0.0))
        
        timerScrollView.layoutIfNeeded()
        timerScrollView.contentSize = CGSize(width: (timerScrollView.bounds.size.width*3) , height: timerScrollView.bounds.size.height-20)

        
        timerScrollView.addSubview(timer2!)
        timer2?.translatesAutoresizingMaskIntoConstraints = false
        timerScrollView.addConstraint(NSLayoutConstraint(item: timerScrollView, attribute: .centerX, relatedBy: .equal, toItem: timer2!, attribute: .centerX, multiplier: 1.0, constant: -(timerScrollView.contentSize.width/3)))
        
        timerScrollView.addConstraint(NSLayoutConstraint(item: timerScrollView, attribute: .centerY, relatedBy: .equal, toItem: timer2!, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        timerScrollView.addConstraint(NSLayoutConstraint(item: timerScrollView, attribute: .height, relatedBy: .equal, toItem: timer2!, attribute: .height, multiplier: 1.0, constant: 0.0))
        
        timerScrollView.addConstraint(NSLayoutConstraint(item: timer2!, attribute: .width, relatedBy: .equal, toItem: timer2!, attribute: .height, multiplier: 1.0, constant: 0.0))

         timerScrollView.layoutIfNeeded()
        
        timerScrollView.addSubview(timer3!)
        timer3?.translatesAutoresizingMaskIntoConstraints = false
        timerScrollView.addConstraint(NSLayoutConstraint(item: timerScrollView, attribute: .centerX, relatedBy: .equal, toItem: timer3!, attribute: .centerX, multiplier: 1.0, constant: -(timerScrollView.contentSize.width/3)*2))
        
        timerScrollView.addConstraint(NSLayoutConstraint(item: timerScrollView, attribute: .centerY, relatedBy: .equal, toItem: timer3!, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        timerScrollView.addConstraint(NSLayoutConstraint(item: timerScrollView, attribute: .height, relatedBy: .equal, toItem: timer3!, attribute: .height, multiplier: 1.0, constant: 0.0))
        
        timerScrollView.addConstraint(NSLayoutConstraint(item: timer3!, attribute: .width, relatedBy: .equal, toItem: timer3!, attribute: .height, multiplier: 1.0, constant: 0.0))
        
        timerScrollView.layoutIfNeeded()
    
    }
    

    
    func setAllButtonsUnselected()
    {
        calenderButton?.setImage(UIImage(named:"icn-calendar"), for: .normal)
        loadTimerButton?.setImage(UIImage(named:"icn-load-timer"), for: .normal)
        addTimerButton?.setImage(UIImage(named: "icn-add-timer"), for: .normal)
        invoiceButton?.setImage(UIImage(named:"icn-invoice-job"), for: .normal)
        invoicesButton.setImage(UIImage(named:"icn-invoices"), for: .normal)
        
        timerView1?.setDim(dim: false)
        timerView2?.setDim(dim: false)
        timerView3?.setDim(dim: false)
        
        invoiceAskView?.isHidden = true
 
    }
    
    //MARK: - ACTIONS
    
// MARK: - Help Button Pressed
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        presenter?.helpButtonPressed()
    }
    

// MARK: - Settings Button Pressed
    @IBAction func settingsButtonPressed()
    {
        
        if archiveIsActive { archiveButtonPressed() }
        if !settingsSelected
        {
            settingsButton?.setImage(UIImage(named:"top-settings-btn-selected"), for: .normal)
            settingsSelected = true
        }
        else
        {
            settingsButton?.setImage(UIImage(named:"btn-settings"), for: .normal)
            settingsSelected = false
        }
        
        presenter?.settingsButtonPressed()
    }
    
// MARK: - Calendar Button Pressed
    @IBAction func calenderButtonPressed()
    {
        if !(presenter?.moduleButtonPressed(selectedModule: .CALENDER))! { return }
        setAllButtonsUnselected()
        if calenderActive {
            calenderActive = false
        }
        else
        {
            calenderButton?.setImage(UIImage(named:"btn-calendar-selected"), for: .normal)
            addTimerSeleced = false
            archiveIsActive = false
            addTimerSeleced = false
            loadTimerSelected = false
            invoiceActive = false
            calenderActive = true
        }
      

    }
    
    func closeCalendar(done:@escaping ()->Void)
    {
        calenderActive = false
        calenderButton?.setImage(UIImage(named:"icn-calendar"), for: .normal)
        presenter?.closeCalender(done: done)
        
    }
    
// MARK: - Invoice Button Pressed
    @IBAction func invoiceButtonPressed()
    {
        self.presenter?.closeAnyViewControllers()
        setAllButtonsUnselected()
        addTimerSeleced = false
        loadTimerSelected = false
        settingsSelected = false
        calenderActive = false
        invoicesActive = false
        
        if invoiceActive == false
        {
            invoiceButton?.setImage(UIImage(named:"btn-invoice-job-active"), for: .normal)
            invoiceActive = true
            presenter?.currentModule = .INVOICE
            showInvoiceJobQuestionView()
        }
        else if invoiceActive == true
        {
            timerView1?.setDim(dim: false)
            timerView2?.setDim(dim: false)
            timerView3?.setDim(dim: false)
            presenter?.currentModule = .HOME
            invoiceAskView?.isHidden = true
            closeArchive(done: {})
        }
    }
    
    func closeArchive(done:@escaping ()->Void)
    {
        invoiceButton?.setImage(UIImage(named:"icn-invoice-job"), for: .normal)
        invoicesButton?.setImage(UIImage(named:"icn-invoices"), for: .normal)
        invoiceActive = false
        invoicesActive = false
        presenter?.closeInvoice(done:done)
        updateHomeScreenValues()
        checkIfTimerWasDeleted()
    }
    
    func showInvoiceJobQuestionView()
    {
        if invoiceActive
        {
            timerView1?.setDim(dim: true)
            timerView2?.setDim(dim: true)
            timerView3?.setDim(dim: true)
            
            if invoiceAskView == nil
            {
                invoiceAskView = UIView()
                invoiceAskView?.translatesAutoresizingMaskIntoConstraints = false
                let topLabel = UILabel()
                topLabel.translatesAutoresizingMaskIntoConstraints = false
                topLabel.numberOfLines = 2
                topLabel.text = "STOP TIMER & INVOICE JOB?"
                topLabel.textAlignment = .center
                topLabel.font = UIFont().boldFont()
                topLabel.textColor = UIColor.white
                invoiceAskView?.addSubview(topLabel)
                invoiceAskView?.addConstraint(NSLayoutConstraint(item: invoiceAskView!, attribute: .top, relatedBy: .equal, toItem: topLabel, attribute: .top, multiplier: 1.0, constant: -60.0))
                invoiceAskView?.addConstraint(NSLayoutConstraint(item: invoiceAskView!, attribute: .centerX, relatedBy: .equal, toItem: topLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
                invoiceAskView?.addConstraint(NSLayoutConstraint(item: topLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 125.0))
                
                
                var buttonsize = CGFloat(75)
                var btnsbottom = CGFloat(-10)
                var bottomText = CGFloat(70)
                if UIScreen.device() == .iphone_5 {
                    buttonsize = 65
                    btnsbottom = 0
                    bottomText = 55
                }
                
                let cancelbutton = UIButton()
                cancelbutton.translatesAutoresizingMaskIntoConstraints = false
                cancelbutton.setImage(UIImage(named:"btn-cancel-red"), for: .normal)
                invoiceAskView?.addSubview(cancelbutton)
                invoiceAskView?.addConstraint(NSLayoutConstraint(item: topLabel, attribute: .bottom, relatedBy: .equal, toItem: cancelbutton, attribute: .top, multiplier: 1.0, constant: btnsbottom))
                invoiceAskView?.addConstraint(NSLayoutConstraint(item: invoiceAskView!, attribute: .centerX, relatedBy: .equal, toItem: cancelbutton, attribute: .centerX, multiplier: 1.0, constant: 40.0))
                invoiceAskView?.addConstraint(NSLayoutConstraint(item: cancelbutton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonsize))
                invoiceAskView?.addConstraint(NSLayoutConstraint(item: cancelbutton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonsize))
                
                    cancelbutton.addTarget(self, action: #selector(HomeViewController.invoiceCancelPressed), for: .touchUpInside)
                
                let okaybutton = UIButton()
                okaybutton.translatesAutoresizingMaskIntoConstraints = false
                okaybutton.setImage(UIImage(named:"btn-invoice-yes"), for: .normal)
                invoiceAskView?.addSubview(okaybutton)
                invoiceAskView?.addConstraint(NSLayoutConstraint(item: topLabel, attribute: .bottom, relatedBy: .equal, toItem: okaybutton, attribute: .top, multiplier: 1.0, constant: btnsbottom))
                invoiceAskView?.addConstraint(NSLayoutConstraint(item: invoiceAskView!, attribute: .centerX, relatedBy: .equal, toItem: okaybutton, attribute: .centerX, multiplier: 1.0, constant: -40.0))
                invoiceAskView?.addConstraint(NSLayoutConstraint(item: okaybutton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonsize))
                invoiceAskView?.addConstraint(NSLayoutConstraint(item: okaybutton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonsize))
                okaybutton.addTarget(self, action: #selector(HomeViewController.invoiceOkayPressed), for: .touchUpInside)
                
                
                
                let bottomLabel = UILabel()
                bottomLabel.translatesAutoresizingMaskIntoConstraints = false
                bottomLabel.textAlignment = .center
                bottomLabel.text = "Jobs moved to invoice can be re-activated by archiving re-activating the job"
                bottomLabel.textColor = UIColor.white
                bottomLabel.font = UIFont().normalFont()
                bottomLabel.numberOfLines = 3
                invoiceAskView?.addSubview(bottomLabel)
                invoiceAskView?.addConstraint(NSLayoutConstraint(item: invoiceAskView!, attribute: .bottom, relatedBy: .equal, toItem: bottomLabel, attribute: .bottom, multiplier: 1.0, constant: bottomText))
                invoiceAskView?.addConstraint(NSLayoutConstraint(item: invoiceAskView!, attribute: .centerX, relatedBy: .equal, toItem: bottomLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
                invoiceAskView?.addConstraint(NSLayoutConstraint(item: bottomLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 150))
                
                
                view?.addSubview(invoiceAskView!)
                
                view?.addConstraint(NSLayoutConstraint(item: timerScrollView!, attribute: .centerX, relatedBy: .equal, toItem: invoiceAskView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
                view?.addConstraint(NSLayoutConstraint(item: timerScrollView!, attribute: .centerY, relatedBy: .equal, toItem: invoiceAskView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
                view?.addConstraint(NSLayoutConstraint(item: timerScrollView!, attribute: .width, relatedBy: .equal, toItem: invoiceAskView, attribute: .width, multiplier: 1.0, constant: 0.0))
                view?.addConstraint(NSLayoutConstraint(item: timerScrollView!, attribute: .height, relatedBy: .equal, toItem: invoiceAskView, attribute: .height, multiplier: 1.0, constant: 0.0))
            }
            else
            {
                invoiceAskView?.isHidden = false
            }
        }
        else
        {
            timerView1?.setDim(dim: false)
            timerView2?.setDim(dim: false)
            timerView3?.setDim(dim: false)
            invoiceAskView?.isHidden = true
        }
    }
    
    func invoiceOkayPressed()
    {
        if (timerView1?.timerIsActive)! {
            timerView1?.stopTimer(true)
        }
        presenter?.invoiceButtonPressed(section: 3)
        invoiceAskView?.isHidden = true
        
        timerView1?.setDim(dim: false)
        timerView2?.setDim(dim: false)
        timerView3?.setDim(dim: false)
        
        UserDefaults.standard.removeObject(forKey: CURRENT_JOB_TIMER)
        
        updateHomeScreenValues()
        checkIfTimerWasDeleted()
    }
    
    func invoiceCancelPressed()
    {
        timerView1?.setDim(dim: false)
        timerView2?.setDim(dim: false)
        timerView3?.setDim(dim: false)
        
        invoiceActive = false
        invoiceAskView?.isHidden = true
        invoiceButton?.setImage(UIImage(named:"icn-invoice-job"), for: .normal)
    }
    
// MARK: - Invoices Button Pressed
    @IBAction func invoicesButtonPressed()
    {

        self.presenter?.closeAnyViewControllers()
        setAllButtonsUnselected()
        addTimerSeleced = false
        loadTimerSelected = false
        settingsSelected = false
        calenderActive = false
        
        if invoiceActive
        {
            if !(invoiceAskView?.isHidden)!
            {
                invoiceAskView?.isHidden = true
                    
                timerView1?.setDim(dim: false)
                timerView2?.setDim(dim: false)
                timerView3?.setDim(dim: false)
                    
                invoiceButton?.setImage(UIImage(named:"icn-invoice-job"), for: .normal)
                invoiceActive = false
            }
            else
            {
                invoiceButton?.setImage(UIImage(named:"icn-invoice-job"), for: .normal)
                invoicesButton.setImage(UIImage(named:"icc-invoices-active"), for: .normal)
                presenter?.changeInvoiceSection(section: 3)
                invoiceActive = false
                invoicesActive = true
                return
            }
        }

        if invoicesActive
        {
            invoicesActive = false
            presenter?.currentModule = .HOME
        
        }
        else
        {
            invoicesButton.setImage(UIImage(named:"icc-invoices-active"), for: .normal)
            invoicesActive = true
            presenter?.invoiceButtonPressed(section: 0)
            presenter?.currentModule = .INVOICE
        }
    }
    
// MARK: - Load Timer Button Pressed
    @IBAction func loadTimerButtonPressed()
    {
        if !(presenter?.moduleButtonPressed(selectedModule: .LOAD_TIMER))! { return }
        setAllButtonsUnselected()
        if loadTimerSelected
        {
            loadTimerSelected = false
            updateHomeScreenValues()
            checkIfTimerWasDeleted()
            
            NotificationCenter.default.removeObserver(self)
        } else {
            loadTimerButton?.setImage(UIImage(named:"btn-load-timer-selected"), for: .normal)
            calenderActive = false
            addTimerSeleced = false
            archiveIsActive = false
            addTimerSeleced = false
            invoiceActive = false
            loadTimerSelected = true
            
            NotificationCenter.default.addObserver(self, selector: #selector(stopCurrentTimer), name: NSNotification.Name(rawValue: "StopRunningTimers"), object: nil)
        }

    }
    
    func closeLoadTimer()
    {
        checkIfTimerWasDeleted()
        loadTimerButton?.setImage(UIImage(named:"icn-load-timer"), for: .normal)
        loadTimerSelected = false
        presenter?.loadTimerButtonPressed(active: loadTimerSelected)
        updateHomeScreenValues()
    }
    
    func checkIfTimerWasDeleted()
    {
        if UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) == nil
        {
            timerView1?.stopTimer()
            timerView2?.stopTimer()
            timerView3?.stopTimer()
        }
    }
    
// MARK: - Add Timer Button Pressed
    @IBAction func addTimerButtonPressed()
    {
            if !(presenter?.moduleButtonPressed(selectedModule: .ADD_TIMER))! { return }
        
            self.setAllButtonsUnselected()
            if !addTimerSeleced
            {
                addTimerButton?.setImage(UIImage(named: "add-timer-selected"), for: .normal)
                addTimerSeleced = true
                calenderActive = false
                archiveIsActive = false
                invoiceActive = false
                loadTimerSelected = false
            }
            else
            {
                addTimerSeleced = false
                if UserDefaults.standard.value(forKey: "autoStartTimer") as! Bool == true
                {
                    timerView1?.startNewTimer(true)
                    timerView1?.startStopButtonPressed()
                    
//                    timerView2?.startNewTimer(true)
//                    timerView2?.startStopButtonPressed()
//                    timerView3?.startNewTimer(true)
//                    timerView3?.startStopButtonPressed()
                    
                    let job = JobTimer.getTimerWith(id: UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) as! Int)
                    job?.timeSpent = 1.0
                    try? DataController.sharedInstance.managedObjectContext.save()
                }
                else
                {
                    timerView1?.setupNewTimer(true)
                    timerView2?.setupNewTimer()
                    timerView3?.setupNewTimer()
                }
            }
    }
    
// MARK: - Archive Button Pressed
    @IBAction func archiveButtonPressed()
    {
        if settingsSelected { self.settingsButtonPressed() }
        presenter?.closeAnyViewControllers()
        setAllButtonsUnselected()
            if archiveIsActive
            {
                archiveButton.setImage(UIImage(named:"btn-archive"), for: .normal)
                archiveIsActive = false
                fullHistoryButton.isHidden = true
                thisYearButton.isHidden = true
            }
            else
            {
                archiveButton.setImage(UIImage(named:"btn-archive-pressed"), for: .normal)
                archiveIsActive = true
                fullHistoryButton.isHidden = false
                thisYearButton.isHidden = false
                thisYearButton.alpha = 1.0
                fullHistoryButton.alpha = 0.2
                calenderActive = false
                addTimerSeleced = false
                addTimerSeleced = false
                invoicesActive = false
                invoiceActive = false
                loadTimerSelected = false
            }
            presenter?.archiveButtonPressed(active: archiveIsActive)
        
    }
    
// MARK: - Full History Button Pressed
    @IBAction func fullHistoryPressed()
    {
        thisYearButton.alpha = 0.2
        fullHistoryButton.alpha = 1.0
     
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "kChangeArchiveStatus"), object: nil, userInfo: ["button":"FULL_HISTORY"]))
    }
    @IBAction func thisYearPressed()
    {
        thisYearButton.alpha = 1.0
        fullHistoryButton.alpha = 0.2
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "kChangeArchiveStatus"), object: nil, userInfo: ["button":"THIS_YEAR"]))
    }
    
    
    @IBAction func chronoCloseButtonPressed()
    {
        if childViewControllers.count > 0
        {
            presenter?.closeAnyViewControllers()
            settingsButton?.setImage(UIImage(named:"btn-settings"), for: .normal)
            settingsSelected = false
            calenderButton?.setImage(UIImage(named:"icn-calendar"), for: .normal)
            calenderActive = false
            invoiceButton?.setImage(UIImage(named:"icn-invoice-job"), for: .normal)
            invoiceActive = false
            invoicesButton?.setImage(UIImage(named:"icn-invoices"), for: .normal)
            invoicesActive = false
            loadTimerButton?.setImage(UIImage(named:"icn-load-timer"), for: .normal)
            loadTimerSelected  = false
            addTimerButton?.setImage(UIImage(named: "icn-add-timer"), for: .normal)
            addTimerSeleced = false
            self.closeAddTimer()
            archiveButton.setImage(UIImage(named:"btn-archive"), for: .normal)
            archiveIsActive = false
            fullHistoryButton.isHidden = true
            thisYearButton.isHidden = true
            for vc in childViewControllers
            {
                if vc is CalenderViewController { continue }
                if vc is SettingsViewController { continue }
                if vc is ArchiveViewController { continue }
                vc.removeFromParentViewController()
            }
            updateHomeScreenValues()
        }
        else
        {
            if (timerView1?.timerIsActive)!
            {
                ChronoTimer.sharedInstance.appWillClose()
                timerView1?.buttonPressed()
            }
            dismiss(animated: true, completion: nil)
        }

    }
    
    func closeAddTimer()
    {
        addTimerButton?.setImage(UIImage(named: "icn-add-timer"), for: .normal)
        addTimerSeleced = false
        presenter?.addTimerButtonPressed(active: addTimerSeleced)
    }

    
    func setSaveButtonEnabled(enabled:Bool)
    {
        if !enabled
        {
            addTimerButton?.setImage(UIImage(named: "add-timer-selected-disabled"), for: .normal)
            
        }else
        {
            addTimerButton?.setImage(UIImage(named: "add-timer-selected"), for: .normal)
        }
        addTimerButton?.isUserInteractionEnabled = enabled
    }
    
    func stopCurrentTimer() {
        if (timerView1?.timerIsActive)!
        {
            timerView1?.startStopButtonPressed()
            timerView2?.startStopButtonPressed()
            timerView3?.startStopButtonPressed()
        }
        
    }
    
// MARK: - Update Home Screen Values
    
    typealias HoursWorked = (Int, Int)
    func updateHomeScreenValues() {
        if UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) != nil
        {
            if let job = JobTimer.getTimerWith(id: (UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) as! NSNumber).intValue)
            {
                invoiceButton?.alpha = 1.0
                invoiceButtonTitle.alpha = 1.0
                invoiceButton?.isUserInteractionEnabled = true
                let taskId = job.stageTaskId
                let task = StageTask.getStageTask(forId: job.stageTaskId.intValue)
                let client = DataController.sharedInstance.getClientForTaskId(id: taskId.intValue)
                if client != nil
                {
                    clientNameLabel?.text = "C: \(client!.name!)"
                }
                else
                {
                    clientNameLabel?.text = "C N/A"
                }
                let project = Project.getProject(forId: task!.projectId.intValue)
                projectNameLabel?.text = "P: \(project!.name!)"

                taskNameLabel?.text = "T: \(StageTask.getStageTask(forId: job.stageTaskId.intValue)!.name!)"
                allocatedForTaskLabel?.text = "\((task!.allocatedTaskTime.intValue)) Days"
                
                if clientNameLabel?.text != "C: N/A"
                {
                    if bottomButtonSelected == incomeEarnedButton {
                        if client != nil
                        {
                            clientValueLabel.text = String(format:"%.2f", ArchiveUtils.getEarned(agency: (client?.id)!, archived:false))
                        }else
                        {
                            clientValueLabel.text = "0.00"
                        }
                    }
                    else if bottomButtonSelected == hoursWorkedButton
                    {
                        if client != nil {
                            let clientHours:HoursWorked = ArchiveUtils.getHoursWorked(agency: (client?.id)!, archived:false)
              
                            clientValueLabel.text = "\(clientHours.0) HRS   \(clientHours.1) MIN"
                        }else {
                            clientValueLabel.text = "N/A"
                        }
                    }
                    else {
                        if client != nil {
                            clientValueLabel.text = "\(ArchiveUtils.getDaysWorked(agency: (client?.id)!, archived:false)) Days"
                        } else {
                            clientValueLabel.text = "N/A"
                        }
                    }
                }
                if bottomButtonSelected == incomeEarnedButton
                {
                    projectValueLabel.text = String(format:"%.2f", ArchiveUtils.getEarned(project: (project?.id)!, archived:false))
                    taskValueLabel.text = String(format:"%.2f", ArchiveUtils.getEarned(task: (task?.id)!))
                }
                else if bottomButtonSelected == hoursWorkedButton
                {
                    let projectTime = ArchiveUtils.getHoursWorked(project: (project?.id)!, archived: false)
                    projectValueLabel.text = "\(projectTime.0) HRS   \(projectTime.1) MIN"
                    let taskTime = ArchiveUtils.getHoursWorked(task: (task?.id)!)
                    taskValueLabel.text = "\(taskTime.0) HRS   \(taskTime.1) MIN"
                }
                else
                {
                    projectValueLabel.text = "\(ArchiveUtils.getDaysWorked(project: (project?.id)!, archived: false)) Days"
                    taskValueLabel.text = "\(ArchiveUtils.getDaysWorked(task: (task?.id)!)) Days"
                }
            }
            else
            {
                clientNameLabel?.text = "C: N/A"
                projectNameLabel?.text = "P: N/A"
                allocatedForTaskLabel?.text = "N/A"
                taskNameLabel?.text = "T: N/A"
                
                timerView1?.setupNewTimer(true)
                timerView2?.setupNewTimer()

                
                
            }
        }
        else
        {
            clientNameLabel?.text = "C: N/A"
            projectNameLabel?.text = "P: N/A"
            allocatedForTaskLabel?.text = "N/A"
            taskNameLabel?.text = "T: N/A"
            
            timerView3?.setupNewTimer()
            
            invoiceButton?.alpha = 0.5
            invoiceButtonTitle.alpha = 0.5
            invoiceButton?.isUserInteractionEnabled = false
            
        }
        timerView1?.checkHoursAndMinutesSettings()
        timerView2?.checkHoursAndMinutesSettings()
        timerView3?.checkHoursAndMinutesSettings()
        
        if !(timerView1?.timerIsActive)!
        {
            timerView1?.checkCurrentTimerPosition()
            timerView2?.checkCurrentTimerPosition()
            timerView3?.checkCurrentTimerPosition()
        }
        timerView1?.layoutSubviews()
        timerView2?.layoutSubviews()
        timerView3?.layoutSubviews()
        updateTopLabels()
 }
    
    
    @IBAction func invomceEarnedButtonPressed(){
        incomeEarnedButton.setImage(UIImage(named:"btn-income-earned-selected"), for: .normal)
        daysWorkedButton.setImage(UIImage(named:"btn-days-worked"), for: .normal)
        hoursWorkedButton.setImage(UIImage(named:"btn-hours-worked"), for: .normal)
        bottomButtonSelected = incomeEarnedButton
        bottomTitleLabel.text = "EARNED"
        updateHomeScreenValues()
    }
    
    
    @IBAction func daysWorkedButtonPressed(){
        incomeEarnedButton.setImage(UIImage(named:"btn-income-earned"), for: .normal)
        daysWorkedButton.setImage(UIImage(named:"btn-days-worked-selected"), for: .normal)
        hoursWorkedButton.setImage(UIImage(named:"btn-hours-worked"), for: .normal)
        bottomButtonSelected = daysWorkedButton
        bottomTitleLabel.text = "WORKING DAYS"
        updateHomeScreenValues()
    
    }
    
    @IBAction func hoursWorkedButtonPressed(){
        incomeEarnedButton.setImage(UIImage(named:"btn-income-earned"), for: .normal)
        daysWorkedButton.setImage(UIImage(named:"btn-days-worked"), for: .normal)
        hoursWorkedButton.setImage(UIImage(named:"btn-hours-worked-selected"), for: .normal)
        bottomButtonSelected = hoursWorkedButton
        bottomTitleLabel.text = "TOTAL HOURS"
         updateHomeScreenValues()
    }
    
// MARK: - Top Values
    
    func updateTopLabels() {
        
        if UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) == nil
        {
            minuteLabel.text = String(format: "    %02d MIN", 0)
            hourLabel.text = String(format: "    %02d HRS", 0)
            dayLabel.text = String(format: "    %02d DAYS",  0)
        }
        else {
            
            let offset = timerScrollView.contentOffset
            if  offset.x > 600 {
                let timer = JobTimer.getTimerWith(id: UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER)
                    as! Int)
                let currentTask = StageTask.getStageTask(forId: timer?.stageTaskId as! Int)
                if let taskTime = currentTask?.allocatedTaskTime {
                    //                    let time = selectedTimer.timeInSeconds
                    //                    let countDownTime = (taskTime.doubleValue * 3600) + time!
                    
                    //print(taskTime)
                    // selectedTimer.timeInSeconds already has the total time of all timers within the same project
                    // see in - TimerView.getTimeForTimer() .case AllocatedTime
                    let time = selectedTimer.timeInSeconds
                    let countDownTime = time!
                    //print(countDownTime)
                    let project = Project.getProject(forId: (currentTask?.projectId.intValue)!)
                    var dayLength = project?.dayLength.intValue
                    if dayLength == nil || dayLength == 0
                    {
                        dayLength = 8
                    }
                    
                    let displayTime = selectedTimer.getDisplayTime(time: countDownTime, dayLength: dayLength!)
                    minuteLabel.text = String(format: "    %02d MIN", displayTime.2)
                    hourLabel.text = String(format: "    %02d HRS", displayTime.1)
                    dayLabel.text = String(format: "    %02d DAYS",  displayTime.0 )
                }
            }
            else {
                
                minuteLabel.text = String(format: "    %02d MIN", selectedTimer.time?.2 != nil ? selectedTimer.time!.2 : 0)
                hourLabel.text = String(format: "    %02d HRS", selectedTimer.time?.1 != nil ? selectedTimer.time!.1 : 0)
                dayLabel.text = String(format: "    %02d DAYS", selectedTimer.time?.0 != nil ? selectedTimer.time!.0 : 0)
            }
            if offset.x >= 0 && offset.x < 100
            {
                setBottomValues(value: .task)
            }
            else if offset.x > 300 && offset.x < 450
            {
                setBottomValues(value: .project)
            }
            else if offset.x > 600
            {
                setBottomValues(value: .allocatedTime)
            }
            
            presenter?.updateCalendarDay()
            
        }
    }
    
    func setTopLabels(min: Int, hrs: Int, days: Int) {
        minuteLabel.text = String(format: "    %02d MIN", min)
        var d = 0
        var hours = hrs
        var intVal = 8
        if let i = UserDefaults.standard.value(forKey: "workHoursPerDay")
        {
            let i = Int(i as! String)
            if i != nil
            {
                intVal = i!
            }
        }
        while hours >= intVal
        {
            hours = hours - intVal
            d = d + 1
        }
        hourLabel.text = String(format: "    %02d HRS", hours)
        dayLabel.text = String(format: "    %02d DAYS", d)
    }
    
// MARK: - Bottom Values
    enum BottomValues
    {
        case task, project, allocatedTime
    }
    
    func setBottomValues(value:BottomValues)
    {
        let j = UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) as? NSNumber
        var job:JobTimer?
        var taskId:NSNumber?
        var task:StageTask?
        var client:Agency?
        var project:Project?
        if j != nil  {
            job = JobTimer.getTimerWith(id: (j?.intValue)!)
            taskId = job?.stageTaskId
            task = StageTask.getStageTask(forId: (job?.stageTaskId.intValue)!)
            client = DataController.sharedInstance.getClientForTaskId(id: (taskId?.intValue)!)
            project = Project.getProject(forId: task!.projectId.intValue)
        }
       
        if value != .allocatedTime
        {
            bottomHeaderLabel.text = "CURRENT TASK"
            if value == .project
            {
                bottomHeaderLabel.text = "CURRENT PROJECT"
            }
            let clientName = (client != nil) ? "C: \(client!.name!)" : "C: N/A"
            clientNameLabel?.text = clientName
            projectNameLabel?.text = "P: \(project?.name ?? "N/A")"
            taskNameLabel?.text = "T: \(task?.name ?? "N/A")"
            if value == .project {
                allocatedForTaskName?.text = "Time allocated for project"
            } else {
                allocatedForTaskName?.text = "Time allocated for task"
            }
            bottomBtnDaysWorked.isHidden = false
            bottomBtnMoneyEarned.isHidden = false
            bottomBtnTimeWorked.isHidden = false
            
            dayTitleLabel.isHidden = true
            allocatedStack.isHidden = true
            if value == .project {
                allocatedForTaskLabel?.text = "\(project?.allocatedProjectTime.intValue ?? 0) Hours"
            }else{
                allocatedForTaskLabel?.text = "\(task?.allocatedTaskTime.intValue ?? 0) Hours"
            }
            if bottomButtonSelected == daysWorkedButton
            {
                if client != nil {
                    //clientValueLabel.text = "\(ArchiveUtils.getDaysWorked(agency: (client?.id)!, archived:false) ) Days"
                    //clientValueLabel.text = "\(ArchiveUtils.getDaysWorked(agency: (client?.id)!, archived:false) )"
                    
                    clientValueLabel.text = HomeViewController.bottomValueGetDaysWorked(agency: (client?.id)!, archived:false)
                } else {
                    //clientValueLabel.text = "0.0 Days"
                    clientValueLabel.text = "0.00"
                }
                
                if project != nil {
                    //projectValueLabel.text = "\(ArchiveUtils.getDaysWorked(project: (project?.id)!, archived: false)) Days"
                    //projectValueLabel.text = "\(ArchiveUtils.getDaysWorked(project: (project?.id)!, archived: false))"
                    
                    projectValueLabel.text = HomeViewController.bottomValueGetDaysWorked(project: (project?.id)!, archived: false)
                } else {
                    //projectValueLabel.text = "0.0 Days"
                    projectValueLabel.text = "0.00"
                }
                
                if task != nil {
                    //taskValueLabel.text = "\(ArchiveUtils.getDaysWorked(task: (task?.id)!)) Days"
                    //taskValueLabel.text = "\(ArchiveUtils.getDaysWorked(task: (task?.id)!))"
                    
                    taskValueLabel.text = HomeViewController.bottomValueGetDaysWorked(task: (task?.id)!)
                } else {
                    //taskValueLabel.text  = "0.0 Days"
                    taskValueLabel.text  = "0.00"
                }
                
                 bottomTitleLabel.text = "WORKING DAYS"
            }
            else if bottomButtonSelected == incomeEarnedButton
            {
                if client != nil
                {
                    clientValueLabel.text = String(format:"%.2f", ArchiveUtils.getEarned(agency: (client?.id)!, archived:false))
                }else
                {
                    clientValueLabel.text = "0.00"
                }
                if project != nil { 
                    projectValueLabel.text = String(format:"%.2f", ArchiveUtils.getEarned(project: (project?.id)!, archived:false))
                } else {
                    projectValueLabel.text = "0.00"
                }
                if task != nil {
                    taskValueLabel.text = String(format:"%.2f", ArchiveUtils.getEarned(task: (task?.id)!))
                } else {
                    taskValueLabel.text = "0.00"
                }
                 bottomTitleLabel.text = "EARNED"
            }
            else
            {
                if client != nil {
                    let clientHours:HoursWorked = ArchiveUtils.getHoursWorked(agency: (client?.id)!, archived:false)
                    clientValueLabel.text = "\(clientHours.0) HRS   \(clientHours.1) MIN"
                }else { clientValueLabel.text = "0 HRS   0 MIN" }
                if project != nil {
                    let projectTime = ArchiveUtils.getHoursWorked(project: (project?.id)!, archived: false)
                    projectValueLabel.text = "\(projectTime.0) HRS   \(projectTime.1) MIN"
                }else {projectValueLabel.text = "0 HRS   0 MIN" }
                if task != nil {
                    let taskTime = ArchiveUtils.getHoursWorked(task: (task?.id)!)
                    taskValueLabel.text = "\(taskTime.0) HRS   \(taskTime.1) MIN"
                }else {taskValueLabel.text = "0 HRS   0 MIN"}
                 bottomTitleLabel.text = "TOTAL HOURS"
            }
           
        } else {
            bottomHeaderLabel.text = "REMAINING TIME"
            clientNameLabel?.text = "P: \(project?.name ?? "N/A")"
            projectNameLabel?.text = "T: \(task?.name ?? "N/A")"
            taskNameLabel?.text = "Project Time Allocated"
            allocatedForTaskName?.text = "Task Time Allocated"
            bottomTitleLabel.text = "TOTAL HOURS"
            bottomBtnDaysWorked.isHidden = true
            bottomBtnMoneyEarned.isHidden = true
            bottomBtnTimeWorked.isHidden = true
            dayTitleLabel.isHidden = false
            allocatedStack.isHidden = false
            
            if project != nil {
                let projectTimeWorked = DataController.sharedInstance.getAllTimeSpentOnProject(project: (project?.id)!)
            
                let alocatedProjectTime = (project?.allocatedProjectTime.doubleValue)!*3600.0
                
                let projectTimes = getDaysAndHours(fromTime: alocatedProjectTime - projectTimeWorked, dayLength: (project?.dayLength.intValue)!)
                let dayString = String(format: "%.2f", projectTimes.0)
                projectDay.text = dayString
                clientValueLabel.text = "\(projectTimes.1)"
            }else {
                projectDay.text = "0.00"
                clientValueLabel.text = "0.00"
            }
            
            if task != nil {
                let taskTimeWorked = job?.timeSpent.doubleValue ?? 0.00
                let taskTimeAllocated = (task?.allocatedTaskTime.doubleValue)! * 3600.0
                let taskTimes = getDaysAndHours(fromTime: taskTimeAllocated - taskTimeWorked, dayLength: (project?.dayLength.intValue)!)

                let taskString = String(format: "%.2f", taskTimes.0)
                taskDay.text = taskString
                projectValueLabel.text = "\(taskTimes.1)"
            } else {
                taskDay.text = "0.00"
                projectValueLabel.text = "0.00"
            }
            if project != nil {
                projectTimeAlloc.text = String(format:"%.2f", (project!.allocatedProjectTime.doubleValue)/(project?.dayLength.doubleValue)!)
                taskValueLabel.text = "\(project!.allocatedProjectTime.intValue)"
            }else {
                projectTimeAlloc.text = "0.00"
                taskValueLabel.text = "0.00"
            }
            
            if task != nil {
                taskTimeAlloc.text = String(format:"%.2f", task!.allocatedTaskTime.doubleValue/(project?.dayLength.doubleValue)!)
                allocatedForTaskLabel?.text =  "\(task!.allocatedTaskTime.intValue)"
            }else {
                taskTimeAlloc.text = "0.00"
                allocatedForTaskLabel?.text =  "0.00"
            }
            
        }

    }
    
    func getDaysAndHours(fromTime:Double, dayLength:Int) -> (Double, Int)
    {
        var days = 0.0
        var hours = 0
        var time = abs(fromTime)
        let isNegative = fromTime < 0
        while Int(time/3600) >= dayLength
        {
            days = days + 1
            time = time - (Double(dayLength)*3600.0)
        }
        
        //print((time/3600).truncatingRemainder(dividingBy: 1))
        days = days + (time/3600).truncatingRemainder(dividingBy: 1)
        
        while Int(time/60) >= 60
        {
            hours = hours + 1
            time = time - 3600
        }
        if isNegative
        {
            return (-days, -hours)
        }
        return (days, hours)
    }
    
// MARK: - UIScrollView Delegate Functions
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        //print(offset.x)
        if offset.x >= 0 && offset.x < 100
        {
            pageScroller.currentPage = 0
            setBottomValues(value: .task)
            selectedTimer = timerView1
        }
        else if offset.x > 300 && offset.x < 450
        {
            pageScroller.currentPage = 1
            setBottomValues(value: .project)
            selectedTimer = timerView2

        }
        else if offset.x > 600
        {
            pageScroller.currentPage = 2
            setBottomValues(value: .allocatedTime)
            selectedTimer = timerView3
        }
        updateTopLabels()
    }

    
    func addTime(active: Bool) {
        if active
        {
            addTimeTop = UIView()
            addTimeTop?.translatesAutoresizingMaskIntoConstraints = false
            addTimeTop?.backgroundColor = UIColor.black
            addTimeTop?.alpha = 0.7
            
            view.addSubview(addTimeTop!)
            view.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: addTimeTop!, attribute: .top, multiplier: 1.0, constant: 50.0))
            view.addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: addTimeTop!, attribute: .leading, multiplier: 1.0, constant: 0.0))
            view.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: addTimeTop!, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            view.addConstraint(NSLayoutConstraint(item: timerTopLabels!, attribute: .top, relatedBy: .equal, toItem: addTimeTop!, attribute: .bottom, multiplier: 1.0, constant: 2.0))
            
            addTimeBottom = UIView()
            addTimeBottom?.translatesAutoresizingMaskIntoConstraints = false
            addTimeBottom?.backgroundColor = UIColor.black
            addTimeBottom?.alpha = 0.7
            
            view.insertSubview(addTimeBottom!, belowSubview: timerScrollView!)
            view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: addTimeBottom!, attribute: .bottom, multiplier: 1.0, constant: 0.0))
            view.addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: addTimeBottom!, attribute: .leading, multiplier: 1.0, constant: 0.0))
            view.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: addTimeBottom!, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            view.addConstraint(NSLayoutConstraint(item: timerTopLabels!, attribute: .bottom, relatedBy: .equal, toItem: addTimeBottom!, attribute: .top, multiplier: 1.0, constant: 2.0))
            
        }
        else
        {
            addTimeTop?.removeFromSuperview()
            addTimeTop = nil
            
            addTimeBottom?.removeFromSuperview()
            addTimeBottom = nil
        }
    }
    
// MARK: - Show Simple Timer
    
    func activateSimpleTimer() {
        
    }
    
    func deactivateSimpleTimer() {
        
    }
    
// MARK: - Helper Functions
    
    class func bottomValueGetDaysWorked(agency:NSNumber, archived:Bool) -> String
    {
        let tasks = StageTask.getAllTasksFor(agency: agency)
        
        var totalProjectDays = 0.00
        for t in tasks! {
            if t.archived || !archived
            {
                let project = Project.getProject(forId: t.projectId as! Int)
                let dayLength = project?.dayLength.intValue
                
                let jobTimer = JobTimer.getTimerWithTask(id: t.id.intValue)
                
                totalProjectDays = totalProjectDays + ((((jobTimer?.timeSpent.doubleValue)!/60.0)/60.0)/Double(dayLength!))
            }
        }
        
        return String(format: "%.2f", totalProjectDays)
    }
    
    
    
    class func bottomValueGetDaysWorked(project:NSNumber, archived:Bool) -> String
    {
        let timeSpent = DataController.sharedInstance.getAllTimeSpentOnProject(project: project)
        print("timeSpent \(timeSpent)")
    
        let project = Project.getProject(forId: project.intValue)
        let dayLength = project?.dayLength.intValue

        return String(format: "%.2f", (((timeSpent/60.0)/60.0)/Double(dayLength!)))
    }
    
    
    class func bottomValueGetDaysWorked(task:NSNumber) -> String
    {
        let t = StageTask.getStageTask(forId: task.intValue)
        
        let project = Project.getProject(forId: t?.projectId as! Int)
        let dayLength = project?.dayLength.intValue
        
        let job = JobTimer.getTimerWith(id: UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) as! Int)
        return String(format: "%.2f", ((((job?.timeSpent.doubleValue)!/60.0)/60.0)/Double(dayLength!)))
    }
    
}
