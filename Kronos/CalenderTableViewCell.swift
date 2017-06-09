//
//  CalenderTableViewCell.swift
//  Kronos
//
//  Created by Wee, David G. on 8/26/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class CalenderTableViewCell: UITableViewCell {

    
    @IBOutlet var monday:CalenderButton?
    @IBOutlet var tuesday:CalenderButton?
    @IBOutlet var wednesday:CalenderButton?
    @IBOutlet var thursday:CalenderButton?
    @IBOutlet var friday:CalenderButton?
    @IBOutlet var saturday:CalenderButton?
    @IBOutlet var sunday:CalenderButton?
    var btnArray:Array<CalenderButton>?
    @IBOutlet var stackView:UIStackView?
    
    @IBOutlet var titleLabel:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        
        
        // Initialization code
        btnArray = [monday!, tuesday!, wednesday!, thursday!, friday!, saturday!, sunday!]
        backgroundColor = UIColor.cellBackgroundColor()
        titleLabel?.font = UIFont().normalFont()
        titleLabel?.textColor = UIColor.white
        setupButtons()
        
    }

    @IBAction func buttonClicked(btn:CalenderButton)
    {
        var array = UserDefaults.standard.value(forKey: "calenderDays") as! Array<String>
        
        if array.contains(btn.dayString!)
        {
            let i = array.index(of: "\(btn.dayString!)")
            array.remove(at:i!)
        }
        else
        {
            array.append(btn.dayString!)
        }
        UserDefaults.standard.set(array, forKey: "calenderDays")
        UserDefaults.standard.set(true, forKey: "calenderDaysChanged")
        setupButtons()
    }
    
    func setupButtons()
    {
        let array = UserDefaults.standard.value(forKey: "calenderDays") as! Array<String>
        for btn in btnArray!
        {
            if array.contains(btn.dayString!)
            {
                btn.backgroundColor = UIColor.black
                btn.dayLabel?.textColor = UIColor.white
            }
            else
            {
                btn.backgroundColor = UIColor.white
                btn.dayLabel?.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
            }
        }
    }

    override func layoutSubviews() {
        self.contentView.layoutIfNeeded()

    }
    
    
    
}
