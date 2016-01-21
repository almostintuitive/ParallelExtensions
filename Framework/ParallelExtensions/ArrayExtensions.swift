//
//  ArrayExtension.swift
//  ParallelExtensions
//
//  Created by Mark Aron Szulyovszky on 20/01/2016.
//  Copyright © 2016 Mark Aron Szulyovszky. All rights reserved.
//

internal enum Half {
  case First, Last
}

internal extension CollectionType where SubSequence : CollectionType, SubSequence.SubSequence == SubSequence, SubSequence.Generator.Element == Generator.Element, Index == Int, SubSequence.Index == Int {
  
  internal func halve(half: Half) -> SubSequence {
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
  
  @inline(__always) internal mutating func withUnsafeMutableBufferIterate(body: (index: Int, buffer: UnsafeMutableBufferPointer<Element>) -> UnsafeMutableBufferPointer<Element>) {
    self.withUnsafeMutableBufferPointer { (inout buffer: UnsafeMutableBufferPointer<Element>) -> UnsafeMutableBufferPointer<Element> in
      dispatch_apply(self.count, dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), { index in
        body(index: index, buffer: buffer)
      })
      return buffer
    }
  }
  
}
