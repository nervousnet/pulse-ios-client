//
//  LocationRecorder.swift
//  SwarmPulse
//
//  Created by sid on 29/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import Foundation
import CoreLocation

class LocationRecorder{//:NSObject, CLLocationManagerDelegate {
    
    let locManager: CLLocationManager
    var lat: Double = 0.0
    var long: Double = 0.0
    
    init() {
        //super.init()
        locManager = CLLocationManager()
        self.locManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }
    
    /*func locManager(didUpdateLocations location: [AnyObject]!) {
        //self.locManager.startUpdatingLocation()
        let locValue:CLLocationCoordinate2D = locManager.location!.coordinate
        self.lat = locValue.latitude
        self.long = locValue.longitude
        print("locations = \(self.lat) \(self.long)")
        self.locManager.stopUpdatingLocation()
    }*/
    func updateLocation() {
        self.locManager.startUpdatingLocation()
        let locValue:CLLocationCoordinate2D = locManager.location!.coordinate
        self.lat = locValue.latitude
        self.long = locValue.longitude
        //print("locations = \(self.lat) \(self.long)")
        self.locManager.stopUpdatingLocation()
    }
    
    func getLat() -> Double {
        return self.lat
    }
    
    func getLong() -> Double {
        return self.long
    }
    
}