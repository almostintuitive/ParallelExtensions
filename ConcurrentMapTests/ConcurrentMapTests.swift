//
//  ConcurrentMapTests.swift
//  ConcurrentMapTests
//
//  Created by Mark Aron Szulyovszky on 10/10/2015.
//  Copyright © 2015 itchingpixels. All rights reserved.
//

import XCTest
@testable import ConcurrentMap

class ConcurrentMapTests: XCTestCase {
    
  let numbers = Array(0...9998)
  var result = [Int]()
  
  func numberTransform(input: Int) -> Int {
    let tempNumber = input * 100
    return tempNumber / 100
  }
  
  override func setUp() {
    super.setUp()
    
    result = numbers.concurrentMap(numberTransform, threads: 5)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testIfItemsAreEqual() {
    // This is an example of a functional test case.
    for (index,item) in result.enumerate() {
      XCTAssertEqual(item, numbers[index])
    }
  }
  
  func testIfArrayHasSameLength() {
    XCTAssertEqual(numbers.count, result.count)
  }
  
}
