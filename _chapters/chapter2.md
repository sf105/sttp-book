---
chapter-number: 2
title: Specification-Based Testing
layout: chapter
---

To get a systematic approach to testing we start with specification-based testing.
More specifically, we look at partition testing.

With specification-based testing we look at the requirements of the program.
For a given input, the test checks that the program gives the correct output.
Therefore specification testing is an input/output driven testing technique.

Specification-based testing is also known as black-box testing.
It requires no knowledge of how the software inside the "box" is structured.
We do not care about the implementation, as long as it meets our requirements.

Specification-based testing contains both functional and non-functional tests.
The functional testing concerns the features and functions of the system.
It checks whether the system behaves as expected.
For example a functional test can execute a method with a certain input and then checks if it gives the correct output.
Here we would test the functioning of (a part of) the system.
Non-functional testing includes testing for performance, usability and maintainability.
We could measure the execution time of the system or perform tests with users to see if the system is easy to work with.
Here we will focus on functional testing.

## Partitions

Usually programs are too complex to test with just one test.
There are different cases in which we execute the program and its execution often depends on various factors.
To find a good set of tests, often referred to as a test suite, we break up the testing of a program in some classes or partitions.

Such a partition represents a case that should be tested.
A case is a certain input of a method.
Separate partitions should exercise the program in a different way.
If two cases exercise the system in the same way they belong to the same partition.

{% include example-begin.html %}
We have a program that determines whether a given year is a leap year or not.

A year is a leap year if:

- the year is divisible by 4
- the year is not divisible by 100
- exceptions are years that are divisible by 400. These are leap years

As we are using specification-based testing we will not need the source code to come up with some tests.

Combining these properties gives us some partitions.
Most obvious is a partition where the year is a leap year and where a year is not a leap year.
Looking at the specification for when a year is a leap year, these two partitions are a bit too simple.
We can split both partitions in two new partitions.

For the leap years, we make on partition where the year is divisible by 4 and not by 100, for example 2016 or 2020.
These years are in the same partition as they will exercise the system in the same way (they follow te same specification).
Then another partition is where the year is divisible by 4 and 100 and also by 400.
Again this makes the year a leap year, while exercising the system differently than the previous partition.

Similarly we can split the partition for non-leap years into years that are not divisable by 4 and years that are divisble by 4 and 100, but not by 400.
Both these partitions test non-leap years, but again in different ways.
{% include example-end.html %}

### Equivalence partitioning

Now that we derived the test cases using partitions we can begin testing the program.
We like to create tests in an automated fashion.
This way it is easy to execute the tests and we verify that the program works each time something changes.
In Java we use the JUnit framework to write automated tests.

The partitions are not test cases we can directly implement.
Each partition usually covers a lot, if not an infinite amount, of tests.
It is impractical to test each case of the partition, as it results in a lot of test cases and then also a long execution time.
Then how do we know which test case in a partition and how many cases to test overall?

As we discussed earlier, each partition exercises the program in a certain way.
In other words, all the cases in one partition will make the program behave the same.
Therefore, when one test case in a partition works correctly, we can assume that the other cases in that partition work as well.
Now it also does not matter which case we pick and one test case for each partition will be enough.
This idea is called equivalence partitioning.
When implementing tests, it is considered good practice to name your test method after the partition that the method tests.

{% include example-begin.html %}
The method we described in the previous example has been implemented in the following way.

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

Since we are doing specification-based testing we do not use this source code to derive our test cases.
Instead we use the partitions we derived from the specifications in the previous example.

Following equivalence partitioning we only have to make one test case per partitions, so 4 in total.
We can choose any test case in a certain partition.
For this example we use the following test cases:

- 2016, divisible by 4, not divisible by 100
- 2000, divisible by 4, also divisble by 100 and by 400. So the method should return true.
- 39, not divisible by 4
- 1900, divisible by 4 and 100, not by 400.

Implementing this using JUnit gives the following code for the tests.

```java
public class LeapYearTests {

      private LeapYear leapYear;

      @BeforeEach
      public void setup() {
            leapYear = new LeapYear();
      }

      @Test
      public void leapYearsNotCenturialTest() {
            boolean leap = leapYear.isLeapYear(2016);

            assertThat(leap).isTrue();
      }

      @Test
      public void leapYearsCenturialTest() {
            boolean leap = leapYear.isLeapYear(2000);

            assertThat(leap).isTrue();
      }

      @Test
      public void nonLeapYearsTest() {
            boolean leap = leapYear.isLeapYear(39);

            assertThat(leap).isFalse();
      }

      @Test
      public void nonLeapYearsCenturialTest() {
            boolean leap = leapYear.isLeapYear(1900);

            assertThat(leap).isFalse();
      }
}
```

