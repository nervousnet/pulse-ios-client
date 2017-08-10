//
//  NoiseRecorder.swift
//  SwarmPulse
//
//  Created by sid on 29/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import Foundation
import AVFoundation

private let _NOISE = NoiseRecorder()

class NoiseRecorder: NSObject, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    let audioSession = AVAudioSession.sharedInstance()
    var levelTimer = Timer()
    var soundVal: Float = 0.0
    
    var recordSettings = [
        AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless as UInt32),
        AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
        //AVEncoderBitRateKey : 320000,
        AVNumberOfChannelsKey: 2,
        AVSampleRateKey : 44100.0
    ]
    
    override init() {
        super.init()
        //print("---------------")
        do {
            if (audioSession.responds(to: "requestRecordPermission:")) {
                try self.audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                try self.audioSession.setActive(true)
                self.audioSession.requestRecordPermission({(allowed: Bool) -> Void in
                    DispatchQueue.main.async {
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
            try self.audioRecorder = AVAudioRecorder(url: directoryURL()!,settings: recordSettings)
            //self.audioRecorder.delegate = self
            //print(self.audioRecorder.prepareToRecord())
            if self.audioRecorder.prepareToRecord(){
                print("Successfully prepared for recording.")
                self.audioRecorder.isMeteringEnabled = true
                self.audioRecorder.record()
                
                //self.levelTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("updateNoise"), userInfo: nil, repeats: true)
            } else {
                print("Could not prepare for recording.")
            }
        }catch {
            print("AudioRecorder Error")
        }
    }
    
    class var sharedInstance: NoiseRecorder {
        return _NOISE
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
        self.audioRecorder.isMeteringEnabled = true
        self.audioRecorder.record()
        //self.levelTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("updateNoise"), userInfo: nil, repeats: true)

    }
    
    func updateNoise(){
        
        //dispatch_sync(dispatch_get_main_queue()) {
        self.audioSession.requestRecordPermission({(allowed: Bool) -> Void in
                if allowed {
                    self.audioRecorder.updateMeters()
                    self.soundVal = self.audioRecorder.peakPower(forChannel: 0)
                    //NSLog(String(self.soundVal))
                } else {
                    self.soundVal = 0.0
                }
        })
        //}
    }
    
    func getNoise() -> Float {
        self.updateNoise()
        return self.soundVal
    }
    
    func stopNoise() {
        self.levelTimer.invalidate()
        self.audioRecorder.isMeteringEnabled = false
        self.audioRecorder.stop()
        self.audioRecorder.deleteRecording()
    }

    func directoryURL() -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent("sound.m4a")
        return soundURL
    }
}
