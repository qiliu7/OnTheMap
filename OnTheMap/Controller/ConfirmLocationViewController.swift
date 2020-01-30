//
//  CurrentLocationViewController.swift
//  OnTheMap
//
//  Created by Kappa on 2020/1/25.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  var coordinate: CLLocationCoordinate2D!
  var addressString: String!
  var mediaURLString: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    // retrieve user name
    OTMClient.getUserData { (success, error) in
      if !success {
        self.showAlert(title: "Error", message: "Can't retrive your full name, will use a default name")
      }
    }
    placePin()
  }
  
  private func placePin(){
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    annotation.title = addressString
    mapView.addAnnotation(annotation)
  }
  
  @IBAction func submitTapped() {
    let newLocation = LocationRequest(uniqueKey: OTMClient.Auth.accountId, firstName: OTMClient.Auth.firstName ?? "John", lastName: OTMClient.Auth.lastName ?? "Doe", mapString: addressString, mediaURL: mediaURLString, latitude: coordinate.latitude, longitude: coordinate.longitude)
    
    // retrive previous posted objectId if any
    let objectId = OTMModel.objectId != nil ? OTMModel.objectId : getPreviousObjectId()
    if let objectId = objectId {
      print("PUT")
      OTMClient.putStudentLocation(objectId: objectId, location: newLocation, completion: handleLocationResponse(success:error:))
    } else {
      print("POST")
      OTMClient.postStudentLocation(location: newLocation, completion: handleLocationResponse(success:error:))
    }
  }
  
  // return objectId of previously posted location
  private func getPreviousObjectId() -> String? {
    let postedLocations = OTMModel.locations
    for location in postedLocations {
      if location.uniqueKey == OTMClient.Auth.accountId {
        let objectId = location.objectId
        return objectId
      }
    }
    return nil
  }
  
  private func handleLocationResponse(success: Bool, error: Error?) {
    if success {
      dismiss(animated: true, completion: nil)
    } else {
      self.showAlert(title: "Error", message: error?.localizedDescription ?? "Failed to submit your location.")
    }
  }
}
  
extension ConfirmLocationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
      pinView.canShowCallout = true
      pinView.pinTintColor = .red
      
      return pinView
    }
}
