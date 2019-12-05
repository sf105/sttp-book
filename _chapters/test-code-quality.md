---
chapter-number: 12
title: Test code quality and test code smells
layout: chapter
toc: true
author: Maurício Aniche
---

We have been writing a lot of test cases and we have automated all these test cases.
This automation process means writing code to execute the test cases.
As the production code base becomes very large and complex, so does the test code base.
Like with the production code, this means that we need to put some effort in making high quality test code and to keep this test code maintainable.

In this chapter we go over some good practices for writing test code and so-called test smells.
These test smells are structures or pieces of code you see in the test code base that indicate problems in the test code or in the system.

## Act Arrange Assert

Automated tests are very similar in structure.
They almost all follow the AAA structure.
This stands for **Arrange**, **Act**, and **Assert**.
In the **Arrange** phase we get everything we need to execute the test.
This usually means initializing some object and/or setting some values.
The **Act** phase is where the production code is used to determine a certain result.
This result is then used in the **Assert** phase, where we assert that the result is what we expect it to be.

{% include example-begin.html %}
We have an automated test:

```java
@Test
public void nonLeapCenturialYears() {
1.  LeapYear ly = new LeapYear();

2.  boolean leap = ly.isLeapYear(1500);

3.  assertFalse(leap);
}
```

This test is made for the `LeapYear` class and tests the `isLeapYear` method.
We find the *arrange* part at the start: we create an instance of `LeapYear` in line 1.
Then we use this instance to find the result of the method in line 2.
This is the *act* part; we use the production code to find a result for a certain input.
In line 3. we *assert* that the result is false.
{% include example-end.html %}

## Code smells

In production code we use the term **code smells** for indications or symptoms that indicate a deeper problem in the system.
Some very well-known examples are long method or long classes.
Lots of research tell us that these code smells hinder the comprehensibility and the maintainability of software systems.
If there are a lot of code smells in a system, it will be very hard to fix an issue or to add a feature later on.

Code smells can also occur in the test code.
When this happens, we talk of **test smells**.
Research shows that these test smells occur a lot in real life and, unsurprisingly, often negatively impact the system.
For example, a paper by Bavota and his co-authors shows that the test smells are widely spread and negatively impact the comprehensibility of the code.
Another study by Spadini and his co-authors says that tests, that are affected by test smells, have defects and are changed more often than tests that are not affected.
Throughout this chapter we will go over some test smells and how to avoid them.

## FIRST

Before we discuss the test smells, we would like to have a look at some best practices first.
Here we follow the FIRST Properties of Good Test, where each letter in FIRST stands for one of the properties.

- **Fast**: the test should be fast.
We do not have a hard line for when a test is slow or fast.
The idea is, however, that when it takes a long time to run a test, developers will not run the test all the time;
it would take too much of their time.
It is important to run the test after each change, because we want to check that the changes do not break anything.
In order to keep our tests fast, we try to use as few slow dependencies as possible.
We have already seen a way to do this; with mock objects.
- **Isolated**: When writing a test, we want the test to be isolated in a two different perspectives.
The first one is in terms of what it tests.
The test should check an isolated piece of functionality.
Following this, good unit tests only focus on small pieces of code.
Another perspective is the isolation from other tests.
The tests should not depend on each other.
When, for example, test A only works when test B is run before it, the tests are not independent.
To have this independence you have to be careful with shared resources between the tests: The resources have to be the same at the end of a test as they were at the beginning.
- **Repeatable**: A repeatable test is a test that gives the same result, no matter how many times it is executed.
If a test fails sometimes and then if you run it a couple of times suddenly passes, we cannot really trust the test's results anymore.
Repeatable tests are related to isolated tests: When a test is not repeatable, it is often not isolated well.
- **Self-validating/Self-arranging**: The tests should validate the result themselves.
We write test code to automate the tests, so we do not want to compare the results ourselves.
Tests are made self-validating by using assertions.
When we talk about self-validating, we should also talk about **self-arranging**.
This means that the test should reach the required initial state itself.
For example if the code uses a database, the test should make sure that this database contains the necessary data to run the code.
- **Timely**: The final property is timely.
Now we are not talking just about the code, but also about the development process.
Automated tests should be written often and shortly after the production code.
In the software testing community we call this becoming "test infected": Testing the software should become a habit.
If the automated tests are left for a long time after the production code is written, chances are high that they are not written at all.
In a later chapter we discuss Test Driven Development.
There, this is taken even further by writing the tests before writing the production code.
For now, keep in mind that you should write tests very frequently.

