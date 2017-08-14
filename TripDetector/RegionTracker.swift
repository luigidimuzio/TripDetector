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
    
    var isMonitoringRegions: Bool = false
    
    var currentUserCoordinate: Coordinate {
        let coordinate = Coordinate()
        coordinate.lat = locationManager.location?.coordinate.latitude ?? 0
        coordinate.lng = locationManager.location?.coordinate.longitude ?? 0
        return coordinate
    }
    
    func askAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func startTrackingRegion(region: Region) throws {
        
        let centerCoordinate = CLLocationCoordinate2DMake(region.center?.lat ?? 0, region.center?.lng ?? 0)
        let circularRegion = CLCircularRegion(center: centerCoordinate, radius: region.radius, identifier: "tracking-region")

        switch CLLocationManager.authorizationStatus() {
        case .denied:
            throw LocationTrackingError.authorizationDenied
        case .notDetermined:
            throw LocationTrackingError.missingAuthorization
        case .restricted:
            throw LocationTrackingError.other
        case .authorizedAlways:
            locationManager.startMonitoring(for: circularRegion)
            isMonitoringRegions = true
        default:
            return
        }
    }
    
    func stopTrackingRegions() {
        let regions = locationManager.monitoredRegions
        regions.forEach { (region) in
            locationManager.stopMonitoring(for: region)
        }
        isMonitoringRegions = false
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
