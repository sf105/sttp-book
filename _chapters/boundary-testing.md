---
chapter-number: 5
title: Boundary Testing
layout: chapter
toc: true
author: Maurício Aniche and Arie van Deursen
---

## Introduction

A high number of bugs happen in the **boundaries** of your program.
In this chapter we are going to derive tests for these boundaries.

The boundaries can reside between partitions or specific conditions.
Off-by-one errors, i.e., when your program outcome is "off by one",
often occur because of the lack of boundary testing.

## Boundaries in between classes/partitions

Whenever we devised partitions/classes, these classes have "close boundaries"
with the other classes.

We can find such boundaries by finding a pair of consecutive input values $$[p_1,p_2]$$, where $$p_1$$ belongs to partition A, and $$p_2$$ belongs to partition B.
In other words,
the boundary itself is where our program changes from our class to the other.
As testers, we should make sure that everything works smoothly (i.e., the program
still behaves correctly) near these values.

{% include example-begin.html %}
**Requirement: Calculating the amount of points of the player**

Our program has two inputs: the score of the player and the remaining life of the player.
If the player's score is below 50, then it always adds 50 points.
If the remaining life is above or equal to 3 lives and the score is greater than or equals to 50, the player's score is doubled.

When devising the partitions to test this method, we come up with the following partitions:

1. Score < 50
2. Score >= 50 and remaining life < 3
3. Score >= 50 and remaining life >= 3

When the score is strictly smaller than 50 it is part of the first partition.
From a score of 50 the test case will be part of partitions 2 or 3.
Now we have found a boundary between partitions 1 and 2, 3.
This boundary is between the score of 49 and 50.

We also find a boundary between partitions 2 and 3.
This boundary is between the remaining life.
When the remaining life is smaller than 3, it belongs to partition 2; otherwise it belongs to partition 3.

We can visualize these partitions with their boundaries in a diagram.
![Partitions with their boundaries](/assets/img/boundary-testing/examples/partition_boundaries.svg)

{% include example-end.html %}

To sum up: you should devise tests for the inputs at the 
boundaries of your classes.


## Analysing conditions

We briefly discussed the off-by-one errors earlier.
Errors where the system behaves incorrectly for values on and close to the boundary are very easily made.
In practice, think of how many times the bug was in the boolean condition of your `if` or `for` condition, and the fix was basically
replacing a `>=` by a `>`.

When we have a properly specific condition, e.g., `x > 100`, we can analyse the boundaries of this condition.
First, we need to go over some terminology:

- On-point: the value that is on the boundary. This is the value we see in the condition.
- Off-point: the value closest to the boundary that flips the conditions. So if the on-point makes the condition true, the off point makes it false and vice versa. Note: when dealing with equalities or non equalities (e.g. $$x == 6$$ or $$x != 6$$), there are two off-points; one in each direction.
- In-points are all the values that make the condition true.
- Out-points are all the values that make the condition false.

Note that, depending on the condition, an on-point can be either an in- or an out-point.

{% include example-begin.html %}
Suppose we have a program that adds shipping costs when the total price is below 100.

The condition used in the program is $$x < 100$$.

* The on-point is $$100$$, as that is the value in the condition.
* The on-point makes the condition false, so the off-point should be the closest number that makes the condition true.
This will be $$99$$,  $$99 < 100$$ is true.
* The in-points are all the values smaller than or equal to $$99$$.
* The out-points are all values larger than or equal to $$100$$.

We show all these points in the diagram below.

![On- and off-points, in- and out-points](/assets/img/boundary-testing/examples/on_off_points.svg)

Now, let's compare it to the next condition $$x <= 100$$ (note how similar they are; the only difference is that, in this one, we use smaller than or equals to):

- The on-point is still $$100$$: this is the point in the condition
- Now the condition is true for the on-point. So, the off-point should make the condition false; the off-point is $$101$$.

![On-, off-, in- and out-points 2](/assets/img/boundary-testing/examples/on_off_points2.svg)