## Test Smells

Now that we covered some best practices we can start looking at the test smells.
You will see that most of these smells can be mapped to one of the best practices.

One common test smell is **Code Duplication**.
That this is a common test smell is not so surprising, as it is also very common in production code.
We already noted that the tests are all very similar in structure.
With that we can very easily get code duplication.
Developers will often just copy paste the code instead of coming up with some private method, or abstractions.
The problem with duplicate code is mostly its effect on the maintainability of code.
If there is a fault in the duplicated piece of code and you want to correct it, you will have to correct it in all the places where the code was duplicated.
Then it is very easy to forget one of the places and you end up with faulty code in your tests.
This is similar to the impact of code duplication in production code.
Because of its effect on the maintainability of a system, code duplication is considered to be a test smell.

Another very common test smell is called **Assertion Roulette**.
Assertion roulette is when a test fails and it is very hard for the developers to understand the failing assertion.
This is problematic, because the developer cannot see what is going wrong exactly and therefore cannot fix the error.
Assertion roulette can happen because of a couple of reasons.
The first one is the amount of assertions in the test.
With a lot of assertions it's hard to see what each of the assertions does.
So, with a lot of assertions in a test case and one of them failing it can be difficult to understand its context and locate the fault in the production code.
The second reason is the complexity of the assertion itself.
By just looking at the assertion it will be very hard to see what the assertion is checking.
Sometimes just adding a comment, or in JUnit a message, to the assert can help.
Another widely used strategy is called the "one assertion per method" strategy.
With that strategy we aim to have the least amount of assertions in a test method as possible.
This can be taken to the extreme by just allowing exactly one assertion per method.
More pragmatically though, when you see a test method with a lot of assertions you can probably think about splitting it up in a couple separate tests.

The next test smell corresponds to the Fast of FIRST: **Slow tests**.
As we discussed test cases should be fast, because then the developers can run the test after each small change they make.
Slower tests will be executed less frequently and therefore give less feedback to the developer.
When you encounter a slow test you should really try to speed it up.
If you have a very slow dependency, you could for example try to mock it.
Be aware that mocking also takes time, so you also do not want to use too many mocks in your tests.

Another test smell relates to the Self-arranging of FIRST: **Resource Optimism**.
Resource optimism means that a test assumes that a necessary resource is readily available at the start of its execution.
Again with the database example: The test should make sure that the required data gets stored in the database, so it cannot assume it is already there.
Another type of resource optimism is assuming that the resource is available all the time.
When we are using a webservice, for example, this might not always be the case.
To avoid this test smell you have two options.
One is again to avoid using external resources, by using mock objects.
As you have already seen, with mock object we do not need the external resources.
If you cannot avoid using the external dependencies, you can make the test robust enough.
In that case you can skip the test when the resource is unavaiable and provide a message containing why the test is skipped.
This is at least better than letting the test fail.
In addition to changing your tests, you have to make sure that all the environments that the tests are run in have the required resources available.
Continuous integration tools like Jenkins, CircleCI, and Travis can help you to make sure that you run the tests always in the same environment.

The next test smell is **Test Run War**.
This happens when the tests pass if you execute them alone, but fail as soon as someone else runs the tests at the same time.
This typically happens when you are using the same database.
Then it does not even matter that the tests are run on different machine; they alter each other resources.
This corresponds to the Isolation of FIRST.
When you encounter a Test Run War, the tests are not well isolated.

Another test smell that we often encounter is **General Fixture**.
Fixture basically means the arrange part of the test, where we create all the objects needed to run the tests.
We often see developers creating one method to create the objects needed for the tests.
Such a fixture does not need to be a problem, but when test A uses a part of the fixture and part B another part the fixture is too general.
The problem with a general fixture is that it becomes very hard to understand what a test needs and uses.
To resolve this issue you have to make sure that the tests all contain clear and concise fixures, which all have just the needed objects.
Later we will see a design pattern called test data builder, that helps avoiding this test smell.

The **Indirect tests** smell concerns the class that is tested by a test class.
When the test not just tests the class under test, but by testing it also tests another class, we call it an indirect test.
This is problemetic, because when one class is not working properly, you suddenly have a lot of tests failing.
For example, we have a test class for class B, that also tests class A.
Now if there is a fault in class A, the tests for class A will fail (this is to be expected), but also the tests of class B will fail.
While there is nothing wrong with class B.
These extra failing tests are cumbersome and costs a lot of time of the developer.
So we need to keep our tests focused and make sure that they do not indirectly test other classes.

