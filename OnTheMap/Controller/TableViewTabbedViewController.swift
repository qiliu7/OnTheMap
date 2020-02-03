//
//  LocationTableViewController.swift
//  OnTheMap
//
//  Created by Kappa on 2020/1/23.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class TableViewTabbedController: UITableViewController {
  
  lazy var activityIndicator = createActivityIndicatorView()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    view.addSubview(activityIndicator)
    
    setActivityAnimation(busy: true)
    OTMClient.getRecentStudentLocations(Constants.numberOfLocations, completion: handleLocationsResponseByUpdatingTable(success:error:))
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
  
  @IBAction func addButtonTapped() {
    // check if user has already posted a location
    if OTMModel.objectId != nil {
      showAlert(title: "You Have Already Posted a Location", message: "Do you want to update it?", cancelable: true, okHandler: { _ in
        self.performSegue(withIdentifier: Constants.postNewLocation, sender: nil)})
    } else {
      performSegue(withIdentifier: Constants.postNewLocation, sender: nil)
    }
  }
  
  private func setActivityAnimation(busy: Bool) {
    busy ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return OTMModel.locations.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let location = OTMModel.locations[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.locationTableViewCellId, for: indexPath)
    cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
    cell.detailTextLabel?.text = location.mediaURL
    cell.imageView?.image = UIImage(named: "icon_pin")
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    setActivityAnimation(busy: true)
    let location = OTMModel.locations[indexPath.row]
    if let url = URL(string: location.mediaURL) {
      UIApplication.shared.open(url, options: [:], completionHandler: handleOpenURLComplete(success:))
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func handleOpenURLComplete(success: Bool) {
    setActivityAnimation(busy: false)
    guard success else {
      self.showAlert(title: "Error", message: "Invalid URL")
      return
    }
  }
  
  @IBAction func refreshTapped(_ sender: Any) {
    setActivityAnimation(busy: true)
    OTMClient.getRecentStudentLocations(Constants.numberOfLocations, completion: handleLocationsResponseByUpdatingTable(success:error:))
  }
  
  private func handleLocationsResponseByUpdatingTable(success: Bool, error: Error?) {
    setActivityAnimation(busy: false)
    guard success else {
      self.showAlert(title: "Get Locations Failed", message: error?.localizedDescription ?? "")
      return
    }
    self.tableView.reloadData()
  }
}
