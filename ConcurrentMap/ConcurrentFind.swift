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
    
    let divideBy = 10
    let batchSize: Int = Int(self.count) / divideBy
    
    var found = [Int]()
    
    dispatch_apply(divideBy, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { index in
      let start = self.startIndex + (index * batchSize)
      let end = start + batchSize
      let index = self.batchedIndexOf(range: Range(start...end), batchSize: max(batchSize, 100), predicate: predicate, checkIfContinue: {
        return found.isEmpty
      })
      if let index = index {
        found.append(index)
      }
    }
    
    return found.first
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


