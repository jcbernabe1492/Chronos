//
//  SettingsProtocols.swift
//  Kronos
//
//  Created by Wee, David G. on 8/23/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit
protocol SettingsWireframeProtocol : class {
}

protocol SettingsPresenterProtocol : class {
    var interactor: SettingsInteractorInput? { get set }
    var wireframe: SettingsWireframeProtocol? { get set }
    func viewDidLoad()
    weak var view: SettingsViewControllerProtocol? { get set }
    func tabChanged(value:Int)
    func getController() -> UIViewController
    
}

protocol SettingsInteractorInput : class {
    weak var presenter: SettingsInteractorOutput? { get set }
    func getDefaultCells() -> NSArray
    func getInvoiceCells() -> NSArray
}

protocol SettingsInteractorOutput : class {
    
}

protocol SettingsViewControllerProtocol : class {
    var presenter: SettingsPresenterProtocol? { get set }
    var tableViewContainer: UIView? {get set}
  
    func setTableViewContainerVisibleWith(viewController:SettingsTableViewController?)
    func setUserGuideContainerVisibleWith(viewController:SettingsUserGuideViewController?)
    var homeWireframe:HomeWireframe? {get set}
    func tabChanged(value:Int)
    func getController() -> UIViewController
}


protocol SettingsTableViewPresenterProtocol : class, UITableViewDelegate, UITableViewDataSource {
    var interactor : SettingsInteractorInput? { get set }
    var wireframe : SettingsWireframeProtocol? {get set }
    var view : SettingsTableViewProtocol? {get set}
    var goBackToStartScreen : () -> ()? {get set}
    func showTable(identifier:String)
    func getController() -> UIViewController

  
}

protocol SettingsTableViewProtocol : class {
    var presenter: SettingsTableViewPresenterProtocol? { get set}
    func reloadTable()
    func keyboardWasShown(insets:UIEdgeInsets)
    func keyboardWasHidden()
   func getController() -> UIViewController 
}

protocol SettingsUserGuideViewControllerDelegate: class {
    func showIntroGuide()
}

protocol SettingsUserGuidePresenterProtocol : class {
    var interactor : SettingsInteractorInput? { get set }
    var wireframe : SettingsWireframeProtocol? {get set }
    var view : SettingsUserGuideProtocol? {get set}
    
    func selected(tab:Int)
    func viewDidLoad()
    
}
protocol SettingsUserGuideProtocol : class {
    var presenter: SettingsUserGuidePresenterProtocol? { get set}
    func setScrollViewImage(image:UIImage)
}
