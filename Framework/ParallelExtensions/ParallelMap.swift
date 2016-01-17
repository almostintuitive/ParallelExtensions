//
//  ParallelMap.swift
//  ParallelExtensions
//
//  Created by Mark Aron Szulyovszky on 01/10/2015.
//  Copyright (c) 2015 Mark Aron Szulyovszky. All rights reserved.
//

import Dispatch

public extension CollectionType where SubSequence : CollectionType, SubSequence.SubSequence == SubSequence, SubSequence.Generator.Element == Generator.Element, Index == Int {
  
  @warn_unused_result
  public func parallelMap<U>(transform: Generator.Element -> U) -> [U] {
    guard !self.isEmpty else { return Array() }
    
    let r = transform(self[self.startIndex])
    var results = Array<U>(count: self.count, repeatedValue:r)
    
    results.withUnsafeMutableBufferPointer { (inout buffer: UnsafeMutableBufferPointer<U>) -> UnsafeMutableBufferPointer<U> in
      dispatch_apply(self.count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { index in
        buffer[index] = transform(self[index])
      })
      return buffer
    }
    
    return results
  }
  
}