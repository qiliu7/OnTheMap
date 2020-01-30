//
//  LocationTableViewController.swift
//  OnTheMap
//
//  Created by Kappa on 2020/1/23.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {
  
  let numberOfLocation = 100
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    OTMClient.getRecentStudentLocations(Constants.numberOfLocations, completion: handleLocationsResponseByUpdatingTable(success:error:))
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
    let location = OTMModel.locations[indexPath.row]
    
    if let url = URL(string: location.mediaURL) {
      UIApplication.shared.open(url, options: [:], completionHandler: handleOpenURLComplete(success:))
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func handleOpenURLComplete(success: Bool) {
    guard success else {
      self.showAlert(title: "Error", message: "Invalid URL")
      return
    }
  }
  
  @IBAction func refreshTapped(_ sender: Any) {
    OTMClient.getRecentStudentLocations(numberOfLocation, completion: handleLocationsResponseByUpdatingTable(success:error:))
  }
  
  private func handleLocationsResponseByUpdatingTable(success: Bool, error: Error?) {
    guard success else {
      self.showAlert(title: "Get Locations Failed", message: error?.localizedDescription ?? "")
      return
    }
    self.tableView.reloadData()
  }
}
