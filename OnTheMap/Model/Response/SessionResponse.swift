//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Kappa on 2020/1/23.
//  Copyright © 2020 qi. All rights reserved.
//

import Foundation

struct Account: Codable {
  let registered: Bool
  let key: String
}
struct Session: Codable {
  let id: String
  let expiration: String
}
struct SessionResponse: Codable {
  let account: Account
  let session: Session
}

