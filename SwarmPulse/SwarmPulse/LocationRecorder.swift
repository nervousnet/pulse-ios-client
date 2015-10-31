//
//  LocationRecorder.swift
//  SwarmPulse
//
//  Created by sid on 29/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import Foundation
import CoreLocation

private let _LOCATION = LocationRecorder()

class LocationRecorder{//:NSObject, CLLocationManagerDelegate {
    
    var locManager: CLLocationManager
    var lat: Double = 0.0
    var long: Double = 0.0
    
    init() {
        //super.init()
        self.locManager = CLLocationManager()
        self.locManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }
    
    class var sharedInstance: LocationRecorder {
        return _LOCATION
    }
    
    /*func locManager(didUpdateLocations location: [AnyObject]!) {
        //self.locManager.startUpdatingLocation()
        let locValue:CLLocationCoordinate2D = locManager.location!.coordinate
        self.lat = locValue.latitude
        self.long = locValue.longitude
        print("locations = \(self.lat) \(self.long)")
        self.locManager.stopUpdatingLocation()
    }*/
    func updateLocation() -> Bool{
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus(){
                case .AuthorizedWhenInUse:
                    //dispatch_async(dispatch_get_main_queue()) {
                        //print("Authorized for location services")
                        self.locManager.startUpdatingLocation()
                        //print("Its Here!!")
                        let locValue:CLLocationCoordinate2D = self.locManager.location!.coordinate
                        self.lat = locValue.latitude
                        self.long = locValue.longitude
                        //print("locations = \(self.lat) \(self.long)")
                        self.locManager.stopUpdatingLocation()
                    //}
                    return false
                default :
                    print("Not Authorized for location services")
                    //dispatch_async(dispatch_get_main_queue()) {
                        self.locManager.requestWhenInUseAuthorization()
                    //}
                    return true
            }
        }else {
            //dispatch_async(dispatch_get_main_queue()) {
                self.locManager.requestWhenInUseAuthorization()
            //}
            return true
        }
    }
    
    func getLat() -> Double {
        return self.lat
    }
    
    func getLong() -> Double {
        return self.long
    }
    
}