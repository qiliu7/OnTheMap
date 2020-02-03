//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Kappa on 2020/1/22.
//  Copyright © 2020 qi. All rights reserved.
//

import Foundation

struct Credential: Codable {
  let username: String
  let password: String
}

struct LoginRequest: Codable {

  let udacity: Credential
}
