//
//  Visit.swift
//  TripDetector
//
//  Created by Luigi Di Muzio on 10/08/2017.
//  Copyright © 2017 WeSwap. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

class Coordinate: Object {
    dynamic var lat: Double = 0
    dynamic var lng: Double = 0
}

class Visit: Object {
    dynamic var arrivalDate = Date()
    dynamic var departureDate = Date()
    dynamic var coordinate = Coordinate()
}

extension Visit {

    convenience init(clVisit: CLVisit) {
        self.init()
        arrivalDate = clVisit.arrivalDate
        departureDate = clVisit.departureDate
        coordinate.lat = clVisit.coordinate.latitude
        coordinate.lng = clVisit.coordinate.longitude
    }
}
