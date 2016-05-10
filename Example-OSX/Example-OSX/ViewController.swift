//
//  ViewController.swift
//  Example-OSX
//
//  Created by Mark Aron Szulyovszky on 20/01/2016.
//  Copyright © 2016 Mark Aron Szulyovszky. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let array = Array(1...3999)
    
    measure("map on one thread", block: { (finish) -> () in
      let newArray = array.map { randomString($0) }
      print(newArray.count)
      finish()
    })
    
    measure("parallel map", block: { (finish) -> () in
      let newArray = array.parallelMap { randomString($0) }
      print(newArray.count)
      finish()
    })
    
    
    let array2 = Array(1...3999999)
    
    measure("contains on one thread", block: { finish in
      let result = array2.contains { 3999998 == $0 }
      print(result)
      finish()
    })
    
    
    
    measure("contains on multiple threads", block: { finish in
      let result = array2.parallelContains { 3999998 == $0 }
      print(result)
      finish()
    })
    
    measure("filter on one thread", block: { finish in
      let result = array2.filter { $0 % 2 == 0 }
      print(result.count)
      finish()
    })
    
    measure("filter on multiple threads", block: { finish in
      let result = array2.parallelFilter { $0 % 2 == 0 }
      print(result.count)
      finish()
    })
    
    measure("sort on one thread", block: { finish in
      let result = array2.sort(<)
      print(result.count)
      finish()
    })
    
    measure("sort on multiple threads", block: { finish in
      let result = array2.parallelSort(<)
      print(result.count)
      finish()
    })
    
  }
  
}

func randomString(len:Int) -> String {
  let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  var c = Array(charSet.characters)
  var s:String = ""
  for i in (1...500) {
    s.append(c[min(charSet.characters.count-1, i)])
  }
  return s
}

