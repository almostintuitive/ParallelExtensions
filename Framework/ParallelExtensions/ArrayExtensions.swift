//
//  ArrayExtension.swift
//  ParallelExtensions
//
//  Created by Mark Aron Szulyovszky on 20/01/2016.
//  Copyright © 2016 Mark Aron Szulyovszky. All rights reserved.
//

import Dispatch

internal enum Half {
  case First, Last
}

internal extension CollectionType where SubSequence : CollectionType, SubSequence.SubSequence == SubSequence, SubSequence.Generator.Element == Generator.Element, Index == Int, SubSequence.Index == Int {
  
  func halve(half: Half) -> SubSequence {
    if self.count == 2 {
      switch half {
      case .First:
        return self[self.startIndex...self.startIndex]
      case .Last:
        return self[self.endIndex-1...self.endIndex-1]
      }
    } else {
      let middle = self.startIndex + (self.endIndex - self.startIndex)/2
      switch half {
      case .First:
        return self[self.startIndex..<middle]
      case .Last:
        return self[middle..<self.endIndex]
      }
    }
  }

}


internal extension Array {
  
  @inline(__always) mutating func parallelIterateWithUnsafeMutableBuffer(body: (index: Int, inout buffer: UnsafeMutableBufferPointer<Element>) -> UnsafeMutableBufferPointer<Element>) {
    
    let queue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
    let group = dispatch_group_create()
    
    let batchSize = Int(self.count) / numberOfCores()
    
    let startIndex = self.startIndex
    let endIndex = self.endIndex
    let count = self.count
    
    self.withUnsafeMutableBufferPointer { (inout buffer: UnsafeMutableBufferPointer<Element>) -> UnsafeMutableBufferPointer<Element> in
      
      for startIndex in startIndex.stride(to: endIndex, by: batchSize) {
        dispatch_group_async(group, queue) {
          let endIndex = min(startIndex + batchSize, count)
          for index in startIndex..<endIndex {
            buffer = body(index: index, buffer: &buffer)
          }
        }
      }
      return buffer
      
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
  }
  
}
