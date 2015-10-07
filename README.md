# ConcurrentMap

We all love Array.map in Swift.
Now you can speed it up by using multiple threads. Like boss.

# Why?

The question is more like, why is this not in the standard library by default :P.

# A little bit more

- The default batch size is 10. If you have lots of elements in the collection, and you're running some quick functions, this will speed it up. If not, then probably it won't hurt. You can modify it though.
- The default number of threads it's using is 5. This seems to be the optimum according to my tests. Feel free to play around with it.
