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
import AVFoundation

// instantiate the pulse vm for use as a singleton
private let _VM = PulseVM()

class PulseVM : NSObject {
    
    let defaults :NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    //var noiseManager = NoiseRecorder()
    
    //let loca = LocationRecorder()
    
    let addr = "129.132.255.27"
    let port = 8445

    
    
    // initializer
    override init(){
        super.init()
        let guuid = self.generateUUID()
        if guuid {
            _ = self.generateUUID()
        }
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
        let generated = self.defaults.boolForKey("generatedUUID")
        
        if(generated){
            let huuid : UInt64 = UInt64(self.defaults.integerForKey("huuid"))
            
            return huuid
        }else{
            return 0
        }
    }
    
    
    func getLUUID() -> UInt64 {
        let generated = self.defaults.boolForKey("generatedUUID")
        
        if(generated){
            let luuid : UInt64 = UInt64(self.defaults.integerForKey("luuid"))
            
            return luuid
        }else{
            return 0
        }
    }
    
    
    func generateUUID() -> Bool {
        
        let generated = self.defaults.boolForKey("generatedUUID")
        
        if(generated){
            //String representation of uuid
            NSLog("starting generation of uuid string")
            let huuidRaw = getHUUID()
            let luuidRaw = getLUUID()
            
            
            let uuidString = pad(String(huuidRaw, radix: 16), toSize:16) + pad(String(luuidRaw, radix: 16), toSize:16)
            NSLog("UUID: %@", uuidString.uppercaseString)
            
            self.defaults.setValue(uuidString.uppercaseString, forKey: "uuidString")
            
            return false
            
        }else{
            
            NSLog("generating a new uuid")
            
            let LUUID:Int = Int(arc4random_uniform(1234567890)+123456)
            let HUUID:Int = Int(arc4random_uniform(1234567890)+234567)
            
            self.defaults.setBool(true, forKey: "generatedUUID")
            
            self.defaults.setInteger(HUUID, forKey: "huuid")
            self.defaults.setInteger(LUUID, forKey: "luuid")
            
            return true
        }
        
    }
    
    
    // push a text to the server (messages, links etc.)
    func push(txtObj: TextVisual) {
        let jsonString = txtObj.getJSON()
        //print(jsonString)
        /*var out :NSOutputStream?
        NSStream.getStreamsToHostWithName(addr, port: port, inputStream: nil, outputStream: &out)
        if out != nil {
            let outputStream = out!
            outputStream.open()
            let data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
            var buffer = [UInt8](count:data.length, repeatedValue:0)
            data.getBytes(&buffer);
            
            outputStream.write(&buffer, maxLength: data.length);
            
            outputStream.close()
        }else {
            print("Server Down!")
        }*/
        let conn = Connection.sharedInstance
        conn.connect(self.addr, port: self.port)
        conn.stringToWrite = jsonString
    }
    // push noise values to the server
    func push(noiseObj: NoiseReading) {
        let jsonString = noiseObj.getJSON()
        let conn = Connection.sharedInstance
        conn.connect(self.addr, port: self.port)
        conn.stringToWrite = jsonString
    }
    
    // generate noise values using the function
    // the function should be called everytime a button is pressed
    // the function will generate the data dand push it to to the server
    func noiseCollection(pushOrNot: Bool) -> Float {
        let currentTime :NSDate = NSDate()
        let noiseManager = NoiseRecorder.sharedInstance
        let loca = LocationRecorder.sharedInstance
        
        let ifNotUpdated = loca.updateLocation()
        if ifNotUpdated{
            return 0.0
        }
        let lat = round(10*loca.getLat())/10
        let long = round(10*loca.getLong())/10
        let loc : [Double] = [lat,long]
        
        let sound = noiseManager.getNoise()
        print(sound)
        
        let Noise = NoiseReading(
            uuid: self.defaults.stringForKey("uuidString")!,
            soundVal: sound,//(sound+180),
            timestamp: UInt64(currentTime.timeIntervalSince1970*1000),
            location: loc
        )
        
        if pushOrNot {
            dispatch_async(dispatch_get_main_queue()) {
                self.push(Noise)
            }
        }
        
        return sound
    }
    // the function is same as noiseCollection()
    // but to push text messages on the server instead
    func textCollection(txtMsg: String) {
        let currentTime :NSDate = NSDate()
        let loca = LocationRecorder.sharedInstance
        
        let ifNotUpdated = loca.updateLocation()
        if ifNotUpdated{
            return
        }
        let lat = round(10*loca.getLat())/10
        let long = round(10*loca.getLong())/10
        let loc : [Double] = [lat,long]
        
        let Text = TextVisual(
            uuid: self.defaults.stringForKey("uuidString")!,
            txtMsg: txtMsg,
            timestamp: UInt64(currentTime.timeIntervalSince1970*1000),
            location: loc
        )
        dispatch_async(dispatch_get_main_queue()) {
            self.push(Text)
        }
    }


}

