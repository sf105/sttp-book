
# Specification-Based Testing

In this chapter, we explore **specification-based testing** techniques.
In such techniques, we use the *requirements* of the program as an input
for our testing.

In simple words, given a requirement, we will aim at devising a set
of inputs, each tackling one part (or partition, as we will call later)
of the program.

Given that specification-based techniques require no knowledge 
of how the software inside the "box" is structured 
(i.e., we do not
care if it's developed in Java or Python), they are also known
as black box testing.

## Partitioning the input space

Programs are usually too complex to be tested with just a single test.
There are different cases in which the program is executed 
and its execution often depends on various factors, such as the input
you pass to the program.

Let's use a small program as an example. The specification below talks
about a program that decides
whether an year is leap or not. 

> **Requirement: Leap year**
>
>Given an year as an input, the program should return true if the 
>the provided year is leap; false if it is not.
>
>A year is a leap year if:
>
>- the year is divisible by 4
>- the year is not divisible by 100
>- exceptions are years that are divisible by 400, which are also leap years.

To find a good set of tests, often referred to as a *test suite*, 
we break up (or to part, or to divide) the testing of a program in classes.
Moreover, we have divide the input space of
the program in such a way that each class is 1) 
disjoint, i.e., represents a unique behavior of the program; in other words,
no two partitions represent the same behavior,
2) can easily verify whether that behavior is correct or not.

**Classes for the leap year problem**

By looking at the requirements, we can derive the
following classes/partitions:

* Year is divisible by 4, but not divisible by 100 = leap year, TRUE
* Year is divisible by 4, divisible by 100, divisible by 400 = leap year, TRUE
* Not divisible by 4 = not a leap year, FALSE
* Divisible by 4, divisible by 100, but not divisible by 400 = not leap year, FALSE


Note how each class above exercises the program in different ways.

{% set todo = "Add a picture here showing the input domain and its classes." %}
{% include "includes/todo.md" %}


{% set video_id = "kSLbxmXcPPI" %}
{% include "includes/youtube.md" %}



## Equivalence partitioning

Now that we just divided the input space into different classes, 
we can automate it.
As we discussed before, the test design is still a human activity, which
we just did. Now, we should automate the execution of test.

The partitions, as you see above, are not test cases we can directly implement.
Each partition might be instantiated by an infinite number of inputs. For example,
the partition _year not divisible by 4_, we have an infinite number
of numbers that are not divisible by 4 that we could use as concrete inputs
to the program.
It is just impractical to test them all.
Then how do we know which concrete input to instantiate for each
of the partitions?

As we discussed earlier, each partition exercises the program in a certain way.
In other words, all input values from one specific partition will make the program behave in the same way. Therefore, any input we select should give us
the same result. And we assume that, if the program behaves correctly
for one given input, it will work correctly for all other inputs from
that class. This idea of inputs being equivalent to each other
is what we call **equivalence partitioning**.

It then does not matter which precise input we pick. And picking one test case per
partition will be enough.


Let's now write some JUnit tests. Remember that the name of a test method
in JUnit can be anything? It is a good practice to name your 
test method after the partition that the method tests.

**Example:**
The Leap Year specification has been implemented by a developer in the following way:

```java
public class LeapYear {

  public boolean isLeapYear(int year) {
    if (year % 400 == 0)
      return true;
    if (year % 100 == 0)
      return false;

    return year % 4 == 0;
  }
}
```

Given the classes we devised before, we know we have 4 test cases in total.
We can choose any input in a certain partition.
We will use the following inputs for each partition:

- 2016, divisible by 4, not divisible by 100.
- 2000, divisible by 4, also divisible by 100 and by 400.
- 39, not divisible by 4.
- 1900, divisible by 4 and 100, not by 400.

Implementing this using JUnit gives the following code for the tests.

```java
package tudelft.leapyear;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class LeapYearTests {

  private LeapYear leapYear;

  @BeforeEach
  public void setup() {
    leapYear = new LeapYear();
  }

  @Test
  public void leapYearsNotCenturialTest() {
    boolean leap = leapYear.isLeapYear(2016);

    assertTrue(leap);
  }

  @Test
  public void leapYearsCenturialTest() {
    boolean leap = leapYear.isLeapYear(2000);

    assertTrue(leap);
  }

  @Test
  public void nonLeapYearsTest() {
    boolean leap = leapYear.isLeapYear(39);

    assertFalse(leap);
  }

  @Test
  public void nonLeapYearsCenturialTest() {
    boolean leap = leapYear.isLeapYear(1900);

    assertFalse(leap);
  }
}
```

Note that each test method covers one of the partitions and the naming of the method refers to the partition it covers.

Some help if you are still learning JUnit: The `setup` method is executed before each test, thanks to the `BeforeEach` annotation.
It creates the `LeapYear`.
This is then used by the tests to execute the method under test.
In each test we first determine the result of the method.
After the method returns a value we assert that this is the expected value.

