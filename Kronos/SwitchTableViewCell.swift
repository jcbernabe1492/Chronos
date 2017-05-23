//
//  SwitchTableViewCell.swift
//  Kronos
//
//  Created by Wee, David G. on 8/26/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel:UILabel?
    @IBOutlet var switchControl:UISwitch?
    @IBOutlet var switcherLabel:UILabel?
    
    @IBOutlet var switcherControl2:UISwitch?
    @IBOutlet var switcherLabel2:UILabel?
    
    var options:NSArray?
    var keys:NSArray?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        backgroundColor = UIColor.cellBackgroundColor()

        titleLabel?.textColor = UIColor.white
        titleLabel?.font = UIFont().normalFont()
        
        switcherLabel?.textColor = UIColor.white
        switcherLabel?.font = UIFont().boldFont()
        switcherLabel2?.textColor = UIColor.white
        switcherLabel2?.font = UIFont().boldFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func swticherClicked()
    {
        if options?.count == 0
        {
            UserDefaults.standard.set(switcherControl2?.isOn, forKey: keys?[0] as! String)
        }
        else
        {
            UserDefaults.standard.set(switcherControl2?.isOn, forKey: keys?[1] as! String)
            UserDefaults.standard.set(switchControl?.isOn, forKey: keys?[0] as! String)
        }
        
        NotificationCenter.default.post(Notification(name: NSNotification.Name("kSettingsChangedNotificaiton")))
    }
    
    func setupSwitch()
    {
        if (options?.count)! > 1
        {
            let value:Bool = (UserDefaults.standard.value(forKey: keys![0] as! String)) as! Bool
            switchControl?.setOn(value, animated: false)
         
            let value2:Bool = (UserDefaults.standard.value(forKey: keys![1] as! String)) as! Bool
            switcherControl2?.setOn(value2, animated: false)
        }
        else
        {
            let value:Bool = (UserDefaults.standard.value(forKey: keys![0] as! String)) as! Bool
        
            switcherControl2?.setOn(value, animated: false)
            
        }
    }

}
