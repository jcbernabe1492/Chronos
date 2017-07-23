//
//  HeaderCEll.swift
//  Kronos
//
//  Created by Wee, David G. on 10/29/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var trashButton:UIButton!
    @IBOutlet var editButtin:UIButton!
    @IBOutlet var unarchiveButton:UIButton!
    
    var status:Tab?
    
    var table:TopTableViewDelegate?
    
    var edit = false
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        titleLabel.font = UIFont().boldFont()
//        trashButton.alpha = 0.5
//        trashButton.isHidden = false
//        editButtin.isHidden = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initButtonsOnly()
    {
        titleLabel.isHidden = true
//        trashButton.isHidden = false
//        editButtin.isHidden = false
//        unarchiveButton.isHidden = true
        
    }
    
    func showUnarchiveButton()
    {
//        unarchiveButton.isHidden = false
//        unarchiveButton.alpha = 0.5
    }
    
    func hideButtons()
    {
//        titleLabel.isHidden = false
//        trashButton.isHidden = true
//        editButtin.isHidden = true
//        unarchiveButton.isHidden = true
    }
    
    @IBAction func unarchivePressed()
    {
        if (table?.isEditing)!
        {
            table?.deleteActionButtonPressed(action: "unarchive")
            setEditing()
        }
    }
    
    @IBAction func trashButtonPressed()
    {
        if (table?.isEditing)!
        {
            table?.deleteActionButtonPressed(action: "delete")
            setEditing()
        }
    }
    
    @IBAction func setEditing()
    {
        if !edit
        {
            trashButton.setImage(UIImage(named:"btn-trash-selected"), for: .normal)
            unarchiveButton.setImage(UIImage(named: "btn-unarchive-selected"), for: .normal)
            edit = true
            trashButton.alpha = 1.0
            unarchiveButton.alpha = 1.0
        }
        else
        {
            trashButton.setImage(UIImage(named:"btn-trash"), for: .normal)
            unarchiveButton.setImage(UIImage(named: "btn-unarchive"), for: .normal)
            edit = false
            trashButton.alpha = 0.5
            unarchiveButton.alpha = 0.5
        }
        table?.setIsEditing(editing: edit)
    }

    
  
}
