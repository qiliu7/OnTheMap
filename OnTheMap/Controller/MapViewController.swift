//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Kappa on 2020/1/23.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  var locations = [StudentLocation]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
    OTMClient.getRecentStudentLocations(100, completion: handleLocationsResponse(success:error:))
  }

  
  func handleLocationsResponse(success: Bool, error: Error?) {
    
    locations = OTMModel.locations
    var annotations = [MKAnnotation]()
    
    for loc in locations {
      let coordinate = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
      let first = loc.firstName
      let last = loc.lastName
      let mediaURL = loc.mediaURL
      
      let annotation = MKPointAnnotation()
      annotation.coordinate = coordinate
      annotation.title = "\(first) \(last)"
      annotation.subtitle = mediaURL
      
      annotations.append(annotation)
    }
    // remove existing annotations
    self.mapView.removeAnnotations(mapView.annotations)
    // place new annotations
    self.mapView.addAnnotations(annotations)
  }
  
  @IBAction func refreshTapped(_ sender: Any) {
    OTMClient.getRecentStudentLocations(2, completion: handleLocationsResponse(success:error:))
  }
  
}


extension MapViewController: MKMapViewDelegate {
  
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
    
    if control == view.rightCalloutAccessoryView {
      let app = UIApplication.shared
      if let toOpen = view.annotation?.subtitle {
        app.open(URL(string: toOpen ?? "")!, options: [:], completionHandler: nil)
      }
    }
  }
}
