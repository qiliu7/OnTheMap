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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    placePinOnMap()
  }
  
  func placePinOnMap() {
    
    var locations = [StudentLocation]()
    var annotations = [MKAnnotation]()
    
    OTMClient.getStudentLocations { (success, error) in
      guard success else {
        //TODO: show alert
        print(error.debugDescription)
        return
      }
      locations = OTMModel.locations
      
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
      self.mapView.addAnnotations(annotations)
    }
  }
}
