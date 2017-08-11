//
//  ViewController.swift
//  TripDetector
//
//  Created by Luigi Di Muzio on 10/08/2017.
//  Copyright © 2017 WeSwap. All rights reserved.
//

import UIKit
import RealmSwift


class ViewController: UITableViewController {

    let visitTracker = VisitTracker.shared
    let visitStore = VisitStore()
    
    var visits: Results<Visit> {
        return visitStore.allVisits()
    }
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "VisitCell", bundle: nil), forCellReuseIdentifier: "VisitCell")
        tableView.rowHeight = 80
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        if !visitTracker.isTrackingVisits {
            do {
                try visitTracker.startTrackingVisits()
            } catch VisitTrackingError.authorizationDenied {
                // user previously denied access to location.
                // gently bring him to settings to change the authorization
                print("User denied access to location services")
            } catch VisitTrackingError.missingAuthorization {
                // we should require authorization to the user
                visitTracker.askAuthorization()
            } catch {
                // generic error, provide a way to retry
                print("generic error")
            }
        }
    }
    
    // MARK: TableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitCell", for: indexPath)
        if let cell = cell as? VisitCell {
            let visit = visits[indexPath.row]
            cell.locationCoordinateLabel.text = visit.coordinatesString
            cell.locationStayLabel.text = visit.stayingDatesString
        }
        return cell
    }
    
}

extension ViewController: VisitTrackerDelegate {
    func didTrackVisit(_ visit: Visit) {
        visitStore.addVisit(visit)
    }
}