Note that, in the diagram, the on-point is part of the in-points, and the off-point is part of the out-points.

{% include example-end.html %}

As a tester, you devise test cases for these different points.

Now that we know the meaning of these different points we can start the boundary analysis in more complicated cases.
In the previous example, we looked at one condition and its boundary.
However, in most programs you will find statements that consist of multiple conditions.

To test the boundaries in these more complicated decisions, we use the **simplified domain testing strategy**.
The idea of this strategy is to test each boundary separately, i.e. independent of the other conditions.
To do so, for each boundary:

* We pick the on- and off-point and we create one test case each.
* If we use multiple variables, we need values for those as well.
As we want to test each boundary independently, we choose in-points for the other variables. Note: We always choose in points, regardless
of the two boolean expressions being connected by ANDs or ORs. In practice, we want all the other conditions to return true, so that
we can evaluate the outcome of the condition under test independently.
* It is important to vary these in-points and to not choose the on- or off-point.
This gives us the ability to partially check that the program gives the correct results for some in-points.
If we would set the in-point to the on- or off-point, we would be testing two boundaries at once.

To find these values and display the test cases in a structured manner, we use a **domain matrix**.
In general the table looks like the following:

![Template for domain matrix](/assets/img/boundary-testing/boundary_template.png)

In this template, we have two conditions with two parameters (see the $$x > a \land y > b$$ condition).
We list the variables, with all their conditions.
Then each condition has two rows: one for the on-point and one for the off-point.
Each variable has an additional row for the typical (or in-) values.
These are used when testing the other boundary.

Each column that corresponds to a test case has two colored cells.
In the colored cells you have to fill in the correct values.
Each of these pairs of values will then give a test case.
If we implement all the test cases that the domain matrix gives us, we exerise each boundary both for the on- and off-point independent of the other parameters.

{% include example-begin.html %}
We have the following condition that we want to test: `x >= 5 && x < 20 && y <= 89`

We start by making the domain matrix, having space for each of the conditions and both parameters.

![Empty boundary table example](/assets/img/boundary-testing/examples/boundary_table_empty.png)

Here you see that we need 6 test cases, because there are 3 conditions.
Now it is time to fill in the table.
We get the on- and off-points like in the previous example.

![Boundary tables example filled in](/assets/img/boundary-testing/examples/boundary_table.png)

Now we have derived the six test cases that we can use to test the boundaries.
{% include example-end.html %}

<iframe width="560" height="315" src="https://www.youtube.com/embed/rPcMJg62wM4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Boundaries that are not so explicit

Let's revisit the example from the specification-based techniques chapter. There, we had a program
where the goal was to return the amount of bars needed in order to build some boxes of chocolates:

{% include example-begin.html %}
**Chocolate bars**

A package should store a total number of kilos. 
There are small bars (1 kilo each) and big bars (5 kilos each). 
We should calculate the number of small bars to use, 
assuming we always use big bars before small bars. Return -1 if it can't be done.

The input of the program is thus the number of small bars, the number of big bars,
and the total amount of kilos to store.
{% include example-end.html %}

And these were the classes we derived after applying the category/partition method:

* **Need only small bars**. A solution that only uses the provided small bars.
* **Need only big bars**. A solution that only uses the provided big bars.
* **Need Small + big bars**. A solution that has to use both small and big bars.
* **Not enough bars**. A case in which it's not possible, because there are not enough bars.
* **Not from the specs**: An exceptional case.

A developer implemented the following code for the requirement, and all the tests pass.

```java
public int calculate(int small, int big, int total) {
  int maxBigBoxes = total / 5;
  int bigBoxesWeCanUse = maxBigBoxes < big ? maxBigBoxes : big;
  
  total -= (bigBoxesWeCanUse * 5);

  if(small <= total)
      return -1;
  return total;
}
```

However, another developer tried `(2,3,17)` as an input and the program crashed. After some debugging,
they noticed that the if statement should had been `if(small < total)` instead of
`if(small <= total)`. This smells like a bug that could had been caught via boundary testing!

