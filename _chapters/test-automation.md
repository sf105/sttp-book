---
chapter-number: 2
title: Software Testing Automation
layout: chapter
toc: true
---

## Getting started with test automation

Before we explore different testing techniques, let's first get used
to software testing automatin frameworks, like JUnit.
For now, let's just use our experience as software developers to devise
test cases.

{% include example-begin.html %}

**The Roman Numeral problem**

It is our goal to implement a program that receives a string as a parameter
containing a roman number and then converts it to an integer.

In roman numeral, letters represent values:

* I = 1
* V = 5
* X = 10
* L = 50
* C = 100
* D = 500
* M = 1000

We can combine these letters to form numbers.
The letters should be ordered from the highest to the lowest value.
For example `CCXVI` would be 216.

When we put a lower value in front of a higher one, we substract that value from the higher value.
For example we make 40 not by XXXX, but instead we use $$50 - 10 = 40$$ and have the roman number `XL`.
Combining both these principles we could give our method `MDCCCXLII` and it should return 1842.


A possible implementation for this Roman Numeral is as follows:

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
{% include example-end.html %}

Now we have to think about tests for this method.
Use your experience as a developer to get as many test cases as you can.
To get you started, a few examples: 

* Just one letter  (C = 100)
* Different letters combined (CLV = 155)
* Subtractive notation (CM = 900)

Let's now automate these manually devised test cases.

## The JUnit Framework

Testing frameworks enables us to write our test cases in a way that
they can be easily executed by the machine. 
For Java, the standard framework to write automated tests is JUnit (the frameworks for the languages work similarly), and its most recent version is 5.x.

To automate the tests we need a Java class.
This is usually named the name of the class under test, followed by "Test".
To create an automated test, we make a method with the return type `void`.
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

Do you see more test cases? Go ahead and implement them!
{% include example-end.html %}

<iframe width="560" height="315" src="https://www.youtube.com/embed/XS4-93Q4Zy8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## The need for systematic software testing

We devised three test cases in our exemple above. How did we do it? We used our experience as software developers.

However, although our experience indeed helps us deeply in finding bugs, this might
not be enough: 

* It is highly prone to mistakes. Maybe you might forget one test case.
* It varies from person to person. We want any developer in the world to be able to test software.
* It is hard to know when to stop, based only on our gut feelings.

This is why, throughout the course, we will study more systematic techniques 
to test software.

<iframe width="560" height="315" src="https://www.youtube.com/embed/xyV5fZsUH9s" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


## An introduction to test code quality

In practice, developers write (and maintain!) thousands of test code lines. 
Taking care of the quality of test code is therefore of utmost importance.
Whenever possible, we'll introduce you to some best practices in test
code engineering.

For example, in the example above, we create the `roman` object four times.
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

We will discuss test code quality in a more systematic way in a future 
chapter.

## Test design vs test execution

In practice, we usually have two distinct 
tasks when performing software testing. 

The first one is about analysing and designing test cases, where the goal is for us to 
think about everything we wanna test so that we are sure that our software works as expected.   
Usually, this phase is done by humans, although we will explore the state-of-the-art in software testing research, where machines also try to 
devise test cases for us. 
We are going to explore different strategies that a person can do to design good test cases, such as functional testing, boundary testing, and structural testing.

The second part is about executing the tests we created. 
And we often do it by actually running the real software or by exercising its classes, and making sure that the software does what it is supposed to do.
Although this phase can also be done by humans, this is an activity that we can easily automate. Meaning, we can write a program that run our software and executes the test cases. 
Writing these test programs or, as we call, writing automated tests, is also a fundamental part of this course. 

To sum up, you should do two activities when testing your software. The first one, the more human part, which is to think and design test cases in the best way possible. And the second phase, which is to execute the tests against the software under test, and make sure that it behaves correctly. And that, we will always try to automate it as much as possible.

Side note 1: If you're very interested on understanding why it is so hard to teach machines to design test cases for us, and therefore, remove the human out of the loop, you can read this amazing paper called "[The Oracle Problem in Software Testing: A Survey](https://ieeexplore.ieee.org/abstract/document/6963470)". 

Side note 2: In industry, the term _automated software testing_ is related to the execution of test cases; in other words, JUnit code. In academia, whenever a research paper says _automated software testing_, it means automatically designing test cases (and not only the JUnit code).


<iframe width="560" height="315" src="https://www.youtube.com/embed/pPv37kPqvAE" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## References

* Pragmatic Unit Testing in Java 8 with Junit. Langr, Hunt, and Thomas. Pragmatic Programmers, 2015.