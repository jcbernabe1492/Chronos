
//
//  HomeWireframe.swift
//  Kronos
//
//  Created by Wee, David G. on 8/15/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit



class HomeWireframe : NSObject, HomeWireframeProtocol, EditTimerViewControllerDelegate
{
    weak var viewController:HomeViewController?
    weak var settingsController:SettingsViewController?
    weak var editTimerViewController:EditTimerViewController?
    weak var helpScreen: HelpController?
    weak var homeWireFrameDelegate: HomeWireFrameDelegate?
    var calenderWireframe: CalenderWireframe?
    var addTimerWireframe:AddTimerWireframe?
    var loadTimerWireframe:LoadTimerWireframe?
    var invoiceWireframe:InvoiceWireframe?
    var archiveWireframe:ArchiveWireframe?
    
    var isAnimating:Bool = false
    
    var isTimerViewPresent: Bool = true
    var isArchiveViewPresent: Bool = false
    var isCalendarViewPresent: Bool = false
    var isInvoiceViewPresent: Bool = false
    
    class func addHomeControllerOnWindow(_ window:UIWindow)
    {
        let wireframe = HomeWireframe()
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeView") as! HomeViewController
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        presenter.view = view
        interactor.presenter = presenter
    
        wireframe.viewController = view
        wireframe.viewController?.modalTransitionStyle = .flipHorizontal
        if window.rootViewController == nil {
            window.rootViewController = view
        } else {
            window.rootViewController?.present(wireframe.viewController!, animated: true, completion: nil)
        }
    }
    
    class func addHomeControllerOnWindowWithSettingsOn(_ window:UIWindow)
    {
        let wireframe = HomeWireframe()
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeView") as! HomeViewController
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        presenter.view = view
        interactor.presenter = presenter
        
        wireframe.viewController = view
        wireframe.viewController?.modalTransitionStyle = .flipHorizontal

        
        if window.rootViewController == nil {
            window.rootViewController = view
        } else {
            window.rootViewController?.present(wireframe.viewController!, animated: true, completion: {
                view.settingsButtonPressed()
            })
        }
    }
    
    
    func isAnyViewAnimating() -> Bool {
        return isAnimating
    }
    
    class func addStartScreenOnWindow(_ window:UIWindow)
    {
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartScreen")
        window.rootViewController = view
    }
    
    class func addIntroScreenOnWindow(_ window: UIWindow) {
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppIntroController")
        window.rootViewController = view
    }
    
// MARK: - Show Intro Screen from User Guide
    
    func showIntroScreenFromUserGuide() {
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppIntroController")
        
        viewController?.present(view, animated: true, completion: nil)
    }
    
// MARK: - Show Start Screen
    
    func showAboutScreen() {
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartScreen")
        
        view.modalTransitionStyle = .flipHorizontal
        viewController?.present(view, animated: true, completion: nil)
    }
    
// MARK: - Show Help Screen
    
