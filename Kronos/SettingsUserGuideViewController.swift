//
//  SettingsUserGuideViewController.swift
//  Kronos
//
//  Created by Wee, David G. on 8/25/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class SettingsUserGuideViewController: UIViewController, SettingsUserGuideProtocol, UIScrollViewDelegate {

    var presenter: SettingsUserGuidePresenterProtocol?
    @IBOutlet var scrollViewImage:UIImageView?
    @IBOutlet var firstBtn:UIButton?
    @IBOutlet var scrollView:UIScrollView?
    @IBOutlet var imageViewHeight:NSLayoutConstraint?
    var selectedTab:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedTab = firstBtn
        presenter?.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tabButtonPressed(btn:UIButton)
    {
        if  selectedTab?.tag == btn.tag {
            return 
        }
        selectedTab?.backgroundColor = UIColor.tableHeaderColor()
        selectedTab = btn
        btn.backgroundColor = UIColor.tabSelectedYellow()
        presenter?.selected(tab: btn.tag)
    }
    
    func setScrollViewImage(image: UIImage) {
        scrollView?.scrollToTop()
        scrollViewImage?.image = image

    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollViewImage
    }

}
