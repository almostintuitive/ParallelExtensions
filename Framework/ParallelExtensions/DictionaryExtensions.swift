//
//  CommonExtensions.swift
//  ConcurrentMapExample
//
//  Created by Mark Aron Szulyovszky on 15/01/2016.
//  Copyright © 2016 itchingpixels. All rights reserved.
//

internal extension Dictionary {
  
  subscript (safe key: Key) -> Value? {
    if let foundValue = self[key] {
      return foundValue
    } else {
      return nil
    }
  }
  
}

