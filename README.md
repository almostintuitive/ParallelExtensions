# ParallelExtensions

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

We all love Array.map in Swift.
Now you can speed it up by using multiple threads. Like a boss.

### Why?

You architecture your app by following functional principles. You should be rewarded by the fact that now your code is easy to parallelize. Remember: anything that's newer than an iPhone5 has at least two cores.

### How?

      let newArray = array.parallelMap { pureFunction($0) }
      
      
### Warning

Only use parallelMap with pure functions that don't have any side effects (they don't manipulate objects outside their scope). If you do otherwise, you'll open yourself to race conditions on scale. They're guaranteed to be executed parallel on background threads.

### A little bit more

- ParallelMap automatically batches you work according to how many threads it's distributing the functions on. It uses dispatch_apply under the hood.

ParallelMap is inspired [this blog post](http://blog.scottlogic.com/2014/10/29/concurrent-functional-swift.html) by [Colin Eberhardt](http://blog.scottlogic.com/ceberhardt/) and [@the1truestripes](https://twitter.com/the1truestripes)

### License

ParallelMap is made available under the MIT license. 
