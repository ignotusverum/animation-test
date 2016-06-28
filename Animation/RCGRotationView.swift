//
//  RCGRotationView.swift
//  Animation
//
//  Created by Vladislav Zagorodnyuk on 6/24/16.
//  Copyright © 2016 Vlad Z. All rights reserved.
//

import UIKit

extension UIBezierPath {
    
    static func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = 0, scalingValue: CGFloat = 6.0) -> UIBezierPath {
        let path = UIBezierPath()
        let theta: CGFloat = CGFloat(2.0 * M_PI) / CGFloat(sides) // How much to turn at every corner
        
        let width = min(rect.size.width, rect.size.height)        // Width of the square
        
        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + rect.size.height / 2.0)
        
        // Radius of the circle that encircles the polygon
        // Notice that the radius is adjusted for the corners, that way the largest outer
        // dimension of the resulting shape is always exactly the width - linewidth
        let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / scalingValue
        
        // Start drawing at a point, which by default is at the right hand edge
        // but can be offset
        var angle = CGFloat(rotationOffset)
        
        let corner = CGPointMake(center.x + (radius - cornerRadius) * cos(angle), center.y + (radius - cornerRadius) * sin(angle))
        path.moveToPoint(CGPointMake(corner.x + cornerRadius * cos(angle + theta), corner.y + cornerRadius * sin(angle + theta)))
        
        for _ in 0..<sides {
            angle += theta
            
            let corner = CGPointMake(center.x + (radius - cornerRadius) * cos(angle), center.y + (radius - cornerRadius) * sin(angle))
            let tip = CGPointMake(center.x + radius * cos(angle), center.y + radius * sin(angle))
            let start = CGPointMake(corner.x + cornerRadius * cos(angle - theta), corner.y + cornerRadius * sin(angle - theta))
            let end = CGPointMake(corner.x + cornerRadius * cos(angle + theta), corner.y + cornerRadius * sin(angle + theta))
            
            path.addLineToPoint(start)
            path.addQuadCurveToPoint(end, controlPoint: tip)
        }
        
        path.closePath()
        
        return path
    }
}

enum ResizingBehavior {
    case AspectFit /// The content is proportionally resized to fit into the target rectangle.
    case AspectFill /// The content is proportionally resized to completely fill the target rectangle.
    case Stretch /// The content is stretched to match the entire target rectangle.
    case Center /// The content is centered in the target rectangle, but it is NOT resized.
    
    func apply(rect rect: CGRect, target: CGRect) -> CGRect {
        if rect == target || target == CGRect.zero {
            return rect
        }
        
        var scales = CGSize.zero
        scales.width = abs(target.width / rect.width)
        scales.height = abs(target.height / rect.height)
        
        switch self {
        case .AspectFit:
            scales.width = min(scales.width, scales.height)
            scales.height = scales.width
        case .AspectFill:
            scales.width = max(scales.width, scales.height)
            scales.height = scales.width
        case .Stretch:
            break
        case .Center:
            scales.width = 1
            scales.height = 1
        }
        
        var result = rect.standardized
        result.size.width *= scales.width
        result.size.height *= scales.height
        result.origin.x = target.minX + (target.width - result.width) / 2
        result.origin.y = target.minY + (target.height - result.height) / 2
        return result
    }
}

class RCGRotationView: UIView {

    // Container view
    var containerView: UIView?
    
    // Lines Color
    var linesColor: UIColor = UIColor.blackColor()
    
    // Lines Height
    var linesHeight: CGFloat = 320.0
    
    // Lines Width
    var linesWidth: CGFloat = 10.0
    
    // Number of lines
    var numberOfLines: Int = 6
    
    // Center Point
    var centerPoint: CGPoint?
    
    // Animation Duration
    var animationDuration = 10.0
    
    // Line Layers
    var topLineLayers = [CAShapeLayer]()
    var bottomLayers = [CAShapeLayer]()
    
    var particleLayers = [CAShapeLayer]()
    
    // Masks
    var topShape = CAShapeLayer()
    var bottomShape = CAShapeLayer()
    
    // restart of interrupted check
    var shouldRestart = false
    
    // Angle between lines
    var lineAngle: CGFloat = 0.0
    
    // Paused
    var paused = true
    
    var shapePath: UIBezierPath {
        get {

            return UIBezierPath.roundedPolygonPath(self.bounds, lineWidth: 1.0, sides: 6, cornerRadius: 2.0, rotationOffset: CGFloat(M_PI / 6.0))
        }
    }
    
