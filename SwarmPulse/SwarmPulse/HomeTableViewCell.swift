//
//  HomeTableViewCell.swift
//  SwarmPulse
//
//  Created by Lewin Könemann on 23/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var bigButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    let VM = PulseVM.sharedInstance
    var homeTableViewcontroller: HomeTableViewController = HomeTableViewController()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let sharedDefaults = NSUserDefaults(suiteName: "group.ch.ethz.coss.nervous")
//        if (true){
//            let sharedText = sharedDefaults?.objectForKey("stringKey") as? String
//
//            sharedDefaults?.setBool(true, forKey: "hasBeenPushed")
//            sharedDefaults?.synchronize()
//            infoLabel.text = sharedText
//            
//        }
//        NSLog(sharedDefaults?.objectForKey("stringKey") as! String!)
        // Initialization code
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func bigButtonPressed(sender: UIButton) {
        if (nameLabel.text == "Noise"){
            //VM.noiseCollection()
        }
        if (nameLabel.text == "Light"){
            
        }
        if (nameLabel.text == "Send Message"){
            let alertController = UIAlertController(title: "Message", message: "to the Pulse Network", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            
            let SendAction = UIAlertAction(title: "Send", style: .Default) { (action) in
                self.infoLabel.text = alertController.textFields![0].text
                let sharedDefaults = NSUserDefaults(suiteName: "group.ch.ethz.coss.nervous")
                sharedDefaults?.setObject(alertController.textFields![0].text, forKey: "stringKey")
                    sharedDefaults?.setBool(false, forKey: "hasBeenPushed")
                    sharedDefaults?.synchronize()
                
                self.homeTableViewcontroller.sendPendingMessages()
            }
            alertController.addAction(SendAction)
            
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Message"
                
                NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                    SendAction.enabled = textField.text != ""
                }
            }
            
            homeTableViewcontroller.presentViewController(alertController, animated: true) {
                // ...
            }
        }
    }
}
