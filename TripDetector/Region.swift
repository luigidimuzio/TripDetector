//
//  Region.swift
//  TripDetector
//
//  Created by Luigi Di Muzio on 11/08/2017.
//  Copyright © 2017 WeSwap. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation
import MapKit

class Region: Object {
    dynamic var center: Coordinate? = Coordinate()
    dynamic var radius: Double = 20
    dynamic var isCurrent: Bool = false
    
    func contains(coordinate: Coordinate) -> Bool {
        if self.toCLCircularRegion().contains(coordinate.toCLCoordinate()) {
            return true
        }
        return false
    }
    
    func toMKCircle() -> MKCircle {
        let coordinate = center?.toCLCoordinate()
        return MKCircle(center: coordinate!, radius: radius)
    }
    
    func toCLCircularRegion() -> CLCircularRegion {
        return CLCircularRegion(center: center!.toCLCoordinate(), radius: radius, identifier: "")
    }
}
