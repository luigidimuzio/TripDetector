//
//  AppDelegate.swift
//  TripDetector
//
//  Created by Luigi Di Muzio on 10/08/2017.
//  Copyright © 2017 WeSwap. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let visitTracker = VisitTracker.shared
    let visitStore = VisitStore()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        visitTracker.delegate = self
        return true
    }

}

extension AppDelegate: VisitTrackerDelegate {
    func didTrackVisit(_ visit: Visit) {
        visitStore.addVisit(visit)
    }
}

