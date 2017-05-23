//
//  CalenderWireframe.swift
//  Kronos
//
//  Created by Wee, David G. on 9/29/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

class CalenderWireframe:NSObject
{
    var calenderViewController:CalenderViewController?
    
    func createCalenderViewController() -> CalenderViewController
    {
        calenderViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalenderViewController") as? CalenderViewController
        return calenderViewController!
    }
    
    
}
