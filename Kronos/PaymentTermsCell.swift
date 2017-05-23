//
//  PaymentTermsCell.swift
//  Kronos
//
//  Created by Wee, David G. on 2/12/17.
//  Copyright © 2017 davidwee. All rights reserved.
//

import UIKit

class PaymentTermsCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet var title:UILabel!
    @IBOutlet var textField:UITextView!
    var section:String?
    var row:Int?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.cellBackgroundColor()
        
        title.text = "PAYMENT TERMS AND CONDITIONS"
        title.font = UIFont().normalFont()
        title.textColor = UIColor.white
        
        textField.delegate = self
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = false
        textField.font = UIFont().boldFont()
        textField.textColor = UIColor.white
        textField.backgroundColor = backgroundColor

        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "--" {
            textView.text = ""
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textField.endEditing(true)

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

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textField.endEditing(true)
        return true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textField.endEditing(true)
            return false
        }
        return true
    }
    
}
