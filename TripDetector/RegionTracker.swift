//
//  RegionTracker.swift
//  TripDetector
//
//  Created by Luigi Di Muzio on 11/08/2017.
//  Copyright © 2017 WeSwap. All rights reserved.
//

import Foundation

import Foundation
import CoreLocation



protocol RegionTrackerDelegate: class {
    func didDetectExitFromRegion()
}

class RegionTracker: NSObject {
    
    static let shared = RegionTracker()
    
    fileprivate let locationManager: CLLocationManager
    weak var delegate: RegionTrackerDelegate?
    
    override init() {
        locationManager = CLLocationManager()
        locationManager.activityType = .other
        locationManager.pausesLocationUpdatesAutomatically = true
        
        super.init()
        locationManager.delegate = self
    }
    
    var isTrackingVisits: Bool = false
    
    func askAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func startTrackingRegion(region: CLRegion) throws {
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            throw LocationTrackingError.authorizationDenied
        case .notDetermined:
            throw LocationTrackingError.missingAuthorization
        case .restricted:
            throw LocationTrackingError.other
        case .authorizedAlways:
            locationManager.startMonitoring(for: Region)
            isTrackingVisits = true
        default:
            return
        }
    }
}

extension RegionTracker: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        delegate?.didDetectExitFromRegion()
    }
    
    func locationManager(_ manager: CLLocationManager,  didFailWithError error: Error) {
        //        if let error = error as? NSError, error.code == .denied {
        //            // Location updates are not authorized.
        //            locationManager.stopMonitoringVisits()
        //            return
        //        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}
