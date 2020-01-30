//
//  LocationPostingViewController.swift
//  OnTheMap
//
//  Created by Kappa on 2020/1/24.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit
import CoreLocation

class LocationPostingViewController: UIViewController {
  
  @IBOutlet weak var locationTextField: UITextField!
  @IBOutlet weak var mediaURLTextField: UITextField!
  @IBOutlet weak var findLocationButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI() {
    findLocationButton.layer.cornerRadius = findLocationButton.frame.height/8
  }
  
  
  @IBAction func findLocationTapped(_ sender: Any) {
    
    if let locationString = locationTextField.text, let mediaURLString = mediaURLTextField.text {
      
      if locationString != "" && mediaURLString != "" {
        getCoordinateForLocation(addressString: locationString) { (placemark, error) in
          guard let placemark = placemark else {
            self.showAlert(title: "Error", message: error?.localizedDescription ?? "Given Location Can't Be Retrieved" )
            return
          }
          
          let confirmLocationVC = self.storyboard!.instantiateViewController(identifier: Constants.currentLocationVCStoryboardId) as! ConfirmLocationViewController
          confirmLocationVC.coordinate = placemark.location!.coordinate
          confirmLocationVC.addressString = "\(placemark.name ?? "") \(placemark.administrativeArea ?? "") \(placemark.country ?? "")"
          confirmLocationVC.mediaURLString = mediaURLString
          self.navigationController?.pushViewController(confirmLocationVC, animated: true)
        }
      } else {
        self.showAlert(title: "Error", message: "Please Fill in Both Your Location and the Media Link")
        
      }
    }
  }
  
  private func getCoordinateForLocation( addressString : String, completionHandler: @escaping(CLPlacemark?, Error?) -> Void ) {
    
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(addressString) { (placemarks, error) in
      if error == nil {
        if let placemark = placemarks?[0] {
          completionHandler(placemark, nil)
          return
        }
      }
      completionHandler(nil, error)
    }
  }
}
