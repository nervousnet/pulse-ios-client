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
    var location : CLLocation
    
    
    init(uuid : String, lightVal : Double, timestamp : UInt64, location : CLLocation) {
        
        self.type = 0
        self.UUID = uuid
        self.lightVal = lightVal
        self.timestamp = timestamp
        self.location = location
    }
    
}