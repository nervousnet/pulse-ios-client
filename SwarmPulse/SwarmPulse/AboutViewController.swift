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
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let attrString = NSMutableAttributedString(string: "ETH Zurich\nDepartment of Humanities and Social Sciences\nProfessorship of Computational Social Science\nClausiusstrasse 50,\n8092 Zurich,\nSwitzerland\n\nDeveloped by:\n Lewin Könemann and Siddhartha")
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        longText.attributedText = attrString
        
        longText.textAlignment = NSTextAlignment.center
        longText.font = UIFont.systemFont(ofSize: 14)
        
        if #available(iOS 8.2, *) {
            longText.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight)
        } else {
            // Fallback on earlier versions
        }
        longText.textColor = UIColor.white
        
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
    @IBAction func rateThisApp(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string : "http://itunes.com/apps/swarmpulse")!);
    }

}
