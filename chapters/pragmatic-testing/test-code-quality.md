# Test code quality and engineering


You probably noticed that, once _test infected_, 
the amount of JUnit code that a software development team writes and maintain
is quite significant. In practice,
test code bases tend to grow up very fast. Empirically, we have been observing
that Lehman's laws of evolution also apply to test code: code tends to rot, unless
one actively works against it. Thus,
as with production code, **developers have to put extra effort 
in making high-quality test code bases, so that it can be maintained and evolved in a
sustainable way**.

In this chapter, we go over some best practices 
in test code engineering. More specifically:

* A set of principles that should guide developers when writing test code.
For those, we discuss both the FIRST principles (from the Pragmatic Unit Testing book),
as well as the recent Test Desiderata (proposed by Kent Beck)
* A set of well-known test smells that might emerge in test code.


## The FIRST principles

In the Pragmatic Unit Testing book, authors discuss "FIRST Properties of Good Tests".
FIRST is an acronym for fast, isolated, repeatable, self-validating, and timely:

- **Fast**: 
Tests are the safety net of a developer. Whenever developers perform any maintenance
or evolution in the source code, they use the feedback of the test suite to understand
whether the system is still working as expected. 
The faster the feedback a developer gets from their test code, the better.
On the other hand, slower test suites force developers to simply run the tests less often,
making them less productive. Therefore, good tests are fast.

There is no hard line that separates slow from fast tests. Good sense is fundamental.
Once you are facing a slow test, you might consider:
	- Make use of mocks/stubs to replace slower components that are part of the test
	- Re-design the production code so that slower pieces of code can be tested separately from fast pieces of code
	- Move slower tests to a different test suite, one that developers might run less often. 
	It is not uncommon to see developers having sets of unit tests that run fast, and these they run all day long, and sets of slower integration and system tests that run once or twice a day in the Continuous Integration server. 

- **Isolated**: Tests should be as cohesive, as independent, and as isolated as possible. 
Ideally, a single test method should test just a single functionality or behavior of the system.
Having fat tests (or, as the test smells community calls it, an eager test) that tests
multiple functionalities are often complex in terms of implementation. Complex test code reduces
the ability of developers to understand what it tests in a glance, and makes future maintenance
harder. If you are facing such a test, break it into multiple smaller tests. Simpler and shorter
code is always better.

Moreover, tests should not depend on other tests to run. The result of a test should be the
same, whether the test is executed in isolation or together with the rest of the test suite.
It is not uncommon to see cases where some test B only works if test A is executed before.
This is often the case when test B relies on the work of test A to set up the environment
for it. Such tests become highly unreliable, as they might fail just because the
developer forgot about such a detail. In such cases, refactor the test code so that tests
are responsible for setting up all the environment they need. If tests A and B depend on
similar resources, make sure they can share the same code, so that you avoid duplicating
code. JUnit's `@BeforeEach` or `@BeforeAll` methods can become handy. Moreover, make sure
that your tests "clean up their messes", e.g., by deleting any possible files it created
on the disk, or cleaning up values it inserted in a database.


- **Repeatable**: A repeatable test is a test that gives the same result, no matter how many times it is executed.
Developers tend to lose their trust in tests that present a flaky behavior (i.e., it sometimes passes, and sometimes fails without any changes in the system and/or in the test code).
Flaky tests might happen for different reasons, and some of the causes can be tricky
to be identified (companies have reported extreme examples where a test presented a flaky behavior
only once in a month). Common causes are dependencies on external resources, not waiting
enough for an external resource to finish its task, and concurrency.


- **Self-validating**: 
The tests should validate/assert the result themselves. This might seem an unnecessary
principle to mention. However, it is not uncommon for developers to make mistakes and not writing
assertions in the test, making the test to always pass. In other more complex cases,
writing the assertions or, in other words, verifying the expected behavior, might not be possible.
In cases where observing the outcome of a behavior is not easily achievable, we suggest
the developer to refactor the class or method under test to increase its observability (revisit
our chapter on design for testability).


- **Timely**: 
Developers should be _test infected_. They should write and run tests as often
as possible. While less technical than the other principles in this list, changing
the behavior of development teams towards writing automated test code can still be challenging.

Leaving the test phase to the very end of the development process, as commonly done
in the past, might incur in
unnecessary costs. After all, at that point, the system might be simply hard to test.
Moreover, as we have seen, tests serve as a safety net to developers. Developing large
complex systems without such a net is highly unproductive and prone to fail.

{% set video_id = "5wLrj-cr9Cs" %}
{% include "/includes/youtube.md" %}


## Test Desiderata

