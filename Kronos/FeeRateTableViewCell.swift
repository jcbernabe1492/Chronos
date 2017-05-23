//
//  FeeRateTableViewCell.swift
//  Kronos
//
//  Created by Wee, David G. on 8/26/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class FeeRateTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var titleLabel: UITextField?
    @IBOutlet var feeLabel: UITextField?
    @IBOutlet var hoursToRateLabel:UITextField?
    var section:Int?
    var row:Int?
    var feeRate:FeeRates?
    var presenter:UIViewController?
    var acceptHoursLabelInput = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.cellBackgroundColor()
        titleLabel?.font = UIFont().normalFont()
        titleLabel?.textColor = UIColor.white
        titleLabel?.delegate = self
        titleLabel?.returnKeyType = .done
        titleLabel?.clearsOnBeginEditing = true
        titleLabel?.enablesReturnKeyAutomatically = false
        hoursToRateLabel?.delegate = self
        hoursToRateLabel?.returnKeyType = .done
        hoursToRateLabel?.enablesReturnKeyAutomatically = false

        hoursToRateLabel?.clearsOnBeginEditing = true
        feeLabel?.delegate = self
        feeLabel?.returnKeyType = .done
        feeLabel?.enablesReturnKeyAutomatically = false
        feeLabel?.clearsOnBeginEditing = true
        
        feeLabel?.font = UIFont().normalFont()
        feeLabel?.textColor = UIColor.white
        feeLabel?.keyboardType = .decimalPad
        
        
        hoursToRateLabel?.font = UIFont().normalFont()
        hoursToRateLabel?.textColor = UIColor.white
        hoursToRateLabel?.keyboardType = .decimalPad
        
        let keyboardDoneButtonView = UIToolbar.init()
        keyboardDoneButtonView.sizeToFit()
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: .done,
                                              target: self,
                                              action: #selector(FeeRateTableViewCell.doneClicked))
        
        keyboardDoneButtonView.items = [doneButton]
        hoursToRateLabel?.inputAccessoryView = keyboardDoneButtonView
        feeLabel?.inputAccessoryView = keyboardDoneButtonView
        
        
    }

    func doneClicked()
    {
        feeLabel?.endEditing(true)
        hoursToRateLabel?.endEditing(true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text == "" || textField.text == nil
        {
            (presenter as! SettingsTableViewController).reloadTable()
            return
        }
        if textField == hoursToRateLabel
        {
            feeRate?.hours = NSNumber(value: Int(textField.text!)!)
        }
        else
        {
            if titleLabel?.text?.characters.count != 0
            {
                feeRate?.name = titleLabel?.text
            }
            if feeLabel?.text?.characters.count != 0
            {
                let num = Double((feeLabel?.text)!)
                if num != nil
                {
                    feeRate?.fee = NSNumber(value: num!)
                }
            }
        }
        try! DataController.sharedInstance.managedObjectContext.save()
        (presenter as! SettingsTableViewController).reloadTable()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    @IBAction func changeTimeInterval()
    {
        self.feeRate?.timeInterval = "HOURS"
        try! DataController.sharedInstance.managedObjectContext.save()
    }
    
    func setEnabled(_ enabled:Bool)
    {
        self.titleLabel?.isUserInteractionEnabled = !enabled
        self.feeLabel?.isUserInteractionEnabled = !enabled
        self.hoursToRateLabel?.isUserInteractionEnabled = !enabled
        if self.titleLabel?.text == "15 MIN RATE" || self.titleLabel?.text == "HOURLY RATE"
        {
            self.hoursToRateLabel?.isUserInteractionEnabled = false
            self.hoursToRateLabel?.alpha = 0.6
        }
    }
    
}
