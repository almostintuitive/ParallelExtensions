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
  
  func testSortWith100Items() {
    let numbers = Array(1...100)
    let sortedOriginal = numbers.sort(<)
    let sortedParallel = numbers.parallelSort(<)
    
    XCTAssertEqual(sortedOriginal, sortedParallel)
  }
  
  func testSortWith199Items() {
    let numbers = Array(1...199)
    let sortedOriginal = numbers.sort(<)
    let sortedParallel = numbers.parallelSort(<)
    
    XCTAssertEqual(sortedOriginal, sortedParallel)
    
  }
  
  

}
