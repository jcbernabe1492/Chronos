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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
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
