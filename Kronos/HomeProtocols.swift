//
//  HomeProtocols.swift
//  Kronos
//
//  Created by Wee, David G. on 8/15/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

protocol HomeWireframeProtocol : class {
    
    weak var settingsController:SettingsViewController? {get set}
    var calenderWireframe: CalenderWireframe? {get set}
    var addTimerWireframe:AddTimerWireframe? {get set}
    var loadTimerWireframe:LoadTimerWireframe? {get set}
    var invoiceWireframe:InvoiceWireframe? {get set}
    var archiveWireframe:ArchiveWireframe? {get set}
    
    func showAboutScreen()
    func showHelpScreen()
    func showSettingsScreen()
    func showAddTimerScreen(active:Bool)
    func canSaveTimer() -> Bool
    func showLoadTimerScreen(active:Bool)
    func isAnyViewAnimating() -> Bool
    func showCalenderView()
    func showInvoiceView(section:Int)
    func closeCalender(done:@escaping () -> Void)
    func closeInvoice(done: @escaping ()->Void)
    func changeInvoiceSection(section:Int)
    func showArchive()
    func closeArchive()
    
    func closeAnyViewControllers()
    
    //Edit Timer
    func showEditTimerScreen(buttonFrame: CGRect)
    func closeEditTimerScreen()
    
    weak var homeWireFrameDelegate: HomeWireFrameDelegate? {get set}
}

protocol HomeWireFrameDelegate : class {
    func updateTimerViewWithNewTime(time: Int)
    func updateTopLabels(min:Int, hrs:Int, days:Int)
}

protocol HomePresenterProtocol : class {
    var interactor: HomeInteractorInput? { get set }
    var wireframe: HomeWireframeProtocol? { get set }
    var currentModule:MODULES {get set}
    weak var view: HomeViewControllerProtocol? { get set }
    func viewDidLoad()
    func createTimerView(_ type:TimerType)
    func helpButtonPressed()
    func settingsButtonPressed()
    func calenderButtonPressed()
    func closeCalender(done: @escaping ()->Void)
    func closeInvoice(done: @escaping ()->Void)
    func addTimerButtonPressed(active:Bool)
    func loadTimerButtonPressed(active:Bool)
    func canSave() -> Bool
    func updateCurrentProject(id: NSNumber)
    func closeLoadTimer()
    func isAnyViewAnimating() -> Bool
    func invoiceButtonPressed(section:Int)
    func changeInvoiceSection(section:Int)
    func archiveButtonPressed(active:Bool)
    func isArchiveAnimating() -> Bool
    func closeAnyViewControllers()
    func updateCalendarDay()

    func moduleButtonPressed(selectedModule:MODULES) -> Bool
    
}
  

protocol HomeInteractorInput : class {
   weak var presenter: HomeInteractorOutput? { get set }
    func updateCalendarDay(stopping: Bool)

}

protocol HomeInteractorOutput : class {
    
}

protocol HomeViewControllerProtocol : class {
    var presenter: HomePresenterProtocol? { get set }
    func updateTopLogoImage(image:UIImage)
    func addTimerButtonPressed()
    func updateHomeScreenValues()
    func closeLoadTimer()
    func stopCurrentTimer()
    func updateTopLabels()
     func setTopLabels(min: Int, hrs: Int, days: Int)
    func showScrollViewWithTimers(timer1:TimerView?, timer2:TimerView?, timer3:TimerView?)
    func addTime(active:Bool)
    
}

protocol SimpleTimerInterface {
    func secondsPassing(seconds: Double)
    func updateValues(withCurrentTime: Double, jobTimer: JobTimer)
}

