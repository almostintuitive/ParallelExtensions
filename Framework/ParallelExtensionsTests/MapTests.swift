//
//  ParallelExtensionsTests.swift
//  ParallelExtensionsTests
//
//  Created by Mark Aron Szulyovszky on 17/01/2016.
//  Copyright © 2016 Mark Aron Szulyovszky. All rights reserved.
//

import XCTest
@testable import ParallelExtensions

class ParallelMapTests: XCTestCase {
    
  let numbers = Array(0...9998)
  
  func numberTransform(input: Int) -> Int {
    let tempNumber = input * 100
    return tempNumber / 100
  }
  
  override func setUp() {
    super.setUp()
    
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testIfItemsAreEqual() {
    let result = numbers.parallelMap { self.numberTransform($0) }
    for (index,item) in result.enumerate() {
      XCTAssertEqual(item, numbers[index])
    }
  }
  
  func testIfArrayHasSameLength() {
    let result = numbers.parallelMap { self.numberTransform($0) }
    
    
    XCTAssertEqual(numbers.count, result.count)
  }
  
  func testWithEmptyArray() {
    let result = [Int]().parallelMap { self.numberTransform($0) }
    XCTAssertEqual(0, result.count)
  }
  
}
