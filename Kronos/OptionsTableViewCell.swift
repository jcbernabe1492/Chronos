//
//  OptionsTableViewCell.swift
//  Kronos
//
//  Created by Wee, David G. on 8/26/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {

    @IBOutlet var option1 : UILabel?
    @IBOutlet var option2 : UILabel?
    @IBOutlet var option3 : UILabel?
    @IBOutlet var option4 : UILabel?
    @IBOutlet var option5 : UILabel?
    @IBOutlet var titleLabel : UILabel?
    var optionArray : Array<UILabel>?
    var options: NSArray?
    var keys: NSArray?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
        
        backgroundColor = UIColor.cellBackgroundColor()
      
        titleLabel?.textColor = UIColor.white
        titleLabel?.font = UIFont().normalFont()
       
        option1?.textColor = UIColor.white

        option1?.isUserInteractionEnabled = true
        let option1Tap = UITapGestureRecognizer(target: self, action: #selector(OptionsTableViewCell.labelSelected(tap:)))
        option1?.addGestureRecognizer(option1Tap)
        option1?.font = UIFont().boldFont()
       
        option2?.textColor = UIColor.white
        option2?.isUserInteractionEnabled = true
        let option2Tap = UITapGestureRecognizer(target: self, action: #selector(OptionsTableViewCell.labelSelected(tap:)))
        option2?.addGestureRecognizer(option2Tap)
        option2?.font = UIFont().boldFont()
        
        option3?.textColor = UIColor.white
        option3?.isUserInteractionEnabled = true
        let option3Tap = UITapGestureRecognizer(target: self, action: #selector(OptionsTableViewCell.labelSelected(tap:)))
        option3?.addGestureRecognizer(option3Tap)
        option3?.font = UIFont().boldFont()
        
        option4?.textColor = UIColor.white
        option4?.isUserInteractionEnabled = true
        let option4Tap = UITapGestureRecognizer(target: self, action: #selector(OptionsTableViewCell.labelSelected(tap:)))
        option4?.addGestureRecognizer(option4Tap)
        option4?.font = UIFont().boldFont()
        
        option5?.textColor = UIColor.white
        option5?.isUserInteractionEnabled = true
        let option5Tap = UITapGestureRecognizer(target: self, action: #selector(OptionsTableViewCell.labelSelected(tap:)))
        option5?.addGestureRecognizer(option5Tap)
        option5?.font = UIFont().boldFont()
        
        
        optionArray = [option5!, option4!, option3!, option2!, option1!]


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func labelSelected(tap:UITapGestureRecognizer)
    {
        for label in optionArray!
        {
            label.backgroundColor = UIColor.clear
        }
        (tap.view as! UILabel).backgroundColor = UIColor(red: 34/255, green: 31/255, blue: 31/255, alpha: 1.0)
        UserDefaults.standard.set((tap.view as! UILabel).text!, forKey: keys![0] as! String)
        
        if keys![0] as? String == "timerDaysBackgroundColor" || keys![0] as? String == "timerNumberVisability"
        {
            NotificationCenter.default.post(Notification(name: NSNotification.Name("kSettingsChangedNotificaiton")))
        }
        
    }
    
    func setupCell()
    {
        var count = 0
        for opt in options!
        {
            optionArray?[count].text = "  \(opt as! String)  "
            optionArray?[count].isHidden = false
            if optionArray?[count].text?.replacingOccurrences(of: " ", with: "") == (UserDefaults.standard.value(forKey: keys![0] as! String) as? String)?.replacingOccurrences(of: " ", with: "")
            {
                optionArray?[count].backgroundColor = UIColor(red: 34/255, green: 31/255, blue: 31/255, alpha: 1.0)
            }
            else
            {
                optionArray?[count].backgroundColor = UIColor.clear
            }
             count = count + 1
        }
        if count < (optionArray?.count)!
        {
            for i in count...(optionArray?.count)!-1
            {
                optionArray?[i].isHidden = true
            }
        }
        
    }
    

   
    
}
