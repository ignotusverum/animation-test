//
//  testView.swift
//  Animation
//
//  Created by Vladislav Zagorodnyuk on 6/23/16.
//  Copyright © 2016 Vlad Z. All rights reserved.
//

import UIKit

class testView: UIView {

    var linesArray: [UIBezierPath]?
    
    var animationLayer: CAShapeLayer?
    
    override func drawRect(rect: CGRect) {
        
        self.linesArray = LogoSpinner.drawLoadingScreenIPhone6(frame: self.bounds, resizing: .AspectFit)
        
        let lineLayer = CAShapeLayer()
        let linePath = UIBezierPath()
        
        /// Line
        
        linePath.moveToPoint(CGPoint(x: 0.5, y: 0.5))
        linePath.addLineToPoint(CGPoint(x: 256.5, y: 171.5))
        lineLayer.lineWidth = 1.0
        lineLayer.path = linePath.CGPath
        lineLayer.strokeColor = UIColor.magentaColor().CGColor
        lineLayer.fillColor = UIColor.magentaColor().CGColor
        
        self.layer.addSublayer(lineLayer)
        
        self.animationLayer = lineLayer
    }
}
