//
//  ConcurrentMap.swift
//  ConcurrentMap
//
//  Created by Mark Aron Szulyovszky on 01/10/2015.
//  Copyright (c) 2015 Mark Aron Szulyovszky. All rights reserved.
//

import Foundation


public extension CollectionType where SubSequence : CollectionType, SubSequence.SubSequence == SubSequence, SubSequence.Generator.Element == Generator.Element, Index == Int {

  @warn_unused_result
  public func concurrentMap<U>(transform: (Self.Generator.Element -> U), threads: Int = 4) -> [U] {

    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    let group = dispatch_group_create()
    
    let batchSize: Int = Int(self.count) / threads
    let r = transform(self[self.startIndex])

    var results = Array<U>(count: self.count, repeatedValue:r)
    
    results.withUnsafeMutableBufferPointer { (inout buffer: UnsafeMutableBufferPointer<U>) -> UnsafeMutableBufferPointer<U> in
      for startIndex in self.startIndex.stride(to: self.endIndex, by: batchSize) {
        dispatch_group_async(group, queue, {
          let endIndex = min(startIndex + batchSize, self.count)
          for (index, item) in self[startIndex..<endIndex].enumerate() {
            buffer[index] = transform(item)
          }
        })
      }
      return buffer
    }
    
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
    return results
    
  }
}


