//
//  RegionStore.swift
//  TripDetector
//
//  Created by Luigi Di Muzio on 14/08/2017.
//  Copyright © 2017 WeSwap. All rights reserved.
//

import Foundation
import RealmSwift

class RegionStore {
    
    let realm = try! Realm()
    
    func allRegions() -> Results<Region> {
        let regions = realm.objects(Region.self)
        return regions
    }
    
    func addRegion(_ region: Region) {
        try! realm.write {
            realm.add(region)
        }
    }
    
    func updateRegion(_ region: Region, isCurrent: Bool) {
        try! realm.write {
            region.isCurrent = isCurrent
        }
    }
    
    var currentRegionToTrack: Region? {
        let regions = realm.objects(Region.self).filter("isCurrent = true")
        guard regions.count > 0 else {
            return nil
        }
        let region = regions[0]
        return region
    }
}
