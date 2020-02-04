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
  
  lazy var activityIndicator = createActivityIndicatorView()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    configureTextFields()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    subscribeToKeyboardNotifications()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeToKeyboardNotifications()
  }
  
  func setupUI() {
    findLocationButton.layer.cornerRadius = findLocationButton.frame.height/8
    view.addSubview(activityIndicator)
  }
  
  func configureTextFields() {
    locationTextField.delegate = self
    locationTextField.returnKeyType = .done
    mediaURLTextField.delegate = self
    mediaURLTextField.returnKeyType = .done
  }
  
  @IBAction func findLocationTapped(_ sender: Any) {
    
    if let locationString = locationTextField.text, let mediaURLString = mediaURLTextField.text {
      
      if locationString != "" && mediaURLString != "" {
        setGeocoding(true)
        getCoordinateForLocation(addressString: locationString) { (placemark, error) in
          self.setGeocoding(false)
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
        showAlert(title: "Error", message: "Please Fill in Both Your Location and the Media Link")
        
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
  
  func setGeocoding(_ coding: Bool) {
     locationTextField.isEnabled = !coding
     mediaURLTextField.isEnabled = !coding
     findLocationButton.isEnabled = !coding
     coding ? activityIndicator.startAnimating(): activityIndicator.stopAnimating()
   }
}

extension LocationPostingViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

