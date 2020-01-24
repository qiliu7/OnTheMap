//
//  Client.swift
//  OnTheMap
//
//  Created by Kappa on 2020/1/22.
//  Copyright © 2020 qi. All rights reserved.
//

import Foundation

class OTMClient {
  
  static let session = URLSession.shared
  
  struct Auth {
    static var sessionId = ""
  }
  
  enum Endpoints {
    static let base = "https://onthemap-api.udacity.com/v1"
    static let signUp = "https://auth.udacity.com/sign-up"
    
    case login
    case getStudentLocations
    
    var stringValue: String {
      switch self {
      case .login:
        return Endpoints.base + "/session"
      case .getStudentLocations:
        return Endpoints.base + "/StudentLocation"
      }
    }
    
    var url: URL {
      return URL(string: stringValue)!
    }
    
  }
  
  class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
    let body = LoginRequest(udacity: Credential(username: username, password: password))
    taskForPOSTRequest(url: Endpoints.login.url, body: body, responseType: SessionResponse.self) { (response, error) in
      if let response = response {
        Auth.sessionId = response.session.id
        print(Auth.sessionId)
        completion(true, nil)
      } else {
        completion(false, error)
      }
    }
  }
  
  class func getStudentLocations(completion: @escaping (Bool, Error?) -> Void) {
    taskForGETRequest(url: Endpoints.getStudentLocations.url, ResponseType: LocationResponse.self) { (response, error) in
      guard let response = response else {
        completion(false, error)
        return
      }
      OTMModel.locations = response.results
      completion(true, nil)
    }
  }
  
  class func taskForGETRequest<ResponseType: Decodable> (url: URL, ResponseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
    let task = session.dataTask(with: url) { (data, response, error) in
      guard let data = data else {
        DispatchQueue.main.async {
          completion(nil, error)
        }
        return
      }
      let decoder = JSONDecoder()
      do {
        let responseObject = try decoder.decode(ResponseType.self, from: data)
        DispatchQueue.main.async {
          completion(responseObject, nil)
        }
      } catch {
        DispatchQueue.main.async {
          completion(nil, error)
        }
      }
    }
    task.resume()
  }
  
  class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable> (url: URL, body: RequestType, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let encoder = JSONEncoder()
    do {
      request.httpBody = try encoder.encode(body)
    } catch {
      completion(nil, error)
    }
    let task = session.dataTask(with: request) { (data, response, error) in
      guard let data = data else {
        DispatchQueue.main.async {
          completion(nil, error)
        }
        return
      }
      let actualData = data.subdata(in : 5..<data.count)
//      print(String(data: actualData, encoding: .utf8))
      let decoder = JSONDecoder()
      do {
        let responseObject = try decoder.decode(ResponseType.self, from: actualData)
        DispatchQueue.main.async {
          completion(responseObject, nil)
        }
      } catch {
        do {
          let errorResponse = try decoder.decode(OTMResponse.self, from: actualData)
          DispatchQueue.main.async {
            completion(nil, errorResponse)
          }
        } catch {
          DispatchQueue.main.async {
            completion(nil, error)
          }
        }
      }
    }
    task.resume()
  }

}
