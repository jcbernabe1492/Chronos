//
//  IntroViewSettingsPage.swift
//  Kronos
//
//  Created by John Christopher Bernabe on 13/08/2017.
//  Copyright © 2017 davidwee. All rights reserved.
//

import UIKit

protocol IntroViewSettingsPageDelegate: class {
    func inputDayRate()
    func inputHours()
}

class IntroViewSettingsPage: UIView {
    
    weak var introSettingsPageDelegate: IntroViewSettingsPageDelegate?
    
    @IBOutlet weak var dayRateHolder: UIView!
    @IBOutlet weak var hoursHolder: UIView!
    
    @IBOutlet weak var dayRateLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    @IBOutlet weak var sixthLabel: UILabel!
    @IBOutlet weak var seventhLabel: UILabel!
    @IBOutlet weak var eigthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        
        dayRateHolder.layer.borderColor = UIColor(red: 68/255, green: 65/255, blue: 66/255, alpha: 1.0).cgColor
        dayRateHolder.layer.borderWidth = 1.0
        hoursHolder.layer.borderColor = UIColor(red: 68/255, green: 65/255, blue: 66/255, alpha: 1.0).cgColor
        hoursHolder.layer.borderWidth = 1.0
        
        dayRateHolder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(inputDayRate)))
        dayRateHolder.isUserInteractionEnabled = true
        hoursHolder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(inputHours)))
        hoursHolder.isUserInteractionEnabled = true
        
        adjustFontSizes()
    }

    func adjustFontSizes() {
        if UIScreen.main.bounds.size.height > 568 {
            firstLabel.font = firstLabel.font.withSize(13)
            secondLabel.font = secondLabel.font.withSize(15)
            thirdLabel.font = thirdLabel.font.withSize(13)
            fourthLabel.font = fourthLabel.font.withSize(13)
            fifthLabel.font = fifthLabel.font.withSize(15)
            sixthLabel.font = sixthLabel.font.withSize(13)
            seventhLabel.font = seventhLabel.font.withSize(15)
            eigthLabel.font = eigthLabel.font.withSize(13)
        }
    }
    
    func inputDayRate() {
        introSettingsPageDelegate?.inputDayRate()
    }
    
    func inputHours() {
        introSettingsPageDelegate?.inputHours()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
