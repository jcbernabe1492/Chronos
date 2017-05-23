//
//  SummaryLabelCell.swift
//  Kronos
//
//  Created by Wee, David G. on 10/21/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class SummaryLabelCell: UITableViewCell {

    @IBOutlet var title:UILabel!
    @IBOutlet var subTitle:UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        title.font = UIFont().normalFont()
        title.textColor = UIColor.white
        
        subTitle.font = UIFont().boldFont()
        subTitle.textColor = UIColor.white
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
