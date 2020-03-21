---
chapter-number: 8
title: The Testing Pyramid
layout: chapter
toc: true
author: Maurício Aniche
---

We have studied different techniques to derive test cases. More specifically, 
specification-based, structural-based, and model-based techniques.
However, most of requirements we tested via specification-based techniques had a single responsibility. Most of the source code
we tested via structural-based techniques fit in a single unit/class.
A large software system, however, is composed of many of those units/responsibilities. Together, they compose
the complex behavior of our software system. In this chapter, we are going to discuss 
the different **test levels** (i.e., unit, integration, and system), their advantages and disadvantages.

## Unit testing

In some situatins, our goal is indeed to test a single feature of the software, "purposefully ignoring the other units of the systems".
Like we have been done so far. When we test units in isolation, we are doing what we call **unit testing**.

Defining what a 'unit' is, is challenging and highly dependent on the context.
A unit can be just one method, or can consist of multiple classes.
According to Roy Osherove's unit testing definition:
_"A unit test is an automated piece of code that invokes a unit of work in the system.
And a unit of work can span a single method, a whole class or multiple classes working together to achieve one single logical purpose that can be verified."_

As with any testing strategy, unit testing has advantages and disadvantages:

* Firstly, one advantage of unit tests is its speed of execution.
A unit test usually takes just a couple of milliseconds to execute.
Fast tests give us the ability to test huge portions of the system in a small amount of time.
* Secondly, unit tests are easy to control.
We have a high degree of control on how the unit tests exercise the system.
A unit test tests the software by giving certain parameters to a method and then comparing the return value of a method to the expected result.
The parameters and expected result values are very easy to be adapted/modified in the test.
* Finally, unit tests are easy to write.
The JUnit test framework is a very nice and easy framework to write unit tests in.
It does not require a lot of setup or additional work to write the tests.

Of course, unit testing also has some disadvantages:

* One of which is the reality of the unit tests.
A software system is rarely composed of a single class or fulfills a single logical purpose.
The large amount of classes in a system and the interaction between these classes can make the system behave differently in its real application than in the unit tests.
Hence, the unit test do not perfectly represent the real execution of a software system.
* Another disadvantage that follows from this is that some bugs simply cannot be caught by means of unit tests. They happen only in the integration of the different components (which we are not exercising in a pure unit test).

## System testing

Unit tests indeed do not exercise the system in a realistic way.
To get a more realistic view of the software, we should run it in its entirely. All the components, databases, front end, etc,
running together. And then devise tests. 

When do it, we are doing what we call **system testing**.
In practice, instead of testing small parts of the system in isolation, system tests execute the system as a whole.
Note that we can also call system testing as **black-box testing**, because the system is some sort of black box to the tests.
We do not care or actually know what goes on inside of the system (the black box) as long as we get the expected output for a given input.

What are the advantages of system testing?
The obvious advantage of system testing is how realistic the test are.
The system executes as if it is being used in a normal setting.
This is good. After all,
the more realistic the tests are, the higher the chance of it actually working will be.
The system tests also capture the user's perspective more than unit tests do.
Faults that the system tests find, can then be fixed before the users would notice the failures that are caused by these faults.

However, system testing also has its downsides.
System tests are often slow when compared to unit tests.
Having to start and run the whole system, with all its components, takes time.
System tests are also harder to write.
Some of the components, e.g., databases, require complex setup before they can be used in a testing scenario.
This takes additional code that is needed just for automating the tests.
Lastly, system tests tend to become flaky.
Flaky tests mean that the tests might pass one time, but fail the other time.


<iframe width="560" height="315" src="https://www.youtube.com/embed/5q_ZjIM_9PQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Integration testing

Unit and system testing are the two extremes of test levels.
Unit tests focus on the smallest parts of the system, while system tests focus on the whole system at once.
However, sometimes we want something in between.
**Integration testing** offers such a level between unit and system testing.

Let's look at a real example.
When a system has an external component, e.g., a database, developers often create a class whose only responsibility is to interact 
with this external component.
Now, instead of testing all the system's components, we just want test this class and its interaction with the component it is made for.
One class, one (often external) component. This is integration testing.

In integration testing, we test multiple components of a system, but not the whole system altogether.
The tests focus on the interaction between these few components of the system.

The advantage of this approach is that, while not fully isolated, devising tests just for a specific integration 
is easier than devising tests for all the components together. Because of that, the effort of writing such tests
is a bit higher than when compared to unit tests (and lower when compared to system tests). 
Setting up the external component, e.g., the database, to the 
state the tester wants, requires effort. 

