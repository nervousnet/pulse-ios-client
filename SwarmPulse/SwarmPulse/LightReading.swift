//
//  LightReading.swift
//  SwarmPulse
//
//  Created by sid on 22/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import Foundation
import CoreLocation

class LightReading : Visual {
    
    var lightVal : Double
    var type : Int
    var timestamp : UInt64
    var UUID : String
    var location : [Double]
    
    
    init(uuid : String, lightVal : Double, timestamp : UInt64, location : [Double]) {
        
        self.type = 0
        self.UUID = uuid
        self.lightVal = lightVal
        self.timestamp = timestamp
        self.location = location
    }
    
    func getJSON() -> String {
        let lat = self.location[0]
        let long = self.location[1]
        
        let string1 = "\"class\"" + ":" + "\"" + "ch.ethz.coss.nervous.pulse.model.LightReading" + "\""
        
        let string21 = "\"location\"" + ":" + "{" + "\"class\"" + ":" + "\"ch.ethz.coss.nervous.pulse.model.VisualLocation\"" + ","
        let string22 = "\"latnLong\"" + ":" + "["
        let string23 = (NSString(format: "%f", lat) as String) + ","
        let string24 = (NSString(format: "%f", long) as String) + "]" + "}"
        let string2 = string21 + string22 + string23 + string24
        
        let string3 = "\"" + "lightVal" + "\"" + ":" + (NSString(format: "%f", lightVal) as String)
        
        let string4 = "\"timestamp\"" + ":" + String(self.timestamp)
        
        let string5 = "\"type\"" + ":" + (NSString(format: "%d", type) as String)
        
        let string6 = "\"uuid\"" + ":" + "\"" + UUID + "\""
        
        return "{" + string1 + "," + string2 + "," + string3 + "," + string4 + "," + string5 + "," + string6 + "}"
    }
    
}