//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Kappa on 2020-01-28.
//  Copyright © 2020 qi. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
  
  let createdAt: String
  let firstName: String
  let lastName: String
  let latitude: Double
  let longitude: Double
  let mapString: String
  let mediaURL: String
  let objectId: String
  let uniqueKey: String
  let updatedAt: String
}
