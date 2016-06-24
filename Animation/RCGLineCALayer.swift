//
//  RCGLineCALayer.swift
//  Animation
//
//  Created by Vladislav Zagorodnyuk on 6/24/16.
//  Copyright © 2016 Vlad Z. All rights reserved.
//

import UIKit

class RCGLineCALayer: CALayer {

    override func drawInContext(ctx: CGContext) {
        
        let gradLocationsNum = 2
        let gradLocations: [CGFloat] = [0.0, 0.1]
        
        let gradColors: [CGFloat] = [1.4, 1.4, 1.4, 0.4,
                          0.0, 0.0, 0.0, 0.0]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum)
        
        let gradRadius = min(self.bounds.size.width, self.bounds.size.height)
        let gradCenter = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0)
        
        CGContextDrawRadialGradient(ctx, gradient, gradCenter, 0.0, gradCenter, gradRadius, .DrawsAfterEndLocation)
    }
}
