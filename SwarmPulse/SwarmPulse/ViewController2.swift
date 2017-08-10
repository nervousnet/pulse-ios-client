//
//  ViewController.swift
//  SwarmPulse
//
//  Created by Lewin Könemann on 22/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//
import Foundation
import UIKit

class ViewController2: UIViewController {
    @IBOutlet var lightLabel: UILabel!
    
    @IBOutlet var noiseLabel: UILabel!
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        setNeedsStatusBarAppearanceUpdate()
        super.viewDidLoad()
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: Selector("updateLabel"), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let sharedDefaults = UserDefaults(suiteName: "group.ch.ethz.coss.nervous")
        lightLabel.text = sharedDefaults?.object(forKey: "stringKey") as? String
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabel()
    {
        noiseLabel.text = String(arc4random_uniform(49)+1) + " dB"
        //lightLabel.text = String(arc4random_uniform(150)+1) + " lux"

    }

    
    
    
}

