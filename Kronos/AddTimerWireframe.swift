//
//  AddTimerWireframe.swift
//  Kronos
//
//  Created by Wee, David G. on 9/5/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

class AddTimerWireframe : NSObject, AddTimerWireframeProtocol
{
    var viewController:AddTimerViewController?
    var homeWireframe:HomeWireframe?
    func createAddTimerView() -> AddTimerViewController
    {
        let wireframe = AddTimerWireframe()
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTimer") as! AddTimerViewController
        let presenter = AddTimerPresenter()
        let interactor = AddTimerInteractor()
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        presenter.view = view
        interactor.presenter = presenter
        
        wireframe.viewController = view
        wireframe.viewController?.modalTransitionStyle = .flipHorizontal
        return wireframe.viewController!
    }
    
    
    func showAddTimerViewOn(viewController:HomeViewController)
    {
        let timerView = self.createAddTimerView()
        self.viewController = timerView
        
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
            
        viewController.view.addConstraint(NSLayoutConstraint(item: (timerView as UIViewController).view , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height))
        
        viewController.view.addConstraint(NSLayoutConstraint(item: (timerView as UIViewController).view , attribute: .leading,     relatedBy: .equal, toItem: viewController.view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        viewController.view.addConstraint(NSLayoutConstraint(item: (timerView as UIViewController).view , attribute: .trailing, relatedBy: .equal, toItem: viewController.view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        let top =  NSLayoutConstraint(item: (timerView as UIViewController).view, attribute: .top, relatedBy: .equal, toItem: viewController.timerTopLabels , attribute: .top, multiplier: 1.0, constant: height)
        top.identifier = "top"
        viewController.view.addConstraint(top)
            
        viewController.view.layoutIfNeeded()
        animateAddTimerScreen(visible: false)
    }
    
     func animateAddTimerScreen(visible:Bool)
    {
        let parent = viewController?.parent as! HomeViewController
        if !visible
        {
            homeWireframe?.isAnimating = true
            parent.view.constraintWithName(identifier: "top")?.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                parent.view.layoutIfNeeded()
                }, completion: {(bool) in
                    self.homeWireframe?.isAnimating = false
            })
        }
        else
        {
          
            parent.view.constraintWithName(identifier: "top")?.constant = parent.view.frame.size.height - (parent.topHeader?.frame.size.height)!
            homeWireframe?.isAnimating = true
            UIView.animate(withDuration: 0.5, animations: {
                parent.view.layoutIfNeeded()
                }, completion: {(done) in
                    self.viewController?.view.removeFromSuperview()
                    self.viewController?.removeFromParentViewController()
                    self.viewController = nil
                    self.homeWireframe?.isAnimating = false
            })
        }
    }
    func canSaveTimer() -> Bool
    {
        return (viewController?.canSaveTimer())!
    }
    
    func closeTimer() {
        let parent = viewController?.parent as! HomeViewController
        parent.closeAddTimer()
    }
    
    func getHomeViewController() -> HomeViewController
    {
        return viewController?.parent as! HomeViewController
    }


}
