//
//  NoiseReading.swift
//  SwarmPulse
//
//  Created by sid on 22/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import Foundation
import CoreLocation

class NoiseReading : Visual {
    
    var soundVal : Float
    var type : Int
    var timestamp : UInt64
    var UUID : String
    var location : CLLocation
    
    
    init(uuid : String, soundVal : Float, timestamp : UInt64, location : CLLocation) {
        
        self.type = 1
        self.UUID = uuid
        self.soundVal = soundVal
        self.timestamp = timestamp
        self.location = location
    }
    
}