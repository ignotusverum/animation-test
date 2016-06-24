//
//  RCGRotationView.swift
//  Animation
//
//  Created by Vladislav Zagorodnyuk on 6/24/16.
//  Copyright © 2016 Vlad Z. All rights reserved.
//

import UIKit

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
    var animationDuration: CGFloat = 1.0
    
    // Line Layers
    var topLineLayers = [CAShapeLayer]()
    var bottomLayers = [CAShapeLayer]()
    
    // restart of interrupted check
    var shouldRestart = false
    
    // Paused
    var paused = true
    
    // Initialization
    init(containerView: UIView, numberOfLines: Int, linesColor: UIColor, linesWidth: CGFloat, linesHeight: CGFloat) {
        
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        
        self.setupWithView(containerView, numberOfLines: numberOfLines, linesColor: linesColor, linesWidth: linesWidth, linesHeight: linesHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Custom Initialization
    
    func setupWithView(containerView: UIView, numberOfLines: Int, linesColor: UIColor, linesWidth: CGFloat, linesHeight: CGFloat) {
        
        self.containerView = containerView
        
        self.numberOfLines = numberOfLines
        
        self.linesColor = linesColor
        
        self.linesWidth = linesWidth
        
        self.linesHeight = linesHeight
        
        self.frame = containerView.bounds
        
        self.centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        
        // Create Line Layers
        for _ in 0..<numberOfLines {
            
            let topLineLayer = CAShapeLayer()
            let bottomLineLayer = CAShapeLayer()
            
            self.topLineLayers.append(topLineLayer)
            self.bottomLayers.append(bottomLineLayer)
        }
        
        self.containerView?.addSubview(self)
        
    }
    
    // MARK: - Center dot drawing
    func drawCenterDot() {
        
        let radius = self.linesWidth / 2.0
        let dot = self.topLineLayers[0]
        
        // Make circular dot path
        dot.path = UIBezierPath(roundedRect: CGRect(x: 0.0, y: 0.0, width: 2 * radius, height: 2 * radius), cornerRadius: radius).CGPath
        
        // Center the dot in container
        dot.position = CGPoint(x: self.centerPoint!.x - radius, y: self.centerPoint!.y - radius)
        dot.fillColor = UIColor.clearColor().CGColor
        
        dot.strokeColor = self.linesColor.CGColor
        dot.lineWidth = self.linesWidth
        
        // Add center dot
        self.layer.addSublayer(dot)
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
    }
    
    func show() {
        
        self.showProgres(0.0)
        self.paused = false
    }
    
    // MARK: - Layers drawing
    
    func drawLineLayerAtIndex(lineIndex: Int) {
        
        if lineIndex == 0 {
            self.drawCenterDot()
            return
        }
        
        
        
    }
    
    func startAnimatingLine(lineLayer: CAShapeLayer, timeIndex: Int) {
        
    }
    
    
    // MARK: - Notifications
    func registerForNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RCGRotationView.prepareForRenderingForeground), name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RCGRotationView.prepareToResignActive), name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    func unregisterForNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Rendering
    func prepareForRenderingForeground() {
        if shouldRestart {
            
        }
    }
    
    func prepareToResignActive() {
        
    }
}
