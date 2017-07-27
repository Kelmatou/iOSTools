//
//  Requester.swift
//  iOSTools
//
//  Created by Antoine Clop on 7/25/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import UIKit

public class Requester {
  
  public enum AccessMethod: String {
    case GET    = "GET"
    case POST   = "POST"
    case PUT    = "PUT"
    case DELETE = "DELETE"
  }
  
  /**
   Sends an HTTP GET request
   
   - parameter url: the targeted url
   - parameter headers: a dictionary of header [Value : HttpField]
   - parameter body: the content of the message
   - parameter handler: allows the user to make actions just after request ended (Data, Error)
   */
  public static func request(_ method: AccessMethod, url: String, headers: [String : String]? = nil, body: String? = nil, handler: @escaping (Data?, Error?) -> Void) {
    if let uri = URL(string: url) {
      var request: URLRequest = URLRequest(url: uri)
      request.httpMethod = method.rawValue
      if let body = body {
        request.httpBody = body.data(using: String.Encoding.utf8)
      }
      if let headers = headers {
        for header in headers {
          request.addValue(header.value, forHTTPHeaderField: header.key)
        }
      }
      let task = URLSession.shared.dataTask(with: request) {
        (data, response, error) in
        handler(data, error)
      }
      task.resume()
    }
    else {
      handler(nil, RequesterError("Invalid URL"))
    }
  }
  
  public static func requestText(_ method: AccessMethod, url: String, headers: [String : String]? = nil, body: String? = nil, handler: @escaping (String?, Error?) -> Void) {
    request(method, url: url, headers: headers, body: body) {
      (data, error) in
      var responseDecoded: String?
      if let data = data, error == nil {
        responseDecoded = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
      }
      handler(responseDecoded, error)
    }
  }
  
  public static func requestImage(_ method: AccessMethod, url: String, headers: [String : String]? = nil, body: String? = nil, handler: @escaping (UIImage?, Error?) -> Void) {
    request(method, url: url, headers: headers, body: body) {
      (data, error) in
      var responseImage: UIImage?
      if let data = data, error == nil {
        responseImage = UIImage(data: data)
      }
      handler(responseImage, error)
    }
  }
}

struct RequesterError: LocalizedError
{
  var errorDescription: String? {
    return mMsg
  }
  var failureReason: String? {
    return mMsg
  }
  var recoverySuggestion: String? {
    return "Try to replace special characters"
  }
  var helpAnchor: String? {
    return "Some characters have special translation '(' = %28, ')' = %29..."
  }
  
  private var mMsg : String
  
  init(_ msg: String)
  {
    mMsg = msg
  }
}
