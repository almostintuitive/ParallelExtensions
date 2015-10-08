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
    
    let array = Array(1...99999)
    
    measure("map on one thread", block: { (finish) -> () in
      
      let newArray = array.map({ randomString($0) })
      finish()
      
    })
    
    measure("batched concurrent map on 5 threads", block: { (finish) -> () in
      
      let newArray = array.concurrentMap( { (item) -> String in
        randomString(item)
      }, maxConcurrentOperation: 5)
      
      finish()
    })
    

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

func randomString(len:Int) -> String {
  let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  var c = Array(charSet.characters)
  var s:String = ""
  for _ in (1...100) {
    s.append(c[Int(arc4random_uniform(UInt32(c.count)))])
  }
  return s
}

