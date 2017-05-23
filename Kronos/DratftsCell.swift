//
//  DratftsCell.swift
//  Kronos
//
//  Created by Wee, David G. on 10/20/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class DratftsCell: UITableViewCell {

    
    @IBOutlet var leftTopLabel:UILabel!
     @IBOutlet var leftBottomLabel:UILabel!
     @IBOutlet var rightTopLabel:UILabel!
     @IBOutlet var rightBottomLabel:UILabel!
    
    @IBOutlet var invoiceStatusView:UIView!
    
    @IBOutlet var hourLabelTop:UILabel!
    @IBOutlet var hourLabelBottom:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        leftTopLabel.font = UIFont().boldFont()
        leftBottomLabel.font = UIFont().normalFont()
        rightTopLabel.font = UIFont().boldFont()
        rightBottomLabel.font = UIFont().normalFont()
        
        hourLabelTop.font = UIFont().boldFont()
        hourLabelBottom.font = UIFont().normalFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
