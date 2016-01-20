//
//  ParallelSort.swift
//  ParallelExtensions
//
//  Created by Mark Aron Szulyovszky on 20/01/2016.
//  Copyright © 2016 Mark Aron Szulyovszky. All rights reserved.
//

import Foundation

public extension Array where Element: Comparable {


  private func merge(a: [Element], b: [Element], mergeInto acc: [Element]) -> [Element] {
    guard !a.isEmpty else {
      return acc + b
    }
    guard !b.isEmpty else {
      return acc + a
    }
    
    if a[0] < b[0] {
      return merge(Array(a.dropFirst(1)), b: b, mergeInto: acc + [a[0]])
    } else {
      return merge(a, b: Array(b.dropFirst(1)), mergeInto: acc + [b[0]])
    }
  }
  
  func mergeSort(cpus: Int, threadsRunning: Int) -> Array {
    
    guard self.count > 1 else {
      return self
    }
    
    var firstHalf: Array!
    var secondHalf: Array!
    
    if cpus - threadsRunning > 0 {
      
      let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
      let group = dispatch_group_create()
      
      dispatch_group_async(group, queue) { () -> Void in
        firstHalf = Array(self[0...self.count/2]).mergeSort(cpus, threadsRunning: threadsRunning-1)
      }
      
      dispatch_group_async(group, queue) { () -> Void in
        secondHalf = Array(self[self.count/2...self.count]).mergeSort(cpus, threadsRunning: threadsRunning-1)
      }
      dispatch_group_wait(group, DISPATCH_TIME_FOREVER)

    } else {
      firstHalf = Array(self[0...self.count/2]).mergeSort(cpus, threadsRunning: threadsRunning)
      secondHalf = Array(self[self.count/2...self.count]).mergeSort(cpus, threadsRunning: threadsRunning)
    }
    

    
    return merge(firstHalf, b: secondHalf, mergeInto: [])
    
  }

  public func parallelSort() -> Array {
    
    guard self.count > 1 else {
      return self
    }
    
    let cpus = numberOfCpus()
//    
//    guard cpus == 1 else {
//      return self.sort()
//    }
//    
    return mergeSort(cpus, threadsRunning: 0)
  }
  
  
}

