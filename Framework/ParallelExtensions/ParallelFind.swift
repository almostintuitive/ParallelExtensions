//
//  ParallelFind.swift
//  ParallelExtensions
//
//  Created by Mark Aron Szulyovszky on 06/01/2016.
//  Copyright © 2016 itchingpixels. All rights reserved.
//

import Dispatch

public extension CollectionType where SubSequence : CollectionType, SubSequence.SubSequence == SubSequence, SubSequence.Generator.Element == Generator.Element, Index == Int {
  
  /// Returns the first index where `value` appears in `self` or `nil` if
  /// `value` is not found.
  /// Uses multiple threads.
  ///
  /// - Warning: Only use it with pure functions that don't manipulate state outside of their scope. The passed funtion is guaranteed to be executed on a background thread.
  @warn_unused_result
  public func parallelIndexOf(predicate: Generator.Element -> Bool) -> Int? {
    guard !self.isEmpty else { return nil }
    
    // if it's running on iOS, we should use the more performant version that's optimised for 2 threads.
    // this makes a huge performance difference, since it slices the array optimally.
    #if os(iOS)
      return parallelIndexOfOn2Threads(predicate)
    #elseif os(OSX)
      return parallelIndexOfWithDispatchApply(predicate)
    #endif
  }
  
  /// Return the first element in `self` satisfies `predicate`.
  /// Uses multiple threads.
  ///
  /// - Warning: Only use it with pure functions that don't manipulate state outside of their scope. The passed funtion is guaranteed to be executed on a background thread.
  @warn_unused_result
  public func parallelFind(predicate: Generator.Element -> Bool) -> Self.Generator.Element? {
    if let foundIndex = self.parallelIndexOf(predicate) {
      return self[foundIndex]
    } else {
      return nil
    }
  }

  
  /// Return `true` if an element in `self` satisfies `predicate`.
  /// Uses multiple threads.
  ///
  /// - Warning: Only use it with pure functions that don't manipulate state outside of their scope. The passed funtion is guaranteed to be executed on a background thread.
  @warn_unused_result
  public func parallelContains(predicate: Generator.Element -> Bool) -> Bool {
    if let _ = self.parallelIndexOf(predicate) {
      return true
    } else {
      return false
    }
  }

}



private extension CollectionType where SubSequence : CollectionType, SubSequence.SubSequence == SubSequence, SubSequence.Generator.Element == Generator.Element, Index == Int {
  
  private func parallelIndexOfOn2Threads(predicate: Generator.Element -> Bool) -> Int? {
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
  
  
  private func parallelIndexOfWithDispatchApply(predicate: Generator.Element -> Bool) -> Int? {
    
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


