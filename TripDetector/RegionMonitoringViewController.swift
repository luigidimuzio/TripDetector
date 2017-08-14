//
//  RegionMonitoringViewController.swift
//  TripDetector
//
//  Created by Luigi Di Muzio on 14/08/2017.
//  Copyright © 2017 WeSwap. All rights reserved.
//

import UIKit
import MapKit

class RegionMonitoringViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let regionTracker = RegionTracker.shared
    var regionStore: RegionStore!
    var regionToTrack: Region?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        regionStore = RegionStore()
        regionTracker.delegate = self
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        regionToTrack = regionStore.currentRegionToTrack
        
        if regionToTrack == nil || !regionToTrack!.contains(coordinate: regionTracker.currentUserCoordinate) {
            generateNewRegion()
        }
        
        if mapView.overlays.count == 0 {
            updateRegionOverlay()
        }
        
        ensureTrackingForCurrentRegion()
    }
    
    func ensureTrackingForCurrentRegion() {
        if !regionTracker.isMonitoringRegions {
            
            guard let region = regionToTrack else {
                return
            }
            
            do {
                try regionTracker.startTrackingRegion(region: region)
            } catch LocationTrackingError.authorizationDenied {
                // user previously denied access to location.
                // gently bring him to settings to change the authorization
                print("User denied access to location services")
            } catch LocationTrackingError.missingAuthorization {
                // we should require authorization to the user
                regionTracker.askAuthorization()
            } catch {
                // generic error, provide a way to retry
                print("generic error")
            }
        }
    }
    
    func generateNewRegion() {
        let newRegion = createRegionAroundUserCurrentLocation()
        regionStore.addRegion(newRegion)
        regionToTrack = newRegion
        updateRegionOverlay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userCoordinate = regionTracker.currentUserCoordinate
        let userLocation = CLLocation(latitude: userCoordinate.lat, longitude: userCoordinate.lng)
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000, 2000)
        mapView.setRegion(region, animated: true)
    }
    
    func createRegionAroundUserCurrentLocation() -> Region {
        let userCoordinate = regionTracker.currentUserCoordinate
        let region = Region()
        region.center = userCoordinate
        region.isCurrent = true
        return region
    }
    
    func updateRegionOverlay() {
        mapView.removeOverlays(mapView.overlays)
        guard let regionToTrack = regionToTrack else {
            return
        }
        let circle = regionToTrack.toMKCircle()
        mapView.add(circle)
        mapView.setCenter(circle.coordinate, animated: true)
    }
}

extension RegionMonitoringViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleView = MKCircleRenderer(overlay: overlay)
        circleView.strokeColor = UIColor.blue
        return circleView
    }
}

extension RegionMonitoringViewController: RegionTrackerDelegate {
    func didDetectExitFromRegion() {
        if let region = regionStore.currentRegionToTrack {
            regionStore.updateRegion(region, isCurrent: false)
            regionTracker.stopTrackingRegions()
            generateNewRegion()
            ensureTrackingForCurrentRegion()
        }
    }
}
