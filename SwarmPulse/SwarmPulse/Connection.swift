//
//  Connection.swift
//  SwarmPulse
//
//  Created by sid on 30/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import Foundation

private let _CONN = Connection()

class Connection: NSObject, NSStreamDelegate {
    var host:String?
    var port:Int?
    var outputStream: NSOutputStream?
    var stringToWrite: String = ""
    var previousString: String = ""
    
    class var sharedInstance: Connection {
        return _CONN
    }
    
    func connect(host: String, port: Int) {
        
        self.host = host
        self.port = port
        
        NSStream.getStreamsToHostWithName(host, port: port, inputStream: nil, outputStream: &outputStream)
        
        if outputStream != nil {
            
            // Set delegate
            outputStream!.delegate = self
            
            // Schedule
            outputStream!.scheduleInRunLoop(.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            
            print("Start open()")
            
            // Open!
            //inputStream!.open()
            outputStream!.open()
            //outputStream!.close()
        }
    }
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        if aStream === outputStream {
            switch eventCode {
            case NSStreamEvent.ErrorOccurred:
                print("output: ErrorOccurred: \(aStream.streamError?.description)")
            case NSStreamEvent.OpenCompleted:
                print("output: OpenCompleted")
            case NSStreamEvent.HasSpaceAvailable:
                //print("output: HasSpaceAvailable")
                // Here you can write() to `outputStream`
                if self.ifWrite() {
                    //print(self.stringToWrite)
                    let data: NSData = self.stringToWrite.dataUsingEncoding(NSUTF8StringEncoding)!
                    var buffer = [UInt8](count:data.length, repeatedValue:0)
                    data.getBytes(&buffer);
                    self.outputStream!.write(&buffer, maxLength: data.length);
                    self.previousString = self.stringToWrite
                    self.outputStream!.close()
                }
            default:
                break
            }
        }
    }
    
    func ifWrite() -> Bool {
        if stringToWrite.isEmpty || self.stringToWrite == self.previousString {
            return false
        } else{
            return true
        }
    }
    
}