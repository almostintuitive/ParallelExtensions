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
  public func parallelIndexOf(predicate: Self.Generator.Element -> Bool) -> Int? {
    guard !self.isEmpty else { return nil }
    
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    let group = dispatch_group_create()
    
    let batchSize: Int = Int(self.count) / 2
    
    var found = [Int: Int]()
    
    dispatch_group_async(group, queue) { () -> Void in
      found[0] = self.batchedIndexOf(range: Range(self.startIndex...batchSize), batchSize: max(self.count/10, 100), predicate: predicate, checkIfContinue: {
        return found[safe: 0] == nil && found[safe: 1] == nil
      })
    }
    
    dispatch_group_async(group, queue) { () -> Void in
      found[1] = self.batchedIndexOf(range: Range(batchSize..<self.endIndex), batchSize: max(self.count/10, 100), predicate: predicate, checkIfContinue: {
        return found[safe: 0] == nil && found[safe: 1] == nil
      })
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
    return found.values.first
  }
  

  @warn_unused_result
  public func parallelFind(predicate: Self.Generator.Element -> Bool) -> Self.Generator.Element? {
    if let foundIndex = self.parallelIndexOf(predicate) {
      return self[foundIndex]
    } else {
      return nil
    }
  }

  
  
  @warn_unused_result
  public func parallelContains(predicate: Self.Generator.Element -> Bool) -> Bool {
    if let _ = self.parallelIndexOf(predicate) {
      return true
    } else {
      return false
    }
  }
  

  
  
  private func batchedIndexOf(range range: Range<Self.Index>, batchSize: Int, predicate: Generator.Element -> Bool, checkIfContinue: () -> Bool) -> Int? {
    for startIndex in range.startIndex.stride(to: range.endIndex, by: batchSize) {
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
  
}


