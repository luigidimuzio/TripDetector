//
//  VisitTracker.swift
//  TripDetector
//
//  Created by Luigi Di Muzio on 10/08/2017.
//  Copyright © 2017 WeSwap. All rights reserved.
//

import Foundation
import CoreLocation

enum VisitTrackingAuthorization {
    case undetermined
    case restricted
    case denied
    case always
    case whenInUse
}

enum VisitTrackingError: Error {
    case missingAuthorization
    case authorizationDenied
    case other
}

protocol VisitTrackerDelegate: class {
    func didTrackVisit(_ visit: Visit)
}

class VisitTracker: NSObject {
    
    fileprivate let locationManager: CLLocationManager
    fileprivate weak var delegate: VisitTrackerDelegate?
    
    override init() {
        locationManager = CLLocationManager()
        locationManager.activityType = .other
        locationManager.pausesLocationUpdatesAutomatically = true

        super.init()
        locationManager.delegate = self
    }
    
    deinit {
        locationManager.stopMonitoringVisits()
    }
    
    var isTrackingVisits: Bool = false
    
    func askAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func startTrackingVisits() throws {
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            throw VisitTrackingError.authorizationDenied
        case .notDetermined:
            throw VisitTrackingError.missingAuthorization
        case .restricted:
            throw VisitTrackingError.other
        case .authorizedAlways:
            locationManager.startMonitoringVisits()
            isTrackingVisits = true
        default:
            return
        }
    }
}

extension VisitTracker: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        //HANDLE THE VISIT
        let trackedVisit = Visit(clVisit: visit)
        delegate?.didTrackVisit(trackedVisit)
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
