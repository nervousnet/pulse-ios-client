//
//  HomeTableViewCellDoubleTableViewCell.swift
//  SwarmPulse
//
//  Created by Lewin Könemann on 23/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import UIKit

class HomeTableViewCellDouble: UITableViewCell {
    
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    @IBOutlet var leftImage: UIImageView!
    @IBOutlet var rightImage: UIImageView!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    var parentViewController: UIViewController = UIViewController()
    
    var leftTarget : String = ""
    var rightTarget : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func leftPress(sender: UIButton) {
    }

    @IBAction func rightPress(sender: UIButton) {
//        let secondViewController:WebViewController = WebViewController()
//        
//        parentViewController.presentViewController(secondViewController, animated: true, completion: nil)
        
    }
}
