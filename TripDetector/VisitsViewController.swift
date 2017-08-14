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
    var visitStore: VisitStore!
    
    var visits: Results<Visit> {
        return visitStore.allVisits()
    }
    
    override func viewDidLoad() {
        visitStore = VisitStore()
        tableView.register(UINib(nibName: "VisitCell", bundle: nil), forCellReuseIdentifier: "VisitCell")
        tableView.rowHeight = 80
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        if !visitTracker.isTrackingVisits {
            do {
                try visitTracker.startTrackingVisits()
            } catch LocationTrackingError.authorizationDenied {
                // user previously denied access to location.
                // gently bring him to settings to change the authorization
                print("User denied access to location services")
            } catch LocationTrackingError.missingAuthorization {
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
            let title = visit.place?.name ?? visit.place?.address ?? visit.coordinatesString
            cell.locationCoordinateLabel.text = title
            cell.locationStayLabel.text = visit.stayingDatesString
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let visitVC = segue.destination as? VisitDetailViewController,
            let visit = sender as? Visit {
            visitVC.visit = visit
        }
    }
    
    //MARK: TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let visit = visits[indexPath.row]
        performSegue(withIdentifier: "goToVisitDetail", sender: visit)
    }
    
}

extension ViewController: VisitTrackerDelegate {
    func didTrackVisit(_ visit: Visit) {
        visitStore.addVisit(visit)
    }
}

