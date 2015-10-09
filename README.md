# ConcurrentMap

We all love Array.map in Swift.
Now you can speed it up by using multiple threads. Like boss.

## Why?

The question is more like, why is this not in the standard library by default :P.

## How?

      // specify the threads
      let newArray = array.concurrentMap({ pureFunction($0) }, threads: 2)
      
      // or just leave it, the default is 4!
      let newArray = array.concurrentMap { pureFunction($0) }
      
## Warning

Only use concurrentMap with pure functions that don't have any side effects (they don't manipulate objects outside their scope). If you do so, you'll open yourself to race conditions on scale. They're guaranteed to be executed parallel on background threads.

## A little bit more

- ConcurrentMap automatically batches you work according to how many threads it's distributing the functions on. If you have 1000 elements in the array, and you execute them on 10 threads, each thread will get a 100 functions.
- The default number of threads it's using is 4. This seems to be the optimum. Feel free to play around with it, and please open an issue if you found that to be misleading.

ConcurrentMap is made available under the MIT license. 
