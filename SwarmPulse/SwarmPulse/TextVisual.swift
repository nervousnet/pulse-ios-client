//
//  TextVisual.swift
//  SwarmPulse
//
//  Created by sid on 22/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import Foundation
import CoreLocation

class TextReading : Visual {
    
    var txtMsg : String
    var type : Int
    var timestamp : UInt64
    var UUID : String
    var location : CLLocation
    
    
    init(uuid : String, txtMsg : String, timestamp : UInt64, location : CLLocation) {
        
        self.type = 2
        self.UUID = uuid
        self.txtMsg = txtMsg
        self.timestamp = timestamp
        self.location = location
    }
    
}