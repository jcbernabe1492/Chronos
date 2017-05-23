//
//  StatusCell.swift
//  Kronos
//
//  Created by Wee, David G. on 11/1/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class StatusCell: UITableViewCell {

    @IBOutlet var blueView:UIView!
    @IBOutlet var yellowView:UIView!
    @IBOutlet var redView:UIView!
    @IBOutlet var greenView:UIView!

    @IBOutlet var invoicedLabel:UILabel!
    @IBOutlet var overdueLabel:UILabel!
    @IBOutlet var criticalLabel:UILabel!
    @IBOutlet var clearedLabel:UILabel!
    
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var radioButton:UIButton!
    @IBOutlet var labelConstraint:NSLayoutConstraint!
    @IBOutlet var stackConstraint:NSLayoutConstraint!
    
    @IBOutlet var stackAgency : UILabel!
    @IBOutlet var stackClient : UILabel!
    
    var toDelete:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.cellBackgroundColor()
        
        
        blueView.layer.cornerRadius = 5
        greenView.layer.cornerRadius = 5
        redView.layer.cornerRadius = 5
        yellowView.layer.cornerRadius = 5
        
        invoicedLabel.font = UIFont().boldFont()
        overdueLabel.font = UIFont().boldFont()
        criticalLabel.font = UIFont().boldFont()
        clearedLabel.font = UIFont().boldFont()
     
        
        invoicedLabel.textColor = UIColor.white
        overdueLabel.textColor = UIColor.white
        criticalLabel.textColor = UIColor.white
        clearedLabel.textColor = UIColor.white
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont().boldFont()
        
        stackClient.font = UIFont().boldFont()
        stackClient.textColor = UIColor.white
        
        stackAgency.font = UIFont().normalFont()
        stackAgency.textColor = UIColor.white
        
        selectionStyle = .none
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setInvoices(_ invoices:(Int, Int, Int, Int))
    {
        invoicedLabel.text = "\(invoices.0)"
        overdueLabel.text = "\(invoices.1)"
        criticalLabel.text = "\(invoices.2)"
        clearedLabel.text = "\(invoices.3)"
    }

    
    func setIsEditing(editing:Bool)
    {
        if editing
        {
            labelConstraint.constant = 40
             stackConstraint.constant = 40
            radioButton.setImage(UIImage(named:"radio-off"), for: .normal)
            radioButton.isHidden = false
            
        }else
        {
            labelConstraint.constant = 10
             stackConstraint.constant = 10
            radioButton.setImage(UIImage(named:"radio-off"), for: .normal)
            radioButton.isHidden = true
        }
    }
    
    func selected()
    {
        if !toDelete
        {
            radioButton.setImage(UIImage(named:"radio-on"), for: .normal)
            toDelete = true
        }
        else
        {
            radioButton.setImage(UIImage(named:"radio-off"), for: .normal)
            toDelete = false
        }
    }
    
    func set(stack:Bool)
    {
        stackClient.isHidden = !stack
        stackAgency.isHidden = !stack
        titleLabel.isHidden = stack
    }
    
    
    

}