{% set video_id = "mXmFiiifwaE" %}
{% include "includes/youtube.md" %}


## Category-Partition Method

So far we derived partitions by just looking at the specification of the program.
We basically used our experience and knowledge to derive the test cases.
We now go over a more systematic way of deriving these partitions: the **Category-Partition** method.

The method gives us 1) a systematic way of deriving test cases, based on the characteristics of the input parameters, 2) minimize the amount of tests
to a feasible amount.

We first go over the steps of this method and then we illustrate the process with an example.

1. Identify the parameters, or the input of the program. For example, the parameters your classes and methods receive.
2. Derive characteristics of each parameter. For example, an `int year` should be a positive integer number between 0 and infinite. 
      - Some of these characteristics can be found directly in the specification of the program.
      - Others cannot be found from specifications. For example an input cannot be `null` if the method does not handle that well.

3. Add constraints, as to minimize the test suite.
      - Identify invalid combinations. For example, some characterics might not be able to be mixed with other characteristics.
      - Exceptional behavior does not always have to be combined with all the different values of the other inputs. For example, trying a single `null` input might be enough to test that corner case.

4. Generate combinations of the input values. These are the test cases.

> **Requirement: Christmas discount**
> 
> The system should give 25% discount on the raw amount of the cart when it is Christmas.
> The method has two input parameters: the total price of the products in the cart and the date.
> When it is not Christmas it just returns the original price, otherwise it applies the discount.

Now following the category partition method:

1. We have two parameters:
      - The current date
      - The total price

2. Now for each parameter we define the characteristics:
      - Based on the requirements, the only important characteristic is that the date can be either Christmas or not.
      - The price can be a positive number, or maybe 0 for some reason. Technically the price can also be a negative number. This is an exceptional case, as you cannot really pay a negative amount.

3. The amount of characteristics and parameters is not too high in this case.
Still we know that the negative price is an exceptional case.
Therefore we can test that with just one combination instead of with both a date that is Christmas and not Christmas.

4. We combine the other characteristics to get the test cases.
These are the following:
      - Positive price on Christmas
      - Positive price not on Christmas
      - Price of 0 on Christmas
      - Price of 0 not on Christmas
      - Negative price on Christmas

Now we can implement these test cases.
Each of the test cases corresponds to one of the partitions that we want to test.

{% set video_id = "frzRmafsPBk" %}
{% include "includes/youtube.md" %}

## One more example of specification-based testing

Imagine the following requirement:


> **Chocolate bars**
> 
> A package should store a total number of kilos. 
> There are small bars (1 kilo each) and big bars (5 kilos each). 
> We should calculate the number of small bars to use, 
> assuming we always use big bars before small bars. Return -1 if it can't be done.
>
> The input of the program is thus the number of small bars, the number of big bars,
> and the total amount of kilos to store.


In this example, the partitions are a bit more "hidden". We have to really understand the problem in order to derive
the partitions. You should spend some time (try to even implement it!!) in understanding it.

Now, let's think about the classes/partitions:

* **Need only small bars**. A solution that only uses the provided small bars.
* **Need only big bars**. A solution that only uses the provided big bars.
* **Need Small + big bars**. A solution that has to use both small and big bars.
* **Not enough bars**. A case in which it's not possible, because there are not enough bars.
* **Not from the specs**: An exceptional case.

For each of these classes, we can devise concrete test cases:

* **Need only small bars**. small = 4, big = 2, total = 3
* **Need only big bars**. small = 5, big = 3, total = 10
* **Need Small + big bars**. small = 5, big = 3, total = 17
* **Not enough bars**. small = 1, big = 1, total = 10
* **Not from the specs**: small = 4, big = 2, total = -1

This example shows why deriving good test cases is challenging. Specifications can be complex and we need to
fully understand the problem!

{% set video_id = "T8caAUwgquQ" %}
{% include "includes/youtube.md" %}



## Random testing vs specification-based testing

One might think: but what if, instead of looking at the requirements,
a tester just keeps giving random inputs to the program?
**Random testing** is indeed a popular black-box technique where programs are tested by generating random inputs. 

Although random testing can definitely help us in finding bugs, it is not an effective way to find bugs in a large input space. 
Human testers use their experience and knowledge of the program to test trouble-prone areas more effectively. However, where humans can generate few tests in a short time period such as a day, computers can generate millions.
A combination of random testing and partition testing is therefore the most beneficial.

In future chapters, we'll discuss fuzzing test and AI-based testing. There,
you will learn more about automated random testing.


## Exercises

**Exercise 1.**
What is an Equivalence Partition?


1. A group of results that is produced by one method
2. A group of results that is produced by one input into different methods
3. A group of inputs that all make a method behave the same way
4. A group of inputs that exactly gives the same output in every method

**Exercise 2.**
We have a program called FizzBuzz.
It does the following:
Given an int n, return the string form of the number followed by "!".
So the int 6 yields "6!".
Except if the number is divisible by 3 use "Fizz" instead of the number, and if the number is divisible by 5 use "Buzz", and if divisible by both 3 and 5, use "FizzBuzz".

