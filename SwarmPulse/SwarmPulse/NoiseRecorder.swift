//
//  NoiseRecorder.swift
//  SwarmPulse
//
//  Created by sid on 29/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import Foundation
import AVFoundation

class NoiseRecorder: NSObject, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?
    let audioSession = AVAudioSession.sharedInstance()
    
    var recordSettings = [
        AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleLossless),
        AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
        //AVEncoderBitRateKey : 320000,
        AVNumberOfChannelsKey: 2,
        AVSampleRateKey : 44100.0
    ]
    
    override init() {
        super.init()
        do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                try audioSession.setActive(true)
        } catch let error as NSError {
            //noiseManager = nil
            print(error.localizedDescription)
        }
        
        do {
            try audioRecorder = AVAudioRecorder(URL: directoryURL()!,settings: recordSettings)
            /* Prepare the recorder and then start the recording */
            audioRecorder.delegate = self
            if audioRecorder.prepareToRecord(){
                print("Successfully prepared for record.")
        }
        }catch {
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        /*print("stop")
        if flag{
            print("Successfully stopped the audio recording process")
            if completionHandler != nil {
                completionHandler(success: flag)
            }
        } else {
            print("Stopping the audio recording failed")
        }*/
    }


    func record(){
        print(audioRecorder.record())
    }
    
    func getDecibels() -> Float{
        audioRecorder.meteringEnabled = true
        audioRecorder.updateMeters()
        let soundVal = audioRecorder.peakPowerForChannel(0)
        audioRecorder.deleteRecording()
        audioRecorder.meteringEnabled = false
        return soundVal
    }

    func pause(){
        self.audioRecorder.pause()
    }
    func directoryURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent("sound.m4a")
        return soundURL
    }
}