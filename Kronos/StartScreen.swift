//
//  StartScreen.swift
//  Kronos
//
//  Created by Wee, David G. on 8/23/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class StartScreen: UIViewController {

    
    @IBOutlet var customizeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeView.layer.borderColor = UIColor.white.cgColor
        customizeView.layer.borderWidth = 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(StartScreen.didTouchScreen))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTouchScreen()
    {
        HomeWireframe.addHomeControllerOnWindow(UIApplication.shared.keyWindow!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
