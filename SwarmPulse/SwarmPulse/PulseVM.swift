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
    
    var noiseManager: AVAudioRecorder!
    
    let url = NSURL(string: "129.132.255.27:8445")
    //let url : String = "129.132.255.27:8445"
    //let socketJSON = SocketIOClient(socketURL: "129.132.255.27:8445")
    let addr = "129.132.255.27"
    let port = 8445

    
    
    // initializer
    override init(){
        super.init()
        _ = self.generateUUID()
    }
    
    // create the share instance function
    class var sharedInstance: PulseVM {
        return _VM
    }
    
    // initialize the location Manager
    func initLocationManager() {
        //locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locManager.requestWhenInUseAuthorization()
    }
    
    /*func directoryURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent("sound.m4a")
        return soundURL
    }
    
    var recordSettings = [
        AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleLossless),
        AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
        AVEncoderBitRateKey : 320000,
        AVNumberOfChannelsKey: 2,
        AVSampleRateKey : 44100.0
    ]
    
    func initNoiseManager() {
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            if (audioSession.respondsToSelector("requestRecordPermission:")) {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("granted")
                    self.noiseManager.record()
                } else {
                    print("Permission to record not granted")
                }
            })
            }
            try noiseManager = AVAudioRecorder(URL: self.directoryURL()!,settings: recordSettings)
            //noiseManager.delegate = self
            //let audioFilename = getDocumentsDirectory().stringByAppendingPathComponent("recording.m4a")
            //let audioURL = NSURL(fileURLWithPath: audioFilename)
            
            noiseManager.meteringEnabled = true
            noiseManager.prepareToRecord()
            noiseManager.record()
        } catch let error as NSError {
            //noiseManager = nil
            print(error.localizedDescription)
        }
    }*/
    
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
    
    
    
    // push a text to the server (messages, links etc.)
    func push(txtObj: TextVisual) {
        let jsonString = txtObj.getJSON()
        //print(jsonString)
        var out :NSOutputStream?
        NSStream.getStreamsToHostWithName(addr, port: port, inputStream: nil, outputStream: &out)
        let outputStream = out!
        outputStream.open()
        let data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
        var buffer = [UInt8](count:data.length, repeatedValue:0)
        data.getBytes(&buffer);
        
        outputStream.write(&buffer, maxLength: data.length);
        
        outputStream.close()
    }
    // push noise values to the server
    func push(noiseObj: NoiseReading) {
        let jsonString = noiseObj.getJSON()
        print(jsonString)
        var out :NSOutputStream?
        NSStream.getStreamsToHostWithName(addr, port: port, inputStream: nil, outputStream: &out)
        let outputStream = out!
        outputStream.open()
        let data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
        var buffer = [UInt8](count:data.length, repeatedValue:0)
        data.getBytes(&buffer);
        
        outputStream.write(&buffer, maxLength: data.length);
        
        outputStream.close()
    }
    
    
    // generate noise values using the function
    // the function should be called everytime a button is pressed
    // the function will generate the data dand push it to to the server
    func noiseCollection(pushOrNot: Bool) -> Float {
        let currentTime :NSDate = NSDate()
        
        let noise = NoiseRecorder()
        noise.record()
        //print(noise.getDecibels())
        let loc : [Double] = [47.0,8.3]
            
        let Noise = NoiseReading(
            uuid: defaults.stringForKey("uuidString")!,
            soundVal: (noise.getDecibels()+180),
            timestamp: UInt64(currentTime.timeIntervalSince1970*1000),
            location: loc
        )
        
        if pushOrNot {
            print(noise.getDecibels()+180)
            push(Noise)
        }
        
        return noise.getDecibels()
    }
    // the function is same as noiseCollection()
    // but to push text messages on the server instead
    func textCollection(txtMsg: String) {
        //print(txtMsg)
        let currentTime :NSDate = NSDate()
        
        //locManager.startUpdatingLocation()
        //let loc : [Double] = [locManager.location!.coordinate.latitude,locManager.location!.coordinate.longitude]
        //locManager.stopUpdatingLocation()
        let loc : [Double] = [47.0,8.3]
        
        let Text = TextVisual(
            uuid: defaults.stringForKey("uuidString")!,
            txtMsg: txtMsg,
            timestamp: UInt64(currentTime.timeIntervalSince1970*1000),
            location: loc
        )
        
        push(Text)
    }


}

