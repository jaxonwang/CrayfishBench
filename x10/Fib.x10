/*
 *  This file is part of the X10 project (http://x10-lang.org).
 *
 *  This file is licensed to You under the Eclipse Public License (EPL);
 *  You may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *      http://www.opensource.org/licenses/eclipse-1.0.php
 *
 *  (C) Copyright IBM Corporation 2006-2015.
 */

import x10.io.Console;

/**
 * This is a small program to illustrate the use of 
 * async and finish in a 
 * prototypical recursive divide-and-conquer algorithm.  
 * It is obviously not intended to show a efficient way to
 * compute Fibonacci numbers in X10.

 *
 * The heart of the example is the run method,
 * which directly embodies the recursive definition of 
 * 

 *   fib(n) = fib(n-1)+fib(n-2);
 * 

 * by using an async to compute fib(n-1) while
 * the current activity computes fib(n-2).  A finish
 * is used to ensure that both computations are complete before 
 * their results are added together to compute fib(n)
 */
public class Fib {

  public static def fib(n:long) {
    if (n<=2) return 1;
    
    var f1:long;
    var f2:long;

    val world = Place.places();

    finish {
        async{
            f1 = at (world.next(here)) { fib(n-1) };
        }
        f2 = at (world.prev(here)) { fib(n-2) };
    }
    return f1 + f2;
  }

  public static def main(args:Rail[String]) {
    val n = (args.size > 0) ? Long.parse(args(0)) : 10;
    Console.OUT.println("Computing fib("+n+")");
    for (i in (0..20)){
	val f = fib(n);
	Console.OUT.println("fib("+n+") = "+f);
	}
  }
}