    func showHelpScreen() {
        
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HelpController") as! HelpController
        let _ = view.view
        
        view.homeWireframe = self
        helpScreen = view
        
        if isTimerViewPresent {
            view.showWithType(type: .TimerHelp)
        } else if isCalendarViewPresent {
            view.showWithType(type: .CalendarHelp)
        } else if isInvoiceViewPresent {
            view.showWithType(type: .InvoiceHelp)
        } else if isArchiveViewPresent {
            view.showWithType(type: .ArchiveHelp)
        } else {
            return
        }
  
        view.view.translatesAutoresizingMaskIntoConstraints = false
        viewController?.addChildViewController(view)
        viewController?.view.addSubview((view.view)!)

        viewController?.view.addConstraint(NSLayoutConstraint(item: (view as UIViewController).view , attribute: .leading,     relatedBy: .equal, toItem: viewController?.view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        viewController?.view.addConstraint(NSLayoutConstraint(item: (view as UIViewController).view , attribute: .trailing, relatedBy: .equal, toItem: viewController?.view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        viewController?.view.addConstraint(NSLayoutConstraint(item: (view as UIViewController).view , attribute: .top, relatedBy: .equal, toItem: viewController?.view, attribute: .top, multiplier: 1.0, constant: 0.0))
        let bottom =  NSLayoutConstraint(item: (view as UIViewController).view, attribute: .bottom, relatedBy: .equal, toItem: viewController?.view , attribute: .bottom, multiplier: 1.0, constant: 0.0)
        bottom.identifier = "bottom"
        viewController?.view.addConstraint(bottom)
        
        viewController?.view.layoutIfNeeded()
    }
    
    func dismissHelpScreen() {
        self.helpScreen?.view.removeFromSuperview()
        self.helpScreen?.removeFromParentViewController()
        self.helpScreen = nil
    }
    
// MARK: - Show Settings Screen
    
    func showSettingsScreen()
    {
        if calenderWireframe != nil && (viewController?.calenderActive)!
        {
            viewController?.calenderButtonPressed()
        }
        if loadTimerWireframe != nil
        {
            viewController?.loadTimerButtonPressed()
        }
        if invoiceWireframe != nil
        {
            viewController?.invoicesButtonPressed()
        }
        if settingsController != nil
        {
            animateSettingsScreen(visible: true)
            
            isTimerViewPresent = true
        }
        else
        {
            settingsController = SettingsWireframe.createSettingsView()
            settingsController?.homeWireframe = self
            settingsController?.view.translatesAutoresizingMaskIntoConstraints = false
            viewController?.addChildViewController(settingsController!)
            viewController?.view.addSubview((settingsController?.view)!)
            viewController?.view.insertSubview((settingsController?.view)!, belowSubview: (viewController?.topHeader)!)
            var height = (viewController?.view.frame.size.height)! - (viewController?.topHeader?.frame.size.height)!
            viewController?.view.setNeedsLayout()
            viewController?.view.layoutIfNeeded()
            if #available(iOS 10.0, *)
            {
                
            }
            else
            {
                height -= 20
            }

            viewController?.view.addConstraint(NSLayoutConstraint(item: (settingsController as! UIViewController).view , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height))
            
        
            viewController?.view.addConstraint(NSLayoutConstraint(item: (settingsController as! UIViewController).view , attribute: .leading,     relatedBy: .equal, toItem: viewController?.view, attribute: .leading, multiplier: 1.0, constant: 0.0))
            viewController?.view.addConstraint(NSLayoutConstraint(item: (settingsController as! UIViewController).view , attribute: .trailing, relatedBy: .equal, toItem: viewController?.view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            let bottom =  NSLayoutConstraint(item: (settingsController as! UIViewController).view, attribute: .bottom, relatedBy: .equal, toItem: viewController?.view , attribute: .bottom, multiplier: 1.0, constant: -height)
            bottom.identifier = "bottom"
            viewController?.view.addConstraint(bottom)
        
            viewController?.view.layoutIfNeeded()
            self.animateSettingsScreen(visible: false)
            
            isTimerViewPresent = false
        }
    }
    
    func animateSettingsScreen(visible:Bool)
    {
        if !visible
        {
            isAnimating = true
            viewController?.view.setNeedsLayout()
            viewController?.view.layoutIfNeeded()
            settingsController?.view.backgroundColor = UIColor(red: 230/250, green: 230/250, blue: 230/250, alpha: 1/0)
            viewController?.view.constraintWithName(identifier: "bottom")?.constant = 1
            UIView.animate(withDuration: 0.5, animations: {
                self.viewController?.view.layoutIfNeeded()
                }, completion: {(bool) in
                    self.isAnimating = false
              
            })
            
        }
        else
        {
            viewController?.view.constraintWithName(identifier: "bottom")?.constant = -(viewController?.view.frame.size.height)! - (viewController?.topHeader?.frame.size.height)! - 20
            isAnimating = true
            UIView.animate(withDuration: 0.5, animations: {
                self.viewController?.view.layoutIfNeeded()
                }, completion: {(done) in
                    self.settingsController?.view.removeFromSuperview()
                    self.settingsController?.removeFromParentViewController()
                    self.settingsController = nil
                    self.isAnimating = false
            })
        }
    }

// MARK: - Show Load Timer
    
    func showLoadTimerScreen(active: Bool) {
        var animating = false
        if addTimerWireframe != nil{
            animating = true
            viewController?.closeAddTimer()
        }
        if invoiceWireframe != nil
        {
            viewController?.closeArchive(done:{})
        }
        if animating
        {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                self.showCloseLoadTimer(active: active)
            })
        }
        else
        {
            showCloseLoadTimer(active: active)
        }
    }
    
    func showCloseLoadTimer(active:Bool)
    {

        if !active
        {
            self.closeLoadTimer()
        }
        else
        {
            self.loadTimerWireframe = LoadTimerWireframe()
            self.loadTimerWireframe?.homeWireFrame = self
            self.loadTimerWireframe?.showLoadTimerViewOn(viewController: self.viewController!)
            
            isTimerViewPresent = false
        }
    }
    
    func closeLoadTimer()
    {
        loadTimerWireframe?.animateLoadTimerScreen(visible: true)
        loadTimerWireframe = nil
        
        isTimerViewPresent = true
    }
    
// MARK: - Show Add Timer
    
    func showAddTimerScreen(active:Bool)
    {
        showCloseAddTimer(active: active)
    }
    
    func showCloseAddTimer(active:Bool)
    {
        if !active
        {
            self.closeAddTimerView()
        }
        else
        {
            self.addTimerWireframe = AddTimerWireframe()
            self.addTimerWireframe?.homeWireframe = self
            self.addTimerWireframe?.showAddTimerViewOn(viewController: self.viewController!)
            
            isTimerViewPresent = false
        }
    }
    
    func canSaveTimer() -> Bool {
        if addTimerWireframe == nil { return false }
        let t = addTimerWireframe!.canSaveTimer()
        if t
        {
            viewController?.updateHomeScreenValues()
        }
        return t
    }
    
    func closeAddTimerView()
    {
        addTimerWireframe?.animateAddTimerScreen(visible: true)
        addTimerWireframe = nil
        
        isTimerViewPresent = true
    }
    
// MARK: - Show/Close Edit TImer
    func showEditTimerScreen(buttonFrame: CGRect) {
        editTimerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditTimer") as? EditTimerViewController
        editTimerViewController?.editTimerDelegate = self
        editTimerViewController?.buttonFrame = buttonFrame
        viewController?.present(editTimerViewController!, animated: false, completion: nil)
    }
    
    func closeEditTimerScreen() {
        
    }
    
// MARK: - Edit Timer View Controller Delegate
    
    func updateTopLabels(min: Int, hrs: Int, days: Int) {
        homeWireFrameDelegate?.updateTopLabels(min: min, hrs: hrs, days: days)
    }
    
    func okButtonTappedWithNewTime(time: Int) {
        homeWireFrameDelegate?.updateTimerViewWithNewTime(time: time)
    }
    
// MARK: - Show/Close Archive
    func showArchive()
    {
        archiveWireframe = ArchiveWireframe()
        let archiveVC = archiveWireframe?.createArchiveViewController()
        archiveVC?.homeArchiveButton = viewController?.archiveButton
        animateViewControllerFromTop(newViewController: archiveVC!, active: false, done: {})
//        animateViewControllerFromBottom(newViewController: archiveVC!, active: false, done: {})
        
        isArchiveViewPresent = true
        isTimerViewPresent = false
    }
    
    func closeArchive()
    {
        if archiveWireframe == nil { return }
        animateViewControllerFromTop(newViewController: archiveWireframe!.archiveViewController!, active: true, done: {self.archiveWireframe = nil})
//        animateViewControllerFromBottom(newViewController: archiveWireframe!.archiveViewController!, active: true, done: {self.archiveWireframe = nil})
        
        isArchiveViewPresent = false
        isTimerViewPresent = true
    }
    
// MARK: - Show/Close Calendar View
    func showCalenderView()
    {
        if loadTimerWireframe != nil
        {
            viewController?.closeLoadTimer()
        }
        if addTimerWireframe != nil
        {
            viewController?.closeAddTimer()
        }
        if invoiceWireframe != nil
        {
            viewController?.closeArchive(done: {
                self.calenderWireframe = CalenderWireframe()
                let calenderVC = self.calenderWireframe?.createCalenderViewController()
                self.animateViewControllerFromBottom(newViewController: calenderVC!, active: false, done: {})
            })
            return
        }
        if calenderWireframe == nil
        {
            calenderWireframe = CalenderWireframe()
            let calenderVC = calenderWireframe?.createCalenderViewController()
            animateViewControllerFromBottom(newViewController: calenderVC!, active: false, done: {})
        }
        else
        {
           calenderWireframe?.calenderViewController?.viewWillAppear(true)
            animateViewControllerFromBottom(newViewController: (calenderWireframe?.calenderViewController!)!, active: false, done: {})
        }
        
        isCalendarViewPresent = true
        isTimerViewPresent = false
    }
    
    func closeCalender(done:@escaping () -> Void) {
        animateViewControllerFromBottom(newViewController: calenderWireframe!.calenderViewController!, active: true, done: done)
        
        isCalendarViewPresent = false
        isTimerViewPresent = true
    }
    
// MARK: - Show/Close Invoice View
    func showInvoiceView(section:Int)
    {
        if loadTimerWireframe != nil
        {
            viewController?.closeLoadTimer()
        }
        if addTimerWireframe != nil
        {
            viewController?.closeAddTimer()
        }
        if calenderWireframe != nil
        {
            closeCalender {
            }
        }
        if invoiceWireframe == nil
        {
            invoiceWireframe = InvoiceWireframe()
            let invoiceVC = invoiceWireframe?.createInvoiceViewController(section: section)
            animateViewControllerFromBottom(newViewController: invoiceVC!, active: false, done: {})
            
            isInvoiceViewPresent = true
            isTimerViewPresent = false
        }
        else
        {
            closeInvoice(done: {})
        }
        
    }
    
    func closeInvoice(done: @escaping ()->Void) {
        if invoiceWireframe != nil
        {
            animateViewControllerFromBottom(newViewController: invoiceWireframe!.invoiceViewController!, active: true, done: done)
            invoiceWireframe?.invoiceViewController?.view.removeFromSuperview()
            invoiceWireframe?.invoiceViewController?.removeFromParentViewController()
            invoiceWireframe = nil
            
            isInvoiceViewPresent = false
            isTimerViewPresent = true
        }
    }

    func changeInvoiceSection(section: Int) {
        invoiceWireframe?.invoiceViewController?.changeSection(section: section)
    }
    
// MARK: - AnimateViewControllerFromBottom
    func animateViewControllerFromBottom(newViewController:UIViewController ,active:Bool, done:@escaping () -> Void)
    {
        if !active
        {
            if newViewController.parent != nil
            {
                if newViewController is CalenderViewController
                {
                    animate(viewController: newViewController, active: false,identifier: "topAnimateCal", done:done)
                }else
                {
                    animate(viewController: newViewController, active: false,identifier: "topAnimate", done:done)
                }
            }
            else
            {
                viewController?.addChildViewController(newViewController)
                 viewController?.view.addSubview(newViewController.view)
                newViewController.view.translatesAutoresizingMaskIntoConstraints = false
                
                let top = NSLayoutConstraint(item: viewController!.animationView!, attribute: .bottom
                    , relatedBy: .equal, toItem: newViewController.view!, attribute: .top, multiplier: 1.0, constant: -UIScreen.main.bounds.size.height)
                if newViewController is CalenderViewController
                {
                    top.identifier = "topAnimateCal"
                }
                else
                {
                    top.identifier = "topAnimate"
                }
                viewController?.view.addConstraint(top)
                
                viewController?.view.addConstraint(NSLayoutConstraint(item: viewController!.view!, attribute: .centerX, relatedBy: .equal, toItem: newViewController.view!, attribute: .centerX, multiplier: 1.0, constant: 0.0))
                viewController?.view.addConstraint(NSLayoutConstraint(item: viewController!.view!, attribute: .leading, relatedBy: .equal, toItem: newViewController.view!, attribute: .leading, multiplier: 1.0, constant: 0.0))
                viewController?.view.addConstraint(NSLayoutConstraint(item:newViewController.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: (viewController?.view.frame.size.height)! - (viewController?.animationView?.frame.origin.y)!))
                
                viewController?.view.layoutIfNeeded()
                animate(viewController: newViewController, active: false,identifier: top.identifier!, done:done)
            }
        }
        else
        {
            if newViewController is CalenderViewController
            {
                animate(viewController: newViewController, active: true,identifier: "topAnimateCal", done:done)
            }else
            {
                animate(viewController: newViewController, active: true,identifier: "topAnimate", done:done)
            }
        }
    }
    
    func animate(viewController:UIViewController ,active:Bool,identifier:String, done:@escaping ()->Void )
    {
        
        if !active
        {
            isAnimating = true
            viewController.isAnimating = true
            self.viewController?.view.constraintWithName(identifier: identifier)?.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                viewController.view.layoutIfNeeded()
                }, completion: {(a) in
                    self.isAnimating = false
                    viewController.isAnimating = false
                    done()
            })
        }
        else
        {
            let height = (self.viewController?.view.frame.size.height)! - (self.viewController?.topHeader?.frame.size.height)! + 50.0
            
            isAnimating = true
            viewController.isAnimating = true
            if identifier == "bottomAnimate"
            { self.viewController?.view.constraintWithName(identifier: identifier)?.constant = height}
            else
            {
                self.viewController?.view.constraintWithName(identifier: identifier)?.constant = -height
            }
            UIView.animate(withDuration: 0.5, animations: {
                viewController.view.layoutIfNeeded()
                }, completion: {(a) in
    
                    self.isAnimating = false
                    viewController.isAnimating = false
                    done()
            })
        }
    }
    
    
    func animateViewControllerFromTop(newViewController:UIViewController ,active:Bool, done:@escaping () -> Void)
    {
        if !active
        {
            viewController?.addChildViewController(newViewController)
            if newViewController is ArchiveViewController
            {
                viewController?.view.addSubview(newViewController.view)
            }
            else
            {
                viewController?.view.insertSubview(newViewController.view, belowSubview: (viewController?.topHeader)!)
            }
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            
            let bottom = NSLayoutConstraint(item: viewController!.view!, attribute: .bottom
                , relatedBy: .equal, toItem: newViewController.view!, attribute: .bottom, multiplier: 1.0, constant: UIScreen.main.bounds.size.height)
            bottom.identifier = "bottomAnimate"
            viewController?.view.addConstraint(bottom)
            
            viewController?.view.addConstraint(NSLayoutConstraint(item: viewController!.view!, attribute: .centerX, relatedBy: .equal, toItem: newViewController.view!, attribute: .centerX, multiplier: 1.0, constant: 0.0))
            viewController?.view.addConstraint(NSLayoutConstraint(item: viewController!.view!, attribute: .leading, relatedBy: .equal, toItem: newViewController.view!, attribute: .leading, multiplier: 1.0, constant: 0.0))
            viewController?.view.addConstraint(NSLayoutConstraint(item:newViewController.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: (viewController?.view.frame.size.height)! - ((viewController?.topHeader?.frame.size.height)!+20)))
            
            viewController?.view.layoutIfNeeded()
            animate(viewController: newViewController, active: false,identifier: bottom.identifier!, done:done)
        }
        else
        {
            animate(viewController: newViewController, active: true,identifier: "bottomAnimate", done:done)
        }
    }
    
    func closeAnyViewControllers() {
        if settingsController != nil{
            self.animateSettingsScreen(visible: true)
        }
        else if loadTimerWireframe != nil
        {
            self.closeLoadTimer()
        }
        else if self.addTimerWireframe != nil
        {
            self.showCloseAddTimer(active: false)
        }
        else if self.invoiceWireframe != nil
        {
            self.closeInvoice {
            }
        }
        if calenderWireframe != nil
        {
            self.closeCalender {
            }
        }
        if archiveWireframe != nil
        {
            self.closeArchive()
        }
    }
}
