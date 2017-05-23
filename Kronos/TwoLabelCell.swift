//
//  TwoLabelCell.swift
//  Kronos
//
//  Created by Wee, David G. on 10/29/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class TwoLabelCell: UITableViewCell {

    @IBOutlet var leftLabel:UILabel!
    @IBOutlet var rightLabel:UILabel!
    @IBOutlet var radioButton:UIButton!
    @IBOutlet var labelConstraint:NSLayoutConstraint!
    @IBOutlet var stackConsraint:NSLayoutConstraint!
    
    @IBOutlet var stackClient:UILabel!
    @IBOutlet var stackAgency:UILabel!
    
    var toDelete:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.cellBackgroundColor()
        
        leftLabel.font = UIFont().normalFont()
        rightLabel.font = UIFont().boldFont()
        leftLabel.textColor = UIColor.white
        rightLabel.textColor = UIColor.white
        
        stackClient.font = UIFont().boldFont()
        stackClient.textColor = UIColor.white
        
        stackAgency.font = UIFont().normalFont()
        stackAgency.textColor = UIColor.white
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setIsEditing(editing:Bool)
    {
        if editing
        {
            labelConstraint.constant = 50
            stackConsraint.constant = 50
            radioButton.setImage(UIImage(named:"radio-off"), for: .normal)
            radioButton.isHidden = false
            
        }else
        {
            labelConstraint.constant = 20
            stackConsraint.constant = 20
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
        leftLabel.isHidden = stack
    }
}
