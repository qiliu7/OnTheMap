//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Kappa on 2020/1/23.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit
import MapKit

class ShowLocationMapViewController: ShowLocationBaseViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
  }
  
  override func handleLocationsResponse(success: Bool, error: Error?) {
    super.handleLocationsResponse(success: success, error: error)

    let locations = OTMModel.locations
    var annotations = [MKAnnotation]()
    
    for location in locations {
      let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
      let first = location.firstName
      let last = location.lastName
      let mediaURL = location.mediaURL
      
      let annotation = MKPointAnnotation()
      annotation.coordinate = coordinate
      annotation.title = "\(first) \(last)"
      annotation.subtitle = mediaURL
      
      annotations.append(annotation)
    }
    mapView.removeAnnotations(mapView.annotations)
    mapView.addAnnotations(annotations)
  }
}

extension ShowLocationMapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    let reuseId = "pin"
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
    
    if pinView == nil {
      pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
      pinView!.canShowCallout = true
      pinView!.pinTintColor = .red
      pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    } else {
      pinView!.annotation = annotation
    }
    
    return pinView
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    setActivityAnimation(busy: true)
    if control == view.rightCalloutAccessoryView {
      if let url = view.annotation?.subtitle {
        openURL(url ?? "")
      }
    }
  }
}
