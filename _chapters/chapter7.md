---
chapter-number: 7
title: Design by Contracts
layout: chapter
---

[//]: TODO: add introduction to the chapter

## Self Testing
A self testing system is in principal a system that tests itself.
This may sound a bit weird so let's take a step back first.

The way we tested systems so far was by creating separate classes for the tests.
The production code and test code were completely separated.
The test suite (consisting of the test classes) exercises and then observes the system under test to check whether it is acting correctly.
If the system does something that is not expected by the test suite it gives an error, because one of the tests have failed.
The code in the test suite is completely redundant.
It does not add any behavior to the system.

With self-testing we move a bit of the test suite into the system itself.
We add some redundant code to the system.
This code, being redundant, does not change the functionalities of the code.
However, it does allow the system to check if it is running correclty by itself.
We do not have to run the test suite, but instead the system can check (part of) its behavior during the normal execution of the system.
Like with the test suite, if anything is not acting as expected, and error will be thrown because one of the self-tests is failing.
In software testing the self-tests are used as an additional check in the system additional to the test suite.

The simplest form of this self-testing is the assertion.
An assertion basically says that a certain condition has to be true at the time the assertion is executed.
In Java, to make an assertion we use the `assert` keyword:
```java
assert <condition> : "<message>";
```
Now the `assert` keywords checks if the `<condition>` is true.
If it is, nothing happens.
The program just continues its execution as everything is according to plan.
However, if the `<condition>` yields false, the `assert` throws an `AssertionError`.
In this error the assertion's message is also included.
This message is optonal, but can be very helpful to yourself and other's working with your code to find solutions to problems that they might face.
So try to always include a message that describes what is going wrong if the assertion is failing.

{% include example-begin.html %}
We have implemented a class representing a stack, we just show the `pop` method:
```java
public class MyStack {
    public Element pop() {
        assert count() > 0 : " The stack does not have any elements to pop."

        // ... actual method body ...

        assert count() == oldCount - 1;
    }
}
```
We did not include a message in the second assert for illustrative purposes.

In this method we check if a condition holds at the start: The stack should have at least one element.
Then after the actual method we check whether the count is now one lower than before popping.

These conditions are also known as pre- and postconditions.
We cover these in the following section.
{% include example-end.html %}

In Java asserts can be enabled or disabled.
If the asserts are disabled, they will never throw an `AssertionError` even if their conditions are false.
The default in Java is to disable the assertions.
This makes it very important to have assertions that are absolutely redundant.
They should not be needed for the system's execution.
To enable the asserts we have to run Java with a special argument in one of these two ways: `java -enableassertions` or `java -ea`.
When using Maven or IntelliJ the assertions are enabled automatically when running tests.
With Eclipse or Gradle we have to change some settings.
To run the system normally with assertions enabled you always have to change some settings.

The assertions are mostly an extra safety measure.
If it is crucial that a system runs correctly, we can use the asserts to add some additional testing during the system's execution.
