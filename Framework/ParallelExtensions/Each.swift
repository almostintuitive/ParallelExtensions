//
//  ParallelEach.swift
//  ParallelExtensions
//
//  Created by Mark Aron Szulyovszky on 20/01/2016.
//  Copyright © 2016 Mark Aron Szulyovszky. All rights reserved.
//

import Foundation

public extension CollectionType where SubSequence : CollectionType, SubSequence.SubSequence == SubSequence, SubSequence.Generator.Element == Generator.Element, Index == Int {
  
  /// Call `body` on each element in `self` in the same order as a
  /// *for-in loop.*
  /// Uses multiple threads.
  ///
  ///     sequence.forEach {
  ///       // body code
  ///     }
  ///
  /// is similar to:
  ///
  ///     for element in sequence {
  ///       // body code
  ///     }
  ///
  /// - Note: You cannot use the `break` or `continue` statement to exit the
  ///   current call of the `body` closure or skip subsequent calls.
  /// - Note: Using the `return` statement in the `body` closure will only
  ///   exit from the current call to `body`, not any outer scope, and won't
  ///   skip subsequent calls.
  ///
  /// - Complexity: O(`self.count`)
  ///
  /// - Warning: Only use it with pure functions that don't manipulate state outside of their scope. The passed funtion is guaranteed to be executed on a background thread.
  @warn_unused_result
  public func parallelForEach(@noescape body: Generator.Element -> Void) {
    guard !self.isEmpty else { return }
    
    typealias Body = Generator.Element -> Void
    let body1 = unsafeBitCast(body, Body.self)
    
    dispatch_apply(self.count, dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), { index in
      body1(self[index])
    })
  }
  
}

