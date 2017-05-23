//
//  SettingsTableViewPresenter.swift
//  Kronos
//
//  Created by Wee, David G. on 8/25/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MessageUI

let DEFAULTS = "defaults"
let INVOICE_INFO = "invoiceInfo"
let FEE_RATES = "feerates"

class SettingsTableViewPresenter : NSObject, SettingsTableViewPresenterProtocol, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var wireframe: SettingsWireframeProtocol?
    var view: SettingsTableViewProtocol?
    var interactor: SettingsInteractorInput?
    var tableIdentifier:String?
    var tableDataDict:NSDictionary?
    var sectionCounter:NSArray?
    var cells:NSArray?
    let imagePicker = UIImagePickerController()
    var selectFee:Bool = false
    
    
    override init()
    {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsTableViewPresenter.keyboardWillShow(notif:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(SettingsTableViewPresenter.keyboardWillHide(notif:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    var goBackToStartScreen: () -> ()? = {() in
        return
    }

    func getController() -> UIViewController {
        return (view?.getController())!
    }
    func keyboardWillShow(notif:NSNotification)
    {
        let info = notif.userInfo
        let kbSize = (info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        view?.keyboardWasShown(insets: contentInsets)
    }
    
    func keyboardWillHide(notif:NSNotification)
    {
        view?.keyboardWasHidden()
    }
    
    func showTable(identifier: String) {
        tableIdentifier = identifier
        imagePicker.delegate = self
        
        if tableIdentifier == DEFAULTS
        {
            let array = interactor?.getDefaultCells()
            tableDataDict = array?[0] as? NSDictionary
            sectionCounter = array?[1] as? NSArray


        }
        else if tableIdentifier == INVOICE_INFO
        {
            let array = interactor?.getInvoiceCells()
            tableDataDict = array?[0] as? NSDictionary
            sectionCounter = array?[1] as? NSArray
        }
        else
        {
            
        }
      
        view?.reloadTable()
    }
    //MARK: - UITableViewDelegate & DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableIdentifier == FEE_RATES
        {
            return 2
        }
        return ((tableDataDict?.allKeys.count))!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableIdentifier == FEE_RATES
        {
            if section == 0
            {
                return FeeRates.getDefaultRates().count
            }
            if selectFee
            {
                return FeeRates.getCustomRates().count - 1
            }
            return FeeRates.getCustomRates().count + 1
        }
        let key = sectionCounter?[section]
        cells = tableDataDict?[key!] as? NSArray
        return cells!.count
    }
    
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        let key = sectionCounter?[indexPath.section]
        cells = tableDataDict?[key!] as? NSArray
        if tableIdentifier == DEFAULTS
        {
            let cellType = (cells?[indexPath.row] as! NSDictionary).value(forKey: "TYPE") as! String
            cell = tableView.dequeueReusableCell(withIdentifier: cellType)
            
            if cellType == "TEXT"
            {
                (cell as! TextTableViewCell).textLabel?.text = (cells?[indexPath.row] as! NSDictionary).value(forKey: "TITLE") as? String
            }
            else if cellType == "ENTER_TEXT"
            {
                (cell as! EnterTextTableViewCell).titleLabel?.text = (cells?[indexPath.row] as! NSDictionary).value(forKey: "TITLE") as? String
                let keys = (cells?[indexPath.row] as! NSDictionary).value(forKey: "KEYS") as! NSArray
                (cell as! EnterTextTableViewCell).keys = keys
                (cell as! EnterTextTableViewCell).setupText()
            }
                
            else if cellType == "OPTIONS"
            {
                (cell as! OptionsTableViewCell).titleLabel?.text = (cells?[indexPath.row] as! NSDictionary).value(forKey: "TITLE") as? String
                let options = (cells?[indexPath.row] as! NSDictionary).value(forKey: "OPTIONS") as? NSArray
                (cell as! OptionsTableViewCell).options = options
                (cell as! OptionsTableViewCell).keys = (cells?[indexPath.row] as! NSDictionary).value(forKey: "KEYS") as? NSArray
                (cell as! OptionsTableViewCell).setupCell()
                
            }
                
            else if cellType == "SWITCH"
            {
                
               (cell as! SwitchTableViewCell).titleLabel?.text = (cells?[indexPath.row] as! NSDictionary).value(forKey: "TITLE") as? String
                let options = (cells?[indexPath.row] as! NSDictionary).value(forKey: "OPTIONS") as! NSArray
                (cell as! SwitchTableViewCell).options = options
                (cell as! SwitchTableViewCell).keys = (cells?[indexPath.row] as! NSDictionary).value(forKey: "KEYS") as? NSArray
                if options.count == 0
                {
                    (cell as! SwitchTableViewCell).switchControl?.isHidden = true
                    (cell as! SwitchTableViewCell).switcherLabel?.isHidden = true
                    (cell as! SwitchTableViewCell).switcherLabel2?.isHidden = true
                }
                else if options.count == 1
                {
                    (cell as! SwitchTableViewCell).switchControl?.isHidden = true
                    (cell as! SwitchTableViewCell).switcherLabel?.isHidden = true
                    (cell as! SwitchTableViewCell).switcherLabel2?.isHidden = false
                    (cell as! SwitchTableViewCell).switcherControl2?.isHidden = false
                    (cell as! SwitchTableViewCell).switcherLabel2?.text = options[0] as? String
                }
                else
                {
                    (cell as! SwitchTableViewCell).switchControl?.isHidden = false
                    (cell as! SwitchTableViewCell).switcherLabel?.isHidden = false
                    (cell as! SwitchTableViewCell).switcherControl2?.isHidden = false
                   (cell as! SwitchTableViewCell).switcherLabel2?.isHidden = false
                   
                    (cell as! SwitchTableViewCell).switcherLabel?.text = options[0] as? String
                    (cell as! SwitchTableViewCell).switcherLabel2?.text = options[1] as? String
                }
                (cell as! SwitchTableViewCell).setupSwitch()
                
            }
            else if cellType == "COLOR_PICKER"
            {
                (cell as! ColorPickerTableViewCell).titleLabel?.text = (cells?[indexPath.row] as! NSDictionary).value(forKey: "TITLE") as? String
                (cell as! ColorPickerTableViewCell).keys = (cells?[indexPath.row] as! NSDictionary).value(forKey: "KEYS") as? NSArray
                (cell as! ColorPickerTableViewCell).setupColors()
             
            }
            else if cellType == "CALENDER"
            {
                (cell as! CalenderTableViewCell).titleLabel?.text = (cells?[indexPath.row] as! NSDictionary).value(forKey: "TITLE") as? String
            }
            else if cellType == "TEXT_WITH_TEXT_AND_IMAGE"
            {
                (cell as! TextWithTextAndImageTableViewCell).options = (cells?[indexPath.row] as! NSDictionary).value(forKey: "OPTIONS") as? NSArray
                (cell as! TextWithTextAndImageTableViewCell).keys = (cells?[indexPath.row] as! NSDictionary).value(forKey: "KEYS") as? NSArray
                (cell as! TextWithTextAndImageTableViewCell).titleLabel?.text = (cells?[indexPath.row] as! NSDictionary).value(forKey: "TITLE") as? String
                (cell as! TextWithTextAndImageTableViewCell).setupText()
                (cell as! TextWithTextAndImageTableViewCell).sideImage?.image = UIImage(named:((cells?[indexPath.row] as! NSDictionary).value(forKey: "IMAGE") as? String)!)
                (cell as! TextWithTextAndImageTableViewCell).tableView = (view as! UIViewController)
            }

            else
            {
                print("Cell type not found")
            }
        }
        else if tableIdentifier == FEE_RATES
        {
            if indexPath.section == 1 && indexPath.row == tableView.numberOfRows(inSection: 1)-1
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "ADD_RATE")
                cell?.selectionStyle = .none
            }
            else
            {
                var rate:FeeRates?
                if indexPath.section == 1
                {
                    rate = FeeRates.getRateWithId(id: indexPath.row + 1 + tableView.numberOfRows(inSection: 0))
                }
                else
                {
                    rate = FeeRates.getRateWithId(id: indexPath.row + 1)
                }
                cell = tableView.dequeueReusableCell(withIdentifier: "FEE_CELL")
                (cell as! FeeRateTableViewCell).titleLabel?.text = rate?.name
            
                if rate?.fee.doubleValue == 0.0
                {
                    (cell as! FeeRateTableViewCell).feeLabel?.text = "FEE"
                }
                else
                {
                    (cell as! FeeRateTableViewCell).feeLabel?.text = "\(rate!.fee.doubleValue)"
                }
                

                if (rate?.hours.intValue)! > 0
                {
                        (cell as! FeeRateTableViewCell).hoursToRateLabel?.text = "\(rate!.hours)"
                }
                else
                {
                    (cell as! FeeRateTableViewCell).hoursToRateLabel?.text = rate?.timeInterval.uppercased()
                }
                (cell as! FeeRateTableViewCell).presenter = (view as! UIViewController)
                (cell as! FeeRateTableViewCell).feeRate = rate
                cell?.selectionStyle = .none
                (cell as! FeeRateTableViewCell).section = indexPath.section
                (cell as! FeeRateTableViewCell).row = indexPath.row
                (cell as! FeeRateTableViewCell).setEnabled(selectFee)
                if sectionCounter?[indexPath.section] as! String == "DEFAULT DAY RATE"{
                    (cell as! FeeRateTableViewCell).titleLabel?.isEnabled = false
                }
            }
        }
            //Table Identifier  is INVOICE_INFO
        else
        {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
            let documentsDirectory = paths[0] as! String
            let path = documentsDirectory.appending("/Invoices.plist")
            let array = NSMutableArray(contentsOfFile: path)
            let cells:NSArray!
            if indexPath.section == 0
            {
                cells = (array?[0] as! NSDictionary).value(forKey: "PERSONAL INFO") as? NSArray
            }
            else
            {
                cells = (array?[0] as! NSDictionary).value(forKey: "ACCOUNT DETAILS") as? NSArray
            }
            
            if indexPath.row == 6 && indexPath.section == 1
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "PAYMENT_TERMS") as! PaymentTermsCell
                (cell as! PaymentTermsCell).textField?.text = (cells[indexPath.row] as! NSDictionary).value(forKey: "SUBTITLE") as? String
                (cell as! PaymentTermsCell).section = key as? String
                (cell as! PaymentTermsCell).row = indexPath.row
                
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "ENTER_TEXT") as! EnterTextTableViewCell
                (cell as! EnterTextTableViewCell).titleLabel?.text = (cells[indexPath.row] as! NSDictionary).value(forKey: "TITLE") as? String
                (cell as! EnterTextTableViewCell).textBox?.text = (cells[indexPath.row] as! NSDictionary).value(forKey: "SUBTITLE") as? String
                (cell as! EnterTextTableViewCell).section = key as? String
                (cell as! EnterTextTableViewCell).row = indexPath.row
                (cell as! EnterTextTableViewCell).keys = nil
                (cell as! EnterTextTableViewCell).textBox?.isUserInteractionEnabled = true
                (cell as! EnterTextTableViewCell).textBox?.keyboardType = .default
                if (cell as! EnterTextTableViewCell).titleLabel?.text == "LOGO"
                {
                    (cell as! EnterTextTableViewCell).textBox?.isUserInteractionEnabled = false
                    (cell as! EnterTextTableViewCell).textBox?.isUserInteractionEnabled = false
                    if let _ = UserDefaults.standard.value(forKey: "logoImage")
                    {
                        (cell as! EnterTextTableViewCell).textBox?.text = "Image Selected"
                    }
                }
            }
        }
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
        
        
        return cell!
    }
    

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableIdentifier == FEE_RATES
        {
            if sectionCounter?[indexPath.section] as! String == "CUSTOM RATES"
            {
                return true
            }
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.row == 0 && indexPath.section == 0 && tableIdentifier == DEFAULTS
        {
            self.goBackToStartScreen()
        }
        if indexPath.row == 9 && tableIdentifier == INVOICE_INFO
        {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            (self.view as! UIViewController).present(imagePicker, animated: true, completion: nil)
        }
        if tableIdentifier == FEE_RATES && selectFee
        {
            let cell:FeeRateTableViewCell = tableView.cellForRow(at: indexPath) as! FeeRateTableViewCell
            UserDefaults.standard.setValue("\(cell.feeRate!.id.intValue)", forKey: "defaultDayRate")

            selectFee = false
            self.showTable(identifier: DEFAULTS)
        }
        if indexPath.row == 6 && indexPath.section == 2 && tableIdentifier == DEFAULTS{
            selectFee = true
            self.showTable(identifier: FEE_RATES)
        }
        if indexPath.section == 1 && indexPath.row == 1 {
            let s = KronoBackupCreator.createBackup()
            let m = KronoBackupCreator.emailBackup(s!, delegate: self)
            view?.getController().present(m, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            UserDefaults.standard.setValue(UIImagePNGRepresentation(pickedImage), forKey: "logoImage")
        }
        imagePicker.dismiss(animated: true, completion: nil)
        view?.reloadTable()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
            let documentsDirectory = paths[0] as! String
            let path = documentsDirectory.appending("Fee-Rates.plist")
            let array = NSArray(contentsOfFile: path)
            let dict = array?[0] as! NSMutableDictionary
            (dict.value(forKey: sectionCounter?[indexPath.section] as! String) as! NSMutableArray).removeObject(at: indexPath.row)
            array?.write(toFile: path, atomically: true)
            showTable(identifier: FEE_RATES)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      
        if sectionCounter?[section] as! String == "NO_NAME" && tableIdentifier != FEE_RATES
        {
            return UIView(frame: CGRect.zero)
        }

        else
        {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 25))
            header.backgroundColor = UIColor.tableHeaderColor()
            let title  = UILabel()
            title.translatesAutoresizingMaskIntoConstraints = false
            if tableIdentifier == FEE_RATES
            {
                if section == 0
                {
                    title.text = "DEFAULT DAY RATE"
                }
                else
                {
                    title.text = "CUSTOM RATES"
                }
            }
            else
            {
                title.text = sectionCounter?[section] as? String
            }
            title.font = UIFont(name: "NeoSans-Medium", size: 10)
            title.textColor = UIColor.cellBackgroundColor()
            header.addSubview(title)
            header.addConstraint(NSLayoutConstraint(item: header, attribute: .leading, relatedBy: .equal, toItem: title, attribute: .leading, multiplier: 1.0, constant: -20.0))
            header.addConstraint(NSLayoutConstraint(item: header, attribute: .centerY, relatedBy: .equal, toItem: title, attribute: .centerY, multiplier: 1.0, constant: -1.0))
            header.addConstraint(NSLayoutConstraint(item: title, attribute: .width, relatedBy: .equal, toItem: header, attribute: .width, multiplier: 0.44, constant: 0.0))
            if tableIdentifier == FEE_RATES
            {
                let secondTitle = UILabel()
                secondTitle.textAlignment = .right
                secondTitle.translatesAutoresizingMaskIntoConstraints = false
                secondTitle.text = "FEE"
                secondTitle.font = UIFont(name: "NeoSans-Medium", size: 10)
                secondTitle.textColor = UIColor.cellBackgroundColor()
                header.addSubview(secondTitle)
                header.addConstraint(NSLayoutConstraint(item: header, attribute: .centerY, relatedBy: .equal, toItem: secondTitle, attribute: .centerY, multiplier: 1.0, constant: 0.0))
                header.addConstraint(NSLayoutConstraint(item: title, attribute: .trailing, relatedBy: .equal, toItem: secondTitle, attribute: .leading, multiplier: 1.0, constant: 0.0))
                header.addConstraint(NSLayoutConstraint(item: secondTitle, attribute: .width, relatedBy: .equal, toItem: header, attribute: .width, multiplier: 0.2, constant: 0.0))
                
                
                let thirdTitle = UILabel()
                thirdTitle.textAlignment = .right
                thirdTitle.translatesAutoresizingMaskIntoConstraints = false
                thirdTitle.text = "HOURS TO RATE"
                thirdTitle.font = UIFont(name: "NeoSans-Medium", size: 10)
                thirdTitle.textColor = UIColor.cellBackgroundColor()
                header.addSubview(thirdTitle)
                header.addConstraint(NSLayoutConstraint(item: header, attribute: .centerY, relatedBy: .equal, toItem: thirdTitle, attribute: .centerY, multiplier: 1.0, constant: 0.0))
                header.addConstraint(NSLayoutConstraint(item: header, attribute: .trailing, relatedBy: .equal, toItem: thirdTitle, attribute: .trailing, multiplier: 1.0, constant: 10.0))
                header.addConstraint(NSLayoutConstraint(item: thirdTitle, attribute: .leading, relatedBy: .equal, toItem: secondTitle, attribute: .trailing, multiplier: 1.0, constant: 0.0))
                
            
            }
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 6 && indexPath.section == 1 && tableIdentifier == INVOICE_INFO
        {
            return 150
        }
        else { return 40 }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sectionCounter?[section] as! String == "NO_NAME" && tableIdentifier != FEE_RATES
        {
            return 0
        }
        else
        {
            return 30
        }
    }
}

extension SettingsTableViewPresenter: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
