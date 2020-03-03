---
chapter-number: 12
title: Test code quality and test code smells
layout: chapter
toc: true
author: Maurício Aniche
---

## Introduction

You probably noticed that the amount of JUnit automated test cases that we
have written so far is quite significant. This is what happens in practice:
the test code base grows up very fast. And
like with the production code, **we have to put some extra effort in making high-quality test code bases so that we can maintain and evolve them in a
sustainable way**.

In this chapter, we go over some good practices 
for writing test code. We'll discuss the so-called **test code smells**.
These test smells are structures or pieces of code you see in the test code base that indicate problems in the test code or in the system. This is a clear
analogy to **code smells**, however focused on test code.

To understand how to write good test code, we first should understand
the structure of a test method.
Automated tests are very similar in structure.
They almost always follow the AAA ("triple A") structure.
This acronym stands for **Arrange**, **Act**, and **Assert**.
In the **Arrange** phase, we get everything we need to execute the test.
This usually means initializing some object and/or setting up some values.
Some people call it the "set up of the test". In practice, this is where
we write the inputs we devised using any of the testing techniques
we discussed.
The **Act** phase is where the production code under test is exercised.
It is usually done by means of one or many method calls.
The result is then used in the **Assert** phase, where we assert that it is what we expect it to be.

{% include example-begin.html %}
We have an automated test:

```java
@Test
public void nonLeapCenturialYears() {
	// this is the arrange
1.  int year = 1500;

	// this is the act
2.  LeapYear ly = new LeapYear();
3.  boolean leap = ly.isLeapYear(year);

	// this is the assert
4.  assertFalse(leap);
}
```

This test is made for the `LeapYear` class and tests the `isLeapYear` method.
We find the *arrange* part at the start: we define `1500` as the year we 
want to pass to the production method.
Then we use this value as an input to the method under test in lines 2 and 3.
This is the *act* part; we use the production code to find a result for a certain input.
In line 4, we *assert* that the result is false.
{% include example-end.html %}

<iframe width="560" height="315" src="https://www.youtube.com/embed/tH_-iIwbDmc" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


## The FIRST principles

Now, let's discuss some best practices in test code.
We will discuss the "FIRST Properties of Good Tests". They come originally
from the Pragmatic Unit Testing book (see references). Each letter in the
acronym represents one best practice.

- **Fast**: 
In practice, it is really important to run the test after each change, to check that the changes do not break anything.
For that to happen smmothly, **the test execution should be fast**. 
Although we do not have a hard line for when a test is slow or fast,
the idea is, however, that when it takes a long time to run a test, developers will not run the test all the time;
it would take just too much of their time.
In order to keep our tests fast, we should use as few slow dependencies as possible.
We have already seen a way to do this with mock objects.

- **Isolated**: When writing a test, we want this specific **test to be as isolated as possible** in a two different perspectives.
The first one is in terms of what it tests.
The test should check an isolated piece of functionality.
Following this, **good unit tests only focus on small pieces of code or in single
functionalities**.
Another perspective is the isolation from other tests.
**Tests should not depend on each other.**
When, for example, test A only works when test B runs before, tests are not independent anymore.
To avoid such dependency, you have to be careful with shared resources between the tests, e.g., databases, files. The resources have to be the same at the end of a test as they were at the beginning (i.e., your tests should "clean their messes up" at the end of their execution).

- **Repeatable**: **A repeatable test is a test that gives the same result, no matter how many times it is executed.**
If a test sometimes fails and sometimes passes, without any changes in the system, you suddenly loose confidence in that test.
Repeatable tests are related to isolated tests. A test that is not so well isolated tend to be not repeatable. (We will call these tests, *flaky tests* later on in this chapter).

- **Self-validating/Self-arranging**: **The tests should validate the result themselves.**
We write test code to automate the tests, so that we do have to compare the results ourselves.
Tests are made self-validating by using assertions. Tests should act as oracles:
they should make sure that the program behaved as expeted.
When we talk about self-validating, we should also talk about **self-arranging**.
This means that the test should reach the required initial state itself.
For example, if the production code uses a database and requires that this database is in some state before running, the test should make sure that this database contains the necessary data to run the code.

