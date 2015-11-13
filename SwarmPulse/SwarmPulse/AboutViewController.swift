//
//  AboutViewController.swift
//  SwarmPulse
//
//  Created by Lewin Könemann on 27/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet var longText: UITextView!
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let attrString = NSMutableAttributedString(string: "ETH Zurich\nDepartment of Humanities and Social Sciences\nProfessorship of Computational Social Science\nClausiusstrasse 50,\n8092 Zurich,\nSwitzerland")
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        longText.attributedText = attrString
        
        longText.textAlignment = NSTextAlignment.Center
        longText.font = UIFont.systemFontOfSize(14)
        
        if #available(iOS 8.2, *) {
            longText.font = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
        } else {
            // Fallback on earlier versions
        }
        longText.textColor = UIColor.whiteColor()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func rateThisApp(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string : "http://itunes.com/apps/swarmpulse")!);
    }

}
