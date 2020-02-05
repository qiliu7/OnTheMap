//
//  LocationTableViewController.swift
//  OnTheMap
//
//  Created by Kappa on 2020/1/23.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class ShowLocationTableViewController: ShowLocationBaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  override func handleLocationsResponse(success: Bool, error: Error?) {
    super.handleLocationsResponse(success: success, error: error)
    tableView.reloadData()
  }
}

extension ShowLocationTableViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return OTMModel.locations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let location = OTMModel.locations[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.locationTableViewCellId, for: indexPath)
    cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
    cell.detailTextLabel?.text = location.mediaURL
    cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    setActivityAnimation(busy: true)
    let location = OTMModel.locations[indexPath.row]
    openURL(location.mediaURL)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
