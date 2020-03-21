# Answers to the exercises

## Principles of software testing

**Exercise 1**

1. Failure, the user notices the system/program behaving incorrectly.
2. Fault, this is a problem in the code, that is causing a failure in this case.
3. Error, the human mistake that created the fault.

**Exercise 2**

The absence-or-error fallacy.
While the software does not have a lot of bugs, it is not giving the user what they want.
In this case the verification was good, but they need work on the validation.

**Exercise 3**

Exhaustive testing is impossible.

**Exercise 4**

Test early, although an important principle, is definitely not related to the problem of only doing unit tests. All others help people in understanding that variation, different types of testing, is important.


## Introduction to software testing automation

Writing tests is fun, isn't it?

## Specification-based testing


**Exercise 1**

A group of inputs that all make a method behave the same way.


**Exercise 2**

We use the concept of equivalence partitioning to determine which tests can be removed.
According to equivalence partitioning we only need to test one test case in a certain partition.

We can group the tests cases in their partitions:

- Divisible by 3 and 5: T1, T2
- Divisible by just 3 (not by 5): T4
- Divisible by just 5 (not by 3): T5
- Not divisible by 3 or 5: T3

Only the partition where the number is divisible by both 3 and 5 has two tests.
Therefore we can only remove T1 or T2.


**Exercise 3**

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


**Exercise 4**

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

**Exercise 5**


* P1: Element not present in the set
* P2: Element already present in the set
* P3: NULL element.

The specification clearly explicits the three different cases of the correct answer.


**Exercise 6**

Option 4 is the incorrect one.
This is a functional based technique. No need for source code.


**Exercise 7**

Possible actions:

1. We should treat pattern size 'empty' as exceptional, and thus, test it just once.
1. We should constraint the options in the 'occurences in a single line' category to happen only if 'occurences in the file' are either exactly one or more than one. % It does not make sense to have none occurences in a file and one pattern in a line.
1. We should treat 'pattern is improperly quoted' as exceptional, and thus, test it just once.


## Boundary testing

**Exercise 1**

The on-point is the value in the conditions: `half`.

When `i` equals `half` the condition is false.
Then the off-point makes the condition true and is as close to `half` as possible.
This makes the off-point `half` - 1.

The in-points are all the points that are smaller than half.
Practically they will be from 0, as that is what `i` starts with.

The out-points are the values that make the condition false: all values equal to or larger than `half`.

**Exercise 2**

The decision consists of two conditions, so we can analyse these separately.

For `n % 3 == 0` we have an on point of 3.
Here we are dealing with an equality; the value can both go up and down to make the condition false.
As such, we have two off-points: 2 and 4.

Similarly to the first condition for `n % 5 == 0` we have an on-point of 5.
Now the off-points are 4 and 6.


**Exercise 3**

The on-point can be read from the condition: 570.

The off-point should make the condition false (the on-point makes it true): 571.

An example of an in-point is 483.
Then the condition evaluates to true.

An example of an out-point, where the condition evaluates to false, is 893.


**Exercise 4**


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

**Exercise 5**

An on-point is the (single) number on the boundary. It may or may not make the condition true. The off point is the closest number to the boundary that makes the condition to be evaluated to the opposite of the on point. Given it's an inequality, there's only a single off-point.


**Exercise 6**

on point = 1024, off point = 1025, in point = 1028, out point = 512

The on point is the number precisely in the boundary = 1024. off point is the closest number to the boundary and has the opposite result of on point. In this case, 1024 makes the condition false, so the off point should make it true. 1025. In point makes conditions true, e.g., 1028. Out point makes the condition false, e.g., 512.


**Exercise 7**

We should always test the behavior of our program when any expected data actually does not exist (EXISTENCE).



