//
//  ParallelFilter.swift
//  ParallelExtensions
//
//  Created by Mark Aron Szulyovszky on 17/01/2016.
//  Copyright © 2016 itchingpixels. All rights reserved.
//

import Dispatch

public extension CollectionType where SubSequence : CollectionType, SubSequence.SubSequence == SubSequence, SubSequence.Generator.Element == Generator.Element, Index == Int {

  @warn_unused_result
  public func parallelFilter(predicate: Generator.Element -> Bool) -> [Generator.Element] {
    guard !self.isEmpty else { return Array() }

    var results = Array<Generator.Element?>(count: self.count, repeatedValue: .None)
    
    results.withUnsafeMutableBufferPointer { (inout buffer: UnsafeMutableBufferPointer<Generator.Element?>) -> UnsafeMutableBufferPointer<Generator.Element?> in
      dispatch_apply(self.count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { index in
        let item = self[index]
        buffer[index] = predicate(item) ? item : nil
      })
      return buffer
    }
    return results.flatMap { $0 }
  }
  
}
