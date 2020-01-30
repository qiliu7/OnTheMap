//
//  locationRequest.swift
//  OnTheMap
//
//  Created by Kappa on 2020-01-29.
//  Copyright © 2020 qi. All rights reserved.
//

import Foundation

struct LocationRequest: Codable {
  
  let uniqueKey: String
  let firstName: String
  let lastName: String
  let mapString: String
  let mediaURL: String
  let latitude: Double
  let longitude: Double
}
