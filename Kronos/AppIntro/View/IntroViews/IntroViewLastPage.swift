//
//  IntroViewLastPage.swift
//  Kronos
//
//  Created by Jc Bernabe on 24/07/2017.
//  Copyright © 2017 davidwee. All rights reserved.
//

import Foundation
import UIKit

protocol IntroViewLastPageDelegate: class {
    func settingsTapped()
    func urlTapped()
    func exitTapped()
}

class IntroViewLastPage: UIView {
    
    weak var delegate: IntroViewLastPageDelegate?
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        //12 16 16 15
        
        if UIScreen.main.bounds.size.height > 568 {
            firstLabel.font = firstLabel.font.withSize(15)
            secondLabel.font = secondLabel.font.withSize(16)
            
            thirdLabel.font = thirdLabel.font.withSize(16)
            fourthLabel.font = fourthLabel.font.withSize(15)
        }
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        delegate?.settingsTapped()
    }
    
    @IBAction func urlButtonPressed(_ sender: Any) {
        delegate?.urlTapped()
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        delegate?.exitTapped()
    }
}
