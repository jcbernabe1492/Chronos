//
//  AddTimerEnterTextCell.swift
//  Kronos
//
//  Created by Wee, David G. on 9/5/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class AddTimerEnterTextCell: UITableViewCell, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet var title:UILabel?
    @IBOutlet var enterText:UITextField?
    var presenter : AddTimerPresenter?
    var tableData:NSMutableArray?
    var row:Int?
    var picker:UIPickerView?
    var tempText:String?
    var fromOtherModule:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        enterText?.font = UIFont().boldFont()
        enterText?.textColor = UIColor.white

        title?.font = UIFont().normalFont()
        title?.textColor = enterText?.textColor
        setupIfNeeded()
    }

    func setupIfNeeded()
    {
        enterText?.enablesReturnKeyAutomatically = false
        enterText?.returnKeyType = .done
        enterText?.delegate = self
    }
    
    func setUpPicker()
    {
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width:  UIScreen.main.bounds.width, height: 270))
        picker?.dataSource = self
        picker?.delegate = self
        picker?.backgroundColor = UIColor.white
        enterText?.inputView = picker
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textFieldDidEndEditing(_ textField: UITextField) {

        if textField.text?.characters.count == 0
        {
            textField.text = tempText
        }
        if !fromOtherModule
        {
            if textField.text == "REQUIRED"
            {
                textField.textColor = UIColor.red
            }
        
            if textField.inputView is UIPickerView
            {
                textField.text = "\(String(format: "%02d", (picker?.selectedRow(inComponent: 0))! + 1))"
                textField.textColor = UIColor.white
            }
            (tableData?[row!] as! NSMutableDictionary).setValue(enterText?.text, forKey: "TEXT")
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        presenter?.selectedTableView(cell: self)
        textField.textColor = UIColor.white
        tempText = textField.text
        textField.text = ""
        if textField.inputView is UIPickerView
        {
            let touchView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 270))
            touchView.backgroundColor = UIColor.clear
            let tap = UITapGestureRecognizer(target: self, action: #selector(AddTimerEnterTextCell.closePicker(tap:)))
            touchView.addGestureRecognizer(tap)
            window?.addSubview(touchView)
        }
    }
    
    func setKeyboardNumeric()
    {
        enterText?.keyboardType = .decimalPad
            let keyboardToolbar = UIToolbar()
            keyboardToolbar.sizeToFit()
            let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                target: nil, action: nil)
            let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                                target: self, action: #selector(AddTimerEnterTextCell.doneClicked))
            keyboardToolbar.items = [flexBarButton, doneBarButton]
            enterText?.inputAccessoryView = keyboardToolbar

        
    }
    
    func setKeyboardCharacters()
    {
        enterText?.keyboardType = .default
        enterText?.inputAccessoryView = nil
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 99
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return String(format: "%02d", row+1)
    }

    func closePicker(tap:UITapGestureRecognizer)
    {
        tap.view?.removeFromSuperview()
        self.endEditing(true)
    }
    
    

    
    func doneClicked()
    {
        self.endEditing(true)
    }

    
    
    

}
