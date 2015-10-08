//
//  ConcurrentMap.swift
//  ConcurrentMap
//
//  Created by Mark Aron Szulyovszky on 01/10/2015.
//  Copyright (c) 2015 Mark Aron Szulyovszky. All rights reserved.
//

import Foundation


extension Array {

  func concurrentMap<U>(transform: (Element -> U), threads: Int = 4) -> Array<U> {

    func processTransformations<E, B>(array: Array<E>, transform: (E -> B), threads: Int = 5) -> Array<B> {

      let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
      let group = dispatch_group_create()
      
      var results = [B]()
      
      for item in array {
        dispatch_group_async(group, queue) {
          results.append(transform(item))
        }
      }
  
      dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
      return results
    }
    
    let batchSize: Int = self.count / threads
    
    let slices = self.deconstruct(batchSize)
    let results = processTransformations(slices, transform: { (slice) -> ConstructructableArraySlice<U> in
      return ConstructructableArraySlice<U>(array: slice.array.map { transform($0) }, startIndex: slice.startIndex)
    }, threads: threads)
    
    return Array.construct(results)
  }
}






struct ConstructructableArraySlice<T> {
  var array: Array<T>
  var startIndex: Int
}


extension Array {
  
  func deconstruct(size: Int) -> [ConstructructableArraySlice<Element>] {
    var slices = [ConstructructableArraySlice<Element>]()
    for index in self.startIndex.stride(through: self.endIndex-1, by: size) {
      let slice = ConstructructableArraySlice<Element>(array: Array(self[index...min(index.advancedBy(size-1), self.endIndex-1)]), startIndex: index)
      slices.append(slice)
    }
    return slices
  }
  
  static func construct<T>(fromConstructables: [ConstructructableArraySlice<T>]) -> Array<T> {
    return fromConstructables.sort { $0.startIndex < $1.startIndex }.flatMap{ $0.array }
  }
}