Note that the test `(2,3,17)` belongs to the **need small + big bars** partition. In this case,
the program will make use of all the big bars (there are 3 available) and then *all* the small bars available (there are 
2 available). Note that the buggy program would work if we had 3 available small bars (having `(3, 3, 17)` as input).
This is a boundary.

How can we apply boundary testing here? 

![Partitions and boundaries](/assets/img/boundary-testing/partition-boundary.png)

Boundaries also happen when we are going from "one partition" to 
another. 
In these cases, what we should do is to devise test cases for a sequence of inputs that move
from one partition to another.

For example, let's focus on the bug caused by the `(2,3,17)` input.

* `(1,3,17)` should return *not possible* (1 small bar is not enough). This test case belongs to the **not enough bars** partition.
* `(2,3,17)` should return 2. This test case belongs to **need for small + big bars** partition.

There is a boundary between the `(1,3,17)` and the `(2,3,17)`. We should make sure the software still behaves correctly in these cases.

Let's explore another boundary. Let's focus on the **only big bars** partition. We should find inputs that transition from this
partition to another one:

* `(10, 1, 10)` returns 5. This input belongs to the **need small + big bars** partition.
* `(10, 2, 10)` returns 0. This input belongs to the **need only big bars** partition.

One more? Let's focus on the **only small bars** partition:

* `(3, 2, 3)` returns 3. We need only small bars here, and therefore, this input belongs to the **only small bars** partition.
* `(2, 2, 3)` returns -1. We can't make the boxes. This input belongs to the **Not enough bars** partition.

A partition might make boundaries with other partitions. See:

* `(4, 2, 4)` returns 4. We need only small bars here, and therefore, this input belongs to the **only small bars** partition.
* `(4, 2, 5)` returns 0. We need only bigs bars here, and therefore, this input belongs to the **only big bars** partition.

Your lesson is: explore the boundaries in between your partitions!

<iframe width="560" height="315" src="https://www.youtube.com/embed/uP_SpXtHxoQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


## Automating boundary testing with JUnit (via Parameterized Tests)

We just analysed the boundaries and derived test cases using a domain matrix.
It is time to automated these tests using JUnit.

You might have noticed that in the domain matrix we always have a certain amount of input values and, implicitly, an expected output value.
We could just implement the boundary tests by making a separate method for each test.
However, the amount of tests can quickly become large and then this approach is not maintainable.
Also, the code in these test methods will be largely the same.
After all, we do the same thing with just different input and output values.

Luckily, JUnit offers a solution where we can implement the tests with just one method: Parameterized Tests.
As the naming suggests, with a parameterized test we can make a test method with parameters.
So we can create a test method and make it act based on the arguments we give the method.
To define a parameterized test you can use the `@ParameterizedTest` annotation instead of the usual `@Test` annotation.

Now that we have a test method that has some parameters, we have to give it the values that it should execute the tests with.
In general these values are provided by a `Source`.
Here we focus and a certain kind of `Source`, namely the `CsvSource`.
With the `CsvSource`, each test case is given as a comma separated list of input values.
We give this list in a string.
To execute multiple test with the same test method, the `CsvSource` expects list of strings, where each string represents the values for one test case.
The `CsvSource` is an annotation itself, so in an implementation it would like like the following: `@CsvSource({"value11, value12", "value21, value22", "value31, value32", ...})`

{% include example-begin.html %}
We are going to implement the test cases that we found in the previous example using the parameterized test.
Suppose we are testing a method that returns the result of the decision we analyzed in the example.
To automate the tests we create a test method with three parameters: `x`, `y`, `expectedResult`.
`x` and `y` are integers.
The `expectedResult` is a boolean, as the result of the method is also a boolean.

```java
@ParameterizedTest
@CsvSource({
  "5, 24, true",
  "4, 13, false",
  "20, -75, false",
  "19, 48, true",
  "15, 89, true",
  "8, 90, false"
})
public void exampleTest(int x, int y, boolean expectedResult) {
  Example example = new Example();

  assertEquals(expectedResult, example.run(x, y))
}
```

