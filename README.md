
Work in progress! ;)

# ParallelExtensions

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

more power to your .map, .forEach, .sort, .filter - just simply parallelize them!

### Why?

You architecture your app by following functional principles. You should be rewarded by the fact that now your code is easy to parallelize. Remember: anything that's newer than an iPhone5 has at least two cores.

### How?

      let newArray = array.parallelMap { pureFunction($0) }

      or you can also use the syntactic sugar and just pass the function as a parameter:

      array.parallelMap(pureFunction)

      
### Warning

Only use the parallel methods with pure functions that don't have any side effects (they don't manipulate objects outside their scope).
If you do otherwise, you'll open yourself to race conditions on scale. They're guaranteed to be executed parallel on background threads.

### Performance

None of these functions are guaranteed to have better performance than the original, single threaded operators.
You should only use them if you know that it makes sense for the type of computation to be parallel.
Ideally, you want to use it where you have lots of long tasks that do not depend on eachother.

### How does it work exactly?

It uses several different optimisation mechanism to potentially achieve better performance.
Let’s take the map operator as an example:

It doesn’t use dispatch_apply anymore, because dispatch_apply doesn’t batch the work, but it’ll create a new queue (although in a very optimised way) for every computation. This may work very well, if you’re working with operations that took more than a few milliseconds, it completely backfires if you have shorter operations, or if the operations length varies.
Instead of that, it does retrieve the number of CPU cores available, and divides the amount of transformations by that, and assign equal amount of transformations for all cores.
This makes it less vulnerable for the cases where operations are shorter, but if one of the transformations you call takes 0.1 milliseconds and the other takes a seconds, you’ll still find that it may be

It uses Array.withUnsafeMutableBufferPointer, because currently, Array.append (or the add operator that adds up two arrays), is really slow. With using unsafe access to the Array and its elements, it’s faster to create a full size Array with repeatedValue initialiser, then replace its elements one by one with the transformed ones.



ParallelExtensions is inspired [this blog post](http://blog.scottlogic.com/2014/10/29/concurrent-functional-swift.html) by [Colin Eberhardt](http://blog.scottlogic.com/ceberhardt/) and [@the1truestripes](https://twitter.com/the1truestripes)

### License

ParallelMap is made available under the MIT license.
