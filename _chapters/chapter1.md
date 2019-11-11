---
chapter-number: 1
title: Introduction to Testing
layout: chapter
---

Software testing and the quality of software is essential in the development process of software system.
High quality code is maintainable and readable, making it easy to work with.
If then something needs to be changed or added to the system it will not break other features and will not take too much effort.
Software testing is important because mistakes are very easily made during software development.
These mistakes cause bugs that influence the behavior of a software system.
To catch most of the bugs we use tests.

You have probably been testing your code in courses like OOP already.
In the Software Quality and Testing course we take the testing further.
Instead of just thinking about a couple of tests for a class we discuss various ways of systematically deriving test cases for a piece of software.
At the start we mainly just look at the problem that our software solves.
Later we will also look at the code itself to derive test cases.

Each of these testing strategies has its advantages and disadvantages, so it is important to know when to use a certain strategy.
We like to be very practical in this reader, so you will see a lot of examples of Java code.

{% include example-begin.html %}
For now, let's try to test the software using our feelings.
Say we have a piece of code, a method, that receives a string with a roman number and then converts this roman number to an integer.

First, we need to know how the roman numbers work.
We have a couple of letters that represent values:

* I = 1
* V = 5
* X = 10
* L = 50
* C = 100
* D = 500
* M = 1000

Now we can combine these letters to form numbers.
The letters should be ordered from the highest to the lowest value.
For example CCXVI would be 216.

Now when we put a lower value in front of a higher one, we substract that value from the higher value.
For example we make 40 not by XXXX, but instead we use $$50 - 10 = 40$$ and have the roman number XL.
Combining both these principles we could give our method MDCCCXLII and it should return 1842.

Now we have to think about tests to make for this method.
Try to use your experience as a developer to get as many test cases as you can.

To get you started, we can of course test just one letter  (C = 100), different letters combined (CLV = 155), and a lower value in front of a higher one (CM = 900).
{% include example-end.html %}

With this example you might notice that it can be hard to know when you have enough tests.
Using just our feelings also gives a higher chance of forgetting a couple of cases.
That is why it is essential to use a strategy to systematically derive the tests.
This is called the test design and is the more human part of software testing.

When testing the software we run (part of) it and check if it gives the right results.
While this can be done by humans, we like to automate them.
This is called automation.
Automated tests are way faster and often more accurate than tests done by humans.

Throughout this reader you will see that we first think about the test cases.
This is the design phase of testing.
Then when we have our test cases we are going to automate them: The automation part.

## Framework

The SQT course is taught in Java, so that is the language we will be using in the reader as well.
For Java, the standard framework to write automated tests is JUnit.
Throughout this reader and the course we will use JUnit 5 to automate the tests.

To automate the tests we need a Java class.
This is usually named the name of the class under test, followed by "Test".
Then to create an automated test, we make a method with the return type `void`.
For the execution the name of the method does not matter, but we always use it to describe the test.
To make sure that JUnit considers the method to be a test, we use the `@Test` annotation.
To use this annotation you have to import `org.junit.jupiter.api.Test`.

In the method itself we execute the code that we want to test.
After we have done that, we check is the result is what we would expect.
To check this result, we use assertions.
A couple of useful assertions are:

* `assertEquals(expected, actual)`: Passes if the expected and actual values are equal, fails otherwise.
  Be sure to pass the expected value as the first argument and the actual value (the value that, for example, the method returns) as second argument.
  Otherwise the fail message of the test will not make sense.
* `assertTrue(condition)`: Passes if the condition evaluates to true, fails otherwise.
* `assertFalse(condition)`: Passes if the condition evaluates to false, fails otherwise.

