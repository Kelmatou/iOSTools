//
//  Reachability.swift
//  iOSTools
//
//  Created by Antoine Clop on 10/18/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation
import SystemConfiguration

public protocol ReachabilityDelegate: class {
  
  func reachabilityStatusChanged(newValue: Reachability.Status)
}

open class Reachability {
  
  public enum Status: String {
    case Disconnected = "Disconnected"
    case WifiConnection = "WifiConnection"
    case CellularConnection = "CellularConnection"
    case Unknown = "Unknown"
  }
  
  public weak var delegate: ReachabilityDelegate? //NOT IMPLEMENTED YET
  public var autoUpdate: Bool = false //NIY
  public var currentStatus: Status = .Unknown //GET ONLY
  
  // MARK: - Public
  
  public init(autoUpdate: Bool = false) {
    checkReachability()
  }
  
  /**
   Determines if current device is connected to internet
   */
  public func isConnectionAvailable() -> Bool {
    return currentStatus == .WifiConnection || currentStatus == .CellularConnection
  }
  
  // MARK: - Static
  
  /**
   Determines if current device is connected to internet
   
   - returns: true if device has an internet connection
   */
  public static func isConnectionAvailable() -> Bool {
    return networkReachabilityForCellular() || networkReachabilityForWiFi()
  }
  
  // MARK: - Private & Internal
  
  internal static func networkReachabilityForCellular() -> Bool {
    var zeroAddress: sockaddr_in = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    return reachabilityTo(hostAddress: zeroAddress)
  }
  
  internal static func networkReachabilityForWiFi() -> Bool {
    var localWifiAddress: sockaddr_in = sockaddr_in()
    localWifiAddress.sin_len = UInt8(MemoryLayout.size(ofValue: localWifiAddress))
    localWifiAddress.sin_family = sa_family_t(AF_INET)
    localWifiAddress.sin_addr.s_addr = 0xA9FE0000
    return reachabilityTo(hostAddress: localWifiAddress)
  }
  
  private static func reachabilityTo(hostAddress: sockaddr_in) -> Bool {
    var address: sockaddr_in = hostAddress
    guard let defaultRouteReachability = withUnsafePointer(to: &address, {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, $0)
      }
    }) else {
      return false
    }
    return checkConnectionFlags(defaultRouteReachability)
  }
  
  private static func checkConnectionFlags(_ networkReachability: SCNetworkReachability) -> Bool {
    var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
    guard withUnsafeMutablePointer(to: &flags, { SCNetworkReachabilityGetFlags(networkReachability, UnsafeMutablePointer($0)) }) else {
      return false
    }
    return flags.contains(.reachable) && (flags.contains(.isWWAN)
                                      || !flags.contains(.connectionRequired)
                                      || !(flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired))
  }
  
  @discardableResult internal func checkReachability() -> Bool {
    if Reachability.networkReachabilityForCellular() {
      currentStatus = .CellularConnection
      return true
    }
    else if Reachability.networkReachabilityForWiFi() {
      currentStatus = .WifiConnection
      return true
    }
    else {
      currentStatus = .Disconnected
      return false
    }
  }
}
