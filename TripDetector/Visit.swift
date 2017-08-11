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
    dynamic var coordinate: Coordinate?
}

extension Visit {

    convenience init(clVisit: CLVisit) {
        self.init()
        arrivalDate = clVisit.arrivalDate
        departureDate = clVisit.departureDate
        coordinate = Coordinate()
        coordinate?.lat = clVisit.coordinate.latitude
        coordinate?.lng = clVisit.coordinate.longitude
    }
    
    var coordinatesString: String {
        guard let lat = coordinate?.lat, let lng = coordinate?.lng else {
            return "N/A"
        }
        return "\(lat), \(lng)"
    }
    
    var stayingDatesString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return "\(dateFormatter.string(from: arrivalDate))-\(dateFormatter.string(from: departureDate))"
    }
}
