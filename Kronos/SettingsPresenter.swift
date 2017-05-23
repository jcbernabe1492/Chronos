//
//  SettingsPresenter.swift
//  Kronos
//
//  Created by Wee, David G. on 8/23/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

class SettingsPresenter:NSObject, SettingsPresenterProtocol
{
    var interactor: SettingsInteractorInput?
    var wireframe: SettingsWireframeProtocol?
    
    var settingTableViewPresenter:SettingsTableViewPresenterProtocol?
    var settingsUserGuidePresenter:SettingsUserGuidePresenterProtocol?
    weak var view: SettingsViewControllerProtocol?
    
    func getController() -> UIViewController {
        return (view?.getController())!
    }
    func viewDidLoad() {
        let settingsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsTableViewController") as! SettingsTableViewController
        settingsTableViewController.presenter = SettingsTableViewPresenter()
        settingTableViewPresenter = settingsTableViewController.presenter
        settingTableViewPresenter?.goBackToStartScreen = {() in
            self.goBackToHomeScreen()
        }
        settingTableViewPresenter?.view = settingsTableViewController
        settingTableViewPresenter?.interactor = self.interactor
        settingsTableViewController.presenter?.showTable(identifier: DEFAULTS)
        view?.setTableViewContainerVisibleWith(viewController: settingsTableViewController)
    }
    
    func tabChanged(value:Int) {
        switch value {
        case 0:
            settingTableViewPresenter?.showTable(identifier: DEFAULTS)
            view?.setTableViewContainerVisibleWith(viewController: nil)
            
            break;
        case 1:
            settingTableViewPresenter?.showTable(identifier: INVOICE_INFO)
            view?.setTableViewContainerVisibleWith(viewController: nil)
            break;
        case 2:
            settingTableViewPresenter?.showTable(identifier: FEE_RATES)
            view?.setTableViewContainerVisibleWith(viewController: nil)
            break;
        case 3:
            if settingsUserGuidePresenter != nil
            {
                view?.setUserGuideContainerVisibleWith(viewController: nil)
            }
            else
            {
                let settingsUserGuideViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsUserGuideViewController") as! SettingsUserGuideViewController
                settingsUserGuideViewController.presenter = SettingsUserGuidePresenter()
                settingsUserGuidePresenter = settingsUserGuideViewController.presenter
                settingsUserGuidePresenter?.view = settingsUserGuideViewController
                view?.setUserGuideContainerVisibleWith(viewController: settingsUserGuideViewController)
            }
            break;
        default:
            break;
        }
    }
    

    
    func goBackToHomeScreen()
    {
        ChronoTimer.sharedInstance.appWillClose()
        view?.homeWireframe?.viewController?.dismiss(animated: true, completion: nil)
    }
    
    
}

extension SettingsPresenter : SettingsInteractorOutput
{
    
}
