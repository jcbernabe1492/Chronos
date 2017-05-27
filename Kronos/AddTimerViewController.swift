//
//  AddTimerViewController.swift
//  Kronos
//
//  Created by Wee, David G. on 9/5/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class AddTimerViewController: UIViewController, AddTimerViewControllerProtocol, AddTimerOutputMethods {
    
    var presenter: AddTimerPresenterProtocol?
    @IBOutlet var addTimerTableView:UITableView?
    @IBOutlet var addTimerTableViewBottom:NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTimerTableView?.delegate = presenter
        addTimerTableView?.dataSource = presenter
        addTimerTableView?.backgroundColor = UIColor.cellBackgroundColor()
        
        view.backgroundColor = UIColor.cellBackgroundColor()
        // Do any additional setup after loading the view.
        presenter?.viewDidLoad()
        presenter?.addTimerPresenterOutput = self
        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: (addTimerTableView?.frame.size.width)! , height: 0.5))
        v.backgroundColor = UIColor.black
        addTimerTableView?.tableFooterView = v
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTable()
    {
        addTimerTableView?.reloadData()
    }
    
    func moveTableView(size:CGFloat, cell:UITableViewCell?)
    {
        if size == 0 || (size > 0 && addTimerTableViewBottom?.constant == 0 )
        {
            addTimerTableViewBottom?.constant = size
            view.setNeedsLayout()
        
            if size > 0
            {
                var aRect = addTimerTableView?.frame
                aRect?.size.height -= size
                guard let point = cell?.frame.origin else { return }
                if(!(aRect?.contains(point))!)
                {
                    let topOfKeyboard = (addTimerTableView?.frame.size.height)!-size
                
                    let scrollPoint = CGPoint(x: 0.0, y: ((cell?.frame.origin.y)! + (cell?.frame.size.height)!)-topOfKeyboard)
                    addTimerTableView?.setContentOffset(scrollPoint, animated: true)
                }
            }
        }
    }
    
    func canSaveTimer() -> Bool {
        return (presenter?.canSaveTimer())!
    }

    
    func endTableEditing()
    {
        addTimerTableView?.endEditing(true)
    }
    
    func showAlertController(alertController: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
