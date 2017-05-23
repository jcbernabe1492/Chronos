//
//  CirclePercentageView.swift
//  Kronos
//
//  Created by Wee, David G. on 8/24/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

class CirclePercentageView: UIView {

    var color = UIColor.white
    var percentage:Double = 0.0
    var progressLayer:CAShapeLayer = CAShapeLayer()
    
    override func draw(_ rect: CGRect) {
        let bezPath = UIBezierPath()
        bezPath.addArc(withCenter: center, radius: rect.height/4, startAngle: CGFloat(-90.degreesToRadians), endAngle: CGFloat(630.degreesToRadians), clockwise: true)
        progressLayer.path = bezPath.cgPath
        progressLayer.strokeColor = color.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 0.5 * rect.size.height
        progressLayer.strokeEnd = CGFloat(percentage)
        layer.addSublayer(progressLayer)

        NotificationCenter.default.addObserver(self, selector: #selector(settingsDidChange), name: NSNotification.Name(rawValue: "kSettingsChangedNotificaiton"), object: nil)
    }

    func settingsDidChange() {
        if self.tag != -1 {
            self.color = UserDefaults.standard.colorForKey("timerColor")!
            setNeedsDisplay()
            layoutSubviews()
        }
    }

}
