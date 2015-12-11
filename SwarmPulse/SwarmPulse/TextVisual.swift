//
//  TextVisual.swift
//  SwarmPulse
//
//  Created by sid on 22/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import Foundation
import CoreLocation

class TextVisual : Visual {
    
    var txtMsg : String
    var type : Int
    var timestamp : UInt64
    var UUID : String
    var location : [Double]
    var volatility : Int
    let VM = PulseVM.sharedInstance
    
    
    init(uuid : String, txtMsg : String, timestamp : UInt64, location : [Double], volatility : Int) {
        
        self.type = 2
        self.UUID = uuid
        self.txtMsg = txtMsg
        self.timestamp = timestamp
        self.location = location
        self.volatility = volatility
    }
    
    func getJSON() -> String {
        let lat = self.location[0]
        let long = self.location[1]
        
        let string1 = "\"class\"" + ":" + "\"" + "ch.ethz.coss.nervous.pulse.model.TextVisual" + "\""
        
        let string21 = "\"location\"" + ":" + "{" + "\"class\"" + ":" + "\"ch.ethz.coss.nervous.pulse.model.VisualLocation\"" + ","
        let string22 = "\"latnLong\"" + ":" + "["
        let string23 = (NSString(format: "%f", lat) as String) + ","
        let string24 = (NSString(format: "%f", long) as String) + "]" + "}"
        let string2 = string21 + string22 + string23 + string24
        
        let string3 = "\"" + "textMsg" + "\"" + ":" + "\"" + self.txtMsg + "\""
        
        let string4 = "\"timestamp\"" + ":" + String(self.timestamp)//(NSString(format: "%d", self.timestamp) as String)
        
        let string5 = "\"type\"" + ":" + (NSString(format: "%d", self.type) as String)
        
        let string6 = "\"uuid\"" + ":" + "\"" + self.UUID + "\""
        
        let string7 = "\"volatility\"" + ":" + (NSString(format: "%d", self.volatility) as String)
        
        return "{" + string1 + "," + string2 + "," + string3 + "," + string4 + "," + string5 + "," + string6 + "," + string7 + "}"
    }
    
}