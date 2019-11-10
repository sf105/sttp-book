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
Failures only occur when the end user is using the system, when it does not behave correctly.

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
