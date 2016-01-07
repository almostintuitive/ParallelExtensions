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
    let group = dispatch_group_create()
    
    let batchSize: Int = Int(self.count) / 2

    let found = Atomic<Bool>(false)
    
    var found1 = false
//
//    found.value = self.batchedContains(range: Range(self.startIndex..<self.endIndex), batchSize: 100, predicate: predicate, checkIfContinue: { () -> Bool in
//      return found.value == false
//    })
//    return found.value
    
//    dispatch_group_async(group, queue) { () -> Void in
//      found.value = self.batchedContains(range: Range(self.startIndex...batchSize), batchSize: max(self.count/10, 100), predicate: predicate, checkIfContinue: {
//        return found.value == false
//      })
//    }
//    
//    dispatch_group_async(group, queue) { () -> Void in
//      found.value = self.batchedContains(range: Range(batchSize..<self.endIndex), batchSize: max(self.count/10, 100), predicate: predicate, checkIfContinue: {
//        return found.value == false
//      })
//    }

    
    dispatch_group_async(group, queue) { () -> Void in
      found1 = self.batchedContains(range: Range(self.startIndex...batchSize), batchSize: max(self.count/10, 100), predicate: predicate, checkIfContinue: {
        return found1 == false
      })
    }
    
    dispatch_group_async(group, queue) { () -> Void in
      found1 = self.batchedContains(range: Range(batchSize..<self.endIndex), batchSize: max(self.count/10, 100), predicate: predicate, checkIfContinue: {
        return found1 == false
      })
    }

    dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
    return found1
  }
  
  
  
  private func batchedIndexOf(range range: Range<Self.Index>, batchSize: Int, predicate: Generator.Element -> Bool, checkIfContinue: () -> Bool) -> Int? {
    for startIndex in self.startIndex.stride(to: self.endIndex, by: batchSize) {
      let endIndex = min(startIndex + batchSize, self.count)
      for (index, item) in self[startIndex..<endIndex].enumerate() {
        if predicate(item) {
          return index
        }
      }
      if !checkIfContinue() {
        return nil
      }
      
    }
    return nil
  }
  
  private func batchedContains(range range: Range<Self.Index>, batchSize: Int, predicate: Generator.Element -> Bool, checkIfContinue: () -> Bool) -> Bool {
    if let _ = self.batchedIndexOf(range: range, batchSize: batchSize, predicate: predicate, checkIfContinue: checkIfContinue) {
      return true
    } else {
      return false
    }
  }
  
}


