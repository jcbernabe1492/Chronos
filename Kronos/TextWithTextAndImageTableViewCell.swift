//
//  TextWithTextAndImageTableViewCell.swift
//  Kronos
//
//  Created by Wee, David G. on 8/26/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class TextWithTextAndImageTableViewCell: UITableViewCell, UIDocumentInteractionControllerDelegate {

    @IBOutlet var titleLabel:UILabel?
    @IBOutlet var subTitleLabel:UILabel?
    @IBOutlet var sideImage:UIImageView?
    var options: NSArray?
    var keys: NSArray?
    var tableView:UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
        
        backgroundColor = UIColor.cellBackgroundColor()
 
        titleLabel?.textColor = UIColor.white
        titleLabel?.font = UIFont().normalFont()
        subTitleLabel?.textColor = UIColor.white
        subTitleLabel?.font = UIFont().boldFont()
        sideImage?.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        sideImage?.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func buttonTapped()
    {
        if titleLabel?.text == "View Invoice Template"
        {
            
            var url = Bundle.main.path(forResource: "Title_Page_Time", ofType: "pdf")
            if UserDefaults.standard.value(forKey: "includeThingsOnInvoice") as! Bool == false
            {
                url = Bundle.main.path(forResource: "Title_Page_No_Time", ofType: "pdf")
            }
            let docController = UIDocumentInteractionController(url: URL(fileURLWithPath: url!))
            docController.delegate = self
            docController.presentPreview(animated: true)
        }
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return tableView!
    }
    
    
    func setupText()
    {
        if keys?.count == 0
        {
            subTitleLabel?.isHidden = true
            return
        }
        subTitleLabel?.isHidden = false
        subTitleLabel?.text = UserDefaults.standard.value(forKey: keys![0] as! String) as? String
        
    }

}
