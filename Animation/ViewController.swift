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
    
    var radiantWave: RCGRotationView?

    @IBAction func testButtonpressed(sender: AnyObject) {
        
        self.radiantWave = RCGRotationView.init(containerView: self.view, numberOfLines: 32, linesColor: UIColor.whiteColor(), linesWidth: 1.0, linesHeight: 300.0)
        
        self.radiantWave!.show()
        
        self.view.sendSubviewToBack(self.radiantWave!)
    }
    
    @IBAction func disco(sender: AnyObject) {
        
        self.radiantWave!.disco(true)
    }
}

