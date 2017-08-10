//
//  Connection.swift
//  SwarmPulse
//
//  Created by sid on 30/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import Foundation

private let _CONN = Connection()

class Connection: NSObject, StreamDelegate {
    var host:String?
    var port:Int?
    var outputStream: OutputStream?
    var stringToWrite: String = ""
    var previousString: String = ""
    
    class var sharedInstance: Connection {
        return _CONN
    }
    
    func connect(_ host: String, port: Int) {
        
        self.host = host
        self.port = port
        
        Stream.getStreamsToHost(withName: host, port: port, inputStream: nil, outputStream: &outputStream)
        
        if outputStream != nil {
            
            // Set delegate
            outputStream!.delegate = self
            
            // Schedule
            outputStream!.schedule(in: .main, forMode: RunLoopMode.defaultRunLoopMode)
            
            print("Start open()")
            
            // Open!
            //inputStream!.open()
            outputStream!.open()
            //outputStream!.close()
        }
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        if aStream === outputStream {
            switch eventCode {
            case Stream.Event.errorOccurred:
                print("output: ErrorOccurred: \(aStream.streamError?.description)")
            case Stream.Event.openCompleted:
                print("output: OpenCompleted")
            case Stream.Event.hasSpaceAvailable:
                //print("output: HasSpaceAvailable")
                // Here you can write() to `outputStream`
                if self.ifWrite() {
                    //print(self.stringToWrite)
                    let data: Data = self.stringToWrite.data(using: String.Encoding.utf8)!
                    var buffer = [UInt8](repeating: 0, count: data.count)
                    (data as NSData).getBytes(&buffer);
                    self.outputStream!.write(&buffer, maxLength: data.count);
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
