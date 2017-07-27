//
//  ReflexivityTest.swift
//  iOSTools
//
//  Created by Antoine Clop on 7/24/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import XCTest
@testable import iOSTools

class ReflexivityTest: XCTestCase {
  
  // MARK: - Test setup
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  class A {}
  class B: A {}
  class C: B {}
  
  // MARK: - Test case
  
  func testNilVariable() {
    let variable: A? = nil
    XCTAssert(Reflexivity.typeName(variable) == "A?")
  }
  
  func testNilVariableParentClass() {
    let variable: A? = nil
    XCTAssert(Reflexivity.parentType(variable) == nil)
  }
  
  func testNilVariableParentClassNotNil() {
    let variable: B? = B()
    XCTAssert(Reflexivity.parentType(variable) == nil)
    //XCTAssert(Reflexivity.parentType(variable) == "A?")
  }
  
  func testBasicClassName() {
    XCTAssert(Reflexivity.typeName(3) == "Int")
    XCTAssert(Reflexivity.typeName("String") == "String")
  }
  
  func testClassName() {
    XCTAssert(Reflexivity.typeName(A()) == "A")
    XCTAssert(Reflexivity.typeName(B()) == "B")
    XCTAssert(Reflexivity.typeName(C()) == "C")
  }
  
  func testClassReflexivity() {
    XCTAssert(Reflexivity.typeName(Reflexivity()) == "Reflexivity")
  }
  
  func testClassOptionalName() {
    let var1: A? = A()
    let var2: B? = B()
    let var3: C? = C()
    XCTAssert(Reflexivity.typeName(var1) == "A?")
    XCTAssert(Reflexivity.typeName(var2) == "B?")
    XCTAssert(Reflexivity.typeName(var3) == "C?")
  }
  
  func testDynamicDispatch() {
    let var1: A = A()
    let var2: A = B()
    let var3: A = C()
    XCTAssert(Reflexivity.typeName(var1) == "A")
    XCTAssert(Reflexivity.typeName(var2) == "B")
    XCTAssert(Reflexivity.typeName(var3) == "C")
  }
  
  func testInherance() {
    let var1: A = A()
    let var2: B = B()
    let var3: C = C()
    XCTAssert(Reflexivity.parentType(var1) == nil)
    XCTAssert(Reflexivity.parentType(var2) == "A")
    XCTAssert(Reflexivity.parentType(var3) == "B")
  }
  
  func testCreatingInstance() {
    let reflexivity: Reflexivity = Reflexivity(3)
    XCTAssert(reflexivity.typeName() == "Int")
  }
  
  func testParentInstance() {
    let var1: A = B()
    let reflexivity: Reflexivity = Reflexivity(var1)
    debugPrint(reflexivity.parent()?.typeName() == "A")
    XCTAssert(reflexivity.parent()?.typeName() == "A")
  }
}
