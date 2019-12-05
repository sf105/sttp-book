---
chapter-number: 1
title: Why software testing?
layout: chapter
toc: true
author: by Maurício Aniche
---

## Motivation

**Welcome to the first chapter of Software Testing: From Theory to Practice!** In this book, we are going to teach you how to effectively test a 
software and make sure it works, and how to, as much as possible, 
automate every step that we can. 

By testing software, we mean that we are gonna explore different techniques to design test cases. For example, based on the requirements, based on the source code, analyze boundaries, and etc. And by automation, we mean making sure that a machine can do the tasks that humans would just take too much time to do, or would not be as good as a machine.   

You are gonna see throughout the course that software testing is a very creative activity, and while creativity's fundamental, we are going to study systematic and rigorous ways to derive test cases. In addition, this course will be very practical. Meaning, whenever we discuss some technique, we are going to apply this technique in several examples.  You should expect to see a lot of Java code throughout this course. And we hope that you can then generalize everything you learn here to test the software that you work in your real life. 

And so why should we think about software testing? **Why should we actually care about software testing?**  Because bugs are everywhere. And you, as a human being, probably faced a few bugs in your life. Some of them probably did not affect you that much, but definitely some other bugs really affected your life.

So just to give an impression of how easy doing mistakes is, let's start with a requirement.   

Let's suppose we have this customer and this person wants a software that given a list of numbers the software, the software should return the smallest and the largest number in this list. 

This looks like a very simple program to do. Let's get our hands dirty and implement it in Java:

```java
public class NumFinder {
  private int smallest = Integer.MAX_VALUE;
  private int largest = Integer.MIN_VALUE;

  public void find(int[] nums) {
    for(int n : nums) {
      if(n < smallest) smallest = n;
      else if(n > largest) largest = n;
    }
  }

  // getters for smallest and largest
}
```


The idea behind the code is as follows: we go through all the elements of this list and store the smallest number in a variable and the largest number in another variable.   If n is smaller than the smallest number we have seen, we replace it. 
We do the same for the largest: if n is bigger than largest, we just replace largest to n. 

And, as developers, that is what we often do: we implement the requirements, and then do small checks to make sure it works.  One way to do a small check would be to come up with a main method that tries the program a bit. 

As an example, let's see what happens if we execute our program with some random numbers as inputs, like, 4, 25, 7, and 9. 

To see if the program behaves correctly, let's just print the largest and smallest fields. Printing debug information is quite common:

```java
public class NumFinderMain {

  public static void main (String[] args) {
    NumFinder nf = new NumFinder();
    nf.find(new int[] {4, 25, 7, 9});

    System.out.println(nf.getLargest());
    System.out.println(nf.getSmallest());
  }
}
```

The output we get is: `25, 4`. This means our software works! We can ship it to our customers! **Can we...?**

We will certainly have problems with this code... Because this implementation does not work for all the possible cases. **There's a bug in there!** (Can you find the bug? Come back to the code above and look for it!)


If we pass an input like 4, 3, 2, and 1; or, in other words, numbers in decreased order, we would get an output like this: `-2147483648, 1`.

We indeed have a bug. Before anything else, let's just fix it.
If we go back to the source code, we can see that this bug is 
actually caused by the `else if`. 

```java
public class NumFinder {
  private int smallest = Integer.MAX_VALUE;
  private int largest = Integer.MIN_VALUE;

  public void find(int[] nums) {
    for(int n : nums) {
      if(n < smallest) smallest = n;

      // BUG was here!!
      if(n > largest) largest = n;
    }
  }

  // getters for smallest and largest
}
```

Take a moment here to understand why. This else if should actually just be an if. 

Yes, this is indeed a very simple bug. But the point is that those mistakes 
can and do happen all the time. As developers, we usually deal with very complex software and it is challenging for us to have everything in our minds. 

**This is why we need to test software. Because bugs do happen.  And they can really have a huge impact in our lifes.**

And that is what we are going to focus throughout this course. Hopefully, with everything we are going to teach you, you will have enough knowledge to rigorously test your software, and make sure that bugs like thise one do not happen.

<iframe width="560" height="315" src="https://www.youtube.com/embed/xtLgp8LXWp8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>