Kent Beck, the "creator" of Test-Driven Development (and author of 
["Test-Driven Development: By Example"](https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530) book), recently wrote a list of eleven
properties that good tests have (the [test desiderata](https://medium.com/@kentbeck_7670/test-desiderata-94150638a4b3)). 

The following list comes directly from his blog post. Note how some of these principles
are also part of the FIRST principles.

* [Isolated](https://www.youtube.com/watch?v=HApI2cspQus): tests should return the same results regardless of the order in which they are run.
* [Composable](https://www.youtube.com/watch?v=Wf3WXYaMt8E): if tests are isolated, then I can run 1 or 10 or 100 or 1,000,000 and get the same results.
* [Fast](https://www.youtube.com/watch?v=L0dZ7MmW6xc): tests should run quickly.
* [Inspiring](https://www.youtube.com/watch?v=2Q1O8XBVbZQ): passing the tests should inspire confidence
* [Writable](https://www.youtube.com/watch?v=CAttTEUE9HM): tests should be cheap to write relative to the cost of the code being tested.
* [Readable](https://www.youtube.com/watch?v=bDaFPACTjj8): tests should be comprehensible for reader, invoking the motivation for writing this particular test.
* [Behavioral](https://www.youtube.com/watch?v=5LOdKDqdWYU): tests should be sensitive to changes in the behavior of the code under test. If the behavior changes, the test result should change.
* [Structure-insensitive](https://www.youtube.com/watch?v=bvRRbWbQwDU): tests should not change their result if the structure of the code changes.
* [Automated](https://www.youtube.com/watch?v=YQlmP08dj6g): tests should run without human intervention.
* [Specific](https://www.youtube.com/watch?v=8lTfrCtPPNE): if a test fails, the cause of the failure should be obvious.
* [Deterministic](https://www.youtube.com/watch?v=PwWyp-wpFiw): if nothing changes, the test result should not change.
* [Predictive](https://www.youtube.com/watch?v=7o5qxxx7SmI): if the tests all pass, then the code under test should be suitable for production.



## Test code smells

Now that we covered some best practices, let us look at the other
side of the coin: **test code smells**.

The term _code smell_ is a well-known term that indicates possible symptoms that might
indicate deeper problems in the source code of the system. 
Some very well-known examples are *Long Method*, *Long Class*, or *God Class*.
A good number of research papers show us that code smells hinder the comprehensibility and the maintainability of software systems.

While the term has been long applied to production code, given
the rise of test code, our community has been developing catalogues of smells that
are now specific to test code.
Research has also shown that test smells are prevalent in real life and, unsurprisingly, often negatively impact the maintenance and comprehensibility of the test suite.

In the following, we will discuss several of the well-known test smells. A more comprehensive
list can be found in the xUnit Test Patterns book, by Meszaros.


* **Code Duplication**: 
It is not surprising that code duplication might also happen in test code, 
as it is very common in production code.
Tests are often similar in structure. You might have noticed it in several of the code
examples throughout this book. We even made use of JUnit's Parameterized Tests feature
to reduce some of the duplication.
A less attentive developer might end up writing duplicated code 
(copying and pasting often happens in real life) instead of putting
some effort in implementing a better solution. 

Duplicated code might reduce the productivity of software testers.
After all, if there is a need for a change in a duplicated piece of code, a developer
will have to apply the same change over and over again, at all places where there is
a duplication. 
In practice, it is easy to skip one of these places, ending up with 
problematic test code.
Note that the effects are similar to the effects of code duplication in production code.

We suggest developers to ruthelessly refactor their test code. The extraction of a duplicated
code to private methods or external classes is often a good solution for the problem.

* **Assertion Roulette**:
Assertions are the first thing a developer looks at when a test is failing.
Assertions, thus, have to clearly communicate what is going wrong with the component
under test. 
The test smell emerges when developers have a hard time in figuring out the 
assertions themselves, or why they are failing.

There are several reasons for the smell to happen. Some features or business rules
are simply too complex and require a complex set of assertions to ensure their behavior.
Suddenly, developers end up writing complex assert instructions that are not easy to
understand. In such cases, we recommend developers to 1) write their own customized
assert instructions that abstract away part of the complexity of the assertion code itself,
2) when expressing it in code it not enough, write code comments that quickly explain, in natural language, what those assertions are about.

Interestingly, a common best practice that is often found in the test best practice literature 
is the "one assertion per method" strategy. While forcing developers to have just a single
assertion per test method is too extremist,  
the idea of minimizing, as much as possible, the amount of assertions in a test method is valid.

Note that a high number of simple assertions in a single test might be as harmful as a complex
set of assertions. In such cases, we provide a similar recommendation: write a customized
assertion instruction to abstract away the need for long sequences of assertions.

Empirically, we also observe that the number of assertions in a test is often large, because
developers tend to write more than one test case in a single test method. We also have done
that in this book (see the boundary testing chapter, where we test both sides of the boundary
in a single test method). However, parcimony is fundamental. Splitting up a large test method
that contains multiple test cases might reduce the cognitive load required by the developer
to understand it.


* **Resource Optimism**:
Resource optimism happens when a test assumes that a necessary resource (e.g., a database) is readily available at the start of its execution. This is related to the _isolated_ principle
of the FIRST principles and of Beck's test desiderata.

To avoid resource optimism, a test should not assume that the resource is already in the correct state. The test should be the one responsible for setting up the state itself. This might mean
the test is the one responsible for populating a database, for writing the required files in the disk, or for starting up a Tomcat server. (This set up might require complex code, and developers
should also do their best effort in abstracting way such complexity by, e.g., moving such 
code to other classes, e.g., `DatabaseInitialization` or `TomcatLoader`, allowing the
test code to focus on the test cases themselves).

Similarly, another incarnation of the resource optimism smell happens
when the test assumes that the resource is available all the time.
Suppose a test method that interacts with a webservice.
The webservice might be down for reasons we do not control.

To avoid this test smell, developers have two options:
First, to avoid using external resources, by using stubs and mocks.
However, if the test cannot avoid using the external dependency, make it robust enough.
In that case, make your test suite to skip that test when the resource is unavailable, and provide a message explaining why that was the case. This seems counterintuitive, but again, remember
that developers trust on their test suites. Having a single test failing for the wrong reasons
makes developers to lose their confidence in the entire test suite.

In addition to changing your tests, developers must make sure 
that the environments where the tests are executed have the required resources available.
Continuous integration tools like Jenkins, CircleCI, and Travis can help developers in 
making sure that tests are being run in the correct environment.











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

{% set video_id = "QE-L818PDjA" %}
{% include "/includes/youtube.md" %}

{% set video_id = "DLfeGM84bzg" %}
{% include "/includes/youtube.md" %}



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

{% set video_id = "-OQgBMSBL5c" %}
{% include "/includes/youtube.md" %}



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


* Finally we have a small tip for assertions.
When an assertions fails, a developer should be able to quickly see what is going wrong in order to fix the fault in the code.
If the assertion in your test is complex, you might want to express it in a different way. For example, you might create a helper that performs this assertion step by step, so that a developer can easily follow the idea. Or you might want to add an explanatory message to the assertion. Or, even, why not a code comment?
Frameworks like [AssertJ](https://joel-costigliola.github.io/assertj/) have become really popular among developers, due to its expresiveness in assertions.

{% hint style='working' %}
Example here of assertj
{% endhint %}


{% set video_id = "RlqLCUl2b0g" %}
{% include "/includes/youtube.md" %}



## Exercises

**Exercise 1.**
Jeanette just heard that two tests are behaving strangely: when executed in isolation, both of them pass. However, when executed together, they fail. Which one of the following **is not** cause for this?

1. Both tests are very slow.
1. They depend upon the same external resources.
1. The execution order of the tests matter.
1. They do not perform a clean-up operation after execution.


**Exercise 2.**
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


**Exercise 3.**
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





**Exercise 4.**
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



**Exercise 5.**
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



## References

- Chapter 5 of Pragmatic Unit Testing in Java 8 with Junit. Langr, Hunt, and Thomas. Pragmatic Programmers, 2015.
- Meszaros, G. (2007). xUnit test patterns: Refactoring test code. Pearson Education.
- Bavota, G., Qusef, A., Oliveto, R., De Lucia, A., & Binkley, D. (2012, September). An empirical analysis of the distribution of unit test smells and their impact on software maintenance. In 2012 28th IEEE International Conference on Software Maintenance (ICSM) (pp. 56-65). IEEE.
- Luo, Q., Hariri, F., Eloussi, L., & Marinov, D. (2014, November). An empirical analysis of flaky tests. In Proceedings of the 22nd ACM SIGSOFT International Symposium on Foundations of Software Engineering (pp. 643-653). ACM. 
- Bell, J., Legunsen, O., Hilton, M., Eloussi, L., Yung, T., & Marinov, D. (2018, May). D e F laker: automatically detecting flaky tests. In Proceedings of the 40th International Conference on Software Engineering (pp. 433-444). ACM. 
- Lam, W., Oei, R., Shi, A., Marinov, D., & Xie, T. (2019, April). iDFlakies: A Framework for Detecting and Partially Classifying Flaky Tests. In 2019 12th IEEE Conference on Software Testing, Validation and Verification (ICST) (pp. 312-322). IEEE. 
- Listfield, J. Where do our flaky tests come from?  
Link: https://testing.googleblog.com/2017/04/where-do-our-flaky-tests-come-from.html, 2017.
- Micco, J. Flaky tests at Google and How We Mitigate Them.  
Link: https://testing.googleblog.com/2016/05/flaky-tests-at-google-and-how-we.html, 2017.
- Fowler, M. Eradicating Non-Determinism in Tests. Link: https://martinfowler.com/articles/nonDeterminism.html, 2011.



