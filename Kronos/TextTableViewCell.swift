//
//  TextTableViewCell.swift
//  Kronos
//
//  Created by Wee, David G. on 8/26/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    var type = "TEXT"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.cellBackgroundColor()
    
        textLabel?.textColor = UIColor.white
        textLabel?.font = UIFont().normalFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func wasClicked(){
        
    }
    

}
