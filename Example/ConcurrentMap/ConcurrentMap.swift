//
//  ConcurrentMap.swift
//  ConcurrentMap
//
//  Created by Mark Aron Szulyovszky on 01/10/2015.
//  Copyright (c) 2015 Mark Aron Szulyovszky. All rights reserved.
//

import Foundation


extension Array {

  func concurrentMap<U>(transform: (Element -> U), completion: (Array<U> -> Void), maxConcurrentOperation: Int = 5, batchSize: Int = 10) {

    func concurrentMapNonBatched<E, B>(array: Array<E>, transform: (E -> B), completion: (Array<B> -> Void), maxConcurrentOperation: Int = 5) {
      
      let queue = NSOperationQueue()
      queue.maxConcurrentOperationCount = maxConcurrentOperation
      
      let lock = Syncronized(value: array)
      var operationsLeft = array.count
      
      let r = transform(array[0])
      var results = Array<B>(count: array.count, repeatedValue:r)
      
      for (index, item) in array.enumerate() {
        queue.addOperationWithBlock({ () -> Void in
          let r = transform(item)
          lock.modify({ () -> () in
            results[index] = r
            operationsLeft--
            if operationsLeft <= 0 {
              completion(results)
            }
          })
        })
      }
    }

    if batchSize <= 1 {
      concurrentMapNonBatched(self, transform: transform, completion: completion, maxConcurrentOperation: maxConcurrentOperation)
      return
    }
    
    let slices = self.deconstruct(batchSize)
    
    concurrentMapNonBatched(slices, transform: { (slice) -> ConstructructableArraySlice<U> in
      let transformedSlice = ConstructructableArraySlice<U>(array: slice.array.map { transform($0) }, startIndex: slice.startIndex)
      return transformedSlice
    }, completion: { (results) -> Void in
      completion(Array.construct(results))
    }, maxConcurrentOperation: maxConcurrentOperation)
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


class Syncronized<T> {
  
  init(value: T) {
    self.value = value
  }
  
  var value: T {
    get {
      var returnValue: T!
      objc_sync_enter(self)
      returnValue = backingValue
      objc_sync_exit(self)
      return returnValue
    }
    set {
      objc_sync_enter(self)
      backingValue = newValue
      objc_sync_exit(self)
    }
  }
  
  func modify(closure: () -> ()) {
    objc_sync_enter(self)
    closure()
    objc_sync_exit(self)
  }
  
  private var backingValue: T!
}



