//
//  PulseVM.swift
//  SwarmPulse
//
//  Created by sid on 22/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// instantiate the pulse vm for use as a singleton
private let _VM = PulseVM()

class PulseVM : NSObject {
    
    let defaults :NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    let manager : CLLocationManager! = CLLocationManager()
    
    // initializer
    override init(){
        super.init()
        _ = self.generateUUID()
    }
    
    // create the share instance function
    class var sharedInstance: PulseVM {
        return _VM
    }
    
    func pad(string : String, toSize: Int) -> String {
        var padded = string
        for _ in 0..<toSize - string.characters.count {
            padded = "0" + padded
        }
        return padded
    }
    
    func getHUUID() -> UInt64 {
        let generated = defaults.boolForKey("generatedUUID")
        
        if(generated){
            let huuid : UInt64 = UInt64(defaults.integerForKey("huuid"))
            
            return huuid
        }else{
            return 0
        }
    }
    
    
    func getLUUID() -> UInt64 {
        let generated = defaults.boolForKey("generatedUUID")
        
        if(generated){
            let luuid : UInt64 = UInt64(defaults.integerForKey("luuid"))
            
            return luuid
        }else{
            return 0
        }
    }
    
    func generateUUID() -> Bool {
        
        let generated = defaults.boolForKey("generatedUUID")
        
        if(generated == true){
            
            
            
            //String representation of uuid
            NSLog("starting generation of uuid string")
            let huuidRaw = getHUUID()
            let luuidRaw = getLUUID()
            
            
            let uuidString = pad(String(huuidRaw, radix: 16), toSize:16) + pad(String(luuidRaw, radix: 16), toSize:16)
            NSLog("UUID: %@", uuidString.uppercaseString)
            
            defaults.setValue(uuidString.uppercaseString, forKey: "uuidString")
            
            return false
            
        }else{
            
            NSLog("generating a new uuid")
            
            let LUUID:Int = Int(arc4random_uniform(1234567890)+123456)
            let HUUID:Int = Int(arc4random_uniform(1234567890)+234567)
            
            let beaconMinor :Int = Int(arc4random_uniform(7000)+200)
            
            defaults.setBool(true, forKey: "generatedUUID")
            
            defaults.setInteger(HUUID, forKey: "huuid")
            defaults.setInteger(LUUID, forKey: "luuid")
            defaults.setInteger(beaconMinor, forKey: "beaconminor")
            
            
            return true
        }
    }
}

