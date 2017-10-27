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
  
  func reachabilityStatusChanged(newStatus: Reachability.Status)
}

open class Reachability {
  
  public enum Status: String {
    case Disconnected = "Disconnected"
    case WifiConnection = "WifiConnection"
    case CellularConnection = "CellularConnection"
    case Unknown = "Unknown"
  }
  
  public weak var delegate: ReachabilityDelegate?
  open var autoUpdate: Bool = true {
    didSet {
      if autoUpdate {
        startAutoUpdate()
      }
      else {
        stopAutoUpdate()
      }
    }
  }
  /// refreshDelay (in second) represents the frequency of the autoUpdate
  public var refreshDelay: Int = 5 {
    didSet {
      stopAutoUpdate()
      initAutoUpdate()
      if autoUpdate {
        startAutoUpdate()
      }
    }
  }
  public internal(set) var currentStatus: Status = .Unknown
  
  private let timer: DispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
  
  // MARK: - Public
  
  public init(autoUpdate: Bool = true) {
    checkReachability()
    initAutoUpdate()
    if autoUpdate {
      self.autoUpdate = true
      startAutoUpdate()
    }
  }
  
  /**
   Determines if current device is connected to internet
   
   - returns: true if device has an internet connection
   */
  public func isConnectionAvailable() -> Bool {
    return checkReachability()
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
  
  /**
   Determines if device can connect through cellular connection
   
   - returns: true if device has internet access through cellular connection
   */
  internal static func networkReachabilityForCellular() -> Bool {
    var zeroAddress: sockaddr_in = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    return reachabilityTo(hostAddress: zeroAddress)
  }
  
  /**
   Determines if device can connect through wifi connection
   
   - returns: true if device has internet access through wifi connection
   */
  internal static func networkReachabilityForWiFi() -> Bool {
    var localWifiAddress: sockaddr_in = sockaddr_in()
    localWifiAddress.sin_len = UInt8(MemoryLayout.size(ofValue: localWifiAddress))
    localWifiAddress.sin_family = sa_family_t(AF_INET)
    localWifiAddress.sin_addr.s_addr = 0xA9FE0000
    return reachabilityTo(hostAddress: localWifiAddress)
  }
  
  /**
   Test reachability of an address
   
   - parameter hostAddress: the sock with all parameters set to reach host
   
   - returns: true if device can reach host address
   */
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
  
  /**
   Verify that flags resulting from connection confirm internet access
   
   - parameter networkReachability: the connection used to reach an host
   
   - returns: true if connection confirm internet access
   */
  private static func checkConnectionFlags(_ networkReachability: SCNetworkReachability) -> Bool {
    var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
    guard withUnsafeMutablePointer(to: &flags, { SCNetworkReachabilityGetFlags(networkReachability, UnsafeMutablePointer($0)) }) else {
      return false
    }
    return flags.contains(.reachable) && (flags.contains(.isWWAN)
                                      || !flags.contains(.connectionRequired)
                                      || !(flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired))
  }
  
  /**
   Determines if current device is connected to internet
   
   - returns: true if device has an internet connection
   */
  @discardableResult internal func checkReachability() -> Bool {
    var newStatus: Status = .Unknown
    if Reachability.networkReachabilityForWiFi() {
      newStatus = .WifiConnection
    }
    else if Reachability.networkReachabilityForCellular() {
      newStatus = .CellularConnection
    }
    else {
      newStatus = .Disconnected
    }
    let statusChanged = newStatus != currentStatus
    currentStatus = newStatus
    if statusChanged {
      reachabilityStatusChanged(newStatus: currentStatus)
    }
    return currentStatus == .CellularConnection || currentStatus == .WifiConnection
  }
  
  /**
   When creating Reachability object, init timer in case autoUpdate is used now or later
   */
  internal func initAutoUpdate() {
    timer.schedule(deadline: .now(), repeating: .seconds(refreshDelay))
    timer.setEventHandler {
      self.checkReachability()
    }
  }
  
  /**
   Resume timer if autoUpdate was set to true
   */
  private func startAutoUpdate() {
    timer.resume()
  }
  
  /**
   Suspend timer if autoUpdate was set to false
   */
  private func stopAutoUpdate() {
    timer.suspend()
  }
}

extension Reachability: ReachabilityDelegate {
  
  public func reachabilityStatusChanged(newStatus: Reachability.Status) {
    if let delegate = delegate {
      delegate.reachabilityStatusChanged(newStatus: newStatus)
    }
  }
}
