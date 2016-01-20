//
//  ParallelSortTests.swift
//  ParallelExtensions
//
//  Created by Mark Aron Szulyovszky on 20/01/2016.
//  Copyright © 2016 Mark Aron Szulyovszky. All rights reserved.
//

import XCTest

class ParallelSortTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testExample() {
    let numbers = (1000...100)
    let sortedOriginal = numbers.sort()
    let sortedParallel = numbers.parallelS
    
  }
  

}
