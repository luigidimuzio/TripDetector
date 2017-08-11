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
