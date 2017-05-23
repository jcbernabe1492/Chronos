//
//  ColorPickerTableViewCell.swift
//  Kronos
//
//  Created by Wee, David G. on 8/26/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class ColorPickerTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel:UILabel?
    @IBOutlet var btn1:UIButton?
    @IBOutlet var btn2:UIButton?
    @IBOutlet var btn3:UIButton?
    @IBOutlet var btn4:UIButton?
    @IBOutlet var btn5:UIButton?
    @IBOutlet var btn6:UIButton?
    @IBOutlet var btn7:UIButton?
    @IBOutlet var btn8:UIButton?
    @IBOutlet var btn9:UIButton?
    @IBOutlet var btn10:UIButton?
    var btnArray:Array<UIButton>?
    var tempColor:UIColor?
    var tempBtn:UIButton?

    var keys:NSArray?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
        
       // self.clipsToBounds = true
        backgroundColor = UIColor.cellBackgroundColor()
     
        titleLabel?.textColor = UIColor.white
        titleLabel?.font = UIFont().normalFont()
        btnArray = [btn1!, btn2!, btn3!, btn4!, btn5!, btn6!, btn7!, btn8!, btn9!, btn10!]
        var count = 0
        for btn in btnArray!
        {
            btn.backgroundColor = UIColor.colorPickerArray()[(btn.tag)-1]
            btn.layer.masksToBounds = true
            
            btn.backgroundColor = UIColor.colorPickerArray()[count]
            count = count + 1
        }

        
    }


    @IBAction func colorSelected(btn:UIButton)
    {
        tempBtn?.backgroundColor = tempColor
        for v in (tempBtn?.subviews)!
        {
            if v.tag == 5
            {
                v.removeFromSuperview()
            }
        }
        tempBtn = btn
        tempColor = btn.backgroundColor
        
        UserDefaults.standard.setColor(btn.backgroundColor!, forKey: keys?[0] as! String)
        NotificationCenter.default.post(Notification(name: NSNotification.Name("kSettingsChangedNotificaiton")))
        let i = UIImageView(image: UIImage(named: "img-colored-selected"))
        i.translatesAutoresizingMaskIntoConstraints = false
        btn.addSubview(i)
        btn.addConstraint(NSLayoutConstraint(item: btn, attribute: .centerX, relatedBy: .equal, toItem: i, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        btn.addConstraint(NSLayoutConstraint(item: btn, attribute: .centerY, relatedBy: .equal, toItem: i, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        btn.addConstraint(NSLayoutConstraint(item: btn, attribute: .width, relatedBy: .equal, toItem: i, attribute: .width, multiplier: 0.6, constant: 0.0))
        btn.addConstraint(NSLayoutConstraint(item: btn, attribute: .height, relatedBy: .equal, toItem: i, attribute: .height, multiplier: 0.6, constant: 0.0))
        i.tag = 5
        btn.clipsToBounds = false
        
    }
    
    func setupColors()
    {
        if keys != nil
        {
            let color = UserDefaults.standard.colorForKey(keys?[0] as! String)
            for btn in btnArray!
            {
                if btn.backgroundColor?.description == color?.description
                {
                    let i = UIImageView(image: UIImage(named: "img-colored-selected"))
                    i.translatesAutoresizingMaskIntoConstraints = false
                    btn.addSubview(i)
                    btn.addConstraint(NSLayoutConstraint(item: btn, attribute: .centerX, relatedBy: .equal, toItem: i, attribute: .centerX, multiplier: 1.0, constant: 0.0))
                    btn.addConstraint(NSLayoutConstraint(item: btn, attribute: .centerY, relatedBy: .equal, toItem: i, attribute: .centerY, multiplier: 1.0, constant: 0.0))
                    btn.addConstraint(NSLayoutConstraint(item: btn, attribute: .width, relatedBy: .equal, toItem: i, attribute: .width, multiplier: 0.6, constant: 0.0))
                    btn.addConstraint(NSLayoutConstraint(item: btn, attribute: .height, relatedBy: .equal, toItem: i, attribute: .height, multiplier: 0.6, constant: 0.0))
                    i.tag = 5
                    btn.clipsToBounds = false
                    tempBtn = btn
                    tempColor = btn.backgroundColor

                }
            }
        }
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        for btn in btnArray!
        {
            btn.layer.cornerRadius = (btn.frame.size.height)/2
        }
    }

    

    
}
