//
//  AppIntroController.swift
//  Kronos
//
//  Created by Jc Bernabe on 26/06/2017.
//  Copyright © 2017 davidwee. All rights reserved.
//

import UIKit

class AppIntroController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var introScrollView: UIScrollView!
    
    @IBOutlet weak var introPageControl: UIPageControl!
    
    @IBOutlet weak var topLabel: UILabel!
    
    let viewCount = 9;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTopLabelText(index: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        createViews()
    }
    
    func createViews() {
        
        for index in 0..<9 {
            
            let introPage = Bundle.main.loadNibNamed("IntroViewPage", owner: self, options: nil)?[0] as! IntroViewPage
            
            introPage.translatesAutoresizingMaskIntoConstraints = false
            
            introPage.frame = CGRect(x: 0+(UIScreen.main.bounds.size.width*CGFloat(index)), y: 0, width: UIScreen.main.bounds.size.width, height: self.introScrollView.frame.size.height)

            introPage.initWithPage(index: index)
            
            self.introScrollView.addSubview(introPage)
            
            self.introScrollView.addConstraint(NSLayoutConstraint(item: introPage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: introPage.frame.size.width))
            self.introScrollView.addConstraint(NSLayoutConstraint(item: introPage, attribute: .height, relatedBy: .equal, toItem: self.introScrollView, attribute: .height, multiplier: 1, constant: 0))
            self.introScrollView.addConstraint(NSLayoutConstraint(item: introPage, attribute: .top, relatedBy: .equal, toItem: self.introScrollView, attribute: .top, multiplier: 1, constant: 0))
            self.introScrollView.addConstraint(NSLayoutConstraint(item: introPage, attribute: .leading, relatedBy: .equal, toItem: self.introScrollView, attribute: .leading, multiplier: 1, constant: CGFloat(Int(0)+Int(Int(self.introScrollView.frame.size.width)*index))))
        }
        
        self.introScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width*9, height: 1)
        self.introScrollView.delegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.introPageControl.currentPage = Int(pageNumber)
        
        updateTopLabelText(index: Int(pageNumber))
    }

    func updateTopLabelText(index: Int) {
        
//        let fontFamilies = UIFont.familyNames
//        for index in 0..<fontFamilies.count {
//            print(fontFamilies[index])
//            print(UIFont.fontNames(forFamilyName: fontFamilies[index]))
//        }
        
        var attributedText: NSMutableAttributedString!
        var text: String!
        
        
        switch index {
        case 0:
            text = "INTRO\nGUIDE"
            attributedText = NSMutableAttributedString(string: text.uppercased())
            let range = (attributedText.string as NSString).range(of: text)
            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 30)!, range: range)
            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.topLabel.textColor, range: range)
            
        case 1:
            text = "Intro Guide\nQuick Guide\n2/8"
            attributedText = NSMutableAttributedString(string: text.uppercased())
            let range = (attributedText.string as NSString).range(of: text)
            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 20)!, range: range)
            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.topLabel.textColor, range: range)
            
        case 2:
            text = "Intro Guide\nSetup\n3/8"
            attributedText = NSMutableAttributedString(string: text.uppercased())
            let range = (attributedText.string as NSString).range(of: text)
            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 20)!, range: range)
            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.topLabel.textColor, range: range)
            
        case 3:
            text = "Intro Guide\nWorking Day\n4/8"
            attributedText = NSMutableAttributedString(string: text.uppercased())
            let range = (attributedText.string as NSString).range(of: text)
            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 20)!, range: range)
            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.topLabel.textColor, range: range)
            
        case 4:
            text = "Intro Guide\nFee Rares\n5/8"
            attributedText = NSMutableAttributedString(string: text.uppercased())
            let range = (attributedText.string as NSString).range(of: text)
            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 20)!, range: range)
            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.topLabel.textColor, range: range)
            
        case 5:
            text = "Intro Guide\nDefault Rate\n6/8"
            attributedText = NSMutableAttributedString(string: text.uppercased())
            let range = (attributedText.string as NSString).range(of: text)
            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 20)!, range: range)
            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.topLabel.textColor, range: range)
            
        case 6:
            text = "Intro Guide\nInvoice Info\n7/8"
            attributedText = NSMutableAttributedString(string: text.uppercased())
            let range = (attributedText.string as NSString).range(of: text)
            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 20)!, range: range)
            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.topLabel.textColor, range: range)
            
//        case 7:
//            text = "Intro Guide\nQuick Guide\n2/8"
//            attributedText = NSMutableAttributedString(string: text.uppercased())
//            let range = (attributedText.string as NSString).range(of: text)
//            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 20)!, range: range)
//            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.topLabel.textColor, range: range)
            
        case 8:
            text = "Intro Guide\nThanks\n8/8"
            attributedText = NSMutableAttributedString(string: text.uppercased())
            let range = (attributedText.string as NSString).range(of: text)
            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 20)!, range: range)
            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.topLabel.textColor, range: range)
            
            
        default:
            attributedText = NSMutableAttributedString(string: "")
        }
        
        self.topLabel.attributedText = attributedText
    }
    
    @IBAction func closeIntro(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}