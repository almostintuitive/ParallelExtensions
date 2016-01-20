//
//  Measure.swift
//  ConcurrentMap
//
//  Created by Mark Aron Szulyovszky on 02/10/2015.
//  Copyright (c) 2015 Mark Aron Szulyovszky. All rights reserved.
//

import Foundation

func measure(title: String, block: (() -> ()) -> ()) {
  
  let startTime = CFAbsoluteTimeGetCurrent()
  
  block {
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("\(title): \(timeElapsed)")
  }
}


class Measure {
  
  var startTime: CFAbsoluteTime
  
  init() {
    self.startTime = CFAbsoluteTimeGetCurrent()
  }
  
  func finish() -> Double {
    return CFAbsoluteTimeGetCurrent() - startTime
  }
  
}