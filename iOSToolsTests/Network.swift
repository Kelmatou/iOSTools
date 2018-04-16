//
//  Network.swift
//  iOSTools
//
//  Created by Antoine Clop on 7/25/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import XCTest
@testable import iOSTools

class Response: Decodable {
    
    public var status: String = ""
    public var data: Card?
}

class Card: Decodable {
    
    public var name: String = ""
    public var text: String = ""
    public var card_type: String = ""
    public var type: String = ""
    public var family: String = ""
    public var atk: Int = 0
    public var def: Int = 0
    public var level: Int = 0
    public var property: String?
}

class NetworkTest: XCTestCase {
    
    // MARK: - Test setup
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Get Test case
    
    func testValidGetRequestText() {
        let asyncRequest = expectation(description: "Request Succeeded")
        Requester.requestText(.GET, url: "http://yugiohprices.com/api/card_data/Dark%20Magician%20(Arkana)") {
            (data, error) in
            XCTAssert(error == nil)
            XCTAssert(data == "{\"status\":\"success\",\"data\":{\"name\":\"Dark Magician (Arkana)\",\"text\":\"The ultimate wizard in terms of attack and defense.\",\"card_type\":\"monster\",\"type\":\"Spellcaster\",\"family\":\"dark\",\"atk\":2500,\"def\":2100,\"level\":7,\"property\":null}}")
            asyncRequest.fulfill()
        }
        waitForExpectations(timeout: 10.0) { (_) -> Void in }
    }
    
    func testValidGetRequestImage() {
        let asyncRequest = expectation(description: "Request Succeeded")
        Requester.requestImage(.GET, url: "http://yugiohprices.com/api/card_image/Dark%20Magician%20(Arkana)") {
            (data, error) in
            XCTAssert(error == nil)
            XCTAssert(data != nil)
            asyncRequest.fulfill()
        }
        waitForExpectations(timeout: 10.0) { (_) -> Void in }
    }
    
    func testValidGetRequestObject() {
        let asyncRequest = expectation(description: "Request Succeeded")
        Requester.requestObject(.GET, url: "http://yugiohprices.com/api/card_data/Dark%20Magician%20(Arkana)", asType: Response.self) {
            (data, error) in
            XCTAssert(error == nil)
            XCTAssert(data != nil)
            XCTAssert(data?.status == "success")
            XCTAssert(data?.data != nil)
            XCTAssert(data?.data?.name == "Dark Magician (Arkana)")
            XCTAssert(data?.data?.text == "The ultimate wizard in terms of attack and defense.")
            XCTAssert(data?.data?.card_type == "monster")
            XCTAssert(data?.data?.type == "Spellcaster")
            XCTAssert(data?.data?.family == "dark")
            XCTAssert(data?.data?.atk == 2500)
            XCTAssert(data?.data?.def == 2100)
            XCTAssert(data?.data?.level == 7)
            XCTAssert(data?.data?.property == nil)
            asyncRequest.fulfill()
        }
        waitForExpectations(timeout: 10.0) { (_) -> Void in }
    }
    
