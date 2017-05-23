//
//  ExpandableCell.swift
//  Kronos
//
//  Created by Wee, David G. on 9/5/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

enum ExpandableItem {
    case AGENCY
    case ADD_AGENCY
    case CLIENT
    case ADD_CLIENT
    case PROJECT
    case ADD_PROJECT
    case STAGE_TASK
    case ADD_STAGE_TASK
    case FEES
    
}

class ExpandableCell: UITableViewCell {

    @IBOutlet var subtitle:UILabel?
    @IBOutlet var title:UILabel?
    @IBOutlet var plusImage: UIImageView?
    @IBOutlet var leadingSpace:NSLayoutConstraint?
    var expandType: String?
    var presenter:AddTimerPresenterProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        var fontSize = CGFloat(10)
        if UIScreen().isiPhone6()
        {
            fontSize = CGFloat(12)
        }else if UIScreen().isiPhone6Plus()
        {
            fontSize = CGFloat(13)
        }
        
        subtitle?.font = UIFont().boldFont()
        subtitle?.textColor = UIColor.white
        title?.font = UIFont().normalFont()
        title?.textColor = subtitle?.textColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    

    
    func checkText()
    {
        if subtitle?.text == "SELECT"
        {
            subtitle?.textColor = UIColor.red
        }
    }
    
    

}
