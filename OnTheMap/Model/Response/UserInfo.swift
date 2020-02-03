//
//  UserInfo.swift
//  OnTheMap
//
//  Created by Kappa on 2020-01-29.
//  Copyright © 2020 qi. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
  let firstName: String
  let lastName: String
  
  enum CodingKeys: String, CodingKey {
    case firstName = "first_name"
    case lastName = "last_name"
  }
}
