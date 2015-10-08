//
//  ConcurrentMap.swift
//  ConcurrentMap
//
//  Created by Mark Aron Szulyovszky on 01/10/2015.
//  Copyright (c) 2015 Mark Aron Szulyovszky. All rights reserved.
//

import Foundation


extension Array {

  func concurrentMap<U>(transform: (Element -> U), maxConcurrentOperation: Int = 5) -> Array<U> {

    func concurrentMapNonBatched<E, B>(array: Array<E>, transform: (E -> B), maxConcurrentOperation: Int = 5) -> Array<B> {

      let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
      let group = dispatch_group_create()
      
      let r = transform(array[0])
      var results = Array<B>(count: array.count, repeatedValue:r)
      
      for (index, item) in array.enumerate() {
        dispatch_group_async(group, queue) {
          let r = transform(item)
          results[index] = r
        }
      }
  
      dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
      return results
    }
    
    let batchSize: Int = self.count / maxConcurrentOperation
    
    let slices = self.deconstruct(batchSize)
    
    return Array.construct( concurrentMapNonBatched(slices, transform: { (slice) -> ConstructructableArraySlice<U> in
      let transformedSlice = ConstructructableArraySlice<U>(array: slice.array.map { transform($0) }, startIndex: slice.startIndex)
      return transformedSlice
    }, maxConcurrentOperation: maxConcurrentOperation)
    )
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