The assertion in the test checks if the result of the method, with the `x` and `y` values, is the expected result.

From the values you can see that each of the six test cases corresponds to one of the test cases in the domain matrix.
{% include example-end.html %}

<iframe width="560" height="315" src="https://www.youtube.com/embed/fFksNXJJfiE" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


## The CORRECT way

The *Pragmatic Unit Testing in Java 8 with JUnit*, by Langr, Hunt, and Thomas, has an interesting discussion about boundary conditions.
Authors call it the **CORRECT** way, as each letter represents one boundary condition you should consider:

* Conformance: 
  * Many data elements must conform to a specific format. Example: e-mail (always name@domain). If you expect an e-mail, and you do not
  receive an e-mail, your software might crash.
  * What should we do? Test when your input is not in conformance with what is expected.

* Ordering:
  * Some inputs might come in specific orders. Imagine a system that receives different products to be inserted in a basket. The order of the data might influence the output. What happens if the list is ordered? Unordered?
  * What should we do? Make sure our program works even if the data comes in an unordered manner (or return an elegant failure to user, avoiding the crash).

* Range:
  * Inputs often should usually be within a certain range. Example: Age should always be greater than 0 and smaller than 120.
  * What should we do? Test what happens when we provide inputs that are outside of the expected range.


* Reference:
  * In OOP systems, objects refer to other objects. Sometimes these relationships get very deep. Moreover, we might depend on
  external dependencies. What happens if these dependencies don't behave as expected?
  * What should we do? When testing a method, consider:
    * What it references outside its scope
    * What external dependencies it has
    * Whether it depends on the object being in a certain state
    * Any other conditions that must exist

* Existence:
  * Does something really exist? What if it doesn't? Imagine you query a database, and your database returns empty. Will our software
  behave correctly?
  * What should we do? What happens if we something we are expecting does not really exist?


