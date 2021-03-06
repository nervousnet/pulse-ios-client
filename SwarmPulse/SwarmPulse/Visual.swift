//
//  Visual.swift
//  SwarmPulse
//
//  Created by sid on 22/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import Foundation
import CoreLocation

protocol Visual {
    var type : Int { get set } // 0 - light, 1 - sound, 2 - text
    var location : [Double]    { get }
    var timestamp : UInt64 { get set }
    var UUID : String {get set}
    var volatility: Int {get set}
}