//
//  SettingInteractor.swift
//  Kronos
//
//  Created by Wee, David G. on 8/23/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation

class SettingsInteractor: NSObject, SettingsInteractorInput
{
    weak var presenter: SettingsInteractorOutput? 
    
    
    
    
    
    //Getting Cells From plists
    func getDefaultCells() -> NSArray {
        let filePath = Bundle.main.url(forResource: "Defaults", withExtension: "plist")
        let array = NSArray(contentsOf: filePath!)! as NSArray
        return array
    }
    
    
    func getInvoiceCells() -> NSArray {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.appending("/Invoices.plist")
        let array = NSArray(contentsOfFile: path)
        return array!
    }
}


