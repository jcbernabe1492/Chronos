//
//  LoadTimerProtocols.swift
//  Kronos
//
//  Created by Wee, David G. on 9/12/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

protocol LoadTimerInteractorProtocol:class
{
    var presenter:LoadTimerPresenterProtocol? {get set}
    func getAllCurrentJobTimers() -> NSMutableArray
    func getAllProjects() -> NSMutableArray
    func getClientForId(id:Int) -> Agency?
    func getProjectForId(id:Int) -> Project
    func delete(jobs:NSMutableArray)
    func getRecentTasks() -> NSMutableArray
    func getAllTasksForProject(id:Int) -> NSMutableArray
}

protocol  LoadTImerWireframeProtocol: class
{
    func closeWithNewProjectSelected(id:NSNumber)
    func close()
    func showOnScreen(view:UIView)
}

protocol LoadTimerPresenterProtocol: class, UITableViewDelegate, UITableViewDataSource
{
    var view:LoadTimerViewControllerProtocol? {get set}
    var interactor:LoadTimerInteractorProtocol? {get set}
    var wireframe:LoadTImerWireframeProtocol? {get set}
    func viewDidLoad()
    func reloadData(tab:TAB)
    func editingPressed(editing:Bool)
    func trashButtonClicked()


}
protocol EditProjectPresenterProtocol : class, UITableViewDelegate, UITableViewDataSource {
    var view:UITableView? {get set}
}

protocol LoadTimerViewControllerProtocol: class
{
    var presenter:LoadTimerPresenterProtocol? {get set}
    var selected:TAB? {get set}
    func itemsDeleted()
    func tableViewCells() -> NSMutableArray!
    func showEditProject(index:IndexPath, view:UITableView)
    func tasksSelected()
    func reloadTable()
    func hideButtons(active:Bool)
    func editingPressed()
    func moveTable(up:Bool, keyboardSize:CGFloat)
}
    