- **Timely**: The final property is timely.
Now, we are not talking just about the code, but also about the development process.
Automated tests should be written often and shortly after the production code.
If we leave automated tests to the end of the process, e.g., long after the production code is written, chances are that they will not be written at all.
We should become "test infected"! Testing the software should become a habit.
(We also discuss the idea of Test-Driven Development, or development guided by the tests in a specific chapter.)

<iframe width="560" height="315" src="https://www.youtube.com/embed/5wLrj-cr9Cs" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Test Desiderata

Kent Beck, the "creator" of Test-Driven Development (and author of the fantastic
["Test-Driven Development: By Example"](https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530) book), recently wrote a list of eleven
properties that good tests have (the [test desiderata](https://medium.com/@kentbeck_7670/test-desiderata-94150638a4b3)). 

Directly from his blog post (each link below points to a YouTube video he recorded about the topic):

* [Isolated](https://www.youtube.com/watch?v=HApI2cspQus) — tests should return the same results regardless of the order in which they are run.
* [Composable](https://www.youtube.com/watch?v=Wf3WXYaMt8E) — if tests are isolated, then I can run 1 or 10 or 100 or 1,000,000 and get the same results.
* [Fast](https://www.youtube.com/watch?v=L0dZ7MmW6xc) — tests should run quickly.
* [Inspiring](https://www.youtube.com/watch?v=2Q1O8XBVbZQ) — passing the tests should inspire confidence
* [Writable](https://www.youtube.com/watch?v=CAttTEUE9HM) — tests should be cheap to write relative to the cost of the code being tested.
* [Readable](https://www.youtube.com/watch?v=bDaFPACTjj8) — tests should be comprehensible for reader, invoking the motivation for writing this particular test.
* [Behavioral](https://www.youtube.com/watch?v=5LOdKDqdWYU) — tests should be sensitive to changes in the behavior of the code under test. If the behavior changes, the test result should change.
* [Structure-insensitive](https://www.youtube.com/watch?v=bvRRbWbQwDU) — tests should not change their result if the structure of the code changes.
* [Automated](https://www.youtube.com/watch?v=YQlmP08dj6g) — tests should run without human intervention.
* [Specific](https://www.youtube.com/watch?v=8lTfrCtPPNE) — if a test fails, the cause of the failure should be obvious.
* [Deterministic](https://www.youtube.com/watch?v=PwWyp-wpFiw) — if nothing changes, the test result shouldn't change.
* [Predictive](https://www.youtube.com/watch?v=7o5qxxx7SmI) — if the tests all pass, then the code under test should be suitable for production.




## Test Smells

Now that we covered some best practices we can start looking at the other
side of the coin, **the test smells**.

In production code we use the term **code smells** for indications or symptoms that indicate a deeper problem in the system.
Some very well-known examples are *Long Method*, *Long Class*, or *God Class*.
A good number of research papers show us that code smells hinder the comprehensibility and the maintainability of software systems.

Code smells can also occur in the test code.
We call them **test smells**.
Research also shows that these test smells occur a lot in real life and, unsurprisingly, often negatively impact the system.
For example, a paper by Bavota and his co-authors shows that the test smells are widely spread and negatively impact the comprehensibility of the code.
Another study by Spadini and his co-authors says that tests, that are affected by test smells, have defects and are changed more often than tests that are not affected.

You will see that most of these smells can be mapped to one of the best practices.
Throughout this chapter we will go over some test smells and how to avoid them.
There are more test smells you can study, though. A good reference for future studies here is the xUnit Test Patterns book, by
Meszaros.


One common test smell is **Code Duplication**.
It is not surprising that this is a test smell, as it is also very common in production code.
We already noted that the tests are all very similar in structure.
With that we can very easily get code duplication.
Developers often just copy paste the code instead of coming up with some private method, or more generally, abstractions.

The problem with duplicate code is mostly its effect on the maintainability of code.
If there is a need for a change in the duplicated piece of code, you will have to apply the change in all the places where the code was duplicated. 
In practice, it is very easy to forget one of the places, and you end up with problematic code in your tests.
This is similar to the impact of code duplication in production code.
Because of its effect on the maintainability of a system, code duplication is considered to be a test smell.

Another very common test smell is called **Assertion Roulette**.
Assertion roulette is when a test fails, and it is very hard for the developers to understand the failing assertion, i.e., why does it fail?
This is problematic, as the developer cannot see what is going wrong exactly and therefore cannot fix the error.
Assertion roulette can happen due to a couple of reasons.
The first one is the amount of assertions in the test.
A test that contains a lot of assertions might make the life of developer more difficult when one assertion fails. After all, understanding the full context of a complex sequence of assertions is just harder than understanding the full context of a simple sequence of assertions.
Sometimes just adding a comment, or JUnit message in the assertion can help.

Another widely used strategy is called the "one assertion per method" strategy.
With that strategy, we aim to have the least amount of assertions in a test method as possible.
This can be taken to the extreme by just allowing exactly one assertion per method.
More pragmatically though, when you see a test method with a lot of assertions, you can probably think about splitting it up in a couple separate tests.

The next test smell corresponds to the Fast of FIRST principles: **Slow tests**.
As we discussed, test cases should be fast, because then the developers can run the test after each small change they make.
Slower tests will be executed less frequently and therefore give less feedback to the developer.
When you encounter a slow test you should really try to speed it up.
If you have a very slow dependency, you could for example try to mock it.


Another test smell relates to the Self-arranging of FIRST: **Resource Optimism**.
Resource optimism happens when a test assumes that a necessary resource (e.g., a database) is readily available at the start of its execution.
Again, with the database example: to avoid resource optimism, a test should not assume that the database is already in the correct state, and should set up the state there itself, by means of, for example, INSERT instructions at the beginning of the test method.

Another type of resource optimism is assuming that the resource is available all the time.
When we are using a webservice, for example, this might not always be the case, as the webservice might be down for reasons we do not control.
To avoid this test smell, you have two options:
One is again to avoid using external resources, by using mock objects.
If you cannot avoid using the external dependencies, you can make the test robust enough.
In that case, you can skip the test when the resource is unavailable, and provide a message explaining why the test was skipped.
This is, at least, better than letting the test fail for a bad reason.

In addition to changing your tests, you have to make sure that all the environments that the tests are executed have the required resources available.
Continuous integration tools like Jenkins, CircleCI, and Travis can help you in making sure that you run the tests always in the same environment.

The next test smell is **Test Run War**.
This happens when the tests pass if you execute them alone, but fail as soon as someone else runs the test at the same time.
This often happen when the tests consume the same resource, e.g., the same database.
Imagine a test suite that communicates to a global database. When developer 1 runs the test, the test changes the state of the database; at the same time, developer 2 runs the same test that also goes to the same database. Now, both tests are touching the same database at the same time. This unexpected situation which might make the test to fail.
If you feel like we talked about this before, you are correct; this smell is highly related to the *Isolation* of the FIRST princinples.
When you encounter a Test Run War, make sure to isolate them well.

Another test smell that we often encounter is the **General Fixture**.
A fixture basically means the arrange part of the test, where we create all the objects and inputs needed by the test.
We often see developers creating one large method (using, for example, the `@BeforeEach` annotation of JUnit) that creates *all* the objects needed by the *all* tests.
Having such a fixture is not necessarily a problem. However, when test A uses just part of this fixture, and part B uses just another part, this means that this fixture is too generic.
The problem with a generic fixture is that it becomes very hard to understand what a single test really needs and uses.
To resolve this issue, you have to make sure that the tests contain clear and concise fixures, nothing more than what it really needs.
Explore the design pattern called **[Test Data Builder](http://www.natpryce.com/articles/000714.html)**, that helps us in avoiding this test smell.

The **Indirect tests** smell concerns the class that is tested by a test class.
When the test goes beyond testing the class under test, but also tests other classes, we call it an *indirect test*.
This might problematic due to the change propagation that might happen in this test. Imagine a test class `ATest` that tests not only class `A`, but also class `B`. If a bug exists in class `B`, we expect tests in `BTest` to fail; however, the tests for class `A` in `ATest` will also break, due to 
this indirect testing.

These extra failing tests are cumbersome and might cost a good amount of time from the developer.
We should try as much as possible to keep our tests focused, making sure that they do not indirectly test other classes.

Finally, we have the test smell called **Sensitive Equality**.
We use assertions to verify that the production code behaves as expected.
This test smell is when we have assertions that are too strict. Or, in other
words, too sensitive. We want our tests to be as resilient as possible, and only break if there is indeed a bug in the system. We do not want small changes that do not affect the behavior of the class to break our tests.

A clear example of such a smell is when the developer decides to use
the results of a `toString()` method to assert the expected behavior.
Imagine an assertion like `Assertion.assertTrue(invoice.toString().contains("Playstation"))`.
`toString()`s change quite often; but a change in `toString()` should not
break all the tests... If the developer had made the assertion to focus
on the specific property, e.g., `Assertion.assertEquals("Playstation", invoice.getProduct().getName())`, this would not had happened.

Again, all these test smells are covered more in-depth in XUnit Test Patterns by Gerard Meszaros.
We highly recommend you to read that book!

<iframe width="560" height="315" src="https://www.youtube.com/embed/QE-L818PDjA" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<iframe width="560" height="315" src="https://www.youtube.com/embed/DLfeGM84bzg" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Flaky Tests

It is unfortunately quite common to have tests in our test suite
that sometimes passes, but sometimes fails. We do not like these tests;
after all, if a test gives us false positives, we can not really trust on them.
We call such tests, **flaky tests**.

Flaky tests can have a lot of causes.
We will name a few examples:

* A test could be flaky, because it **depends on an external and/or shared resource**.
Let's say we need a database to run our tests.
Sometimes the test passes, because the database is available; sometimes it fails, because then the database is not available.
In this case, the test depends on the availability of an external infrastructure.

* The tests can also be flaky because of time-outs.
This cause is common in web applications.
With timeouts, the test waits for something to happen in the web application, e.g.,
a new message to appear in an HTML element.
If the web application is a bit slower than normal, the test will suddenly fail.

* Finally we could have interacting tests, which we also discussed above.
Then test A influences the result of test B, possibly causing it to fail.
All these examples are plausible causes of flakiness that actually occur in practice.

As you might have notices, a lot of the causes of flaky tests correspond to scenarios we described when discussing the test smells.
The quality of our test code is indeed very important!

If you want to find the exact cause of a flaky test, the author of the XUnit Test Patterns book has made a whole decision table.
You can find it in the book or on Gerard Meszaros' website [here](http://xunitpatterns.com/Erratic%20Test.html).
With the decision table you can find a probable cause for the flakiness of your test.
For example: Does the flaky test get worse over time?
This means if the test gets slower and slower to execute.
If this is true, you probably have a resource leakage in the tests, otherwise it is probably a non-deterministic test.

If you want to read more about flaky tests, we suggest the following papers and blog posts (including Google discussing how problematic flaky tests are for their development teams):

- Luo, Q., Hariri, F., Eloussi, L., & Marinov, D. (2014, November). An empirical analysis of flaky tests. In Proceedings of the 22nd ACM SIGSOFT International Symposium on Foundations of Software Engineering (pp. 643-653). ACM. 
Authors' version: [http://mir.cs.illinois.edu/~eloussi2/publications/fse14.pdf](http://mir.cs.illinois.edu/~eloussi2/publications/fse14.pdf)
- Bell, J., Legunsen, O., Hilton, M., Eloussi, L., Yung, T., & Marinov, D. (2018, May). D e F laker: automatically detecting flaky tests. In Proceedings of the 40th International Conference on Software Engineering (pp. 433-444). ACM. 
Authors' version: [http://mir.cs.illinois.edu/legunsen/pubs/BellETAL18DeFlaker.pdf](http://mir.cs.illinois.edu/legunsen/pubs/BellETAL18DeFlaker.pdf)
- Lam, W., Oei, R., Shi, A., Marinov, D., & Xie, T. (2019, April). iDFlakies: A Framework for Detecting and Partially Classifying Flaky Tests. In 2019 12th IEEE Conference on Software Testing, Validation and Verification (ICST) (pp. 312-322). IEEE. 
Authors' version: [http://taoxie.cs.illinois.edu/publications/icst19-idflakies.pdf](http://taoxie.cs.illinois.edu/publications/icst19-idflakies.pdf)
- Listfield, J. Where do our flaky tests come from?  
Link: [https://testing.googleblog.com/2017/04/where-do-our-flaky-tests-come-from.html](https://testing.googleblog.com/2017/04/where-do-our-flaky-tests-come-from.html), 2017.
- Micco, J. Flaky tests at Google and How We Mitigate Them.  
Link: [https://testing.googleblog.com/2016/05/flaky-tests-at-google-and-how-we.html](https://testing.googleblog.com/2016/05/flaky-tests-at-google-and-how-we.html), 2017.
- Fowler, M. Eradicating Non-Determinism in Tests. Link: [https://martinfowler.com/articles/nonDeterminism.html](https://martinfowler.com/articles/nonDeterminism.html), 2011.

<iframe width="560" height="315" src="https://www.youtube.com/embed/-OQgBMSBL5c" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


## Improving the Readability of Test Code

As developers are often working on their test code bases.
Therefore, it is crucial that the developers can understand the test code easily.
**We need readable and understandable test code.** 
Note that "readability" is one of the test desiderata!
But how can we do this?
In the following, we give you some tips to write readable test code.

* The first tip concerns the **structure of your tests**.
As you have seen earlier, tests all follow the same structure: Arrange, Act and Assert.
When **these are clearly separated, it is easier for a developer to see what is happening in the test**.
In the example, at the start of this chapter, we did this by just adding some blank lines between the different parts.

* A second tip is about the **information in tests**.
Test are full of information, i.e., input values, expected results.
However, we often have to deal with complex data structures and information, which makes the test code naturally complex.
**We should make sure that the important information present in a test is easy to understand.**
An easy way to do this is by storing the values in variables with descriptive names.
This is illustrated in the example below.

{% include example-begin.html %}
We have written a test for an invoice that checks if the invoice has been paid.

```java
@Test
public void invoiceNotPaid() {
  Invoice inv = new Invoice(1, 10.0, 25.0);

  boolean p = inv.isPaid();

  assertFalse(p);
}
```

As you can see, is not clear what all the hard-coded values really mean (what does 1, 10.0, or 25.0 mean?), and thus, it is not clear what kind of information this test deals with.

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

The variables with descriptive names makes it easier for a developer
to understand what they actually mean.
Now, we clearly see that the ID can be any number (does not really matter which one for this test), hence the `any` at the front. The variables `tax` and
`amount` also now clearly explain what the previously "magic numbers with no explanation" mean.
{% include example-end.html %}

* Finally we have a small tip for assertions.
When an assertions fails, a developer should be able to quickly see what is going wrong in order to fix the fault in the code.
If the assertion in your test is complex, you might want to express it in a different way. For example, you might create a helper that performs this assertion step by step, so that a developer can easily follow the idea. Or you might want to add an explanatory message to the assertion. Or, even, why not a code comment?
Frameworks like [AssertJ](https://joel-costigliola.github.io/assertj/) have become really popular among developers, due to its expresiveness in assertions.

{% assign todo = "Example here of assertj" %}
{% include todo.html %}


<iframe width="560" height="315" src="https://www.youtube.com/embed/RlqLCUl2b0g" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## References

- Chapter 5 of Pragmatic Unit Testing in Java 8 with Junit. Langr, Hunt, and Thomas. Pragmatic Programmers, 2015.
- Meszaros, G. (2007). xUnit test patterns: Refactoring test code. Pearson Education.
- Bavota, G., Qusef, A., Oliveto, R., De Lucia, A., & Binkley, D. (2012, September). An empirical analysis of the distribution of unit test smells and their impact on software maintenance. In 2012 28th IEEE International Conference on Software Maintenance (ICSM) (pp. 56-65). IEEE.
- Bavota, G., Qusef, A., Oliveto, R., De Lucia, A., & Binkley, D. (2015). Are test smells really harmful? An empirical study. Empirical Software Engineering, 20(4), 1052-1094.
- Luo, Q., Hariri, F., Eloussi, L., & Marinov, D. (2014, November). An empirical analysis of flaky tests. In Proceedings of the 22nd ACM SIGSOFT International Symposium on Foundations of Software Engineering (pp. 643-653). ACM. 
- Bell, J., Legunsen, O., Hilton, M., Eloussi, L., Yung, T., & Marinov, D. (2018, May). D e F laker: automatically detecting flaky tests. In Proceedings of the 40th International Conference on Software Engineering (pp. 433-444). ACM. 
- Lam, W., Oei, R., Shi, A., Marinov, D., & Xie, T. (2019, April). iDFlakies: A Framework for Detecting and Partially Classifying Flaky Tests. In 2019 12th IEEE Conference on Software Testing, Validation and Verification (ICST) (pp. 312-322). IEEE. 
- Listfield, J. Where do our flaky tests come from?  
Link: https://testing.googleblog.com/2017/04/where-do-our-flaky-tests-come-from.html, 2017.
- Micco, J. Flaky tests at Google and How We Mitigate Them.  
Link: https://testing.googleblog.com/2016/05/flaky-tests-at-google-and-how-we.html, 2017.
- Fowler, M. Eradicating Non-Determinism in Tests. Link: https://martinfowler.com/articles/nonDeterminism.html, 2011.

## Exercises

{% include exercise-begin.html %}

Jeanette just heard that two tests are behaving strangely: when executed in isolation, both of them pass. However, when executed together, they fail. Which one of the following **is not** cause for this?

1. Both tests are very slow.
1. They depend upon the same external resources.
1. The execution order of the tests matter.
1. They do not perform a clean-up operation after execution.

{% include answer-begin.html %}

Correct: Both tests are very slow.

{% include exercise-answer-end.html %}




{% include exercise-begin.html %}

RepoDriller is a project that extracts information from Git repositories. Its integration tests consumes lots of real Git repositories, each one with a different characteristic, e.g., one repository contains a merge commit, another repository contains a revert operation, etc.

Its tests look like what you see below:

```java
@Test
public void test01() {

  // arrange: specific repo
  String path = "test-repos/git-4";

  // act
  TestVisitor visitor = new TestVisitor();
  new RepositoryMining()
  .in(GitRepository.singleProject(path))
  .through(Commits.all())
  .process(visitor)
  .mine();
  
  // assert
  Assert.assertEquals(3, visitor.getVisitedHashes().size());
  Assert.assertTrue(visitor.getVisitedHashes().get(2).equals("b8c2"));
  Assert.assertTrue(visitor.getVisitedHashes().get(1).equals("375d"));
  Assert.assertTrue(visitor.getVisitedHashes().get(0).equals("a1b6"));
}
```


Which test smell does this piece of code suffers from?

1. Mystery guest
1. Condition logic in test
1. General fixture
1. Flaky test

{% include answer-begin.html %}

Correct answer: Mystery guest

{% include exercise-answer-end.html %}


{% include exercise-begin.html %}

In the code below, we present the source code of an automated test.
However, Joe, our new test specialist, believes this test is smelly and it can be better written.
Which of the following could be Joe's main concern?

  
1. The test contains code that may or may not be executed, making the test less readable.
2. It is hard to tell which of several assertions within the same test method will cause a test failure.
3. The test depends on external resources and has nondeterministic results depending on when/where it is run.
4. The test reader is not able to see the cause and effect between fixture and verification logic because part of it is done outside the test method.

```java
@Test
public void flightMileage() {
  // setup fixture
  // exercise contructor
  Flight newFlight = new Flight(validFlightNumber);
  // verify constructed object
  assertEquals(validFlightNumber, newFlight.number);
  assertEquals("", newFlight.airlineCode);
  assertNull(newFlight.airline);
  // setup mileage
  newFlight.setMileage(1122);
  // exercise mileage translater
  int actualKilometres = newFlight.getMileageAsKm();    
  // verify results
  int expectedKilometres = 1810;
  assertEquals(expectedKilometres, actualKilometres);
  // now try it with a canceled flight
  newFlight.cancel();
  boolean flightCanceledStatus = newFlight.isCancelled();
  assertFalse(flightCanceledStatus);
}
```

{% include answer-begin.html %}

Correct answer: It is hard to tell which of several assertions within the same test method will cause a test failure.

{% include exercise-answer-end.html %}





{% include exercise-begin.html %}

See the test code below. What is the most likely test code smell that this piece of code presents?

```java
@Test
void test1() {
  // webservice that communicates with the bank
  BankWebService bank = new BankWebService();

  User user = new User("d.bergkamp", "nl123");
  bank.authenticate(user);
  Thread.sleep(5000); // sleep for 5 seconds

  double balance = bank.getBalance();
  Thread.sleep(2000);

  Payment bill = new Payment();
  bill.setOrigin(user);
  bill.setValue(150.0);
  bill.setDescription("Energy bill");
  bill.setCode("YHG45LT");

  bank.pay(bill);
  Thread.sleep(5000);

  double newBalance = bank.getBalance();
  Thread.sleep(2000);
  
  // new balance should be previous balance - 150
  Assertions.assertEquals(newBalance, balance - 150);
}
```

1. Flaky test.
2. Test code duplication.
3. Obscure test.
4. Long method.

{% include answer-begin.html %}

Flaky test.
{% include exercise-answer-end.html %}



{% include exercise-begin.html %}

In the code below, we show an actual test from Apache Commons Lang, a very popular open source Java library. This test focuses on the static `random()` method, which is responsible for generating random characters. A very interesting detail in this test is the comment: *Will fail randomly about 1 in 1000 times.*

```java
/**
 * Test homogeneity of random strings generated --
 * i.e., test that characters show up with expected frequencies
 * in generated strings.  Will fail randomly about 1 in 1000 times.
 * Repeated failures indicate a problem.
 */
@Test
public void testRandomStringUtilsHomog() {
    final String set = "abc";
    final char[] chars = set.toCharArray();
    String gen = "";
    final int[] counts = {0,0,0};
    final int[] expected = {200,200,200};
    for (int i = 0; i< 100; i++) {
       gen = RandomStringUtils.random(6,chars);
       for (int j = 0; j < 6; j++) {
           switch (gen.charAt(j)) {
               case 'a': {counts[0]++; break;}
               case 'b': {counts[1]++; break;}
               case 'c': {counts[2]++; break;}
               default: {fail("generated character not in set");}
           }
       }
    }
    // Perform chi-square test with df = 3-1 = 2, testing at .001 level
    assertTrue("test homogeneity -- will fail about 1 in 1000 times",
        chiSquare(expected,counts) < 13.82);
}
```

Which one of the following **is incorrect** about the test?

1. The test is flaky because of the randomness that exists in generating characters.
1. The test checks for invalidly generated characters, and that characters are picked in the same proportion.
1. The method being static has nothing to do with its flakiness.
1. To avoid the flakiness, a developer could have mocked the random function. 


{% include answer-begin.html %}

To avoid the flakiness, a developer could have mocked the random function. It does not make sense, the test is about testing the generator and its homogeinity; if we mock, the test looses its purposes.

{% include exercise-answer-end.html %}



