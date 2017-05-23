//
//  AddCustomRateCell.swift
//  Kronos
//
//  Created by Wee, David G. on 9/2/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class AddCustomRateCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.cellBackgroundColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addCustomRate()
    {
        
        DataController.sharedInstance.addFeeRate(name: "New Rate", fee: nil, hours: nil, custom: true, interval: "hours")
        ((superview?.superview as! UITableView).delegate as! SettingsTableViewPresenter).showTable(identifier: FEE_RATES)
    }

}
