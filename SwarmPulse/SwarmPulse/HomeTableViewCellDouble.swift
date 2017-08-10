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
    var homeTableViewcontroller: HomeTableViewController = HomeTableViewController()
    
    var leftTarget : String = ""
    var rightTarget : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func leftPress(_ sender: UIButton) {
        let  targetVC : UIViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: leftLabel.text!)
        homeTableViewcontroller.present(targetVC, animated: true, completion: nil)
        
    }

    @IBAction func rightPress(_ sender: UIButton) {
            let  targetVC : UIViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: rightLabel.text!)
            homeTableViewcontroller.present(targetVC, animated: true, completion: nil)
        
    }
}
