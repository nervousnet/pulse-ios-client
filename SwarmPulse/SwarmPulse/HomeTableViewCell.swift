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
    @IBOutlet var bar: UIProgressView!
    @IBOutlet var progressLabel: UILabel!
    let VM = PulseVM.sharedInstance
    let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var homeTableViewcontroller: HomeTableViewController = HomeTableViewController()
    var buttonColor = UIColor.whiteColor()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBarTo(){
        if (abs(VM.noiseCollection(false)) < 160){
            let val : Float = (VM.noiseCollection(false)/120)
            bar.setProgress(val , animated: false)
            infoLabel.text = String(Int(VM.noiseCollection(false))) + " dB"
        }
        else {
            bar.setProgress(1, animated: true)
            infoLabel.text = ">160 dB"
        }
        if (VM.getUploadVal("noise") == 0){
            bigButton.enabled = true
            progressLabel.text = "Ready"
            bigButton.backgroundColor = buttonColor
            
        }
        if (VM.getUploadVal("noise") == 1){
            bigButton.alpha = 1
            bigButton.enabled = false
            progressLabel.text = "Uploading"
            
        }
        if (VM.getUploadVal("noise") == 2){
            progressLabel.text = "Value Sent"
        }
        if (VM.getUploadVal("noise") == 3){
            bigButton.enabled = false
            progressLabel.text = "Wait"
        }
        
    }
    func updateMessageLabel(){
        
        if (VM.getUploadVal("text") == 0){
            bigButton.enabled = true
            progressLabel.text = "Ready"
            bigButton.backgroundColor = buttonColor
            
        }
        if (VM.getUploadVal("text") == 1){
            bigButton.alpha = 1
            bigButton.enabled = false
            progressLabel.text = "Uploading"
            
        }
        if (VM.getUploadVal("text") == 2){
            progressLabel.text = "Message Sent"
        }
        if (VM.getUploadVal("text") == 3){
            bigButton.enabled = false
            progressLabel.text = "Wait"
        }
        progressLabel.sizeToFit()
        
    }

    
    
    func setBarTo(value:Float){
        //Set progressbar to value between 0 and 1
        //bar.progress = value
        bar.setProgress(value, animated: true)
    }
    
    func startBar(){
        buttonColor = bigButton.backgroundColor!
        _ = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("setBarTo"), userInfo: nil, repeats: true)
    }
    
    func startMessageUpdate(){
        progressLabel.removeConstraints(progressLabel.constraints)
        progressLabel.sizeToFit()
        
        progressLabel.translatesAutoresizingMaskIntoConstraints = true
        progressLabel.center = CGPointMake(self.bounds.midX, self.bounds.midY)
        progressLabel.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleBottomMargin]
        buttonColor = bigButton.backgroundColor!
        _ = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateMessageLabel"), userInfo: nil, repeats: true)
    }

    
    func onlySpace ( string : String) -> Bool{
        var answer:Bool = true
        for character in string.characters{
            if (character != " "){
                answer = false
            }
        }
        return answer
    
    }
    

    @IBAction func bigButtonPressed(sender: UIButton) {
        NSLog("i work")
        if (progressLabel.text=="Ready" ){
        if (nameLabel.text == "Sound"){
            
            VM.noiseCollection(true)
        }
        if (nameLabel.text == "Light"){
//            setBarTo()
        }
        if (nameLabel.text == "Message"){
            let alertController = UIAlertController(title: "Message", message: "To the SwarmPulse Network", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            
            let SendAction = UIAlertAction(title: "Send", style: .Default) { (action) in
                //self.infoLabel.text = alertController.textFields![0].text
                let sharedDefaults = NSUserDefaults(suiteName: "group.ch.ethz.coss.nervous")
                sharedDefaults?.setObject(alertController.textFields![0].text, forKey: "stringKey")
                    sharedDefaults?.setBool(false, forKey: "hasBeenPushed")
                    sharedDefaults?.synchronize()
                
                //self.homeTableViewcontroller.sendPendingMessages()
                
                self.appdelegate.sendPendingMessages()
                
            }
            alertController.addAction(SendAction)
            SendAction.enabled = false
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Message"
                
                NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                    SendAction.enabled = ((textField.text != "") && (false == self.onlySpace(textField.text!)))
                }
            }
            
            homeTableViewcontroller.presentViewController(alertController, animated: true) {
                // ...
            }
            }
        }
        else {
        
        }
        
}
}