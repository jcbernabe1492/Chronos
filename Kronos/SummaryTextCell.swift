//
//  SummaryTextCell.swift
//  Kronos
//
//  Created by Wee, David G. on 10/21/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit
import DatePickerDialog

class SummaryTextCell: UITableViewCell, UITextFieldDelegate {

    
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var textfield:UITextField!
    var invoice:Invoice?
    var table:UITableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.font = UIFont().normalFont()
        titleLabel.textColor = UIColor.white
        textfield.font = UIFont().boldFont()
        textfield.textColor = UIColor.white
        textfield.clearsOnBeginEditing = true
        textfield.autocorrectionType = .no
        textfield.delegate = self
        textfield.returnKeyType = .done
        textfield.enablesReturnKeyAutomatically = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if titleLabel.text == "ISSUE DATE:" || titleLabel.text == "DUE DATE:" {
            DatePickerDialog().show(title: "DatePicker", doneButtonTitle: "Select", cancelButtonTitle: "Cancel", datePickerMode: .date) { (date) -> Void in
                
                if date == nil {
                    textField.text = "--/--/--"
            
                } else {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MM/dd/yy"
                    
                    textField.text = formatter.string(from: date!)
                    
                    self.saveDate()
                }
            }
        }
    }
    
    func saveDate() {
        if self.titleLabel.text == "ISSUE DATE:"
        {
            self.invoice?.issueDate = textfield.text
        }else
        {
            self.invoice?.dueDate = textfield.text
        }
        
        try!  DataController.sharedInstance.managedObjectContext.save()
        table?.reloadData()
        self.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        if textfield.text == ""
        {
            table?.reloadData()
            return
        }
        if titleLabel.text == "REF NO:"
        {
            invoice?.refNumber = textField.text
        }
//        else if titleLabel.text == "ISSUE DATE:" || titleLabel.text == "DUE DATE:"
//        {
//            let calender = Calendar(identifier: .gregorian)
//            let formatter = DateFormatter()
//            formatter.calendar = calender
//            formatter.dateFormat = "MM/dd/yy"
//            let date = formatter.date(from: textField.text!)
//            if date != nil
//            {
//                if titleLabel.text == "ISSUE DATE:"
//                {
//                    invoice?.issueDate = textField.text
//                }else
//                {
//                    invoice?.dueDate = textField.text
//                }
//            }
//        }
        else if titleLabel.text == "OTHER FEES"
        {
            if let num = Double(textField.text!)
            {
                invoice?.otherFees = NSNumber(value:num)
            }
        }
        else if titleLabel.text == "OTHER FEES FOR"
        {
            invoice?.otherFeesFor = textField.text!
        }
        else if titleLabel.text == "TOTAL DUE"
        {
            invoice?.totalDue = NSNumber(value:Double(textField.text!.replacingOccurrences(of: ",", with: ""))!)
        }
        else if titleLabel.text == "CURRENCY" {
            invoice?.currency = textField.text!
        }
        try!  DataController.sharedInstance.managedObjectContext.save()
        table?.reloadData()
        self.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

}