Note that each test method covers one of the partitions and the naming of the method refers to the partition it covers

The `setup` method is executed before each tests, thanks to the `BeforeEach` annotation.
It creates the `LeapYear`.
This is then used by the tests to execute the method under test.

In each test we first determine the result of the method.
After the method returns a value we assert that this is the expected value.
{% include example-end.html %}

<!-- ### Random vs. partition testing

Random testing is a black-box technique where programs are tested by generating random inputs. It is not an effective way to find bugs in a large input space. 
Human testers use their experience and knowledge of the program to test trouble-prone areas more effectively. However, where humans can generate few tests in a short time period such as a day, computers can generate millions.
A combination of random testing and partition testing is therefore the most beneficial. -->

## Category-Partition Method

So far we derived partitions by just looking at the specification of the program.
Now we will go over a more systematic way of getting these partitions: With the Category-Partition method.

Other than just having a certain way of deriving test cases, the category-partition method helps us reduce the number of possible tests to a feasible amount.
Complex methods that have a lot of parameters can easily give too many test cases when not using the category-partition method.

We first go over the steps of this method and then we illustrate the process with an example.

1. Identify the parameters, or the input of the program.
2. Derive characteristics of each parameter
      - Some are found from the specifications of the program.
      - Others cannot be found from specifications. For example an input cannot be `null` if the method does not handle that well.

3. Add constraints, minimize the test suite
      - Done by removing the invalid combinations. Some characterics might not be able to be mixed with other characteristics.
      - Exceptional behavior does not always have to be combined with different values for other inputs. For example when the system behaves the same way when an input is `null` regardless of the other input values.

4. Generate combinations of the input values. These are the test cases.

{% include example-begin.html %}
In this example we are testing program for a webshop.
The system should give 25% discount on the raw amount of the cart when it is Christmas.
The method has two parameters: the total price of the products in the cart and the date.
When it is not Christmas it just returns the original price, otherwise it applies the discount.

Now following the category partition method:

1. We have two parameters:
      - The current date
      - The total price

2. Now for each parameter we define the characteristics:
      - Based on the requirements, the only important characteristic is that the date can be either Christmas or not.
      - The price can be a positive number, or maybe 0 for some reason. Technically the price can also be a negative number. This is an exceptional case, as you cannot really pay an negative amount.

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
{% include example-end.html %}

## Exercises

Below you will find some exercises to practise with the material discussed in this chapter.
After each exercise you can immediately view the answer.

{% include exercise-begin.html %}
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
{% include answer-begin.html %}
We use the concept of equivalence partitioning to determine which tests can be removed.
According to equivalence partitioning we only need to test one test case in a certain partition.

We can group the tests cases in their partitions:

- Divisible by 3 and 5: T1, T2
- Divisible by just 3 (not by 5): T4
- Divisible by just 5 (not by 3): T5
- Not divisible by 3 or 5: T3

Only the partition where the number is divisible by both 3 and 5 has two tests.
Therefore we can only remove T1 or T2.
{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
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
{% include answer-begin.html %}
Following the category partition method:

1. Two parameters: key and value
2. The execution of the program does not depend on the value; it always inserts it into the map.
We can define different characteristics of the key:
      - The key can already be present in the map or not.
      - The key can be null.
3. The requirements did not give a lot of parameters and/or characteristics, so we do not have to add constraints.
4. The combinations are each of the possibilities for the key with any value, as the programs execution does not depend on the value.
We end up with three partitions:
      - New key
      - Existing key
      - null key

{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
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
{% include answer-begin.html %}
We go over each given partition and identify whether it is a valid partition:

1. Valid partition: Invalid numbers, which are too small.
2. Valid partition: Valid numbers
3. Invalid partition: Contains some valid numbers, but the range is too small to cover the whole partition.
4. Invalid partition: Same reason as number 3.
5. Valid partition: Invalid numbers, that are too large.
6. Invalid partition: Contains both valid and invalid letters (the C is included in the domain).
7. Valid partition: Valid letters.
8. Valid partition: Invalid letters, past the range of valid letters.

We have the following valid partitions: 1, 2, 5, 7, 8.
{% include exercise-answer-end.html %}
