//
//  TimingsCell.swift
//  Kronos
//
//  Created by Wee, David G. on 10/24/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class TimingsCell: UITableViewCell {

    @IBOutlet var leftLabel:UILabel!
    @IBOutlet var rightLabel:UILabel!
    @IBOutlet var middleLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
