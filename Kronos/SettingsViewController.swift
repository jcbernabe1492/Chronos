//
//  SettingsViewController.swift
//  Kronos
//
//  Created by Wee, David G. on 8/23/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, SettingsViewControllerProtocol {

    
    var presenter: SettingsPresenterProtocol?
    var homeWireframe:HomeWireframe?
    
    @IBOutlet var defaultsButton:UIButton!
    @IBOutlet var tableViewContainer:UIView?
    @IBOutlet var userGuideContainer:UIView?
    var tabSelected:UIButton?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tabSelected = defaultsButton
        presenter?.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getController() -> UIViewController {
        return self
    }
    
    func setTableViewContainerVisibleWith(viewController: SettingsTableViewController?) {
        if viewController != nil
        {
            addChildViewController(viewController!)
            tableViewContainer?.addSubview((viewController?.view)!)
            viewController?.view.translatesAutoresizingMaskIntoConstraints = false
            tableViewContainer?.addConstraint(NSLayoutConstraint(item: (tableViewContainer! as UIView), attribute: .leading, relatedBy: .equal, toItem: viewController?.view, attribute: .leading, multiplier: 1.0, constant: 0.0))
            tableViewContainer?.addConstraint(NSLayoutConstraint(item: (tableViewContainer! as UIView), attribute: .trailing, relatedBy: .equal, toItem: viewController?.view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            tableViewContainer?.addConstraint(NSLayoutConstraint(item: (tableViewContainer! as UIView), attribute: .top, relatedBy: .equal, toItem: viewController?.view, attribute: .top, multiplier: 1.0, constant: 0.0))
            tableViewContainer?.addConstraint(NSLayoutConstraint(item: (tableViewContainer! as UIView), attribute: .bottom, relatedBy: .equal, toItem: viewController?.view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        }
        tableViewContainer?.isHidden = false
        userGuideContainer?.isHidden = true
    }
    
    func setUserGuideContainerVisibleWith(viewController: SettingsUserGuideViewController?) {
        if viewController != nil
        {
            addChildViewController(viewController!)
            userGuideContainer?.addSubview((viewController?.view)!)
            viewController?.view.translatesAutoresizingMaskIntoConstraints = false
            userGuideContainer?.addConstraint(NSLayoutConstraint(item: (userGuideContainer! as UIView), attribute: .leading, relatedBy: .equal, toItem: viewController?.view, attribute: .leading, multiplier: 1.0, constant: 0.0))
            userGuideContainer?.addConstraint(NSLayoutConstraint(item: (userGuideContainer! as UIView), attribute: .trailing, relatedBy: .equal, toItem: viewController?.view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            userGuideContainer?.addConstraint(NSLayoutConstraint(item: (userGuideContainer! as UIView), attribute: .top, relatedBy: .equal, toItem: viewController?.view, attribute: .top, multiplier: 1.0, constant: 0.0))
            userGuideContainer?.addConstraint(NSLayoutConstraint(item: (userGuideContainer! as UIView), attribute: .bottom, relatedBy: .equal, toItem: viewController?.view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        }
        tableViewContainer?.isHidden = true
        userGuideContainer?.isHidden = false
    }
    
    //Actions
    @IBAction func tabChanged(btn:UIButton)
    {
        tabSelected?.backgroundColor = UIColor.clear
        tabSelected = btn
        tabSelected?.backgroundColor = UIColor.tabSelectedYellow()
        presenter?.tabChanged(value: btn.tag)
    }
    
    func tabChanged(value: Int) {
        tabSelected?.backgroundColor = UIColor.clear
        presenter?.tabChanged(value: value)
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
