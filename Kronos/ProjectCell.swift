//
//  ProjectCell.swift
//  Kronos
//
//  Created by Wee, David G. on 9/13/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class ProjectCell: UITableViewCell {

    @IBOutlet var projectNameLabel:UILabel?
    @IBOutlet var clientNameLabel:UILabel?
    @IBOutlet var stackViewLeading:NSLayoutConstraint?
    @IBOutlet var selectCellImageView:UIImageView?
    var isPicked:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProjectCell.dotPressed))
        selectCellImageView?.isUserInteractionEnabled = true
        selectCellImageView?.addGestureRecognizer(tap)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dotPressed()
    {
        if isPicked
        {
            selectCellImageView?.image = UIImage(named: "radio-off")
            isPicked = false
        }
        else
        {
            selectCellImageView?.image = UIImage(named: "radio-on")
            isPicked = true
        }
    }

}
