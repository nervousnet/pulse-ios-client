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
    
    let locManager = CLLocationManager()
    
    let noiseManager = AVAudioRecorder()
    
    let url = NSURL(string: "129.132.255.27:8445")
    
    
    
    
    
    // initializer
    override init(){
        super.init()
        _ = self.generateUUID()
        locManager.requestWhenInUseAuthorization()
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
    
    
    // JSON format for pushing text-based content
    func getJSON(cl: String, lat: Double,long: Double,txtMsg: String,timestamp: UInt64,uuid: String,typeN: String,type: Int) -> String {
        let string1 = "\"class\"" + ":" + "\"" + cl + "\""
        
        let string21 = "\"location\"" + ":" + "{" + "\"class\"" + ":" + "\"ch.ethz.coss.nervous.pulse.model.VisualLocation\"" + ","
        let string22 = "\"latnLong\"" + ":" + "["
        let string23 = (NSString(format: "%f", lat) as String) + ","
        let string24 = (NSString(format: "%f", long) as String) + "]" + "}"
        let string2 = string21 + string22 + string23 + string24
        
        let string3 = "\"" + typeN + "\"" + ":" + "\"" + txtMsg + "\""
        
        let string4 = "\"timestamp\"" + ":" + (NSString(format: "%d", timestamp) as String)
        
        let string5 = "\"type\"" + ":" + (NSString(format: "%d", type) as String)
        
        let string6 = "\"uuid\"" + ":" + "\"" + uuid + "\""
        
        return "{" + string1 + "," + string2 + "," + string3 + "," + string4 + "," + string5 + "," + string6 + "}"
     }
    // different signature - to be used for non-text mode
    func getJSON(cl: String, lat: Double,long: Double,val: Float,timestamp: UInt64,uuid: String,typeN: String,type: Int) -> String {
        let string1 = "\"class\"" + ":" + "\"" + cl + "\""
        
        let string21 = "\"location\"" + ":" + "{" + "\"class\"" + ":" + "\"ch.ethz.coss.nervous.pulse.model.VisualLocation\"" + ","
        let string22 = "\"latnLong\"" + ":" + "["
        let string23 = (NSString(format: "%f", lat) as String) + ","
        let string24 = (NSString(format: "%f", long) as String) + "]" + "}"
        let string2 = string21 + string22 + string23 + string24
        
        let string3 = "\"" + typeN + "\"" + ":" + (NSString(format: "%f", val) as String)
        
        let string4 = "\"timestamp\"" + ":" + (NSString(format: "%d", timestamp) as String)
        
        let string5 = "\"type\"" + ":" + (NSString(format: "%d", type) as String)
        
        let string6 = "\"uuid\"" + ":" + "\"" + uuid + "\""
        
        return "{" + string1 + "," + string2 + "," + string3 + "," + string4 + "," + string5 + "," + string6 + "}"
    }
    
    
    // push a text to the server (messages, links etc.)
    func pushText(cl: String, lat: Double,long: Double,txtMsg: String,timestamp: UInt64,uuid: String,type: Int) {
        let request = NSMutableURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let jsonBody = getJSON(cl, lat: lat,long: long,txtMsg: txtMsg,timestamp: timestamp,uuid: uuid,typeN: "textMsg",type: type)
        
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        _ = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("Body: \(strData)")
            //let err: NSError?
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    print(json)
                }
            } catch {
                print("Error in JSON - text message")
            }
        })
    }
    // push noise values to the server
    func pushNoise(cl: String, lat: Double,long: Double,val: Float,timestamp: UInt64,uuid: String,type: Int) {
        let request = NSMutableURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let jsonBody = getJSON(cl, lat: lat,long: long,val: val,timestamp: timestamp,uuid: uuid,typeN: "noiseVal",type: type)
        
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        _ = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("Body: \(strData)")
            //let err: NSError?
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    print(json)
                }
            } catch {
                print("Error in JSON - noise value")
            }
        })
    }
    
    // generate noise values using the function
    // the function should be called everytime a button is pressed
    // the function will generate the data dand push it to to the server
    func noiseCollection() {
        noiseManager.meteringEnabled = true
        let noiseLevel = noiseManager.peakPowerForChannel(1)
        let currentTime :NSDate = NSDate()
        locManager.startUpdatingLocation()
        
        let noise = NoiseReading(
            uuid: defaults.stringForKey("generatedUUID")!,
            soundVal: noiseLevel,
            timestamp: UInt64(currentTime.timeIntervalSince1970*1000),
            location: locManager.location!
        )
        
        noiseManager.meteringEnabled = false
        locManager.stopUpdatingLocation()
        
        pushNoise("ch.ethz.coss.nervous.pulse.model.NoiseReading", lat: noise.location.coordinate.latitude, long: noise.location.coordinate.longitude, val: noise.soundVal, timestamp: noise.timestamp, uuid: noise.UUID, type: noise.type)
    }
    // the function is same as noiseCollection()
    // but to push text messages on the server instead
    func textCollection(txtMsg: String) {
        let currentTime :NSDate = NSDate()
        locManager.startUpdatingLocation()
        
        let text = TextVisual(
            uuid: defaults.stringForKey("generatedUUID")!,
            txtMsg: txtMsg,
            timestamp: UInt64(currentTime.timeIntervalSince1970*1000),
            location: locManager.location!
        )
        
        locManager.stopUpdatingLocation()
        
        pushText("ch.ethz.coss.nervous.pulse.model.NoiseReading", lat: text.location.coordinate.latitude, long: text.location.coordinate.longitude, txtMsg: text.txtMsg, timestamp: text.timestamp, uuid: text.UUID, type: text.type)
    }



}

