//
//  AddTimerProtocol.swift
//  Kronos
//
//  Created by Wee, David G. on 9/5/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

protocol AddTimerViewControllerProtocol : class {
    var presenter:AddTimerPresenterProtocol? {get set}
    func  reloadTable()
    func moveTableView(size:CGFloat, cell:UITableViewCell?)
    func canSaveTimer() -> Bool
    func endTableEditing()
}

protocol AddTimerInteractorInput : class {
    weak var presenter: AddTimerPresenterProtocol? { get set }
    func getCellsForAddTimer() -> NSMutableArray
    func getCellsForExpandable(section:Int) -> NSMutableArray
    func getAllClients() -> NSMutableArray
    func getAllAgencies() -> NSMutableArray
    func getAgency(forId id:Int) -> Agency?
    func getProject(forId id:Int) -> Project
    func getStageTask(forId id:Int) -> StageTask
}

protocol AddTimerPresenterProtocol : class, UITableViewDataSource, UITableViewDelegate {
    var interactor: AddTimerInteractorInput? { get set }
    var wireframe: AddTimerWireframeProtocol? { get set }
     weak var view: AddTimerViewControllerProtocol? { get set }
    
    weak var addTimerPresenterOutput: AddTimerOutputMethods? { get set }
    
    func viewDidLoad()
    func expandToItem(cell:ExpandableItem)
    func selectedTableView(cell:UITableViewCell)
    func canSaveTimer() -> Bool
}

protocol AddTimerWireframeProtocol : class  {
    func animateAddTimerScreen(visible:Bool)
    func closeTimer()
    func getHomeViewController() -> HomeViewController
    func canSaveTimer() -> Bool
    
}

protocol AddTimerOutputMethods : class {
    func showAlertController(alertController: UIAlertController)
}
