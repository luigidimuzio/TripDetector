//
//  Geocoder.swift
//  TripDetector
//
//  Created by Luigi Di Muzio on 14/08/2017.
//  Copyright © 2017 WeSwap. All rights reserved.
//

import Foundation
import CoreLocation

class Geocoder {
    
    func getPlace(from coordinate: Coordinate, completion: @escaping (Place?) -> ()) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.lat, longitude: coordinate.lng)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                let place = Place(placemark: placemark)
                completion(place)
            } else {
                completion(nil)
            }
        }
    }
}
