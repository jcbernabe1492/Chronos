//
//  HomePresenter.swift
//  Kronos
//
//  Created by Wee, David G. on 8/15/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit


enum MODULES
{
    case HOME, CALENDER, INVOICE, SETTINGS, ADD_TIMER, LOAD_TIMER, ARCHIVES
}


class HomePresenter : NSObject, HomePresenterProtocol, TimerViewDelegate, HomeWireFrameDelegate
{
    var interactor : HomeInteractorInput?
    var wireframe : HomeWireframeProtocol?
    
    
    var currentModule:MODULES = .HOME
    var openingOrClosing:Bool = false
    
    weak var view : HomeViewControllerProtocol?
    
    var timerOne: TimerView?
    
    func viewDidLoad() {
        createTimerView(TimerType.Normal)
        
        wireframe?.homeWireFrameDelegate = self
    }
    
    func createTimerView(_ type:TimerType) {
        let timer = TimerView()
        timer.delegate = self
        timer.timer = type
        timer.translatesAutoresizingMaskIntoConstraints = false
        timer.backgroundColor = UIColor.clear
        timer.initTimer()
        timer.minuteDidPass = {() in
            self.view?.updateTopLabels()
        }
        
        let timer2 = TimerView()
        timer2.delegate = self
        timer2.timer = TimerType.ProjectTime
        timer2.translatesAutoresizingMaskIntoConstraints = false
        timer2.backgroundColor = UIColor.clear
        timer2.initTimer()
        timer2.minuteDidPass = {() in
            self.view?.updateTopLabels()
        }
        
        let timer3 = TimerView()
        timer3.delegate = self
        timer3.timer = TimerType.AllocatedTime
        timer3.translatesAutoresizingMaskIntoConstraints = false
        timer3.backgroundColor = UIColor.clear
        timer3.initTimer()
        timer3.minuteDidPass = {() in
            self.view?.updateTopLabels()
        }
        
        self.timerOne = timer
        
        timer.otherTimers = [timer2, timer3]
        timer2.otherTimers = [timer, timer3]
        timer3.otherTimers = [timer,timer2]
        
        view?.showScrollViewWithTimers(timer1: timer, timer2: timer2, timer3: timer3)

    }
    
    
    
    func moduleButtonPressed(selectedModule:MODULES) -> Bool
    {
        if openingOrClosing { return false }
        
        if selectedModule == .CALENDER
        {
            if currentModule == .CALENDER
            {
                currentModule = .HOME
                openingOrClosing = true
                wireframe?.closeCalender {
                    self.openingOrClosing = false
                }
            }
            else
            {
                self.closeAnyViewControllers()
                wireframe?.showCalenderView()
                currentModule = .CALENDER
            }
        }
        else if selectedModule == .LOAD_TIMER
        {
            if currentModule == .LOAD_TIMER
            {
                currentModule = .HOME
                openingOrClosing = true
                wireframe?.showLoadTimerScreen(active: false)
                openingOrClosing = false
            }
            else
            {
                
                self.closeAnyViewControllers()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: { () in
                     self.wireframe?.showLoadTimerScreen(active: true)
                })
                currentModule = .LOAD_TIMER
            }
        }
        else if selectedModule == .ADD_TIMER
        {
            if currentModule == .ADD_TIMER
            {
                if (wireframe?.canSaveTimer())!
                {
                    currentModule = .HOME
                    openingOrClosing = true
                    wireframe?.showAddTimerScreen(active: false)
                    openingOrClosing = false
                }else
                {
                    return false
                }
            }
            else
            {
                self.closeAnyViewControllers()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: { () in
                    self.wireframe?.showAddTimerScreen(active: true)
                })
                currentModule = .ADD_TIMER
            }
        }
        return true
    }
    
    func updateCalendarDay() {
        interactor?.updateCalendarDay(stopping: false)
    }
    
// MARK: - HomeWireFrame Delegates
    
    func updateTimerViewWithNewTime(time: Int) {
        self.timerOne?.updateTimerViewWithNewTime(time: time)
    }
    
    func updateTopLabels(min: Int, hrs: Int, days: Int) {
        view?.setTopLabels(min: min, hrs: hrs, days: days)
    }
    
// MARK: - Timer View Delegates
    func showEditTimer(buttonFrame: CGRect) {
        wireframe?.showEditTimerScreen(buttonFrame: buttonFrame)
    }
    
    func setTopLabels(min: Int, hrs: Int, days: Int) {
        view?.setTopLabels(min: min, hrs: hrs, days: days)
    }

    func startStopButtonPressed(_ active:Bool)
    {
        var image:UIImage?
        if active
        {
            image = UIImage(named: "icn-logo-red")
            interactor?.updateCalendarDay(stopping: false)
        }else
        {
            image = UIImage(named: "icn-logo-black")
            interactor?.updateCalendarDay(stopping: true)
        }
        view?.updateTopLogoImage(image: image!)
    }
    
    func noTimerActive() {
        let alert = UIAlertController(title: "No Active Timers Available", message: "Load or create a new timer", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(closeAction)
        
        (view as! UIViewController).present(alert, animated: true, completion: nil)
    }
    
    func addTime(active: Bool) {
        view?.addTime(active: active)
    }
    
// MARK: - Settings Button Pressed
    func settingsButtonPressed() {
        wireframe?.showSettingsScreen()
    }
    
    func addTimerButtonPressed(active: Bool) {
        self.currentModule = .HOME
        wireframe?.showAddTimerScreen(active: active)
    }
    
    func addTimerClosedFromElseWhere(){
        view?.addTimerButtonPressed()
    }
    
    //For addtimer
    func canSave() -> Bool {
        if wireframe!.canSaveTimer()
        {
            view?.updateHomeScreenValues()
            return true
        }
        return false
    }
    
    func loadTimerButtonPressed(active: Bool) {
        wireframe?.showLoadTimerScreen(active: active)
    }
    
    func calenderButtonPressed() {
        wireframe?.showCalenderView()
    }
    
    func closeCalender(done: @escaping ()->Void) {
        wireframe?.closeCalender(done: done)
    }
    
    func invoiceButtonPressed(section:Int)
    {
        wireframe?.showInvoiceView(section: section)
    }
    
    func closeInvoice(done: @escaping ()->Void) {
        wireframe?.closeInvoice(done: done)
    }
    
    func archiveButtonPressed(active: Bool) {
        if active{
            wireframe?.showArchive()
        }
        else { wireframe?.closeArchive()}
    }
    func isArchiveAnimating() -> Bool {
        if wireframe?.archiveWireframe == nil { return false }
        return (wireframe?.archiveWireframe?.archiveViewController?.isAnimating)!
    }
    
    
    func changeInvoiceSection(section: Int) {

        wireframe?.changeInvoiceSection(section: section)
    }
    
    func updateCurrentProject(id: NSNumber) {
        view?.stopCurrentTimer()
        UserDefaults.standard.set(id, forKey: CURRENT_JOB_TIMER)
        view?.updateHomeScreenValues()
        
        
        view?.closeLoadTimer()
        self.currentModule = .HOME
    }
    
    func closeLoadTimer() {
        view?.closeLoadTimer()

    }
    
    func isAnyViewAnimating() -> Bool {
        return (wireframe?.isAnyViewAnimating())!
    }
    
    func closeAnyViewControllers() {
        wireframe?.closeAnyViewControllers()
    }
    
}



extension HomePresenter : HomeInteractorOutput {
    
}
