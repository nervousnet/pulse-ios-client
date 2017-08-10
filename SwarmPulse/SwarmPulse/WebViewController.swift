//
//  WebViewController.swift
//  SwarmPulse
//
//  Created by Lewin Könemann on 22/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        
        let url = "http://pulse.inn.ac/"
        let requestURL = URL(string:url)
        let request = URLRequest(url: requestURL!)
        webView.loadRequest(request)
//        UIApplication.sharedApplication().openURL(NSURL(string: "http://pulse.inn.ac/")!)
        
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

}
