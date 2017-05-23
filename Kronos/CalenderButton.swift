//
//  CalenderButton.swift
//  Kronos
//
//  Created by Wee, David G. on 9/1/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class CalenderButton: UIButton {

    @IBInspectable var dayString:String?
    var dayLabel:UILabel?
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.backgroundColor = UIColor.white
        dayLabel = UILabel()
        dayLabel?.translatesAutoresizingMaskIntoConstraints = false
        dayLabel?.text = dayString
        dayLabel?.font = UIFont(name: "NeoSans-Medium", size: 10)
        dayLabel?.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
        addSubview(dayLabel!)
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: dayLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: dayLabel, attribute: .centerY, multiplier: 1.0, constant: -1.0))
    }


    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.size.height/2
        dayLabel?.text = "\(dayString!.characters.first!)"
    }
}
