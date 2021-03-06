//
//  LocationTrackingError.swift
//  TripDetector
//
//  Created by Luigi Di Muzio on 11/08/2017.
//  Copyright © 2017 WeSwap. All rights reserved.
//

import Foundation

enum LocationTrackingError: Error {
    case missingAuthorization
    case authorizationDenied
    case other
}
