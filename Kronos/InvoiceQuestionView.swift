//
//  InvoiceQuestionView.swift
//  Kronos
//
//  Created by John Christopher Bernabe on 12/08/2017.
//  Copyright © 2017 davidwee. All rights reserved.
//

import UIKit

protocol InvoiceQuestionViewDelegate: class {
    func cancelledInvoiceJob()
    func acceptedInvoiceJob()
}

class InvoiceQuestionView: UIView {
    
    weak var invoiceQuestionDelegate: InvoiceQuestionViewDelegate?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var invoiceJobButton: UIButton!
   
    @IBAction func cancelButtonTapped(_ sender: Any) {
        invoiceQuestionDelegate?.cancelledInvoiceJob()
    }
    
    @IBAction func invoiceJobTapped(_ sender: Any) {
        invoiceQuestionDelegate?.acceptedInvoiceJob()
    }
}
