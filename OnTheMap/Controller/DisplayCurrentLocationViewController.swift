//
//  CurrentLocationViewController.swift
//  OnTheMap
//
//  Created by Kappa on 2020/1/25.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit
import MapKit

class DisplayCurrentLocationViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  var coordinate: CLLocationCoordinate2D!
  var addressString: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    placePin()
  }
  
  func placePin(){
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    annotation.title = addressString
    mapView.addAnnotation(annotation)
  }
}

extension DisplayCurrentLocationViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
    pinView.canShowCallout = true
    pinView.pinTintColor = .red
    
    return pinView
  }
}