Finally, we have the test smell called **Sensitive Equality**.
We use assertions to verify that the production code behaves as expected.
This test smell is when we have assertions that are too strict.
Then when you change a small thing in the production code, the tests will break and they have to be edited as well.
This is not a kind of test that we want: We want our tests to be as resilient as possible.
If we then make a small change in the production code, we do not have to immediately change the test code as well.

All these test smells are covered more in-depth in XUnit Test Patterns by Gerard Meszaros.
We highly recommend you to read that book!

## Flaky Tests

What often happens is that a test sometimes passes, but sometimes it also fails.
You might have encountered this yourself as well.
We call such tests **Flaky tests**.

Flaky tests hurt the development process, because if we have a flaky test the development team loses confidence in the tests suite.
After all, at some point they do not know anymore if there is a real bug in the system or if the test fails, while there is nothing wrong.
We like to have no flaky tests in our test suite.

Flaky tests can have a lot of causes.
We will name a few examples.
A test could be flaky, because it depends on an external infrastructure.
Let's say we need a database to run our tests.
At some times the test can pass, because the database is available, and at other times it might fail, because then the database is not available.
In this case the test depends on the availability of an external infrastructure.
Another reason could be that the tests are using a shared resource.
We covered this scenario in the previous section.
The tests can also be flaky because of time-outs.
This cause is common in web applications.
With timeouts the test waits for something to happen in the web application.
If the web application is a bit slower than normal, the test will suddenly fail.
Finally we could have interacting tests.
Then test A influences the result of test B, possibly causing it to fail.
All these examples are plausible causes of flakiness that actually occur in practice.

As you might have notices, a lot of the causes of flaky tests correspond to scenarios we described when discussing the test smells.
Actually, research shows that there is a correlation between a test being affected by test smells and it being flaky.
In other words: If you find and handle the test smells well, you will probably resolve the cause of flakiness as well.
The quality of our test code is indeed very important!

If you want to find the exact cause of a flaky test, the author of the XUnit Test Patterns book has made a whole decision table.
You can find it in the book or on Gerard Meszaros' website [here](http://xunitpatterns.com/Erratic%20Test.html).
With the decision table you can find a probable cause for the flakiness of your test.
For example: Does the flaky test get worse over time?
This means if the test gets slower and slower to execute.
If this is true, you probably have a resource leakage in the tests, otherwise it is probably a non-deterministic test.

## Readability

As we often need to improve the test suite, developers will spend a lot of time working on the test code.
Therefore, it is crucial that the developers can understand the test code easily.
We need readable and understandable test code.
But how can you do this?
We give you some tips to write readable test code in this section.

The first tip concerns the structure of your tests.
As you have seen earlier test all follow the same structure: Arrange, Act and Assert.
When these are clearly separated, it is easier to see what is happening in the test.
In the example at the start of this chapter, we did this by just adding some blank lines between the different parts.

A second tip is about information in tests.
Test are full of information, i.e. the input values and the expected results.
Then dealing with complex object, the information in the test will also become complex.
So you have to make sure that the information present in a test is easy to understand.
An easy way to do this is by storing the values in variables with descriptive names.
This is illustrated in the example below.

{% include example-begin.html %}
We have written a test for an invoice that checks if the invoice has been paid.

```java
@Test
public void invoiceNotPaid() {
  Invoice inv = new Invoice(1, 10.0, 25.0);

  boolean paid = inv.isPaid();

  assertFalse(paid);
}
```

In the test above it is not clear what the values mean: It is not clear what information is in the test.
Let's rewrite the test with some variables.

```java
@Test
public void invoiceNotPaid() {
  int anyId = 1;
  double tax = 10.0;
  double amount = 25.0;
  Invoice inv = new Invoice(anyId, tax, amount);

  boolean paid = inv.isPaid();

  assertFalse(paid);
}
```

With these variables it is clear what the values actually mean.
The ID can be any number (does not really matter what), hence the `any` at the front.
And then we use some values for the tax and the actual amount in of the invoice.
With the variables it is easier to find out what the information in the test is.
{% include example-end.html %}

Finally we have a small tip for assertions.
When an assertions fails, a developer should be able to quickly see what is going wrong in order to fix the fault in the code.
If the assertion in your test is  complex, you might want to express it in a different way, or to add a message to the assertion.
