//
//  EnterTextTableViewCell.swift
//  Kronos
//
//  Created by Wee, David G. on 8/26/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class EnterTextTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var textBox:UITextField?
    @IBOutlet var titleLabel:UILabel?
    var options: NSArray?
    var keys: NSArray?
    var section:String?
    var row:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
        
        backgroundColor = UIColor.cellBackgroundColor()

        titleLabel?.textColor = UIColor.white
        titleLabel?.font = UIFont().normalFont()
        textBox?.textColor = UIColor.white
        textBox?.delegate = self
        textBox?.clearsOnBeginEditing = true
        textBox?.returnKeyType = .done
        textBox?.enablesReturnKeyAutomatically = false
        textBox?.font = UIFont().boldFont()
        
        let keyboardDoneButtonView = UIToolbar.init()
        keyboardDoneButtonView.sizeToFit()
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: .done,
                                              target: self,
                                              action: #selector(EnterTextTableViewCell.doneClicked))
        
        keyboardDoneButtonView.items = [doneButton]
        textBox?.inputAccessoryView = keyboardDoneButtonView
        
    
    
    }
    
    func doneClicked()
    {
        textBox?.endEditing(true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupText()
    {
        textBox?.isUserInteractionEnabled = true
        if self.titleLabel?.text == "Default Rate"
        {
            self.textBox?.isUserInteractionEnabled = false
            let num = Int((UserDefaults.standard.value(forKey: keys?[0] as! String) as? String)!)
            
            if num != nil
            {
                let rate = FeeRates.getRateWithId(id: num!)
                textBox?.text = rate.name
            }
            else
            {
                textBox?.text = "SELECT A RATE"
            }
        }
        else
        {
            textBox?.text = UserDefaults.standard.value(forKey: keys?[0] as! String) as? String
        }
        if titleLabel?.text == "Work Hours Per Day"
        {
            textBox?.keyboardType = .decimalPad
        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if keys == nil
        {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
            let documentsDirectory = paths[0] as! String
            let path = documentsDirectory.appending("/Invoices.plist")
            let array = NSMutableArray(contentsOfFile: path)
            
            let sec = array?[0] as! NSMutableDictionary
            let head = sec[section!] as! NSMutableArray
            let cell = head[row!] as! NSMutableDictionary
            
            if (textField.text?.characters.count)! > 0
            {
                cell.setValue(textField.text, forKey: "SUBTITLE")
            }else
            {
                cell.setValue("--", forKey: "SUBTITLE")
            }
         
            array?.write(toFile: path, atomically: true)
        }
        else
        {
            if (textField.text?.characters.count)! > 0
            {
                UserDefaults.standard.set(textBox?.text, forKey: keys?[0] as! String)
            }
            if keys?[0] as! String == "workHoursPerDay"
            {
                NotificationCenter.default.post(Notification(name: NSNotification.Name("kSettingsChangedNotificaiton")))
            }
        }
        if keys != nil{
            textField.text = UserDefaults.standard.value(forKey: keys?[0] as! String) as? String
        }
        
        if titleLabel?.text == "Work Hours Per Day"
        {
            let alert = UIAlertController(title: "Warning", message: "Changes will not effect current or past projects", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: {(alertAction) in
                
            })
            alert.addAction(alertAction)
            UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)


        return true
    }


    

}
