
//
//  LoadTimerWireframe.swift
//  Kronos
//
//  Created by Wee, David G. on 9/12/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

class LoadTimerWireframe:NSObject, LoadTImerWireframeProtocol
{
    var loadTimerViewController:LoadTimerViewController?
    var homeViewPresenter:HomePresenterProtocol?
    var homeWireFrame:HomeWireframe?

    func createLoadTimer() -> UIViewController
    {
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoadTimer") as! LoadTimerViewController
        let presenter = LoadTimerPresenter()
        let interactor = LoadTimerInteractor()
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = view
        interactor.presenter = presenter
        self.loadTimerViewController = view
        return self.loadTimerViewController!
    }
    
    
    func showLoadTimerViewOn(viewController:HomeViewController)
    {
        let timerView = self.createLoadTimer()
        self.loadTimerViewController = timerView as? LoadTimerViewController
        homeViewPresenter = viewController.presenter
        timerView.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.addChildViewController(timerView)
        viewController.view.addSubview((timerView.view)!)
        viewController.view.insertSubview((timerView.view)!, belowSubview: (viewController.topHeader)!)
        var height = viewController.view.frame.size.height - (viewController.topHeader?.frame.size.height)!
        
        if #available(iOS 10.0, *)
        {
            
        }
        else
        {
            height -= 20
        }
        
        let tableBottomInset = (viewController.timerTopLabels?.frame.origin.y)! - 40.0
        
        self.loadTimerViewController?.tableView?.contentInset = UIEdgeInsetsMake(0, 0, tableBottomInset, 0)
        
        viewController.view.addConstraint(NSLayoutConstraint(item: (timerView as UIViewController).view , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height))
        
        viewController.view.addConstraint(NSLayoutConstraint(item: (timerView as UIViewController).view , attribute: .leading,     relatedBy: .equal, toItem: viewController.view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        viewController.view.addConstraint(NSLayoutConstraint(item: (timerView as UIViewController).view , attribute: .trailing, relatedBy: .equal, toItem: viewController.view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        let top =  NSLayoutConstraint(item: (timerView as UIViewController).view, attribute: .top, relatedBy: .equal, toItem: viewController.timerTopLabels , attribute: .top, multiplier: 1.0, constant: height)
        top.identifier = "top"
        viewController.view.addConstraint(top)
        
        viewController.view.layoutIfNeeded()
        animateLoadTimerScreen(visible: false)
    }
    
    
    func animateLoadTimerScreen(visible:Bool)
    {
        let parent = loadTimerViewController?.parent as! HomeViewController
        if !visible
        {
            homeWireFrame?.isAnimating = true
            parent.view.constraintWithName(identifier: "top")?.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                parent.view.layoutIfNeeded()
                }, completion: {(bool) in
                    self.homeWireFrame?.isAnimating = false
            })
        }
        else
        {
            parent.view.constraintWithName(identifier: "top")?.constant = parent.view.frame.size.height - (parent.topHeader?.frame.size.height)!
            homeWireFrame?.isAnimating = true
            UIView.animate(withDuration: 0.5, animations: {
                parent.view.layoutIfNeeded()
                }, completion: {(done) in
                    self.loadTimerViewController?.view.removeFromSuperview()
                    self.loadTimerViewController?.removeFromParentViewController()
                    self.loadTimerViewController = nil
                    self.homeWireFrame?.isAnimating = false
            })
        }
    }
    
    func close() {
        homeViewPresenter?.closeLoadTimer()
    }
    func closeWithNewProjectSelected(id: NSNumber) {
        homeViewPresenter?.updateCurrentProject(id: id)

    }
    
    func showOnScreen(view:UIView)
    {
        UIApplication.shared.keyWindow?.addSubview(view)
        UIApplication.shared.keyWindow?.addConstraint(NSLayoutConstraint(item: UIApplication.shared.keyWindow!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        UIApplication.shared.keyWindow?.addConstraint(NSLayoutConstraint(item: UIApplication.shared.keyWindow!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        UIApplication.shared.keyWindow?.addConstraint(NSLayoutConstraint(item: UIApplication.shared.keyWindow!, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0.0))
        UIApplication.shared.keyWindow?.addConstraint(NSLayoutConstraint(item: UIApplication.shared.keyWindow!, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: 0.0))
    }
    

    
    
    
    
}