* Cardinality:
  * Basically, the famous *off-by-one* errors. In simple words, our loop performed one step less (or more) than it should.
  * What should we do? Make sure we test our loops in different situations, such as when it actually performs zero iterations,
  one iterations, or many. (We'll discuss more about loops in the structural-based testing chapter).

* Time
  * Many perspectives here. First, systems rely a lot on dates and times. What happens if we receive inputs that are not
  ordered in regards to date and time?
  * Timeouts: does our system handle timeouts well?
  * Concurrency: does our system handle concurrency well?


<iframe width="560" height="315" src="https://www.youtube.com/embed/oxNEUYqEvzM" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Short summary

<iframe width="560" height="315" src="https://www.youtube.com/embed/PRVqsJ5fT2I" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


## References

* Jeng, B., & Weyuker, E. J. (1994). A simplified domain-testing strategy. ACM Transactions on Software Engineering and Methodology (TOSEM), 3(3), 254-270.

* Chapter 7 of Pragmatic Unit Testing in Java 8 with Junit. Langr, Hunt, and Thomas. Pragmatic Programmers, 2015.

## Exercises

{% include exercise-begin.html %}
We have the following method.

```java
public String sameEnds(String string) {
  int length = string.length();
  int half = length / 2;

  String left = "";
  String right = "";

  int size = 0;
  for(int i = 0; i < half; i++) {
    left += string.charAt(i);
    right = string.charAt(length - 1 - i) + right;

    if (left.equals(right))
      size = left.length();
  }

  return string.substring(0, size);
}
```

Perform boundary analysis on the condition in the for-loop: `i < half`, i.e. what are the on- and off-point and the in- and out-points?
You can give the points in terms of the variables used in the method.
{% include answer-begin.html %}
The on-point is the value in the conditions: `half`.

When `i` equals `half` the condition is false.
Then the off-point makes the condition true and is as close to `half` as possible.
This makes the off-point `half` - 1.

The in-points are all the points that are smaller than half.
Practically they will be from 0, as that is what `i` starts with.

The out-points are the values that make the condition false: all values equal to or larger than `half`.
{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
Perform boundary analysis on the following decision: `n % 3 == 0 && n % 5 == 0`.
What are the on- and off-points?
{% include answer-begin.html %}
The decision consists of two conditions, so we can analyse these separately.

For `n % 3 == 0` we have an on point of 3.
Here we are dealing with an equality; the value can both go up and down to make the condition false.
As such, we have two off-points: 2 and 4.

Similarly to the first condition for `n % 5 == 0` we have an on-point of 5.
Now the off-points are 4 and 6.
{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
A game has the following condition: `numberOfPoints <= 570`.
Perform boundary analysis on the condition.
What are the on- and off-point of the condition?
Also give an example for both an in-point and an out-point.
{% include answer-begin.html %}
The on-point can be read from the condition: 570.

The off-point should make the condition false (the on-point makes it true): 571.

An example of an in-point is 483.
Then the condition evaluates to true.

An example of an out-point, where the condition evaluates to false, is 893.
{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
We extend the game with a more complicated condition: `(numberOfPoints <= 570 && numberOfLives > 10) || energyLevel == 5`.

Perform boundary analysis on this condition.
What is the resulting domain matrix?
{% include answer-begin.html %}

![Answer domain matrix](/assets/img/boundary-testing/exercises/domain_exercise.png)

Note that we require 7 test cases in total: `numberOfPoints <= 570` and `numberOfLives > 10` each have one on- and one off-point.
`energyLevel == 5` is an equality, so we have two off-points and one on-point.
This gives a total of 7 test cases.

For one of the first two conditions we need two typical rows. \\
Let's rewrite the whole condition to: `(c1 && c2) || c3`.

To test `c1` we have to make `c2` true, otherwise the result will always be false. \\
The same goes for testing `c2` and then making `c1` true.

However, when testing `c3`, we need to make `(c1 && c2)` false, otherwise the result will always be true.
That is why, when testing `c3`, `c1` or `c2` has to be false, i.e. and out-point instead of an in-point.
Therefore we use two different typical rows for the `numberOfLives` variable.
The same could have been done with two typical rows for the `numberOfPoints` variable.
{% include exercise-answer-end.html %}




{% include exercise-begin.html %}
Regarding **boundary analysis of inequalities** (e.g., `a < 10`), which of the following statements **is true**?

1. There can only be a single on-point which always makes the condition true.
2. There can be multiple on-points for a given condition which may or may not make the condition true.
3. There can only be a single off-point which may or may not make the condition false.
4. There can be multiple off-points for a given condition which always make the condition false.

{% include answer-begin.html %}

An on-point is the (single) number on the boundary. It may or may not make the condition true. The off point is the closest number to the boundary that makes the condition to be evaluated to the opposite of the on point. Given it's an inequality, there's only a single off-point.
{% include exercise-answer-end.html %}





{% include exercise-begin.html %}

A game has the following condition: `numberOfPoints > 1024`. Perform a boundary analysis.


{% include answer-begin.html %}
on point = 1024, off point = 1025, in point = 1028, out point = 512

The on point is the number precisely in the boundary = 1024. off point is the closest number to the boundary and has the opposite result of on point. In this case, 1024 makes the condition false, so the off point should make it true. 1025. In point makes conditions true, e.g., 1028. Out point makes the condition false, e.g., 512.
{% include exercise-answer-end.html %}







{% include exercise-begin.html %}

Which one of the following statements about the **CORRECT** principles is **true**?

1. We should suppose that external dependencies are already on the right state for the test (REFERENCE).
1. We should test different methods from the same class in an isolated way in order to avoid order issues (TIME).
1. Whenever we encounter a loop, we should always test whether the program works for 0, 1, and 10 iterations (CARDINALITY).
1. We should always test the behavior of our program when any expected data actually does not exist (EXISTENCE).

{% include answer-begin.html %}

We should always test the behavior of our program when any expected data actually does not exist (EXISTENCE).

{% include exercise-answer-end.html %}









