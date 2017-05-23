//
//  AddTimerInteractor.swift
//  Kronos
//
//  Created by Wee, David G. on 9/5/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation

class AddTimerInteractor:NSObject, AddTimerInteractorInput
{
    var presenter: AddTimerPresenterProtocol?
    
    func getCellsForAddTimer() -> NSMutableArray
    {
        let path = Bundle.main.path(forResource: "AddTimerCells", ofType: "plist")
        return NSMutableArray(contentsOfFile: path!)!
    }
    
    func getCellsForExpandable(section:Int) -> NSMutableArray
    {
        let path = Bundle.main.path(forResource: "ExpandableCells", ofType: "plist")
        let array = NSMutableArray(contentsOfFile: path!)!
        return array[section] as! NSMutableArray
    }
    
    func getAllClients() -> NSMutableArray {
        return []
    }
    
    func getAllAgencies() -> NSMutableArray {
        return []
    }
    
    func getAgency(forId id:Int) -> Agency?
    {
        return Agency.getAgency(forId: id)
    }
    
    func getProject(forId id:Int) -> Project
    {
        return Project.getProject(forId: id)!
    }
    
    func getStageTask(forId id:Int) -> StageTask
    {
        return StageTask.getStageTask(forId: id)!
    }
    

    
    
}


