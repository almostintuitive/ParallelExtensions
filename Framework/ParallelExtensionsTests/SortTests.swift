//
//  ParallelSortTests.swift
//  ParallelExtensions
//
//  Created by Mark Aron Szulyovszky on 20/01/2016.
//  Copyright © 2016 Mark Aron Szulyovszky. All rights reserved.
//

import XCTest
@testable import ParallelExtensions


class ParallelSortTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testExample() {
    let numbers = Array(1...100)
    let sortedOriginal = numbers.sort(<)
    let sortedParallel = numbers.parallelSort(<)
    
    XCTAssertEqual(sortedOriginal, sortedParallel)
    
  }
  

}