    // Initialization
    init(containerView: UIView, numberOfLines: Int, linesColor: UIColor, linesWidth: CGFloat, linesHeight: CGFloat) {
        
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        
        self.setupWithView(containerView, numberOfLines: numberOfLines, linesColor: linesColor, linesWidth: linesWidth, linesHeight: linesHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Custom Initialization
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
    }
    
    func setupWithView(containerView: UIView, numberOfLines: Int, linesColor: UIColor, linesWidth: CGFloat, linesHeight: CGFloat) {
        
        self.containerView = containerView
        
        self.numberOfLines = numberOfLines
        
        self.linesColor = linesColor
        
        self.linesWidth = linesWidth
        
        self.linesHeight = linesHeight
        
        self.frame = containerView.bounds
        
        self.centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        
        self.lineAngle = CGFloat(2 * M_PI) / CGFloat(numberOfLines)
        
        // Create Line Layers
        for _ in 0..<numberOfLines {
            
            let topLineLayer = CAShapeLayer()
            let bottomLineLayer = CAShapeLayer()
            
            let particleLayer = CAShapeLayer()
            
            self.topLineLayers.append(topLineLayer)
            self.bottomLayers.append(bottomLineLayer)
            
            self.particleLayers.append(particleLayer)
        }
        
        self.containerView?.addSubview(self)
    }
    
    // MARK: - Center dot drawing
    func drawCenterDot() {
        
        let dot = self.topLineLayers[0]
        
        // Make circular dot path
        dot.path = self.shapePath.CGPath
        
        // Center the dot in container
        dot.fillColor = UIColor.blackColor().CGColor
        
        dot.strokeColor = UIColor.blackColor().CGColor
        dot.lineWidth = self.linesWidth
        
        // Add center dot
        self.containerView!.layer.insertSublayer(dot, atIndex: 1)
    }
    
    // MARK: - Progress Logic
    func showProgres(progress: CGFloat) {
    
        self.drawLines()
        self.shouldRestart = true
    }
    
    func drawLines() {
        
        for i in 0..<self.topLineLayers.count {
            
            self.drawLineLayerAtIndex(i)
            self.startAnimatingLine(self.topLineLayers[i], timeIndex: i)
            self.startAnimatingLine(self.bottomLayers[i], timeIndex: i)
        }
        
        self.bottomShape.frame = self.layer.bounds
        self.bottomShape.path = UIBezierPath.roundedPolygonPath(self.bounds, lineWidth: 1.0, sides: 6, cornerRadius: 0.0, rotationOffset: CGFloat(M_PI / 6.0), scalingValue: 4.0).CGPath
        self.bottomShape.lineWidth = 3.0
        self.bottomShape.strokeColor = UIColor.redColor().CGColor
        self.bottomShape.fillColor = UIColor.blackColor().CGColor
        self.bottomShape.fillRule = kCAFillRuleEvenOdd
        self.layer.mask = self.bottomShape
        
        self.topShape.frame = self.layer.bounds
        self.topShape.path = UIBezierPath.roundedPolygonPath(self.bounds, lineWidth: 1.0, sides: 6, cornerRadius: 0.0, rotationOffset: CGFloat(M_PI / 6.0), scalingValue: 3.0).CGPath
        self.topShape.lineWidth = 3.0
        self.topShape.strokeColor = UIColor.redColor().CGColor
        self.topShape.fillColor = UIColor.blackColor().CGColor
        self.topShape.fillRule = kCAFillRuleEvenOdd
//        self.containerView!.layer.mask = self.topShape
    }
    
    func show() {
        
        self.showProgres(0.0)
        self.paused = false
    }
    
    func disco(on: Bool) {
        
        for i in 0..<self.topLineLayers.count {
            
            let topLayer = self.topLineLayers[i]
            let bottomLayer = self.bottomLayers[i]
            
            self.discoTimeForLine(topLayer, index: i)
            self.discoTimeForLine(bottomLayer, index: i)
        }
    }
    
    func discoTimeForLine(layer: CAShapeLayer, index: Int) {
        
        let colors = [UIColor.redColor(), UIColor.orangeColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.purpleColor()]
        
        var animationsArray = [CABasicAnimation]()
        
        for i in 0..<colors.count {
            
            let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
            colorAnimation.beginTime = (0.33 / Double(colors.count))  * Double(i)
            colorAnimation.duration = 0.33
            colorAnimation.fromValue = colors[i].CGColor
            colorAnimation.toValue = colors[(i + 1) % colors.count].CGColor
            
            animationsArray.append(colorAnimation)
        }
        
        let discoAnimation = CAAnimationGroup()
        discoAnimation.beginTime = 0.33 / 10.0 * Double(index)
        discoAnimation.duration = 0.33
        discoAnimation.animations = animationsArray
        discoAnimation.autoreverses = false
        discoAnimation.repeatCount = Float.infinity
        discoAnimation.removedOnCompletion = true
        
        layer.addAnimation(discoAnimation, forKey: "party")
    }
    
    func particleAnimationForIndex(index: Int) {
        
//        let particleLine = 
        
    }
    
    // MARK: - Layers drawing
    
    func drawLineLayerAtIndex(lineIndex: Int) {
        
        if lineIndex == 0 {
            self.drawCenterDot()
            return
        }
        
        let topLine = self.topLineLayers[lineIndex]
        topLine.bounds = CGRect(x: 0.0, y: 0.0, width: self.linesWidth, height: self.linesHeight)
        topLine.path = UIBezierPath(rect: topLine.bounds).CGPath

        topLine.position = CGPoint(x: self.centerPoint! .x, y: self.centerPoint!.y)
        topLine.fillColor = UIColor.clearColor().CGColor
        topLine.strokeColor = self.linesColor.CGColor
        topLine.lineWidth = self.linesWidth
        
        let bottomLine = self.bottomLayers[lineIndex]
        bottomLine.bounds = CGRect(x: 0.0, y: 0.0, width: self.linesWidth + 1.5, height: self.linesHeight)
        bottomLine.path = UIBezierPath(rect: bottomLine.bounds).CGPath

        bottomLine.position = CGPoint(x: self.centerPoint! .x, y: self.centerPoint!.y)
        bottomLine.fillColor = UIColor.clearColor().CGColor
        bottomLine.strokeColor = self.linesColor.CGColor
        bottomLine.lineWidth = self.linesWidth + 1.5
        
        self.layer.insertSublayer(bottomLine, atIndex: 0)
        self.containerView!.layer.insertSublayer(topLine, atIndex: 0)
    }
    
    func animateParticlesAtIndex(lineLayer: CAShapeLayer, timeIndex: Int) {
        
        let rotationAnimation = CABasicAnimation(keyPath: "strokeEnd")
        rotationAnimation.fromValue = (lineLayer.presentationLayer() as? CAShapeLayer)?.strokeEnd
        rotationAnimation.toValue = 100
        rotationAnimation.duration = 1.0
        
        rotationAnimation.autoreverses = true
        rotationAnimation.removedOnCompletion = true
        
        rotationAnimation.repeatCount = Float.infinity
        
        lineLayer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func startAnimatingLine(lineLayer: CAShapeLayer, timeIndex: Int) {
        if timeIndex != 0 {

//            let centerShape = self.topLineLayers[0]
//           
//            let path = CGPathCreateMutableCopy(centerShape.path)
//            
//            let delay = (Double(self.animationDuration) / Double(self.numberOfLines)) * Double(timeIndex)
//            
//            let theAnimation = CAKeyframeAnimation(keyPath: "position")
//            theAnimation.path = path
//            
//            theAnimation.duration = self.animationDuration
//            theAnimation.removedOnCompletion = false
//            theAnimation.autoreverses = false
//            theAnimation.beginTime = delay
//            theAnimation.repeatCount = Float.infinity
//            theAnimation.rotationMode = kCAAnimationRotateAutoReverse
//            theAnimation.fillMode = kCAFillModeForwards
//            
//            lineLayer.addAnimation(theAnimation, forKey: "positionAnimation")
            
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.fromValue = Double(self.lineAngle) * Double(timeIndex)
            rotationAnimation.toValue = Double(CGFloat(M_PI * 2)) + Double(self.lineAngle) * Double(timeIndex)
            rotationAnimation.duration = self.animationDuration
            rotationAnimation.fillMode = kCAFillModeForwards
            rotationAnimation.autoreverses = false
            rotationAnimation.removedOnCompletion = false
//            rotationAnimation.cumulative = true
            rotationAnimation.repeatCount = Float.infinity
            
            lineLayer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
        }
    }
}
