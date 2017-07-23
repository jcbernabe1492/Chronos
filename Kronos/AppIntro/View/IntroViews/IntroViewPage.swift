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
    
//    private func grayTextColor() -> UIColor {
//        return UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
//    }
//    
//    private func generateLargeTypeAttributedString(text: String) -> NSMutableAttributedString {
//        
//        let attributedText = NSMutableAttributedString(string: text)
//        let range = (attributedText.string as NSString).range(of: text as String)
//        attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 18)!, range: range)
//        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: range)
//        
//        return attributedText
//    }
//    
//    private func generateMediumTypeAttributedString(text: String) -> NSMutableAttributedString {
//        
//        let attributedText = NSMutableAttributedString(string: text)
//        let range = (attributedText.string as NSString).range(of: text as String)
//        attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 16)!, range: range)
//        attributedText.addAttribute(NSForegroundColorAttributeName, value: grayTextColor(), range: range)
//        
//        return attributedText
//    }
//    
//    private func generateSmallTypeAttributedString(text: String) -> NSMutableAttributedString {
//        
//        let attributedText = NSMutableAttributedString(string: text)
//        let range = (attributedText.string as NSString).range(of: text as String)
//        attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 13)!, range: range)
//        attributedText.addAttribute(NSForegroundColorAttributeName, value: grayTextColor(), range: range)
//        
//        return attributedText
//    }
//    
//    private func generateDoubleNewLine() -> NSAttributedString {
//        return NSAttributedString(string: "\n\n")
//    }
    
    func initWithPage(index: Int) {
//        var text: NSString!
//        var attributedText: NSMutableAttributedString!
        
        switch index {
        case 0:
//            text = "Hi. This is Chrono.\n\nThe time tracking app designed specifically for remote freelancers and small businesses.\n\nChrono enables you to track the time you spend on your projects, auto calculate your earnings, create invoice, and view your productivity over the month and year.\n\nThis is a quick guide to help you get started using the app."
//            attributedText = NSMutableAttributedString(string: text as String)
//            let range = (attributedText.string as NSString).range(of: text as String)
//            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 16)!, range: range)
//            attributedText.addAttribute(NSForegroundColorAttributeName, value: grayTextColor(), range: range)
            
            self.contentImage.image = UIImage(named: "app-intro-page1")
            
        case 1:
//            text = "To track time straight away:\n\n1. Tap button\n\n2. Tap PROJECT then the symbol to add Project name\n\n3. Tap TASK then the symbol to add Task name\n\n4. Tap SAVE\n\nThis will auto-start the timer specific to the job your working on.\n\nWe recommend that before you use the app you set a few preferences. This will ensure all Chrono features are fully functional. Setting preferences later will not affect any timers you have already created - so it’s best to set these now :)"
//            
//            attributedText = NSMutableAttributedString()
//            
//            attributedText.append(generateLargeTypeAttributedString(text: "To track time straight away:"))
//            attributedText.append(generateDoubleNewLine())
//            attributedText.append(generateMediumTypeAttributedString(text: "1. Tap  "))
//            let addTimerImage = NSTextAttachment()
//            addTimerImage.image = UIImage(named: "icn-add-timer")
//            addTimerImage.bounds = CGRect(x: 0, y: -10, width: 30, height: 30)
//            attributedText.append(NSAttributedString(attachment: addTimerImage))
//            attributedText.append(generateMediumTypeAttributedString(text: "  button"))
//            attributedText.append(generateDoubleNewLine())
//            attributedText.append(generateMediumTypeAttributedString(text: "2. Tap PROJECT then the  "))
//            let projectImage = NSTextAttachment()
//            projectImage.image = UIImage(named: "btn-add")
//            projectImage.bounds = CGRect(x: 0, y: -5, width: 20, height: 20)
//            attributedText.append(NSAttributedString(attachment: projectImage))
//            attributedText.append(generateMediumTypeAttributedString(text: "  symbol to add Project name"))
//            attributedText.append(generateDoubleNewLine())
//            attributedText.append(generateMediumTypeAttributedString(text: "3. Tap TASK then the  "))
//            attributedText.append(NSAttributedString(attachment: projectImage))
//            attributedText.append(generateMediumTypeAttributedString(text: "  symbol to add Task name"))
//            attributedText.append(generateDoubleNewLine())
//            attributedText.append(generateMediumTypeAttributedString(text: "4. Tap SAVE"))
            
            self.contentImage.image = UIImage(named: "app-intro-page2")
            
        case 2:
            self.contentImage.image = UIImage(named: "app-intro-page3")
            
        case 3:
            self.contentImage.image = UIImage(named: "app-intro-page4")
            
        case 4:
            self.contentImage.image = UIImage(named: "app-intro-page5")
            
        case 5:
            self.contentImage.image = UIImage(named: "app-intro-page6")
            
        case 6:
            self.contentImage.image = UIImage(named: "app-intro-page7")
            
        case 7:
            self.fullContentImage.image = UIImage(named: "app-intro-fullpage")
            
        case 8:
            self.contentImage.image = UIImage(named: "app-intro-page8")
            
        default: break
//            text = ""
        }
        
//        self.contentTextView.attributedText = attributedText
    }
}
