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
        
        let radiantWave = RCGRotationView.init(containerView: self.view, numberOfLines: 64, linesColor: UIColor.whiteColor(), linesWidth: 1.0, linesHeight: 150.0)
        
        radiantWave.show()
        
        self.view.sendSubviewToBack(radiantWave)
    }
}

