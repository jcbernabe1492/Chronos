//
//  SettingsWireframe.swift
//  Kronos
//
//  Created by Wee, David G. on 8/23/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

class SettingsWireframe:NSObject, SettingsWireframeProtocol
{
    
    weak var viewController:SettingsViewController?
    
    var homeWireFrame:HomeWireframe?
    
    class func createSettingsView() -> SettingsViewController
    {
        let wireframe = SettingsWireframe()
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsView") as! SettingsViewController
        let presenter = SettingsPresenter()
        let interactor = SettingsInteractor()
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        presenter.view = view
        interactor.presenter = presenter
        
        wireframe.viewController = view
        wireframe.viewController?.modalTransitionStyle = .flipHorizontal
        return wireframe.viewController!
    }

    

    
    
}
