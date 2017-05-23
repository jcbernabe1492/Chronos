//
//  AddTimerOptionCell.swift
//  Kronos
//
//  Created by Wee, David G. on 9/5/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class AddTimerOptionCell: UITableViewCell {

    @IBOutlet var title:UILabel?
    @IBOutlet var option1:UIButton?
    @IBOutlet var option2:UIButton?
    
    var presenter : AddTimerPresenter?
    
    var currentSelected:UIButton?
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
        
        option1?.titleLabel?.font = UIFont().boldFont()
        option1?.tintColor = UIColor.white
        option1?.addTarget(self, action: #selector(AddTimerOptionCell.buttonPressed(btn:)), for: .touchUpInside)
        option2?.titleLabel?.font = option1?.titleLabel?.font
        option2?.tintColor = option1?.tintColor
        option1?.backgroundColor = UIColor.black
        option2?.addTarget(self, action: #selector(AddTimerOptionCell.buttonPressed(btn:)), for: .touchUpInside)
        title?.font = UIFont().normalFont()
        option2?.tag = 2
        title?.textColor = option1?.tintColor
        currentSelected = option1
        option2?.setTitle("CUSTOM", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func buttonPressed(btn:UIButton)
    {

        currentSelected?.backgroundColor = UIColor.clear
        btn.backgroundColor = UIColor.black
        currentSelected = btn
        if btn.tag == 2
        {
            presenter?.expandToItem(cell: .FEES)
        }
    }
    
    func setDefault()
    {
        currentSelected?.backgroundColor = UIColor.clear
        option1?.backgroundColor = UIColor.black
        currentSelected = option1
        option2?.setTitle("CUSTOM", for: .normal)
    }
    
    
    

}
