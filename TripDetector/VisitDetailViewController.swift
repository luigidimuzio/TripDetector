//
//  VisitDetailViewController.swift
//  TripDetector
//
//  Created by Luigi Di Muzio on 14/08/2017.
//  Copyright © 2017 WeSwap. All rights reserved.
//

import UIKit
import MapKit

class VisitDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    var visit: Visit?
    
    override func viewWillAppear(_ animated: Bool) {
        
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        nameLabel.text = visit?.place?.name ?? "N/A"
        addressLabel.text = visit?.place?.address ?? "N/A"
        cityLabel.text = visit?.place?.city ?? "N/A"
        countryLabel.text = visit?.place?.country ?? "N/A"
        
        arrivalLabel.text = "N/A"
        departureLabel.text = "N/A"
        if let arrivalDate = visit?.arrivalDate {
            arrivalLabel.text = dateFormatter.string(from: arrivalDate)
        }
        if let departureDate = visit?.arrivalDate {
            departureLabel.text = dateFormatter.string(from: departureDate)
        }
        
        if let coordinate = visit?.coordinate {
            let visitLocation = CLLocation(latitude: coordinate.lat, longitude: coordinate.lng)
            let region = MKCoordinateRegionMakeWithDistance(visitLocation.coordinate, 500, 500)
            mapView.setRegion(region, animated: false)
            let annotation = MKPointAnnotation()
            annotation.coordinate = visitLocation.coordinate
            mapView.addAnnotation(annotation)
        }
    }
}
