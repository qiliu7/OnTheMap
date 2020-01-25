//
//  LocationPostingViewController.swift
//  OnTheMap
//
//  Created by Kappa on 2020/1/24.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class LocationPostingViewController: UIViewController {
  
  @IBOutlet weak var findLocationButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    title = "aa"
  }
  
  func setupUI() {
    findLocationButton.layer.cornerRadius = findLocationButton.frame.height/8
  }
  
}
