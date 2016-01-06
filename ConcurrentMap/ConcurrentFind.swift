//
//  ConcurrentFind.swift
//  ConcurrentMap
//
//  Created by Mark Aron Szulyovszky on 06/01/2016.
//  Copyright © 2016 itchingpixels. All rights reserved.
//

import Foundation

public extension CollectionType where SubSequence : CollectionType, SubSequence.SubSequence == SubSequence, SubSequence.Generator.Element == Generator.Element, Index == Int {
  
  @warn_unused_result
  public func parallelContains(predicate: Self.Generator.Element -> Bool) -> Bool {
    guard !self.isEmpty else { return false }
    
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    let semaphore = dispatch_semaphore_create(2)
    let batchSize: Int = Int(self.count) / 2

    var found = (false, false)

    dispatch_async(queue) {
      found.0 = self[self.startIndex...batchSize].contains(predicate)
      dispatch_semaphore_signal(semaphore)
    }
    
    dispatch_async(queue) {
      found.1 = self[batchSize...self.endIndex].contains(predicate)
      dispatch_semaphore_signal(semaphore)
    }
      
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    return found.0 == true || found.1 == true
  }
}
    