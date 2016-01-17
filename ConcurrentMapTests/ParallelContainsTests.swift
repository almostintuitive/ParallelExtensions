//
//  ParallelContainsTests.swift
//  ConcurrentMap
//
//  Created by Mark Aron Szulyovszky on 06/01/2016.
//  Copyright © 2016 itchingpixels. All rights reserved.
//

import XCTest

class ParallelContainsTests: XCTestCase {

  
  let numbers = Array(0...99998)
  
  
  override func setUp() {
    super.setUp()
    
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testIfItemsAreEqual() {
    let result = numbers.parallelContains { $0 == 99997 }
    XCTAssertEqual(true, result)

  }
  
  
  func testWithEmptyArray() {
    let result = [Int]().parallelContains { $0 == 99997 }
    XCTAssertEqual(false, result)
  }

  
 
  func testOldPerformanceExample() {
    self.measureBlock {
      let result = self.numbers.contains { $0 == 99997 }
    }
  }
  
  func testNewPerformance() {
    self.measureBlock {
      let result = self.numbers.parallelContains { $0 == 99997 }
    }
  }

}