Can we fully replace system testing with integration testing? After all, it is more real than unit tests and less expensive
than system tests. Well... No. Some bugs are really tricky and might only happen in specific sitations where multiple
components are working together. There is no silver bullet.

<iframe width="560" height="315" src="https://www.youtube.com/embed/MPjQXVYqadQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## The Testing Pyramid

We discussed three levels of tests: unit, system, and integration. How much should we do of each?
A famous diagram that help us in discussion is the so-called **testing pyramid**.

![Testing pyramid](/assets/img/testing-pyramid/testing_pyramid.svg)

The diagram indicates all the test levels we discussed, plus *manual testing*. The more you go to the top, the more
real the test is; however, the more complex it is to devise it.

How much should we do of each then? The common practice in industry is also represented in the diagram. The size of the pyramid slice represents the the amount of test we would want of each test level. 
Unit test is at the bottom of the pyramid, which means that we want most tests to be unit tests.
The reasons for this have been discussed in the unit testing section (they are fast and require less effort to be written).
Then, we go for integration tests, of which we do a bit less than unit tests. Given the extra effort that integration tests require,
we make sure to write tests for the integrations we indeed need.
Lastly, we perform a bit less system tests, and even less manual tests.

Again, note that the further up the pyramid, the closer to reality (and more complex) the tests become.
These are important factors in determining what kind of tests to create for a given software system.
We will now go over a couple of guidelines you can use to determine what level of tests to write when testing a system (which you should take with a grain of salt; after all, software systems are different from each other, and might require specific guidelines):

* We start at the unit level.
When you have implemented a clear algorithm that you want to test, unit tests are the way to go.
In an algorithmic piece of code, the parameters are easily controllable, so with unit test you can test the different cases your algorithm might encounter.

* Then, whenever the system is interacting with an external component, e.g. a database or a web service, integration testing is the way to go.
For each of the external components that the system uses, integration tests should be created to test the interaction between the system and the external component.

* System tests are very costly, so often we do not test the entire system with it.
However, the absolutely critical parts of the system (the ones that should never, ever, stop working), system tests are fundamental.

* As the testing pyramid shows, the manual tests are not done a lot compared to the other testing levels.
The main reason is that manual testing is expensive.
Manual testing is mainly used for exploratory testing. In practice, exploratory testing helps testers in finding issues that could not be found any other way.

Something you should definitely try to avoid is the so-called *ice cream cone*.
The cone is the testing pyramid, but put upside down.

![Ice cream cone](/assets/img/testing-pyramid/ice_cream_cone.svg)

It is common to see teams mostly relying on manual tests. Whenever they have system tests, it is not because they believe on the power
of system tests, but because the system was so badly designed, that unit and integration tests are just impossible to be automated.
We will discuss design for testability in future chapters.

<iframe width="560" height="315" src="https://www.youtube.com/embed/YpKxAicxasU" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## An academic remark on the testing pyramid

{% assign todo = "to be written" %}
{% include todo.html %}

## References

* Chapter 2 of the Foundations of software testing: ISTQB certification. Graham, Dorothy, Erik Van Veenendaal, and Isabel Evans, Cengage Learning EMEA, 2008.

* Vocke, Ham. The Practical Test Pyramid (2018), https://martinfowler.com/articles/practical-test-pyramid.html.

* Fowler, Martin. TestingPyramid (2012). https://martinfowler.com/bliki/TestPyramid.html

## Exercises


{% include exercise-begin.html %}
Now we have a skeleton for the testing pyramid.
What words/sentences should be at the numbers?

![Testing Pyramid exercise skeleton](/assets/img/testing-pyramid/exercises/pyramid_skeleton.svg)

(Try to answer the question without scrolling up!)
{% include answer-begin.html %}

1. Manual
2. System
3. Integration
4. Unit
5. More reality (interchangeable with 6)
6. More complexity (interchangeable ith 5)

See the diagram in the Testing Pyramid section.
{% include exercise-answer-end.html %}




{% include exercise-begin.html %}
As a tester, you have to decide which test level (i.e., unit, integration, or system test) you will apply.
Which of the following statements is true?

