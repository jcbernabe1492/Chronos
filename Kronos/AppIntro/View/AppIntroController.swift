//
//  AppIntroController.swift
//  Kronos
//
//  Created by Jc Bernabe on 26/06/2017.
//  Copyright © 2017 davidwee. All rights reserved.
//

import UIKit

class AppIntroController: UIViewController, UIScrollViewDelegate, IntroViewLastPageDelegate {

    @IBOutlet weak var introScrollView: UIScrollView!
    
    @IBOutlet weak var introPageControl: UIPageControl!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var pageNumber: UILabel!
        
    let viewCount = 5;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTopLabelText(index: 0)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createViews()
    }
    
    func createViews() {
        
        for index in 0..<5 {
            
            var introPage: UIView
    
            if index == 4 {
                introPage = Bundle.main.loadNibNamed("IntroViewLastPage", owner: self, options: nil)?[0] as! UIView
                
                let introLastPage = introPage as! IntroViewLastPage
                introLastPage.delegate = self
            } else {
                introPage = Bundle.main.loadNibNamed("IntroViewPage", owner: self, options: nil)?[0] as! UIView
                
                let introViewPage = introPage as! IntroViewPage
                introViewPage.initWithPage(index: index)
            }
            
            introPage.translatesAutoresizingMaskIntoConstraints = false
            
            introPage.frame = CGRect(x: 0+(UIScreen.main.bounds.size.width*CGFloat(index)), y: 0, width: UIScreen.main.bounds.size.width, height: self.introScrollView.frame.size.height)

            self.introScrollView.addSubview(introPage)
            
            self.introScrollView.addConstraint(NSLayoutConstraint(item: introPage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: introPage.frame.size.width))
            self.introScrollView.addConstraint(NSLayoutConstraint(item: introPage, attribute: .height, relatedBy: .equal, toItem: self.introScrollView, attribute: .height, multiplier: 1, constant: 0))
            self.introScrollView.addConstraint(NSLayoutConstraint(item: introPage, attribute: .top, relatedBy: .equal, toItem: self.introScrollView, attribute: .top, multiplier: 1, constant: 0))
            self.introScrollView.addConstraint(NSLayoutConstraint(item: introPage, attribute: .leading, relatedBy: .equal, toItem: self.introScrollView, attribute: .leading, multiplier: 1, constant: CGFloat(Int(0)+Int(Int(self.introScrollView.frame.size.width)*index))))
        }
        
        self.introScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width*5, height: 1)
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
            text = "INTRO"
//            attributedText = NSMutableAttributedString(string: text.uppercased())
//            let range = (attributedText.string as NSString).range(of: text)
//            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 20)!, range: range)
//            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.topLabel.textColor, range: range)
            
        case 1:
            text = "TRACK TASK TIME"
//            attributedText = NSMutableAttributedString(string: text.uppercased())
//            let range = (attributedText.string as NSString).range(of: text)
//            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 20)!, range: range)
//            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.topLabel.textColor, range: range)
            
        case 2:
            text = ""
//            attributedText = NSMutableAttributedString(string: text.uppercased())
//            let range = (attributedText.string as NSString).range(of: text)
//            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 20)!, range: range)
//            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.topLabel.textColor, range: range)
            
        case 3:
            text = "SETTINGS"
//            attributedText = NSMutableAttributedString(string: text.uppercased())
//            let range = (attributedText.string as NSString).range(of: text)
//            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 20)!, range: range)
//            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.topLabel.textColor, range: range)
            
        case 4:
            text = "MORE INFO"
//            attributedText = NSMutableAttributedString(string: text.uppercased())
//            let range = (attributedText.string as NSString).range(of: text)
//            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 20)!, range: range)
//            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.topLabel.textColor, range: range)
            
//        case 5:
//            text = "Intro Guide\nDefault Rate\n6/8"
//            attributedText = NSMutableAttributedString(string: text.uppercased())
//            let range = (attributedText.string as NSString).range(of: text)
//            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 20)!, range: range)
//            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.topLabel.textColor, range: range)
            
//        case 6:
//            text = "Intro Guide\nInvoice Info\n7/8"
//            attributedText = NSMutableAttributedString(string: text.uppercased())
//            let range = (attributedText.string as NSString).range(of: text)
//            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 20)!, range: range)
//            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.topLabel.textColor, range: range)
            
//        case 7:
//            text = "Intro Guide\nQuick Guide\n2/8"
//            attributedText = NSMutableAttributedString(string: text.uppercased())
//            let range = (attributedText.string as NSString).range(of: text)
//            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 20)!, range: range)
//            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.topLabel.textColor, range: range)
            
//        case 8:
//            text = "Intro Guide\nThanks\n8/8"
//            attributedText = NSMutableAttributedString(string: text.uppercased())
//            let range = (attributedText.string as NSString).range(of: text)
//            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "NeoSans", size: 20)!, range: range)
//            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.topLabel.textColor, range: range)
            
            
        default: break
            //attributedText = NSMutableAttributedString(string: "")
        }
        
        self.topLabel.text = text
        if index != 2 {
            self.pageNumber.text = "\(index+1)/5"
        } else {
            self.pageNumber.text = ""
        }
        
        
        //self.topLabel.attributedText = attributedText
    }
    
    @IBAction func closeIntro(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
// MARK: - Intro View Last Page Delegate
    
    func settingsTapped() {
        HomeWireframe.addHomeControllerOnWindowWithSettingsOn(UIApplication.shared.keyWindow!)
    }
    
    func urlTapped() {
        
    }
    
    func exitTapped() {
//        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
//        
//        if launchedBefore {
//            self.dismiss(animated: true, completion: nil)
//        } else {
            HomeWireframe.addHomeControllerOnWindow(UIApplication.shared.keyWindow!)
//        }
    }
}
