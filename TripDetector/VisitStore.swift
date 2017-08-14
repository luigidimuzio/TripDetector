//
//  VisitStore.swift
//  TripDetector
//
//  Created by Luigi Di Muzio on 10/08/2017.
//  Copyright © 2017 WeSwap. All rights reserved.
//

import Foundation
import RealmSwift

class VisitStore {
    
    let realm = try! Realm()
    let geocoder = Geocoder()
    
    init() {
        updateVisits()
    }
    
    private func updateVisits() {
        let visits = allVisits()
        for visit in visits {
            if visit.place == nil, let coordinate = visit.coordinate {
                geocoder.getPlace(from: coordinate) { [weak self] place in
                    try! self?.realm.write {
                        visit.place = place
                    }
                }
            }
        }
    }
    
    func allVisits() -> Results<Visit> {
        let visits = realm.objects(Visit.self)
        return visits
    }
    
    func addVisit(_ visit: Visit) {
        try! realm.write {
            realm.add(visit)
        }
    }
}
