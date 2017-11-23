//
//  MachineLearning.swift
//  iOSToolsTests
//
//  Created by Antoine Clop on 10/6/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import XCTest
@testable import iOSTools

@available(iOS 11.0, *)
class MachineLearningTest: XCTestCase {
  
  // MARK: - Test setup
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  // NOTE: Due to Xcode 9 assets loading bug, we use UIImage(contentsOfFile:) method to load images
  let pathToAssets: String = "/Users/antoine.clop/Projets/iOSTools/iOSToolsTests/Ressources/Assets.xcassets"
  
  func testRecognizeCat() {
    let asyncRequest = expectation(description: "Recognition Succeeded")
    let catImage: UIImage = UIImage(contentsOfFile: pathToAssets + "/cat.imageset/cat.jpg")!
    //let catImage: UIImage = #imageLiteral(resourceName: "cat")
    ImageVision.detectObject(in: catImage, maxResult: 5) { (results, error) in
      XCTAssert(error == nil)
      XCTAssert(results != nil)
      XCTAssert((results?.count)! <= 5)
      XCTAssert(results?.first?.0 == "tabby, tabby cat")
      asyncRequest.fulfill()
    }
    waitForExpectations(timeout: 10.0) { (_) -> Void in }
  }
  
  func testRecognizeTiger() {
    let asyncRequest = expectation(description: "Recognition Succeeded")
    let tigerImage: UIImage = UIImage(contentsOfFile: pathToAssets + "/tiger.imageset/tiger.jpg")!
    //let tigerImage: UIImage = #imageLiteral(resourceName: "tiger")
    ImageVision.detectObject(in: tigerImage) { (results, error) in
      XCTAssert(error == nil)
      XCTAssert(results != nil)
      XCTAssert(results?.first?.0 == "tiger, Panthera tigris")
      asyncRequest.fulfill()
    }
    waitForExpectations(timeout: 10.0) { (_) -> Void in }
  }
  
  func testRecognizeZebra() {
    let asyncRequest = expectation(description: "Recognition Succeeded")
    let zebraImage: UIImage = UIImage(contentsOfFile: pathToAssets + "/zebra.imageset/zebra.png")!
    //let zebraImage: UIImage = #imageLiteral(resourceName: "zebra")
    ImageVision.detectObject(in: zebraImage, maxResult: nil) { (results, error) in
      XCTAssert(error == nil)
      XCTAssert(results != nil)
      XCTAssert(results?.first?.0 == "zebra")
      asyncRequest.fulfill()
    }
    waitForExpectations(timeout: 10.0) { (_) -> Void in }
  }
  
  func testRecognizeWater() {
    let asyncRequest = expectation(description: "Recognition Succeeded")
    let waterImage: UIImage = UIImage(contentsOfFile: pathToAssets + "/water.imageset/water.jpg")!
    //let waterImage: UIImage = #imageLiteral(resourceName: "water")
    ImageVision.detectObject(in: waterImage, maxResult: 10) { (results, error) in
      XCTAssert(error == nil)
      XCTAssert(results != nil)
      XCTAssert((results?.count)! <= 10)
      XCTAssert(results?.first?.0 == "water bottle")
      asyncRequest.fulfill()
    }
    waitForExpectations(timeout: 10.0) { (_) -> Void in }
  }
  
  func testRecognizeSoda() {
    let asyncRequest = expectation(description: "Recognition Succeeded")
    let sodaImage: UIImage = UIImage(contentsOfFile: pathToAssets + "/soda.imageset/soda.png")!
    //let sodaImage: UIImage = #imageLiteral(resourceName: "soda")
    ImageVision.detectObject(in: sodaImage, maxResult: 2) { (results, error) in
      XCTAssert(error == nil)
      XCTAssert(results != nil)
      XCTAssert((results?.count)! <= 2)
      XCTAssert(results?.first?.0 == "pop bottle, soda bottle")
      asyncRequest.fulfill()
    }
    waitForExpectations(timeout: 10.0) { (_) -> Void in }
  }
  
  func testRecognizeJellyfish() {
    let asyncRequest = expectation(description: "Recognition Succeeded")
    let jellyfishImage: UIImage = UIImage(contentsOfFile: pathToAssets + "/jellyfish.imageset/jellyfish.jpg")!
    //let jellyfishImage: UIImage = #imageLiteral(resourceName: "jellyfish")
    ImageVision.detectObject(in: jellyfishImage, maxResult: 1) { (results, error) in
      XCTAssert(error == nil)
      XCTAssert(results != nil)
      XCTAssert((results?.count)! <= 1)
      XCTAssert(results?.first?.0 == "jellyfish")
      asyncRequest.fulfill()
    }
    waitForExpectations(timeout: 10.0) { (_) -> Void in }
  }
  
  func testRecognizeNoResult() {
    let asyncRequest = expectation(description: "Recognition Succeeded")
    let jellyfishImage: UIImage = UIImage(contentsOfFile: pathToAssets + "/jellyfish.imageset/jellyfish.jpg")!
    //let jellyfishImage: UIImage = #imageLiteral(resourceName: "jellyfish")
    ImageVision.detectObject(in: jellyfishImage, maxResult: 0) { (results, error) in
      XCTAssert(error == nil)
      XCTAssert(results != nil)
      XCTAssert(results?.count == 0)
      asyncRequest.fulfill()
    }
    waitForExpectations(timeout: 10.0) { (_) -> Void in }
  }
  
  func testRecognizeResultNeg() {
    let asyncRequest = expectation(description: "Recognition Succeeded")
    let jellyfishImage: UIImage = UIImage(contentsOfFile: pathToAssets + "/jellyfish.imageset/jellyfish.jpg")!
    //let jellyfishImage: UIImage = #imageLiteral(resourceName: "jellyfish")
    ImageVision.detectObject(in: jellyfishImage, maxResult: -12) { (results, error) in
      XCTAssert(error == nil)
      XCTAssert(results != nil)
      XCTAssert(results?.count == 0)
      asyncRequest.fulfill()
    }
    waitForExpectations(timeout: 10.0) { (_) -> Void in }
  }
}
