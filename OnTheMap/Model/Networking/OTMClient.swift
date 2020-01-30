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
    static var accountId = ""
    static var userId = ""
    static var firstName: String?
    static var lastName: String?
  }
  
  enum Endpoints {
    static let base = "https://onthemap-api.udacity.com/v1"
    static let signUp = "https://auth.udacity.com/sign-up"
    
    case login
    case logout
    case getUserData
    case getRecentStudentLocations(Int)
    case putStudentLocation(String)
    case postStudentLocation
    
    var stringValue: String {
      switch self {
      case .login,
           .logout:
        return Endpoints.base + "/session"
      case .getUserData:
        return Endpoints.base + "/users/\(Auth.userId)"
      case .getRecentStudentLocations(let number):
        return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=\(number)"
      case .putStudentLocation(let objectId):
        return Endpoints.base + "/StudentLocation/\(objectId)"
      case .postStudentLocation:
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
        Auth.userId = response.account.key
        completion(true, nil)
      } else {
        completion(false, error)
      }
    }
  }
  
  class func logout(completion: @escaping (Bool, Error?) -> Void) {
    var request = URLRequest(url: Endpoints.logout.url)
    request.httpMethod = "DELETE"
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    for cookie in sharedCookieStorage.cookies! {
      if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    if let xsrfCookie = xsrfCookie {
      request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }
    let task = session.dataTask(with: request) { (data, response, error) in
      guard let data = data else {
        DispatchQueue.main.async {
          completion(false, error)
        }
         return
      }
      let actualData = data.subdata(in: 5..<data.count)
      let decoder = JSONDecoder()
      do {
        let _ = try decoder.decode([String: Session].self, from: actualData)
        DispatchQueue.main.async {
          completion(true, nil)
        }
      } catch {
        DispatchQueue.main.async {
          completion(false, error)
        }
      }
    }
    task.resume()
  }
  
  class func getUserData(completion: @escaping (Bool, Error?) -> Void) {
    taskForGETRequest(url: Endpoints.getUserData.url, ResponseType: UserInfo.self, trimResponse: true) { (response, error) in
      guard let response = response else {
        completion(false, error)
        return
      }
      Auth.firstName = response.firstName
      Auth.lastName = response.lastName
      completion(true, nil)
    }
  }
  
  class func getRecentStudentLocations(_ number: Int, completion: @escaping (Bool, Error?) -> Void) {
    taskForGETRequest(url: Endpoints.getRecentStudentLocations(number).url, ResponseType: LocationResponse.self) { (response, error) in
      guard let response = response else {
        completion(false, error)
        return
      }
      OTMModel.locations = response.results
      completion(true, nil)
    }
  }
  
  class func putStudentLocation(objectId: String, location: LocationRequest, completion: @escaping (Bool, Error?) -> Void) {
    taskForPUTRequest(url: Endpoints.putStudentLocation(objectId).url, body: location, responseType: [String: String].self) { (response, error) in
      if response != nil {
        completion(true, nil)
      } else {
        completion(false, error)
      }
    }
  }
  
  class func postStudentLocation(location: LocationRequest, completion: @escaping (Bool, Error?) -> Void) {
    taskForPOSTRequest(url: Endpoints.postStudentLocation.url, body: location, responseType: PostLocationResponse.self, trimResponse: false) { (response, error) in
      if let response = response {
        OTMModel.objectId = response.objectId
        completion(true, nil)
      } else {
        completion(false, error)
      }
    }
  }
  
  class func taskForGETRequest<ResponseType: Decodable> (url: URL, ResponseType: ResponseType.Type, trimResponse: Bool = false, completion: @escaping (ResponseType?, Error?) -> Void) {
    let task = session.dataTask(with: url) { (data, response, error) in
      guard let data = data else {
        DispatchQueue.main.async {
          completion(nil, error)
        }
        return
      }
      let decoder = JSONDecoder()
      // determine whether to trim the first 5 characters of response
      let actualData = trimResponse ? data.subdata(in: 5..<data.count) : data
      do {
        let responseObject = try decoder.decode(ResponseType.self, from: actualData)
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
  
  class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable> (url: URL, body: RequestType, responseType: ResponseType.Type, trimResponse: Bool = true, completion: @escaping (ResponseType?, Error?) -> Void) {
    
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
      // determine whether to trim the first 5 characters of response
      let actualData = trimResponse ? data.subdata(in : 5..<data.count) : data
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
  
  class func taskForPUTRequest<RequestType: Encodable, ResponseType: Decodable> (url: URL, body: RequestType, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let encoder = JSONEncoder()
    do {
      request.httpBody = try encoder.encode(body)
    } catch {
      DispatchQueue.main.async {
        completion(nil, error)
      }
    }
    let task = session.dataTask(with: request) { (data, response, error) in
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
  
}
