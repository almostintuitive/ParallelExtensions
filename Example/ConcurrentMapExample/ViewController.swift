//
//  ViewController.swift
//  ConcurrentMap
//
//  Created by Mark Aron Szulyovszky on 01/10/2015.
//  Copyright (c) 2015 Mark Aron Szulyovszky. All rights reserved.
//

import UIKit
  
class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let array = Array(1...3999)
    
    measure("map on one thread", block: { (finish) -> () in
      
      let newArray = array.map({ randomString($0) })
      finish()
      
    })
    
    measure("parallel map", block: { (finish) -> () in
      
      let newArray = array.parallelMap { randomString($0) }
      finish()
    })

  }

}

func randomString(len:Int) -> String {
  let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  var c = Array(charSet.characters)
  var s:String = ""
  for _ in (1...5000) {
    s.append(c[Int(arc4random_uniform(UInt32(c.count)))])
  }
  return s
}

