//
//  SettingsUserGuidePresenter.swift
//  Kronos
//
//  Created by Wee, David G. on 8/25/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

class SettingsUserGuidePresenter : NSObject, SettingsUserGuidePresenterProtocol
{
    var interactor: SettingsInteractorInput?
    var wireframe: SettingsWireframeProtocol?
    var view: SettingsUserGuideProtocol?
    
    
    func viewDidLoad()
    {
        view?.setScrollViewImage(image: UIImage(named: "img-versions")!)
        
    }
    
    func selected(tab: Int) {
        switch tab{
        case 1:
             view?.setScrollViewImage(image: UIImage(named: "img-versions")!)
            break
        case 2:
            if UIScreen().isiPhone6() || UIScreen().isiPhone6Plus()
            {
                view?.setScrollViewImage(image: UIImage(named: "img-timer")!)
            }
            else
            {
                view?.setScrollViewImage(image: UIImage(named: "img-timer-5")!)
            }
            break
        case 3:
            if UIScreen().isiPhone6Plus()
            {
                view?.setScrollViewImage(image: UIImage(named: "img-calender-6-plus")!)
            }
            else if UIScreen().isiPhone6()
            {
                view?.setScrollViewImage(image: UIImage(named: "img-calender-6")!)
            }
            else
            {
                view?.setScrollViewImage(image: UIImage(named: "img-calender-5")!)
            }
            break
        case 4:
            if UIScreen().isiPhone6Plus()
            {
                view?.setScrollViewImage(image: UIImage(named: "img-invoices-6-plus")!)
            }
            else if UIScreen().isiPhone6()
            {
                view?.setScrollViewImage(image: UIImage(named: "img-invoices-6")!)
            }
            else
            {
                view?.setScrollViewImage(image: UIImage(named: "img-invoices-5")!)
            }
            break
        case 5:
            if UIScreen().isiPhone6Plus()
            {
                view?.setScrollViewImage(image: UIImage(named: "img-archive-6-plus")!)
            }
            else if UIScreen().isiPhone6()
            {
                view?.setScrollViewImage(image: UIImage(named: "img-archive-6")!)
            }
            else
            {
                view?.setScrollViewImage(image: UIImage(named: "img-archive-5")!)
            }
            break
        default:
            break
        }
    }
}
