//
//  ViewController.swift
//  Animation
//
//  Created by Vladislav Zagorodnyuk on 6/23/16.
//  Copyright © 2016 Vlad Z. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var testViewtest: testView!

    @IBAction func testButtonpressed(sender: AnyObject) {
        
        let rotationAngle = CGFloat(M_PI)
        
        for line in self.testViewtest.linesArray! {
            
        }
        
        let springAnimation = CABasicAnimation(keyPath: "transform.rotation")
        springAnimation.byValue = Float(M_PI)
        springAnimation.duration = 4.0
        springAnimation.repeatCount = Float.infinity
        
        self.testViewtest.animationLayer?.addAnimation(springAnimation, forKey: "testAnimation")
    }
}

