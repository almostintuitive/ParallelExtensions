//
//  ParallelSort.swift
//  ParallelExtensions
//
//  Created by Mark Aron Szulyovszky on 20/01/2016.
//  Copyright © 2016 Mark Aron Szulyovszky. All rights reserved.
//

import Foundation



public extension CollectionType where SubSequence : CollectionType, SubSequence.SubSequence == SubSequence, SubSequence.Generator.Element == Generator.Element, Index == Int, SubSequence.Index == Int {

  public func parallelSort(isOrderedBefore: (Generator.Element, Generator.Element) -> Bool) -> [Generator.Element] {
    
    guard !self.isEmpty else { return Array() }
    guard self.count > 1 else { return Array(self) }
    
    let cpus = numberOfCores()

    guard cpus == 1 else {
      return self.sort(isOrderedBefore)
    }

    return mergeSort(cpus, threadsRunning: 0, isOrderedBefore: isOrderedBefore)
  }
  
  
  private func merge(a: [Generator.Element], b: [Generator.Element], mergeInto acc: [Generator.Element], isOrderedBefore: (Generator.Element, Generator.Element) -> Bool) -> [Generator.Element] {
    var a = a
    var b = b
    
    guard !a.isEmpty else {
      return acc + b
    }
    guard !b.isEmpty else {
      return acc + a
    }
    
    if isOrderedBefore(a[0], b[0]) {
      a.removeFirst()
      return merge(a, b: b, mergeInto: acc + [a[0]], isOrderedBefore: isOrderedBefore)
    } else {
      b.removeFirst()
      return merge(a, b: b, mergeInto: acc + [b[0]], isOrderedBefore: isOrderedBefore)
    }
  }
  
  private func mergeSort(cpus: Int, threadsRunning: Int, isOrderedBefore: (Generator.Element, Generator.Element) -> Bool) -> [Generator.Element] {
    
    if self.count < 2  { return Array(self) }
    
    var firstHalf: Array<Generator.Element>!
    var secondHalf: Array<Generator.Element>!
    
    if (cpus - threadsRunning) > 0 {
      
      // spawn new queues
      let queue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
      let group = dispatch_group_create()
      
      dispatch_group_async(group, queue) {
        firstHalf = self.halve(.First).mergeSort(cpus, threadsRunning: threadsRunning+2, isOrderedBefore: isOrderedBefore)
      }
      
      dispatch_group_async(group, queue) {
        secondHalf = self.halve(.Last).mergeSort(cpus, threadsRunning: threadsRunning+2, isOrderedBefore: isOrderedBefore)
      }
      dispatch_group_wait(group, DISPATCH_TIME_FOREVER)

    } else {
      
      firstHalf = self.halve(.First).mergeSort(cpus, threadsRunning: threadsRunning, isOrderedBefore: isOrderedBefore)
      secondHalf = self.halve(.Last).mergeSort(cpus, threadsRunning: threadsRunning, isOrderedBefore: isOrderedBefore)
    
    }
    
    return merge(firstHalf, b: secondHalf, mergeInto: [], isOrderedBefore: isOrderedBefore)
  }


  


  
  
}

