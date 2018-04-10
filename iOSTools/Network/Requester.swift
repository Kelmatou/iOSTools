//
//  Requester.swift
//  iOSTools
//
//  Created by Antoine Clop on 7/25/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import UIKit

open class Requester {
    
    public enum AccessMethod: String {
        case GET    = "GET"
        case POST   = "POST"
        case PUT    = "PUT"
        case DELETE = "DELETE"
    }
    
    /**
     Sends an HTTP request
     
     - parameter method: the AccessMethod
     - parameter url: the targeted url
     - parameter headers: a dictionary of header [Value : HttpField]
     - parameter body: the content of the message
     - parameter handler: allows the user to make actions just after request ended (Data, Error)
     */
    public static func request(_ method: AccessMethod, url: String, headers: [String : String]? = nil, body: String? = nil, handler: @escaping (Data?, GenericError?) -> Void) {
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
                if let error = error {
                    handler(data, RequesterError(error.localizedDescription))
                }
                else {
                    handler(data, nil)
                }
            }
            task.resume()
        }
        else {
            handler(nil, RequesterError("Invalid URL"))
        }
    }
    
    /**
     Sends an HTTP request and that will receive text
     
     - parameter method: the AccessMethod
     - parameter url: the targeted url
     - parameter headers: a dictionary of header [Value : HttpField]
     - parameter body: the content of the message
     - parameter handler: allows the user to make actions just after request ended (String, Error)
     */
    public static func requestText(_ method: AccessMethod, url: String, headers: [String : String]? = nil, body: String? = nil, handler: @escaping (String?, GenericError?) -> Void) {
        request(method, url: url, headers: headers, body: body) {
            (data, error) in
            var responseDecoded: String?
            if let data = data, error == nil {
                responseDecoded = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            }
            handler(responseDecoded, error)
        }
    }
    
    /**
     Sends an HTTP request and that will receive an image
     
     - parameter method: the AccessMethod
     - parameter url: the targeted url
     - parameter headers: a dictionary of header [Value : HttpField]
     - parameter body: the content of the message
     - parameter handler: allows the user to make actions just after request ended (UIImage, Error)
     */
    public static func requestImage(_ method: AccessMethod, url: String, headers: [String : String]? = nil, body: String? = nil, handler: @escaping (UIImage?, GenericError?) -> Void) {
        request(method, url: url, headers: headers, body: body) {
            (data, error) in
            var responseImage: UIImage?
            if let data = data, error == nil {
                responseImage = UIImage(data: data)
            }
            handler(responseImage, error)
        }
    }
    
    public static func requestObject<T: Decodable>(_ method: AccessMethod, url: String, headers: [String : String]? = nil, body: String? = nil, asType: T.Type, handler: @escaping (T?, GenericError?) -> Void) {
        request(method, url: url, headers: headers, body: body) {
            (data, error) in
            var responseObject: T?
            if let data = data, error == nil {
                let conversion: (T?, GenericError?) = ObjectMapper.convert(data, into: T.self)
                if let object = conversion.0 {
                    responseObject = object
                }
            }
            handler(responseObject, error)
        }
    }
}