1. Integration tests, although more complicated (in terms of automation) than unit tests, would better help in finding bugs in the communication with the webservice and/or the communication with the database.
2. Given that unit tests could be easily written (by using mocks) and they would cover as much as integration tests would, it is the best choice in this problem.
3. The most effective way to find bugs in this code is through system tests. In this case, the tester should run the entire system and exercise the batch process. Given that this code can be easily mocked, system tests would also be cheap.
4. While all the test levels can be used for this problem, testers would likely find more bugs if they choose one level and explore all the possibilities and corner cases there.

{% include answer-begin.html %}
The correct answer is 1.

1. This is correct. The primary use of integration tests is to find mistakes in the communication between a system and its external dependencies
2. Unit tests do not cover as much as integration tests. They cannot cover the communication between different components of the system.
3. When using system tests the bugs will not be easy to identify and find, because it can be anywhere in the system if the test fails. Additionally, system tests want to execute the whole system as if it is run normally, so we cannot just mock the code in a system test.
4. The different test levels do not find the same kind of bugs, so settling down on one of the levels is not a good idea.

{% include exercise-answer-end.html %}




{% include exercise-begin.html %}
The tester should now write an integration test for the `OrderDao` class below.

```java
public class OrderDeliveryBatch {

  public void runBatch() {

    OrderDao dao = new OrderDao();
    DeliveryStartProcess delivery = new DeliveryStartProcess();

    List<Order> orders = dao.paidButNotDelivered();

    for(Order order : orders) {
      delivery.start(order);

      if(order.isInternational()) {
        order.setDeliveryDate("5 days from now");
      } else {
        order.setDeliveryDate("2 days from now");
      }
    }
  }
}

class OrderDao {
  // accesses a database
}

class DeliveryStartProcess {
  // communicates with a third-party webservice
}
```

Which one of the following statements **is not required** when writing
an integration test for this class?

1. Reset the database state before each test.
2. Apply the correct schema to the database under test.
3. Assert that any database constraints are met.
4. Set the transaction autocommit to true.

{% include answer-begin.html %}
Option 4 is not required.

Changing the transaction level is not really required. Better would be to actually exercise the transaction policy your application uses in production.

{% include exercise-answer-end.html %}


{% include exercise-begin.html %}

A newly developed product started off with some basic unit tests but later on decided to only add integration tests and system tests for the new code that was written. This was because a user interacts with the system as a whole and therefore these types of tests were considered more valuable. Thus, unit tests became less prevalent, whereby integration tests and system tests became a more crucial part of the test suite. This transition can be described as:

1. Transitioning from a testing pyramid to an ice-cream cone pattern
2. Transitioning from an ice-cream cone anti-pattern to a testing pyramid
3. Transitioning form an ice-cream cone pattern to a testing pyramid
4. Transitioning from a testing pyramid to an ice-cream cone anti-pattern


{% include answer-begin.html %}
Correct answer: Transitioning from a testing pyramid to an ice-cream cone anti-pattern
{% include exercise-answer-end.html %}





{% include exercise-begin.html %}


TU Delft just built an in-house software to control the payroll of its employees. The applications makes use of Java web technologies and stores data in a Postgres database. Clearly, the application frequently retrieves, modifies, and inserts large amounts of data into the database. All this communication is made by Java classes that send (complex) SQL queries to the database. 

As testers, we know that a bug can be anywhere, including in the SQL queries themselves. We also know that there are many ways to exercise our system. Which one of the following **is not** a good option to detect in the SQL queries?
  
1. Unit testing.
1. Integration testing.
1. System testing.
1. Stress testing.


{% include answer-begin.html %}
Unit testing.
{% include exercise-answer-end.html %}






{% include exercise-begin.html %}

Choosing the level of a test is a matter of a trade-off. After all, each 
test level has advantages and disadvantages.
Which one of the following is the **main advantage** of a test at system level?


1. The interaction with the system is much closer to reality.
1. In a continuous integration environment, system tests provide real feedback to developers.
1. Given that system tests are never flaky, they provide developers with more stable feedback.
1. A system test is written by product owners, making it closer to reality.


{% include answer-begin.html %}

The interaction with the system is much closer to reality.

{% include exercise-answer-end.html %}




{% include exercise-begin.html %}

What is the main reason for the number of recommended system tests in the testing pyramid to be smaller than the number of unit tests?


1. Unit tests are as good as system tests.
1. System tests do not provide developers with enough quality feedback.
1. There are no good tools for system tests.
1. System tests tend to be slow and often are non-deterministic.

{% include answer-begin.html %}

System tests tend to be slow and often are non-deterministic.
See https://martinfowler.com/bliki/TestPyramid.html!

{% include exercise-answer-end.html %}