A novice tester is trying hard to devise as many tests as she can for
the FizzBuzz method.
She came up with the following tests:

- T1 = 15
- T2 = 30
- T3 = 8
- T4 = 6
- T5 = 25

Which of these tests can be removed while keeping a good test suite?

What concept can we use to determine the tests that can be removed?

**Exercise 3.**
See a slightly modified version of HashMap's `put` method Javadoc. (Source code [here](http://developer.classpath.org/doc/java/util/HashMap-source.html)).

```java
/**
 * Puts the supplied value into the Map,
 * mapped by the supplied key.
 * If the key is already on the map, its
 * value will be replaced by the new value.
 *
 * NOTE: Nulls are not accepted as keys;
 *  a RuntimeException is thrown when key is null.
 *
 * @param key the key used to locate the value
 * @param value the value to be stored in the HashMap
 * @return the prior mapping of the key, or null if there was none.
 */
public V put(K key, V value) {
  // implementation here
}
```

Apply the category/partition method.
What are the minimal and most suitable partitions?

**Exercise 4.**
Zip codes in country X are always composed of 4 numbers + 2 letters, e.g., 2628CD.
Numbers are in the range [1000, 4000].
Letters are in the range [C, M].

Consider a program that receives two inputs: an integer (for the 4 numbers) and a string (for the 2 letters), and returns true (valid zip code) or false (invalid zip code).

A tester comes up with the following partitions:

1. [0,999]
2. [1000, 4000]
3. [2001, 3500]
4. [3500, 3999]
5. [4001, 9999]
6. [A-C]
7. [C-M]
8. [N-Z]

Note that with [a, b] all numbers between and including a and b are in the domain.
The same goes with letters like [A-Z].

Which of these partitions are valid (and good) partitions, i.e. which can actually be used as partitions?
Name each of the valid partitions, corresponding to how they exercise the program.

**Exercise 5.**
See a slightly modified version of HashSet's `add()`'s Javadoc below.
Apply the category/partition method. What is **the minimal and most suitable partitions** for the `e` input parameter? 

```java
/**
 * Adds the specified element to this set if it 
 * is not already present.
 * If this set already contains the element, 
 * the call leaves the set unchanged
 * and returns false.
 *
 * If the specified element is NULL, the call leaves the
 * set unchanged and returns false.
 *
 * @param e element to be added to this set
 * @return true if this set did not already contain 
 *   the specified element
 */
public boolean add(E e) {
    // implementation here
}
```


**Exercise 6.**
Which of the following statements **is false** about applying the category/partition method in method below?

```java
/**
 * Puts the supplied value into the Map, 
 * mapped by the supplied key.
 * If the key is already on the map, its
 * value will be replaced by the new value.
 *
 * NOTE: Nulls are not accepted as keys; 
 *  a RuntimeException is thrown when key is null.
 *
 * @param key the key used to locate the value
 * @param value the value to be stored in the HashMap
 * @return the prior mapping of the key, 
 *  or null if there was none.
 */
public V put(K key, V value) {
  // implementation here
}
```


1. The specification does not specify any details about the `value` input parameter, and thus, experience should be used to partition it, e.g., `value` being null and not null.

2. The number of tests generated by the category/partition method can grow quickly, as the chosen partitions for each category are later combined one-by-one. This is not a practical problem to the `put()` method because the number of categories and their partitions is small.

3. In an object-oriented language, besides using the method's input parameters to explore partitions, we should also consider the internal state of the object (i.e., the class's attributes), as it can also affect the behavior of the method.

4. With the information in hands, it is not possible to perform the category/partition method, as the source code is required for the last step of the category/partition method: adding constraints.


**Exercise 7.**
Suppose a `find` program that finds occurrences of a pattern in a file. The program has the following syntax:

```
find <pattern> <file>
```

A tester, after reading the specs and following the Category-Partition method, devised the following test specification:


* Pattern size: empty, single character, many characters, longer than any line in the file.
* Quotting: pattern is quoted, pattern is not quoted, pattern is improperly quoted.
* File name: good file name, no file name with this name, omitted.
* Occurrences in the file: none, exactly one, more than one.
* Occurrences in a single line, assuming line contains the pattern: one, more than one.

However, the number of combinations is now too high. What actions could we take to reduce the number of combinations?



## References

* Chapter 4 of the Foundations of software testing: ISTQB certification. Graham, Dorothy, Erik Van Veenendaal, and Isabel Evans, Cengage Learning EMEA, 2008.
* Chapter 10 of the Software Testing and Analysis: Process, Principles, and Techniques. Mauro Pezzè, Michal Young, 1st edition, Wiley, 2007.
* Ostrand, T. J., & Balcer, M. J. (1988). The category-partition method for specifying and generating functional tests. Communications of the ACM, 31(6), 676-686.


