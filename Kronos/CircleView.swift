//
//  CircleView.swift
//  Kronos
//
//  Created by Wee, David G. on 8/21/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class CircleView: UIView {

    var circleColor:UIColor! = UIColor.white

    override func draw(_ rect: CGRect) {
        if circleColor == nil
        {
            circleColor = UIColor.white
        }
        let ctx = UIGraphicsGetCurrentContext()
        ctx!.addEllipse(in: rect)
        ctx!.setFillColor(circleColor.cgColor.components!)
        ctx!.fillPath()
    }
    

}
