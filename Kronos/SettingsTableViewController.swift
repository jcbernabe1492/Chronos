//
//  SettingsTableViewController.swift
//  Kronos
//
//  Created by Wee, David G. on 8/25/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class SettingsTableViewController: UIViewController, SettingsTableViewProtocol {
    
    var presenter: SettingsTableViewPresenterProtocol?
    @IBOutlet var settingsTableView:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView?.delegate = presenter
        settingsTableView?.dataSource = presenter
        settingsTableView?.backgroundColor = UIColor.cellBackgroundColor()
     
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTable() {
        if settingsTableView != nil
        {
            settingsTableView!.reloadData()
        }
    }

    func getController() -> UIViewController {
        return self
    }
    
    func keyboardWasShown(insets: UIEdgeInsets) {
        settingsTableView?.contentInset = insets
        settingsTableView?.scrollIndicatorInsets = insets
    }
    func keyboardWasHidden() {
        settingsTableView?.contentInset = UIEdgeInsets.zero
        settingsTableView?.scrollIndicatorInsets = UIEdgeInsets.zero
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
