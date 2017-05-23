//
//  InvoiceStatusCell.swift
//  Kronos
//
//  Created by Wee, David G. on 11/5/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class InvoiceStatusCell: UITableViewCell {

    
    @IBOutlet var draftBtn:UIButton!
    @IBOutlet var invoicedBtn:UIButton!
    @IBOutlet var overdueBtn:UIButton!
    @IBOutlet var criticalBtn:UIButton!
    @IBOutlet var clearedBtn:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        draftBtn.setTitleColor(UIColor.cellBackgroundColor(), for: .normal)
        draftBtn.alpha = 0.5
        draftBtn.titleLabel?.font = UIFont().boldFont()
        
        invoicedBtn.setTitleColor(UIColor.cellBackgroundColor(), for: .normal)
        invoicedBtn.alpha = 0.5
        invoicedBtn.titleLabel?.font = UIFont().boldFont()
        
        overdueBtn.setTitleColor(UIColor.cellBackgroundColor(), for: .normal)
        overdueBtn.alpha = 0.5
        overdueBtn.titleLabel?.font = UIFont().boldFont()
        
        criticalBtn.setTitleColor(UIColor.cellBackgroundColor(), for: .normal)
        criticalBtn.alpha = 0.5
        criticalBtn.titleLabel?.font = UIFont().boldFont()
        
        clearedBtn.setTitleColor(UIColor.cellBackgroundColor(), for: .normal)
        clearedBtn.alpha = 0.5
        clearedBtn.titleLabel?.font = UIFont().boldFont()
        
        selectionStyle = .none
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
