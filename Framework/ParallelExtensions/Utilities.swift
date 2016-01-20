//
//  Utilities.swift
//  ParallelExtensions
//
//  Created by Mark Aron Szulyovszky on 20/01/2016.
//  Copyright © 2016 Mark Aron Szulyovszky. All rights reserved.
//

internal func numberOfCpus() -> Int {
  var cpuCores: UInt32 = 0
  var len = sizeof(UInt32)
  sysctlbyname ("hw.ncpu", &cpuCores, &len, nil ,0);
  return Int(cpuCores)
}