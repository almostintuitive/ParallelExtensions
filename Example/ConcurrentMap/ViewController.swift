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
    
    measure("concurrent map with two threads", block: { (finish) -> () in
      
      array.concurrentMap({ (item) -> String in
        return randomString(item)
      }, completion: {sequence in
        finish()
      }, maxConcurrentOperation: 5, batchSize: 1)
      
    })
    
    measure("batched concurrent map with two threads", block: { (finish) -> () in
      array.concurrentMap({ (item) -> String in
        return randomString(item)
      }, completion: { sequence in
        finish()
      }, maxConcurrentOperation: 5, batchSize: 10)
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
    s.append(c[Int(arc4random()) % c.count])
  }
  return s
}

