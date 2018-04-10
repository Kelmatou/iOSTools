//
//  ObjectMapper.swift
//  EpilifeKit
//
//  Created by Antoine Clop on 1/12/18.
//  Copyright © 2018 3IE. All rights reserved.
//

import Foundation

class ObjectMapper {
    
    /**
     Convert data into an object of type T, if T is Decodable
     
     - parameter data: the data to convert
     - parameter type: the destination type
     
     - returns: a couple (T?, Error?) where T is the result object if conversion succeed and Error is the error if available
     */
    internal static func convert<T: Decodable>(_ data: Data?, into type: T.Type) -> (T?, GenericError?) {
        if let data = data {
            do {
                let dataJson: T = try JSONDecoder().decode(T.self, from: data)
                return (dataJson, nil)
            }
            catch {
                let error: GenericError = GenericError(description: "Could not parse \(type) data from json")
                return (nil, error)
            }
        }
        else {
            return (nil, nil)
        }
    }
}
