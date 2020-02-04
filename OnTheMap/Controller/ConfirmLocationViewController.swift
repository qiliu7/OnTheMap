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
  @IBOutlet weak var submitButton: UIButton!
  
  var coordinate: CLLocationCoordinate2D!
  var addressString: String!
  var mediaURLString: String!
  lazy var activityIndicator = createActivityIndicatorView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    setupUI()
    placePin()
  }

  private func setupUI() {
    submitButton.layer.cornerRadius = submitButton.frame.height/8
    view.addSubview(activityIndicator)
  }
  
  private func placePin(){
    mapView.setRegion(MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000), animated: true)
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    annotation.title = addressString
    mapView.addAnnotation(annotation)
  }
  
  @IBAction func submitTapped() {
    setActivityAnimation(busy: true)
    
    // retrieve user name if is the first time posting a location
    if OTMModel.firstName == nil {
      OTMClient.getUserData(completion: handleUserDataResponse(success:error:))
    } else {
      updateLocation()
    }
  }
  
  private func handleUserDataResponse(success: Bool, error: Error?) {
     if !success {
       showAlert(title: "Error", message: "Can't retrive your full name, will use a default name", okHandler: postNewLocation(_:))
     } else {
      postNewLocation()
    }
   }

  private func postNewLocation(_ action: UIAlertAction? = nil) {
    let newLocation = LocationRequest(uniqueKey: OTMClient.Auth.userId, firstName: OTMModel.firstName!, lastName: OTMModel.lastName!, mapString: addressString, mediaURL: mediaURLString, latitude: coordinate.latitude, longitude: coordinate.longitude)
    
    OTMClient.postStudentLocation(location: newLocation, completion: handleLocationResponse(success:error:))
  }
  
  private func updateLocation() {
    // send PUT request if user already posted
    let updatedLocation = LocationRequest(uniqueKey: OTMClient.Auth.userId, firstName: OTMModel.firstName!, lastName: OTMModel.lastName!, mapString: addressString, mediaURL: mediaURLString, latitude: coordinate.latitude, longitude: coordinate.longitude)
    
    OTMClient.putStudentLocation(objectId: OTMModel.objectId!, location: updatedLocation, completion: handleLocationResponse(success:error:))
  }
  
  private func setActivityAnimation(busy: Bool) {
    busy ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
  }

  private func handleLocationResponse(success: Bool, error: Error?) {
    if success {
      dismiss(animated: true, completion: nil)
    } else {
      showAlert(title: "Error", message: error?.localizedDescription ?? "Failed to submit your location.")
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
  
  func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
    setActivityAnimation(busy: true)
  }
  func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
    setActivityAnimation(busy: false)
  }
  
}
