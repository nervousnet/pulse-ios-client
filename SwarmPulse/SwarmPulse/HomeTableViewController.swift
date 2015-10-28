//
//  HomeTableViewController.swift
//  SwarmPulse
//
//  Created by Lewin Könemann on 23/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    let VM = PulseVM.sharedInstance
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create and set tableview background
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "Background_Graph_Mockup")
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.tableView.backgroundView = backgroundImageView
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        let textcell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! HomeTableViewCell
        //Regularly check whether there are new messages pending
        let sharedDefaults = NSUserDefaults(suiteName: "group.ch.ethz.coss.nervous")
        if (sharedDefaults?.objectForKey("stringKey") == nil){
            sharedDefaults?.setObject(" ", forKey: "stringKey")
            sharedDefaults?.synchronize()
        }
        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("sendPendingMessages"), userInfo: nil, repeats: true)
        
      
        
        
    }
    //Get the message from the NSUserDefaults and send it to the VM
    //Update the bool
    func sendPendingMessages (){
        let sharedDefaults = NSUserDefaults(suiteName: "group.ch.ethz.coss.nervous")
        if (sharedDefaults?.boolForKey("hasBeenPushed") == false){
            let sharedText = sharedDefaults?.objectForKey("stringKey") as? String
            VM.initLocationManager()
            VM.textCollection(sharedText!)
            //VM.textCollection(sharedText!)
            sharedDefaults?.setBool(true, forKey: "hasBeenPushed")
            sharedDefaults?.synchronize()
            NSLog(sharedDefaults?.objectForKey("stringKey") as! String!)

        }
        //NSLog(sharedDefaults?.objectForKey("stringKey") as! String!)
    }

    // MARK: - Table view data source
    //Only one section, might add more later
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //The number of rows. Columns are achieved to the hometableviewcelldouble
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    //Change return divisor in order to adjust number of rows shown at one time
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (tableView.frame.height/4)
    }
    //initialize the cells with names and icons, also pass a reference to self in order to allow segues
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0){
            
            let cell = tableView.dequeueReusableCellWithIdentifier("FullWidthLeftIcon", forIndexPath: indexPath) as! HomeTableViewCell
            cell.nameLabel.text = "Noise"
            cell.infoLabel.text = "42dB"
            cell.iconImage.image = UIImage(named: "icon_noise_msg_frame")
            cell.homeTableViewcontroller = self
            return cell
        }
        if (indexPath.row == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("FullWidthRightIcon", forIndexPath: indexPath) as! HomeTableViewCell
            cell.nameLabel.text  = "Light"
            cell.infoLabel.text = "211 lux"
            cell.iconImage.image = UIImage(named: "icon_light")
            cell.homeTableViewcontroller = self
            cell.startBar()
            return cell
            
        }
        if (indexPath.row == 2) {
            let cell = tableView.dequeueReusableCellWithIdentifier("SplitWidthTwoIcons", forIndexPath: indexPath) as! HomeTableViewCellDouble
            cell.leftLabel.text = "About"
            cell.rightLabel.text = "Visualise"
            cell.rightImage.image = UIImage(named: "icon_about")
            cell.rightImage.image = UIImage(named: "icon_visual")
            cell.rightTarget = "Visualise"
            cell.homeTableViewcontroller = self
            
            return cell

        }
        if (indexPath.row == 3){
            let cell = tableView.dequeueReusableCellWithIdentifier("FullWidthLeftIcon", forIndexPath: indexPath) as! HomeTableViewCell
            cell.nameLabel.text = "Send Message"
            cell.infoLabel.text = ""
            cell.iconImage.image = UIImage(named: "icon_message")
        
            cell.bigButton.backgroundColor = UIColor(red: (1/3), green: (1/3), blue: (1/3), alpha: 0.59)
            cell.homeTableViewcontroller = self

            return cell
        
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("FullWidthRightIcon", forIndexPath: indexPath) as! HomeTableViewCell
            cell.nameLabel.text  = "Please specify this cell"
            cell.homeTableViewcontroller = self

            return cell
            
        }
        // Configure the cell...

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
