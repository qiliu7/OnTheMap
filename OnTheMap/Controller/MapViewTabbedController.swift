//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Kappa on 2020/1/23.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit
import MapKit

class MapViewTabbedController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  lazy var activityIndicator = createActivityIndicatorView()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    view.addSubview(activityIndicator)
    
    mapView.delegate = self
    setActivityAnimation(busy: true)
    OTMClient.getRecentStudentLocations(Constants.numberOfLocations, completion: handleLocationsResponse(success:error:))
  }
  
  func handleLocationsResponse(success: Bool, error: Error?) {
    guard success else {
      self.showAlert(title: "Get Locations Failed", message: error?.localizedDescription ?? "")
      return
    }
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
    // remove existing annotations
    self.mapView.removeAnnotations(mapView.annotations)
    // place new annotations
    self.mapView.addAnnotations(annotations)
    setActivityAnimation(busy: false)
  }
  
  @IBAction func refreshTapped(_ sender: Any) {
    setActivityAnimation(busy: true)
    OTMClient.getRecentStudentLocations(Constants.numberOfLocations, completion: handleLocationsResponse(success:error:))
  }
  
  @IBAction func addButtonTapped() {
    // check if user has already posted a location
    if OTMModel.objectId != nil {
      showAlert(title: "You Have Already Posted a Location", message: "Do you want to update it?", cancelable: true, okHandler: { _ in
        self.performSegue(withIdentifier: Constants.postNewLocation, sender: nil)})
    } else {
      performSegue(withIdentifier: Constants.postNewLocation, sender: nil)
    }
  }
  
  @IBAction func logoutTapped(_ sender: Any) {
    setActivityAnimation(busy: true)
    OTMClient.logout(completion: handleLogoutResponse(success:error:))
  }

  private func handleLogoutResponse(success: Bool, error: Error?) {
    setActivityAnimation(busy: false)
    if success {
      self.dismiss(animated: true, completion: nil)
    } else {
      self.showAlert(title: "Logout Error", message: error?.localizedDescription ?? "")
    }
  }
  private func setActivityAnimation(busy: Bool) {
    busy ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
  }
  
  private func handleOpenURLComplete(success: Bool) {
    setActivityAnimation(busy: false)
    guard success else {
      self.showAlert(title: "Error", message: "Invalid URL")
      return
    }
  }
}
extension MapViewTabbedController: MKMapViewDelegate {
  
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
      let app = UIApplication.shared
      if let toOpen = view.annotation?.subtitle {
        app.open(URL(string: toOpen ?? "")!, options: [:], completionHandler: handleOpenURLComplete(success:))
      }
    }
  }
}