    func testValidGetCacheRequestText() {
        var asyncDone: Int = 0
        let asyncRequest = expectation(description: "Request Succeeded")
        CacheRequester.requestText(.GET, url: "http://yugiohprices.com/api/card_data/Dark%20Magician%20(Arkana)", behavior: .ForceRequest("request1")) {
            (data, error) in
            XCTAssert(error == nil)
            XCTAssert(data == "{\"status\":\"success\",\"data\":{\"name\":\"Dark Magician (Arkana)\",\"text\":\"The ultimate wizard in terms of attack and defense.\",\"card_type\":\"monster\",\"type\":\"Spellcaster\",\"family\":\"dark\",\"atk\":2500,\"def\":2100,\"level\":7,\"property\":null}}")
            CacheRequester.requestText(.GET, url: "http://yugiohprices.com/api/card_data/Dark%20Magician%20(Arkana)", behavior: .CacheOnly("request1")) {
                (data, error) in
                XCTAssert(error == nil)
                XCTAssert(data == "{\"status\":\"success\",\"data\":{\"name\":\"Dark Magician (Arkana)\",\"text\":\"The ultimate wizard in terms of attack and defense.\",\"card_type\":\"monster\",\"type\":\"Spellcaster\",\"family\":\"dark\",\"atk\":2500,\"def\":2100,\"level\":7,\"property\":null}}")
                asyncDone += 1
                if (asyncDone == 4) {
                    asyncRequest.fulfill()
                }            }
            CacheRequester.requestText(.GET, url: "http://yugiohprices.com/api/card_data/Dark%20Magician%20(Arkana)", behavior: .CacheOrRequest("request1")) {
                (data, error) in
                XCTAssert(error == nil)
                XCTAssert(data == "{\"status\":\"success\",\"data\":{\"name\":\"Dark Magician (Arkana)\",\"text\":\"The ultimate wizard in terms of attack and defense.\",\"card_type\":\"monster\",\"type\":\"Spellcaster\",\"family\":\"dark\",\"atk\":2500,\"def\":2100,\"level\":7,\"property\":null}}")
                asyncDone += 1
                if (asyncDone == 4) {
                    asyncRequest.fulfill()
                }            }
        }
        CacheRequester.requestText(.GET, url: "http://yugiohprices.com/api/card_data/Dark%20Magician%20(Arkana)", behavior: .CacheOrRequest("request2")) {
            (data, error) in
            XCTAssert(error == nil)
            XCTAssert(data == "{\"status\":\"success\",\"data\":{\"name\":\"Dark Magician (Arkana)\",\"text\":\"The ultimate wizard in terms of attack and defense.\",\"card_type\":\"monster\",\"type\":\"Spellcaster\",\"family\":\"dark\",\"atk\":2500,\"def\":2100,\"level\":7,\"property\":null}}")
            CacheRequester.requestText(.GET, url: "http://yugiohprices.com/api/card_data/Dark%20Magician%20(Arkana)", behavior: .CacheAndRequest("request2")) {
                (data, error) in
                XCTAssert(error == nil)
                XCTAssert(data == "{\"status\":\"success\",\"data\":{\"name\":\"Dark Magician (Arkana)\",\"text\":\"The ultimate wizard in terms of attack and defense.\",\"card_type\":\"monster\",\"type\":\"Spellcaster\",\"family\":\"dark\",\"atk\":2500,\"def\":2100,\"level\":7,\"property\":null}}")
                asyncDone += 1
                if (asyncDone == 4) {
                    asyncRequest.fulfill()
                }
            }
        }
        var responseCount: Int = 0
        var cacheText: String? = nil
        if let cacheData = SavableObject.loadData(withKey: "request3") {
            cacheText = String(data: cacheData, encoding: .utf8)
        }
        CacheRequester.requestText(.GET, url: "http://yugiohprices.com/api/card_data/Dark%20Magician%20(Arkana)", behavior: .CacheAndRequest("request3")) {
            (data, error) in
            XCTAssert(error == nil)
            responseCount += 1
            if (responseCount == 1) {
                XCTAssert(data == cacheText)
            }
            else {
                XCTAssert(data == "{\"status\":\"success\",\"data\":{\"name\":\"Dark Magician (Arkana)\",\"text\":\"The ultimate wizard in terms of attack and defense.\",\"card_type\":\"monster\",\"type\":\"Spellcaster\",\"family\":\"dark\",\"atk\":2500,\"def\":2100,\"level\":7,\"property\":null}}")
            }
            asyncDone += 1
            if (asyncDone == 4) {
                asyncRequest.fulfill()
            }
        }
        waitForExpectations(timeout: 10.0) { (_) -> Void in
            SavableObject.removeData(withKey: "request1")
            SavableObject.removeData(withKey: "request2")
            SavableObject.removeData(withKey: "request3")
        }
    }
    
