//
//  IntroViewPage.swift
//  Kronos
//
//  Created by Jc Bernabe on 02/07/2017.
//  Copyright © 2017 davidwee. All rights reserved.
//

import UIKit


class IntroViewPage: UIView {
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var fullContentImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.contentTextView.backgroundColor = UIColor.clear
        self.contentTextView.textColor = UIColor.white
        
        self.contentTextView.isHidden = true
    }

    func initWithPage(index: Int) {

        switch index {
        case 0:
            self.contentImage.image = UIImage(named: "app-intro-new-page1")
            
        case 1:
            self.contentImage.image = UIImage(named: "app-intro-new-page2")
            
        case 2:
            self.fullContentImage.image = UIImage(named: "app-intro-new-page3")
            
        case 3:
            self.contentImage.image = UIImage(named: "app-intro-new-page4")
            
        case 4:
            self.contentImage.image = UIImage(named: "app-intro-new-page5")
            
//        case 5:
//            self.contentImage.image = UIImage(named: "app-intro-page6")
//            
//        case 6:
//            self.contentImage.image = UIImage(named: "app-intro-page7")
//            
//        case 7:
//            self.fullContentImage.image = UIImage(named: "app-intro-fullpage")
//            
//        case 8:
//            self.contentImage.image = UIImage(named: "app-intro-page8")
            
        default: break
            
        }

    }
}
