//
//  ParallelFilter.swift
//  ParallelExtensions
//
//  Created by Mark Aron Szulyovszky on 17/01/2016.
//  Copyright © 2016 itchingpixels. All rights reserved.
//

import Dispatch

public extension CollectionType where SubSequence : CollectionType, SubSequence.SubSequence == SubSequence, SubSequence.Generator.Element == Generator.Element, Index == Int {

  /// Return an `Array` containing the elements of `self`,
  /// in order, that satisfy the predicate `includeElement`.
  /// Uses multiple threads.
  ///
  /// - Warning: Only use it with pure functions that don't manipulate state outside of their scope. The passed funtion is guaranteed to be executed on a background thread.
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
  
  /// Return an `Array` containing the elements of `self`,
  /// in order, that satisfy the predicate `includeElement`.
  /// Uses multiple threads.
  ///
  /// - Warning: Only use it with pure functions that don't manipulate state outside of their scope. The passed funtion is guaranteed to be executed on a background thread.
  @warn_unused_result
  public func parallelFilter(predicate: Generator.Element throws -> Bool) throws -> [Generator.Element] {
    guard !self.isEmpty else { return Array() }
    
    var results = Array<Generator.Element?>(count: self.count, repeatedValue: .None)
    var foundError: ErrorType?
    
    results.withUnsafeMutableBufferPointer { (inout buffer: UnsafeMutableBufferPointer<Generator.Element?>) -> UnsafeMutableBufferPointer<Generator.Element?> in
      dispatch_apply(self.count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { index in
        let item = self[index]
        do {
          buffer[index] = try predicate(item) ? item : nil
        } catch let error {
          foundError = error
        }
      })
      return buffer
    }
    
    if let foundError = foundError {
      throw foundError
    }
    
    return results.flatMap { $0 }
  }
  
}