    func testValidGetCacheRequestImage() {
        var asyncDone: Int = 0
        let asyncRequest = expectation(description: "Request Succeeded")
        CacheRequester.requestImage(.GET, url: "http://yugiohprices.com/api/card_image/Dark%20Magician%20(Arkana)", behavior: .ForceRequest("requestImage1")) {
            (data, error) in
            XCTAssert(error == nil)
            XCTAssert(data != nil)
            CacheRequester.requestImage(.GET, url: "http://yugiohprices.com/api/card_image/Dark%20Magician%20(Arkana)", behavior: .CacheOnly("requestImage1")) {
                (data, error) in
                XCTAssert(error == nil)
                XCTAssert(data != nil)
                asyncDone += 1
                if (asyncDone == 4) {
                    asyncRequest.fulfill()
                }            }
            CacheRequester.requestImage(.GET, url: "http://yugiohprices.com/api/card_image/Dark%20Magician%20(Arkana)", behavior: .CacheOrRequest("requestImage1")) {
                (data, error) in
                XCTAssert(error == nil)
                XCTAssert(data != nil)
                asyncDone += 1
                if (asyncDone == 4) {
                    asyncRequest.fulfill()
                }            }
        }
        CacheRequester.requestImage(.GET, url: "http://yugiohprices.com/api/card_image/Dark%20Magician%20(Arkana)", behavior: .CacheOrRequest("requestImage2")) {
            (data, error) in
            XCTAssert(error == nil)
            XCTAssert(data != nil)
            CacheRequester.requestImage(.GET, url: "http://yugiohprices.com/api/card_image/Dark%20Magician%20(Arkana)", behavior: .CacheAndRequest("requestImage2")) {
                (data, error) in
                XCTAssert(error == nil)
                XCTAssert(data != nil)
                asyncDone += 1
                if (asyncDone == 4) {
                    asyncRequest.fulfill()
                }
            }
        }
        var responseCount: Int = 0
        var cacheImage: UIImage? = nil
        if let cacheData = SavableObject.loadData(withKey: "requestImage3") {
            cacheImage = UIImage(data: cacheData)
        }
        CacheRequester.requestImage(.GET, url: "http://yugiohprices.com/api/card_image/Dark%20Magician%20(Arkana)", behavior: .CacheAndRequest("requestImage3")) {
            (data, error) in
            XCTAssert(error == nil)
            responseCount += 1
            if (responseCount == 1) {
                XCTAssert(data == cacheImage)
            }
            else {
                XCTAssert(data != nil)
            }
            asyncDone += (responseCount == 2) ? 1 : 0
            if (responseCount == 2) {
            }
            if (asyncDone == 4) {
                asyncRequest.fulfill()
            }
        }
        waitForExpectations(timeout: 10.0) { (_) -> Void in
            SavableObject.removeData(withKey: "requestImage1")
            SavableObject.removeData(withKey: "requestImage2")
            SavableObject.removeData(withKey: "requestImage3")
        }
    }
    
    func testInvalidGetRequest() {
        let asyncRequest = expectation(description: "Request Succeeded")
        Requester.requestText(.GET, url: "http://yugiNOPEohprices.com/api/card_data/Dark%20Magician%20(Arkana)") {
            (data, error) in
            XCTAssert(error != nil)
            XCTAssert(data == nil)
            asyncRequest.fulfill()
        }
        waitForExpectations(timeout: 10.0) { (_) -> Void in }
    }
    
    func testEmptyGetRequest() {
        let asyncRequest = expectation(description: "Request Succeeded")
        Requester.requestText(.GET, url: "") {
            (data, error) in
            XCTAssert(error != nil)
            XCTAssert(data == nil)
            asyncRequest.fulfill()
        }
        waitForExpectations(timeout: 10.0) { (_) -> Void in }
    }
}
