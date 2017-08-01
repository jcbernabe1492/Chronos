//
//  HelpController.swift
//  Kronos
//
//  Created by Jc Bernabe on 25/07/2017.
//  Copyright © 2017 davidwee. All rights reserved.
//

import UIKit

enum HelpType {
    case TimerHelp
    case ArchiveHelp
    case InvoiceHelp
    case CalendarHelp
}

class HelpController: UIViewController {
    var homeWireframe:HomeWireframe?
    
    @IBOutlet weak var helpImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
    }
    
    func showWithType(type: HelpType) {
        var image: UIImage!
        
        switch type {
            case .TimerHelp: image = UIImage(named: "help-timer-overlay")
            case .ArchiveHelp: image = UIImage(named: "help-archive-overlay")
            case .InvoiceHelp: image = UIImage(named: "help-invoice-overlay")
            case .CalendarHelp: image = UIImage(named: "help-calendar-overlay")
        }
        
        self.helpImageView.image = image
    }

    @IBAction func dismissHelpScreenTapped(_ sender: Any) {
        //self.dismiss(animated: false, completion: nil)
        self.homeWireframe?.dismissHelpScreen()
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
