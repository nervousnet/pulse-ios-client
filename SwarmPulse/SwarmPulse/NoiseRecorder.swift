//
//  NoiseRecorder.swift
//  SwarmPulse
//
//  Created by sid on 29/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import Foundation
import AVFoundation

class NoiseRecorder: NSObject, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    let audioSession = AVAudioSession.sharedInstance()
    var levelTimer = NSTimer()
    var soundVal: Float = 0.0
    
    var recordSettings = [
        AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleLossless),
        AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
        //AVEncoderBitRateKey : 320000,
        AVNumberOfChannelsKey: 2,
        AVSampleRateKey : 44100.0
    ]
    
    override init() {
        super.init()
        //print("---------------")
        do {
            if (audioSession.respondsToSelector("requestRecordPermission:")) {
                try self.audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                try self.audioSession.setActive(true)
                self.audioSession.requestRecordPermission({(allowed: Bool) -> Void in
                    dispatch_async(dispatch_get_main_queue()) {
                        if allowed {
                            print("Granted")
                        } else {
                            print("Not Granted")
                        }
                    }
                })
            }
        } catch{
            print("AudioSession Error")
        }
        
        do {
            try self.audioRecorder = AVAudioRecorder(URL: directoryURL()!,settings: recordSettings)
            //self.audioRecorder.delegate = self
            //print(self.audioRecorder.prepareToRecord())
            if self.audioRecorder.prepareToRecord(){
                print("Successfully prepared for recording.")
                self.audioRecorder.meteringEnabled = true
                self.audioRecorder.record()
                
                //self.levelTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("updateNoise"), userInfo: nil, repeats: true)
            } else {
                print("Could not prepare for recording.")
            }
        }catch {
            print("AudioRecorder Error")
        }
    }
    
    //func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        /*print("stop")
        if flag{
            print("Successfully stopped the audio recording process")
            if completionHandler != nil {
                completionHandler(success: flag)
            }
        } else {
            print("Stopping the audio recording failed")
        }*/
    //}
    
    func startNoise() {
        self.audioRecorder.prepareToRecord()
        self.audioRecorder.meteringEnabled = true
        self.audioRecorder.record()
        //self.levelTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("updateNoise"), userInfo: nil, repeats: true)

    }
    
    func updateNoise(){
        self.audioSession.requestRecordPermission({(allowed: Bool) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                if allowed {
                    self.audioRecorder.updateMeters()
                    self.soundVal = self.audioRecorder.peakPowerForChannel(0)
                    //NSLog(String(self.soundVal))
                } else {
                    self.soundVal = 0.0
                }
            }
        })
    }
    
    func getNoise() -> Float {
        self.updateNoise()
        return self.soundVal
    }
    
    func stopNoise() {
        self.levelTimer.invalidate()
        self.audioRecorder.meteringEnabled = false
        self.audioRecorder.stop()
        self.audioRecorder.deleteRecording()
    }

    func directoryURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent("sound.m4a")
        return soundURL
    }
}