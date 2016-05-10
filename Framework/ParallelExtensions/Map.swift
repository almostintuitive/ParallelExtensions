//
//  ParallelMap.swift
//  ParallelExtensions
//
//  Created by Mark Aron Szulyovszky on 01/10/2015.
//  Copyright (c) 2015 Mark Aron Szulyovszky. All rights reserved.
//

import Dispatch

public extension CollectionType where SubSequence : CollectionType, SubSequence.SubSequence == SubSequence, SubSequence.Generator.Element == Generator.Element, Index == Int {
  
  /// Return an `Array` containing the results of mapping `transform`
  /// over `self`. Uses multiple threads.
  /// 
  /// - Warning: Only use it with pure functions that don't manipulate state outside of their scope. The passed funtion is guaranteed to be executed on a background thread.
  @warn_unused_result
  func parallelMap<U>(@noescape transform: Generator.Element -> U) -> [U] {
    typealias Transform = Generator.Element -> U
    let transform = unsafeBitCast(transform, Transform.self)
    
    guard !self.isEmpty else { return Array() }
    
    let r = transform(self[self.startIndex])
    var results = Array<U>(count: self.count, repeatedValue:r)
    
    results.parallelIterateWithUnsafeMutableBuffer { (index, buffer) -> UnsafeMutableBufferPointer<U> in
      buffer[index] = transform(self[index])
      return buffer
    }
    
    return results
  }
  
  /// Return an `Array` containing the results of mapping `transform`
  /// over `self`. Uses multiple threads.
  ///
  /// - Warning: Only use it with pure functions that don't manipulate state outside of their scope. The passed funtion is guaranteed to be executed on a background thread.
  @warn_unused_result
  func parallelMap<U>(@noescape transform: Generator.Element throws -> U) throws -> [U] {
    typealias Transform = Generator.Element throws -> U
    let transform = unsafeBitCast(transform, Transform.self)
    
    guard !self.isEmpty else { return Array() }
    
    do {
      let r = try transform(self[self.startIndex])
      var results = Array<U>(count: self.count, repeatedValue:r)
      
      var foundError: ErrorType?
      
      results.parallelIterateWithUnsafeMutableBuffer { (index, buffer) -> UnsafeMutableBufferPointer<U> in
        do {
          buffer[index] = try transform(self[index])
        } catch let error {
          foundError = error
        }
        return buffer
      }
      
      if let foundError = foundError {
        throw foundError
      }

      return results
    }
  }
  
}