More assertions and additional arguments can be found in [JUnit's documentation](https://junit.org/junit5/docs/5.3.0/api/org/junit/jupiter/api/Assertions.html).
To make easy use of the assertions and to import them all in one go, you can use `import static org.junit.jupiter.api.Assertions.*;`.

{% include example-begin.html %}
We made an implementation for the problem in the previous example.

```java
public class RomanNumeral {
  private static Map<Character, Integer> map;

  static {
    map = new HashMap<>();
    map.put('I', 1);
    map.put('V', 5);
    map.put('X', 10);
    map.put('L', 50);
    map.put('C', 100);
    map.put('D', 500);
    map.put('M', 1000);
  }

  public int convert(String s) {
    int convertedNumber = 0;

    for (int i = 0; i < s.length(); i++) {
      int currentNumber = map.get(s.charAt(i));
      int next = i + 1 < s.length() ? map.get(s.charAt(i + 1)) : 0;

      if (currentNumber >= next) {
        convertedNumber += currentNumber;
      } else {
        convertedNumber -= currentNumber;
      }
    }

    return convertedNumber;
  }
}
```

You do not have to fully understand this implementation.
After all, we are looking at the problem to design our tests.

Now that we got the test cases in the previous example, we want to automate them.

We need a class and methods annotated with `@Test` to automate our test cases.
The three cases we had, can be automated as follows.

```java
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class RomanNumeralTest {

  @Test
  void convertSingleDigit() {
    RomanNumeral roman = new RomanNumeral();
    int result = roman.convert("C");

    assertEquals(100, result);
  }

  @Test
  void convertNumberWithDifferentDigits() {
    RomanNumeral roman = new RomanNumeral();
    int result = roman.convert("CCXVI");

    assertEquals(216, result);
  }

  @Test
  void convertNumberWithSubtractiveNotation() {
    RomanNumeral roman = new RomanNumeral();
    int result = roman.convert("XL");

    assertEquals(40, result);
  }
}
```

Notice that we first create an instance of `RomanNumeral`.
Then we execute or run the `convert` method, which is the method we want to test.
Finally we assert that the result is what we would expect.
{% include example-end.html %}

### BeforeEach

In the example we create the `roman` object four times.
This is good, because we want to start fresh with each test.
If the method would in some way change the object, we do not want this to carry over to another test.
However, now we have the same line of code in each test method.
The risk of this code duplication is that we might do it wrong in one of the cases, or if we want to change the code somewhere, we forget to change it everywhere.

We can write everything we want to do at the start of each test in just one method.
In order to do so, we will use the `@BeforeEach` annotation.
Like the tests, we annotate a method with this annotation.
Then JUnit knows that before it runs the code in a test method is has to run the code in the `BeforeEach` method.

{% include example-begin.html %}
In the test code we just wrote, we can instantiate the `roman` object inside a method annotated with `BeforeEach`.
In this case it is just one line that we move out of the test methods, but as your tests become more complicated this approach becomes more important.

The new test code would look as follows.

```java
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class RomanNumeralTest {
  
  private RomanNumeral roman;
  
  @BeforeEach
  void setup() {
    roman = new RomanNumeral();
  }

  @Test
  void convertSingleDigit() {
    roman = new RomanNumeral();
    int result = roman.convert("C");

    assertEquals(100, result);
  }

  @Test
  void convertNumberWithDifferentDigits() {
    roman = new RomanNumeral();
    int result = roman.convert("CCXVI");

    assertEquals(216, result);
  }

  @Test
  void convertNumberWithSubtractiveNotation() {
    roman = new RomanNumeral();
    int result = roman.convert("XL");

    assertEquals(40, result);
  }
}
```

{% include example-end.html %}

## Testing Principles

Now that we have some basic tools to design and automate our tests, we can think more about some testing concepts.
We start with some precise definitions for certain terms.
In later chapters, we start looking at the various testing strategies that can be used to test software.

### Failure, Fault and Error

We can use a lot of different words for a system that is not behaving correctly.
Just to name a few we have error, mistake, defect, bug, fault and failure.
As we like to be able to describe the problem in software precisely, we need to agree on a certain vocabulairy.
For now this comes down to three terms: failure, fault and error.

A failure is a component of the (software) system that is not behaving as expected.
An example of a failure is the well-known blue screen of death.
We generally expect our pc to keep running, but it just crashes.

Failures are generally caused by faults.
Faults are also called defects or bugs.
A fault is a flaw, or mistake, in a component of the system that can cause the system to behave incorrectly.
We have a fault when we have, for example, a `>` instead of `>=` in a condition.

A fault in the code does not have to cause a failure.
If the code containing the fault is not being run, it can also not cause a failure.
Failures only occur when the end user is using the system, when they notice it not behaving as expected.

Finally we have the error, also called a mistake.
An error is a human action that cause the system to run not as expected.
For example someone can forget to think about a certain corner case that the code might run into.
This then creates a fault in the code, which can result in a failure.

### Verification and Validation

We keep extending our vocabulairy a bit with two more concepts.
Here we introduce verification and validation.
Both concepts are about assessing the quality of a system and can be described by a single question.

Validation: Are we building the right software?
Validation concerns the features that our system offers and the costumer, for who the system is made.
Is the system that we are building actually the system that the users want?
Is the system actually useful?

Verification on the other hand is about the system behaving as it is supposed to according to the specification.
This mostly means that the systems behaves without any bugs, like it is said it should behave.
This does not guarantee that the system is useful.
That is a matter of validation.
We can summarize verification with the question: Are we building the system right?

In this reader, the focus is on verification.
We try to test if the system behaves according to its specification.
However, validation is also very important when it comes to building succesfull software systems.

### Tests, tests and more tests...

So if we want to test our systems well, we just keep adding more tests until it is enough, right?
Actually a very important part of software testing is knowing when to stop testing.
Creating too few tests will leave us with a system that might not behave as intended.
On the other hand, creating test after test without stopping will probably cost too much time to create and at some point will make the whole test suite too slow.
A couple of tests are executed in a very short amount of time, but if the amount of tests becomes very high the time needed to execute them will naturally increase as well.
We discuss a couple of important concepts surrounding this subject.

First, exhaustive testing is impossible.
We simply cannot test every single case a method might be executing.
This means that we have to prioritize the tests that we do run.

When prioritizing the test cases that we make, it is important to notice that bugs are not uniformly distributed.
If we have some components in our system, then they will not all have the same amount of bugs.
Some components probably have more bugs than others.
We should think about which components we want to test most when prioritizing the tests.

A crucial notion for software testing is that testing shows the precense of defects.
Testing does not show the absence of defects.
So while we might find more bugs by testing more, we will never be able to say that our software is 100% bug-free, because of the tests.

To test our software we need a lot of variation in our tests.
When testing a method we want variety in the inputs, for example, like we saw in the examples above.
To test the software well, however, we also need variation in the testing strategies that we apply.
This is described by the pesticide paradox: "Every method you use to prevent or find bugs leaves a residue of subtler bugs against which those methods are ineffectual."
There is no testing strategy that guarantees that the tested software sis bug-free.
So when using a certain strategy all the time, we will miss some of the defects that are in the software.
This is the residue that is talked about in the pesticide paradox.
From the pesticide paradox we learn that we have to use different testing strategies on the same software to minimize the bugs left in the software.
When learning the various testing strategies in this reader, keep in mind that you want to combine them when you are testing your software.

Combining these testing strategies is a great idea, but it can be quite challenging.
For example, testing a mobile app if very different from testing a web application or a rocket.
In other words: Testing is context-dependent.
The way that we test depends on the context of the software that we test.

Finally, while we are mostly focusing on verification when we create tests, we should not forget that just having a low amount of bugs is not enough.
If we have a program that works like it is specified, but is of no use for its users, we still do not have good software.
This is called the absence-of-errors fallacy.
We cannot forget about the validation part, where we check if the software meets the users' needs.

## Exercises

Below you will find some exercises to practise the material with.
After each question you can click the button to show the answer to the question.

{% include exercise-begin.html %}
Having a certain terminology helps testers to explain the problems they have with a program or in their software.

Below is a small conversation.
Fill each of the caps with: failure, fault, or error.

**Mark**: Hey, Jane, I just observed a (1) _ _ _ _ _ _ in our software: if the user has multiple surnames, our software doesn't allow them to sign in. \\
**Jane**: Oh, that's awful. Let me debug the code so that I can find the (2) _ _ _ _ _ _.\\
*(a few minutes later)*\\
**Jane**: Mark, I found it! It was my (3) _ _ _ _ _ _. I programmed that part, but never thought of this case.\\
**Mark**: No worries, Jane! Thanks for fixing it!
{% include answer-begin.html %}

1. Failure, the user notices the system/program behaving incorrectly.
2. Fault, this is a problem in the code, that is causing a failure in this case.
3. Error, the human mistake that created the fault.

{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
Kelly, a very experienced software tester, visits Books!, a social network focused on matching people based on books they read.
Users do not report bugs so often; Books! developers have strong testing practices in place.
However, users do say that the software is not really delivering what it promises.

What testing principle applies to this problem?
{% include answer-begin.html %}
The absence-or-error fallacy.
While the software does not have a lot of bugs, it is not giving the user what they want.
In this case the verification was good, but they need work on the validation.
{% include exercise-answer-end.html %}
