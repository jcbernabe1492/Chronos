//
//  AppIntroController.swift
//  Kronos
//
//  Created by Jc Bernabe on 26/06/2017.
//  Copyright © 2017 davidwee. All rights reserved.
//

import UIKit

class AppIntroController: UIViewController, UIScrollViewDelegate, IntroViewLastPageDelegate, IntroViewSettingsPageDelegate {

    @IBOutlet weak var introScrollView: UIScrollView!
    
    @IBOutlet weak var introPageControl: CHIPageControlAji!
    
    @IBOutlet weak var settingsIcon: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var pageNumber: UILabel!
    
    var introSettingsPage: IntroViewSettingsPage?
    
    var feeRate: FeeRates?
    
    let viewCount = 5;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTopLabelText(index: 0)
        
        settingsIcon.isHidden = true
        
        feeRate = FeeRates.getRateWithId(id: 4)
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
                
            } else if index == 3 {
                
                introPage = Bundle.main.loadNibNamed("IntroViewSettingsPage", owner: self, options: nil)?[0] as! UIView
                
                introSettingsPage = introPage as? IntroViewSettingsPage
                introSettingsPage?.introSettingsPageDelegate = self
                
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
        self.introPageControl.set(progress: Int(pageNumber), animated: true)
        
        updateTopLabelText(index: Int(pageNumber))
    }

    func updateTopLabelText(index: Int) {
        
//        let fontFamilies = UIFont.familyNames
//        for index in 0..<fontFamilies.count {
//            print(fontFamilies[index])
//            print(UIFont.fontNames(forFamilyName: fontFamilies[index]))
//        }
        
        var text: String!
        
        switch index {
        case 0:
            text = "INTRO"
            settingsIcon.isHidden = true
   
        case 1:
            text = "TRACK TASK TIME"
            settingsIcon.isHidden = true
 
        case 2:
            text = ""
            settingsIcon.isHidden = true

        case 3:
            text = "SETTINGS"
            settingsIcon.isHidden = false

        case 4:
            text = "MORE INFO"
            settingsIcon.isHidden = true

        default: break
            
        }
        
        self.topLabel.text = text
        if index != 2 {
            self.pageNumber.text = "\(index+1)/5"
        } else {
            self.pageNumber.text = ""
        }
    }
    
    @IBAction func closeIntro(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
// MARK: - Intro View Last Page Delegate
    
    func settingsTapped() {
        //HomeWireframe.addHomeControllerOnWindowWithSettingsOn(UIApplication.shared.keyWindow!)
    }
    
    func urlTapped() {
        if UIApplication.shared.canOpenURL(URL(string: "https://www.chronoapp.net/")!) {
            UIApplication.shared.openURL(URL(string: "https://www.chronoapp.net/")!)
        }
    }
    
// MARK: - Intro View Settings Page Delegate 
    
    func inputDayRate() {
        let alert = UIAlertController(title: "Enter day rate", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            self.introSettingsPage?.dayRateLabel.text = textField.text
            
            self.feeRate?.fee = NSNumber(value: Int(textField.text!)!)
            try! DataController.sharedInstance.managedObjectContext.save()
        }))
            
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField { (textField) in
            textField.placeholder = "enter here"
            textField.keyboardType = .numberPad
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func inputHours() {
        let alert = UIAlertController(title: "Enter Hours", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            self.introSettingsPage?.hoursLabel.text = textField.text
            
            self.feeRate?.hours = NSNumber(value: Int(textField.text!)!)
            try! DataController.sharedInstance.managedObjectContext.save()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField { (textField) in
            textField.placeholder = "enter here"
            textField.keyboardType = .numberPad
        }
        
        present(alert, animated: true, completion: nil)
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
