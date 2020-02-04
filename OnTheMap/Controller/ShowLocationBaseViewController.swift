//
//  ShowLocationBaseViewController.swift
//  OnTheMap
//
//  Created by Kappa on 2020-02-03.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class ShowLocationBaseViewController: UIViewController {
  
  lazy var activityIndicator = createActivityIndicatorView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    view.addSubview(activityIndicator)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setActivityAnimation(busy: true)
    OTMClient.getRecentStudentLocations(Constants.numberOfLocations, completion: handleLocationsResponse(success:error:))
  }
  
  @objc func refreshTapped(_ sender: Any) {
    setActivityAnimation(busy: true)
    OTMClient.getRecentStudentLocations(Constants.numberOfLocations, completion: handleLocationsResponse(success:error:))
  }
  
  @objc func addButtonTapped() {
    // check if user has already posted a location
    if OTMModel.objectId != nil {
      showAlert(title: "You Have Already Posted a Location", message: "Do you want to update it?", cancelable: true, okHandler: { _ in
        self.performSegue(withIdentifier: Constants.postNewLocation, sender: nil)})
    } else {
      performSegue(withIdentifier: Constants.postNewLocation, sender: nil)
    }
  }
  
  @objc func logoutTapped(_ sender: Any) {
    setActivityAnimation(busy: true)
    OTMClient.logout(completion: handleLogoutResponse(success:error:))
  }
  
  fileprivate func setupNavigationBar() {
    let logout =  UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logoutTapped(_:)))
    let refresh = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), style: .plain, target: self, action: #selector(refreshTapped(_:)))
    let add = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_addpin"), style: .plain, target: self, action: #selector(addButtonTapped))
    navigationItem.title = "On the Map"
    navigationItem.leftBarButtonItem = logout
    navigationItem.rightBarButtonItems = [add, refresh]
  }
  
  internal func handleLocationsResponse(success: Bool, error: Error?) {
    setActivityAnimation(busy: false)
    guard success else {
      showAlert(title: "Get Locations Failed", message: error?.localizedDescription ?? "")
      return
    }
  }
  
  internal func handleLogoutResponse(success: Bool, error: Error?) {
    setActivityAnimation(busy: false)
    if success {
      dismiss(animated: true, completion: nil)
    } else {
      showAlert(title: "Logout Error", message: error?.localizedDescription ?? "")
    }
  }
  internal func setActivityAnimation(busy: Bool) {
    busy ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
  }
  
  internal func openURL(_ url: String) {
    if let url = URL(string: url) {
      UIApplication.shared.open(url, options: [:], completionHandler: handleOpenURLComplete(success:))
    } else {
      handleOpenURLComplete(success: false)
    }
  }
  
  internal func handleOpenURLComplete(success: Bool) {
    setActivityAnimation(busy: false)
    guard success else {
      showAlert(title: "Error", message: "Invalid URL")
      return
    }
  }
}
