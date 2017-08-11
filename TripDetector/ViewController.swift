//
//  ViewController.swift
//  TripDetector
//
//  Created by Luigi Di Muzio on 10/08/2017.
//  Copyright © 2017 WeSwap. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let visitTracker = VisitTracker()
    let visitStore = VisitStore()
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        if !visitTracker.isTrackingVisits {
            do {
                try visitTracker.startTrackingVisits()
            } catch VisitTrackingError.authorizationDenied {
                // user previously denied access to location.
                // gently bring him to settings to change the authorization
                print("User denied access to location services")
            } catch VisitTrackingError.missingAuthorization {
                // we should require authorization to the user
                visitTracker.askAuthorization()
            } catch {
                // generic error, provide a way to retry
                print("generic error")
            }
        }
    }
    
}

extension ViewController: VisitTrackerDelegate {
    func didTrackVisit(_ visit: Visit) {
        visitStore.addVisit(visit)
    }
}

