//
//  CacheRequester.swift
//  iOSTools
//
//  Created by Antoine Clop on 4/13/18.
//  Copyright © 2018 clop_a. All rights reserved.
//

import Foundation

public class CacheRequester {
    
    public enum Behavior {
        case ForceRequest(String?)
        case CacheOnly(String)
        case CacheOrRequest(String)
        case CacheAndRequest(String)
    }
    
    public var behavior: Behavior
    
    public init(behavior: Behavior) {
        self.behavior = behavior
    }
    
    /**
     Sends an HTTP request
     
     - parameter method: the AccessMethod
     - parameter url: the targeted url
     - parameter headers: a dictionary of header [Value : HttpField]
     - parameter body: the content of the message
     - parameter handler: allows the user to make actions just after request ended (Data, Error)
     */
    public func request(_ method: Requester.AccessMethod, url: String, headers: [String : String]? = nil, body: String? = nil, handler: @escaping (Data?, GenericError?) -> Void) {
        CacheRequester.request(method, url: url, behavior: self.behavior, headers: headers, body: body) {
            (data, error) in
            handler(data, error)
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
    public func requestText(_ method: Requester.AccessMethod, url: String, headers: [String : String]? = nil, body: String? = nil, handler: @escaping (String?, GenericError?) -> Void) {
        CacheRequester.requestText(method, url: url, behavior: self.behavior, headers: headers, body: body) {
            (data, error) in
            handler(data, error)
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
    public func requestImage(_ method: Requester.AccessMethod, url: String, headers: [String : String]? = nil, body: String? = nil, handler: @escaping (UIImage?, GenericError?) -> Void) {
        CacheRequester.requestImage(method, url: url, behavior: self.behavior, headers: headers, body: body) {
            (data, error) in
            handler(data, error)
        }
    }
    
    /**
     Sends an HTTP request and that will receive an object of type T
     
     - parameter method: the AccessMethod
     - parameter url: the targeted url
     - parameter headers: a dictionary of header [Value : HttpField]
     - parameter body: the content of the message
     - parameter asType: the type of the output object
     - parameter handler: allows the user to make actions just after request ended (UIImage, Error)
     */
    public func requestObject<T: Decodable>(_ method: Requester.AccessMethod, url: String, headers: [String : String]? = nil, body: String? = nil, asType: T.Type, handler: @escaping (T?, GenericError?) -> Void) {
        CacheRequester.requestObject(method, url: url, behavior: self.behavior, headers: headers, body: body, asType: asType) {
            (data, error) in
            handler(data, error)
        }
    }
    
    /**
     Sends an HTTP request
     
     - parameter method: the AccessMethod
     - parameter url: the targeted url
     - parameter behavior: request behavior
     - parameter headers: a dictionary of header [Value : HttpField]
     - parameter body: the content of the message
     - parameter handler: allows the user to make actions just after request ended (Data, Error)
     */
    public static func request(_ method: Requester.AccessMethod, url: String, behavior: Behavior = .ForceRequest(nil), headers: [String : String]? = nil, body: String? = nil, handler: @escaping (Data?, GenericError?) -> Void) {
        switch behavior {
        case .CacheAndRequest(let key), .CacheOnly(let key), .CacheOrRequest(let key):
            let dataFound: Data? = SavableObject.loadData(withKey: key)
            switch behavior {
            case .CacheOnly:
                handler(dataFound, nil)
                return
            case .CacheOrRequest:
                if let dataFound = dataFound {
                    handler(dataFound, nil)
                    return
                }
            case .CacheAndRequest:
                handler(dataFound, nil)
            default: break
            }
        default: break
        }
        Requester.request(method, url: url, headers: headers, body: body) {
            (data, error) in
            var cacheKey: String?
            switch(behavior) {
            case .ForceRequest(let keyOptional):
                cacheKey = keyOptional
            case .CacheAndRequest(let key), .CacheOrRequest(let key):
                cacheKey = key
            default: break
            }
            if let data = data, let key = cacheKey {
                SavableObject.saveData(data, withKey: key)
            }
            handler(data, error)
        }
    }
    
    /**
     Sends an HTTP request and that will receive text
     
     - parameter method: the AccessMethod
     - parameter url: the targeted url
     - parameter behavior: request behavior
     - parameter headers: a dictionary of header [Value : HttpField]
     - parameter body: the content of the message
     - parameter handler: allows the user to make actions just after request ended (String, Error)
     */
    public static func requestText(_ method: Requester.AccessMethod, url: String, behavior: Behavior = .ForceRequest(nil), headers: [String : String]? = nil, body: String? = nil, handler: @escaping (String?, GenericError?) -> Void) {
        request(method, url: url, behavior: behavior, headers: headers, body: body) {
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
     - parameter behavior: request behavior
     - parameter headers: a dictionary of header [Value : HttpField]
     - parameter body: the content of the message
     - parameter handler: allows the user to make actions just after request ended (UIImage, Error)
     */
    public static func requestImage(_ method: Requester.AccessMethod, url: String, behavior: Behavior = .ForceRequest(nil), headers: [String : String]? = nil, body: String? = nil, handler: @escaping (UIImage?, GenericError?) -> Void) {
        request(method, url: url, behavior: behavior, headers: headers, body: body) {
            (data, error) in
            var responseImage: UIImage?
            if let data = data, error == nil {
                responseImage = UIImage(data: data)
            }
            handler(responseImage, error)
        }
    }
    
    /**
     Sends an HTTP request and that will receive an object of type T
     
     - parameter method: the AccessMethod
     - parameter url: the targeted url
     - parameter behavior: request behavior
     - parameter headers: a dictionary of header [Value : HttpField]
     - parameter body: the content of the message
     - parameter asType: the type of the output object
     - parameter handler: allows the user to make actions just after request ended (UIImage, Error)
     */
    public static func requestObject<T: Decodable>(_ method: Requester.AccessMethod, url: String, behavior: Behavior = .ForceRequest(nil), headers: [String : String]? = nil, body: String? = nil, asType: T.Type, handler: @escaping (T?, GenericError?) -> Void) {
        request(method, url: url, behavior: behavior, headers: headers, body: body) {
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
