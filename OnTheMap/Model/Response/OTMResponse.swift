//
//  OTMResponse.swift
//  OnTheMap
//
//  Created by Kappa on 2020/1/23.
//  Copyright © 2020 qi. All rights reserved.
//

import Foundation

struct OTMResponse: Codable {
  let status: Int
  let error: String
}

extension OTMResponse: LocalizedError {
  var errorDescription: String? {
    return error
  }
}
