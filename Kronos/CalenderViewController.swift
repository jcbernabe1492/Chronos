//
//  CalenderViewController.swift
//  Kronos
//
//  Created by Wee, David G. on 9/29/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit


let daySettingsImageArray = ["day-settings-available", "day-setting-day-off", "day-setting-half-booked", "day-settings-full-booked"]

class CalenderViewController: UIViewController, CalenderViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet var monthButton:UIButton!
    @IBOutlet var yearButton:UIButton!
    @IBOutlet var topView:UIView?
    @IBOutlet var bottomView:UIView?
    @IBOutlet var dayStatusButton:UIButton?
    @IBOutlet var bottomTtitleLabel:UILabel?
    @IBOutlet var bottomLabelView:UIView?
    @IBOutlet var hoursWorkedLabel:UILabel?
    
    @IBOutlet var projectsWorkedLabels:UILabel!
    @IBOutlet var totalWorkedDaysHoursLabel:UILabel!
    @IBOutlet var totalEarnedLabel:UILabel!
    @IBOutlet var individualDaysWorkedLabel:UILabel!
    var dayTableView:UITableView?
    var calendarScrollingView:UIScrollView!
    
    var currentStatus = 0
    var currentDay:Day?
    
    var calendarSize:CGSize!
    var currentMonth:Int!
    var loadedYears:[Int] = []
    var scrollViewWasLoadedOnce = false
    var firstLoad = false
    
    var calendarViews: [CalenderView] = []
    
    private var previousScrollPos = CGFloat(0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        calendarScrollingView = UIScrollView()
        calendarScrollingView.delegate = self
        calendarScrollingView.decelerationRate = UIScrollViewDecelerationRateFast
        calendarScrollingView.translatesAutoresizingMaskIntoConstraints = false
        calendarScrollingView.isDirectionalLockEnabled = true
        view.addSubview(calendarScrollingView)
        
        view.addConstraint(NSLayoutConstraint(item: topView!, attribute: .bottom, relatedBy: .equal, toItem: calendarScrollingView, attribute: .top, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: bottomView!, attribute: .top, relatedBy: .equal, toItem: calendarScrollingView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: calendarScrollingView, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: calendarScrollingView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        view.layoutIfNeeded()
        view.setNeedsLayout()
        var height:CGFloat = UIScreen().isIphone5() ? 277.50 : 330.0
        if UIScreen().isiPhone6Plus()
        {
            height = 365.6666
        }
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        
        calendarScrollingView.contentSize = CGSize(width: 12 * UIScreen.main.bounds.size.width, height: height * CGFloat(((year - (UserDefaults.standard.value(forKey: "USER_DOWNLOAD_YEAR") as! Int)))+3))
        calendarScrollingView.isPagingEnabled = true
        calendarScrollingView.isDirectionalLockEnabled = true
        calendarScrollingView.backgroundColor = UIColor.cellBackgroundColor()
        loadYear(year, position: 0)
        loadedYears.append(2017)
        view.backgroundColor = calendarScrollingView.backgroundColor
        UserDefaults.standard.setValue(Date(), forKey: "refreshDate")
        
        firstLoad = true
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if firstLoad == false {
            refreshChangesFromSettings()
        } else {
            UserDefaults.standard.set(false, forKey: "calenderDaysChanged")
            firstLoad = false
        }
        
        if scrollViewWasLoadedOnce
        {
            if Date().timeIntervalSince(UserDefaults.standard.value(forKey: "refreshDate") as! Date) > 900 {
                DispatchQueue.main.async {
                    for s in self.calendarScrollingView.subviews {
                        s.removeFromSuperview()
                        self.loadedYears = []
                        }
                }
                let date = Date()
                let calendar = Calendar.current
                let year = calendar.component(.year, from: date)
                loadYear(year, position: 0)
                UserDefaults.standard.setValue(Date(), forKey: "refreshDate")
            }

        }
        scrollViewWasLoadedOnce = true
        
        let amounts = CalenderUtils.getDataFor(month: Date().getMonth(), year: Date().getYear())
        self.updateBottomLabels(amounts: amounts)
        
        refreshCurrentMonth()
    }
    
    private func refreshChangesFromSettings() {
        
        guard let changed = UserDefaults.standard.value(forKey: "calenderDaysChanged") as? Bool else {
            return
        }
        
        //let changed = UserDefaults.standard.value(forKey: "calenderDaysChanged") as? Bool
        
        if changed {
            let date = Date()
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            loadYear(year, position: 0)
            
            UserDefaults.standard.set(false, forKey: "calenderDaysChanged")
        }
    }
    
    private func refreshCurrentMonth() {
        
        guard let current = currentMonth  else {
            return
        }
        
        let currentCalendarMonth = self.calendarViews[current] 
        currentCalendarMonth.refreshCurrentMonth()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func loadYear(_ year:Int, position:Int) {
        
        var height:CGFloat = UIScreen().isIphone5() ? 277.50 : 330.0
        if UIScreen().isiPhone6Plus()
        {
            height = 365.6666
        }
        UIScreen().showActivity()
        calendarScrollingView.isHidden = true
        let queue = DispatchQueue(label: "CalenderQueue", qos: .background, attributes: .concurrent)
        queue.async {
            for month in 0...11
            {
                DispatchQueue.main.sync {
                    let calender1 = CalenderView(month: month+1, year: year)
                    calender1.translatesAutoresizingMaskIntoConstraints = false
                    calender1.delegate = self
                    self.calendarScrollingView.addSubview(calender1)
                    self.view.addConstraint(NSLayoutConstraint(item: self.calendarScrollingView, attribute: .top, relatedBy: .equal, toItem: calender1, attribute: .top, multiplier: 1.0, constant: -(height * CGFloat(position))))
                    self.view.addConstraint(NSLayoutConstraint(item: self.calendarScrollingView!, attribute: .height, relatedBy: .equal, toItem: calender1, attribute: .height, multiplier: 1.0, constant: 0.0))
                    self.view.addConstraint(NSLayoutConstraint(item: self.calendarScrollingView!, attribute: .width, relatedBy: .equal, toItem: calender1, attribute: .width, multiplier: 1.0, constant: 0.0))
                    let calender1Leading = NSLayoutConstraint(item: self.calendarScrollingView, attribute: .leading, relatedBy: .equal, toItem: calender1, attribute: .leading, multiplier: 1.0, constant: -(UIScreen.main.bounds.size.width * CGFloat(month)))
                    calender1.calenderLeadingConstraint = calender1Leading
                    self.view.addConstraint(calender1Leading)
                    
                    self.calendarViews.append(calender1)
                    
//                    let amounts = CalenderUtils.getDataFor(month: (calender1.currentMonth)!, year: (calender1.year)!)
//                    self.updateBottomLabels(amounts: amounts)
                    
                    self.hoursWorkedLabel?.isHidden = true
                    if month == 11 {
                        self.scrollToCurrentMonth(year:year, index: position)
                           self.calendarScrollingView.isHidden = false
                        UIScreen().hideActivity()
                    }
                }
            }
        }

        self.monthButton.setTitle(Months().monthArray[Date().getMonth() - 1].uppercased(), for: .normal)
        self.yearButton.setTitle("\(year)", for: .normal)
        loadedYears.append(year)
    }

    
    func scrollToCurrentMonth(year:Int, index:Int)
    {
        
        var height:CGFloat = UIScreen().isIphone5() ? 277.50 : 330.0
        if UIScreen().isiPhone6Plus()
        {
            height = 365.6666
        }
        let m = Date().getMonth() - 1
        currentMonth = m
        let size = calendarScrollingView.bounds.size.width
        calendarScrollingView.contentOffset = CGPoint(x:size * CGFloat(m), y:height * CGFloat(index))
        
    }
// MARK: - Month Button Pressed
    @IBAction func monthButtonPressed()
    {
        setDayValues(active: false)
        bottomTtitleLabel?.text = "MONTHLY SUMMARY"
        monthButton.setTitleColor(UIColor(red: 240.0/255.0, green: 80.0/255.0, blue: 50.0/255.0, alpha: 1.0), for: .normal)
        yearButton.setTitleColor(UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0), for: .normal)
        
        let m = Date().getMonth()
        let amounts = CalenderUtils.getDataFor(month: m, year: Int((yearButton.titleLabel?.text)!)!)
        //(numberOfProjects,totalTimeWorked,totalEarned,daySet.count)
        updateBottomLabels(amounts: amounts)
        print(amounts)
    }
    
// MARK: - Year Button Pressed
    //TODO: - Could cache months here after they are in the past and calculated before
    @IBAction func yearButtonPressed()
    {
        yearButton.setTitleColor(UIColor(red: 240.0/255.0, green: 80.0/255.0, blue: 50.0/255.0, alpha: 1.0), for: .normal)
        monthButton.setTitleColor(UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0), for: .normal)
        setDayValues(active: false)
        bottomTtitleLabel?.text = "ANNUAL SUMMARY"
        var totals:(Int, (Int, Int), Double, Int)! = (0,(0,0),0.0,0)
        for x in 0...12
        {
            let amounts = CalenderUtils.getDataFor(month: x, year: Int((yearButton.titleLabel?.text)!)!)
            totals.0 = totals.0 + amounts.0
            totals.1.0 = totals.1.0 + amounts.1.0
            totals.1.1 = totals.1.1 + amounts.1.1
            totals.2 = totals.2 + amounts.2
            totals.3 = totals.3 + amounts.3
        }
//        let num = Double(totals.1.1).truncatingRemainder(dividingBy: 24)
//        totals.1.0 = totals.1.0 + Int(num)
//        totals.1.1 = Int((24*num)) - totals.1.1
        
        updateBottomLabels(amounts: totals)
        
    }
    
    @IBAction func dayTypeChanged()
    {        
        currentStatus = currentStatus + 1
        if currentStatus > 3
        {
            currentStatus = 0
        }
        currentDay?.parentCalendar.updateDayView(dayView: currentDay!, type: DAY_TYPE(rawValue: currentStatus)!)
        dayStatusButton?.setImage(UIImage(named:daySettingsImageArray[currentStatus]), for: .normal)
 
    }
    
// MARK: - CalendarView Delegate Functions
    func dayViewWasPressed(day:Day)
    {
        currentDay = day
        currentStatus = day.type.rawValue
        
        DispatchQueue.main.async {
            self.dayStatusButton?.setImage(UIImage(named:daySettingsImageArray[self.currentStatus]), for: .normal)
            self.bottomTtitleLabel?.text = "\(String(format: "%02d", day.day)) \(Months().monthArray[day.month-1].uppercased()) \(day.year)"
            self.setDayValues(active: true)
        }
        
    
        
    }
    
    func monthChanged(month: Int) {
        monthButton.setTitle(Months().monthArray[currentMonth].uppercased(), for: .normal)
        let amounts = CalenderUtils.getDataFor(month: currentMonth, year: Int((yearButton.titleLabel?.text)!)!)
        updateBottomLabels(amounts: amounts)
    }
    
    func yearChanged(year:Int)
    {
        yearButton.setTitle("\(year)", for: .normal)
        let amounts = CalenderUtils.getDataFor(month: currentMonth , year: Int((yearButton.titleLabel?.text)!)!)
        updateBottomLabels(amounts: amounts)
    }
    
    func updateBottomLabels(amounts: (Int, (Int, Int), Double, Int)) {
        projectsWorkedLabels.text = "\(amounts.0)"
        totalWorkedDaysHoursLabel.text = "\(String(format: "%02d", amounts.1.0)) DAYS \t\(String(format: "%02d", amounts.1.1)) HOURS"
        
        totalEarnedLabel.text = String(format: "%0.2f", amounts.2)
        individualDaysWorkedLabel.text = "\(amounts.3)"
    }
    
    func setDayValues(active:Bool)
    {
        if dayTableView == nil
        {
            if active
            {
                dayTableView = UITableView()
                dayTableView?.separatorStyle = .none
                dayTableView?.translatesAutoresizingMaskIntoConstraints = false
                dayTableView?.delegate = self
                dayTableView?.dataSource = self
                bottomLabelView?.addSubview(dayTableView!)
                dayTableView?.backgroundColor = bottomLabelView?.backgroundColor
                bottomLabelView?.addConstraint(NSLayoutConstraint(item: bottomLabelView!, attribute: .centerX, relatedBy: .equal, toItem: dayTableView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
                bottomLabelView?.addConstraint(NSLayoutConstraint(item: bottomLabelView!, attribute: .centerY, relatedBy: .equal, toItem: dayTableView, attribute: .centerY, multiplier: 1.0, constant: -10.0))
                bottomLabelView?.addConstraint(NSLayoutConstraint(item: bottomLabelView!, attribute: .width, relatedBy: .equal, toItem: dayTableView, attribute: .width, multiplier: 1.0, constant: 0.0))
                bottomLabelView?.addConstraint(NSLayoutConstraint(item: bottomLabelView!, attribute: .height, relatedBy: .equal, toItem: dayTableView, attribute: .height, multiplier: 1.0, constant: 0.0))
                hoursWorkedLabel?.isHidden = false
            }
        } else {
            
            if active == true
            {
                dayTableView?.reloadData()
            }
            dayTableView?.isHidden = !active
            hoursWorkedLabel?.isHidden = !active
        }
    }
    
    
    
    //MARK: - UITableViewDelegate and DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = CalendarDay.getCalenderDay(date: Date(day: (currentDay?.day)!, month: (currentDay?.month)!, year: (currentDay?.year)!))
        let newData = data.filter {
            let task = StageTask.getStageTask(forId: $0.taskId.intValue)
            return !task!.wasDeleted
        }
        return newData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = CalendarDay.getCalenderDay(date: Date(day: (currentDay?.day)!, month: (currentDay?.month)!, year: (currentDay?.year)!)).filter {
                let task = StageTask.getStageTask(forId: $0.taskId.intValue)
                return !task!.wasDeleted
            }
        let cell = UITableViewCell()
        cell.backgroundColor = tableView.backgroundColor
        cell.selectionStyle = .none
        let titleLabel = UILabel()
        titleLabel.font = UIFont().normalFont()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.white
        let task = StageTask.getStageTask(forId: data[indexPath.row].taskId.intValue)
        let project = Project.getProject(forId: (task?.projectId.intValue)!)
        titleLabel.text = "\(project?.name ?? "N/A") - \(task?.name ?? "N/A")"
        
        cell.addSubview(titleLabel)
        cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1.0, constant: -20.0))
        let hoursLabel = UILabel()
        hoursLabel.textColor = UIColor.white
        hoursLabel.translatesAutoresizingMaskIntoConstraints = false
        hoursLabel.font = UIFont().boldFont()
        hoursLabel.text = String(format: "%0.2f", data[indexPath.row].timeWorked/60/60)
        cell.addSubview(hoursLabel)
        cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .centerY, relatedBy: .equal, toItem: hoursLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .trailing, relatedBy: .equal, toItem: hoursLabel, attribute: .trailing, multiplier: 1.0, constant: 20.0))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if UIScreen().isIphone5() {
            return 20
        }
        return 30.0
    }
    
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let userYear = (UserDefaults.standard.value(forKey: "USER_DOWNLOAD_YEAR") as! Int)
        
        let sizeH = scrollView.frame.size.height
        let scrolledToY = scrollView.contentOffset.y
        let year = Int(scrolledToY / sizeH)
        self.yearButton.setTitle("\(userYear+year)", for: .normal)
        
        let scrolledToX = scrollView.contentOffset.x
        let month = scrolledToX/UIScreen.main.bounds.size.width
        self.monthButton.setTitle(Months().monthArray[Int(month)
            ].uppercased(), for: .normal)
        
        let amounts = CalenderUtils.getDataFor(month: Int(month)+1, year: Date().getYear())
        self.updateBottomLabels(amounts: amounts)
        
        if loadedYears.contains(userYear+year) {
            return
        }
        else {
            loadYear(userYear+year, position: year)
        }
    }
}


    
extension Double {
    var isInteger: Bool {return rint(self) == self}
}

