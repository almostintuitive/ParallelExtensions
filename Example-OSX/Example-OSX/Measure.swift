//
//  Measure.swift
//  Example-OSX
//
//  Created by Mark Aron Szulyovszky on 20/01/2016.
//  Copyright © 2016 Mark Aron Szulyovszky. All rights reserved.
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