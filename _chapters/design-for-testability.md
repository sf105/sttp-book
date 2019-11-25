---
chapter-number: 8
title: Design for Testability
layout: chapter
toc: true
---

So far we have seen a lot of different ways of deriving tests.
We used specifications, models and even the source code itself to find proper test cases.
We use all these tests to find errors in the code and to then be able to fix these errors.
We have also seen that using just one of the methods is not enough to get a well tested system.

All the tests that we have looked at so are unit tests.
A unit test tests a small piece of code (usually one method) in isolation.
So a unit test exercises this small piece of code without any interaction with the rest of the system.
This untested interaction might give problems.
In this chapter we will go different levels of testing, some of these levels do exercise this interaction.

Additionally in this chapter we go over a concept widely used in testing: mocks.
The chapter covers the advantages and disadvantages of using mocks in your tests.
Finally we look at testability of code and a development process called Test-Driven-Development (TDD).

## Unit testing

Up to now, we used the testing strategies to derive tests that exercise a small part of the software.
This kind of testing is called unit testing.

In unit testing we create tests that test a small portion of the system in isolation.
Testing in isolation means that the test is executing code without using other parts of the software system.
It is just the piece of code under test that is executed.
The small portion of the system is what is usually called a unit.
Hence the term unit testing.

This unit can be just one method, but can also consist of multiple classes.
According to a definition of unit testing of Roy Osherove:
"A unit test is an automated piece of code that invokes a unit of work in the system.
And a unit of work can span a single method, a whole class or multiple classes working together to achieve one single logical purpose that can be verified."
So we are looking for tasks that the system performs that are as small as possible for unit tests.

To unit test our code we would then want our classes to operate indepedently.
Then we can test each class in isolation.
However, sometimes classes need other classes and we include these additional classes in the unit tests.
In software systems most classes are linked to other classes, which can make unit testing harder.
We will see how to deal with this later in the chapter.

As with any testing strategy, unit testing has advantages and disadvantages.
Firstly, one advantage of unit tests is the speed of execution.
One unit test usually takes just a couple of milliseconds to execute.
Fast tests give the ability to test huge portions of the system in a small amount of time.
Secondly, unit tests are easy to control.
A unit test tests the software by giving certain parameters to a method and then comparing the return value of a method to the expected result.
The parameters and expected result value are very easy to adapt in the test.
We have a lot of control on how the unit tests exercise the system.
Finally, unit tests are easy to write.
The JUnit test framework is a very nice and easy framework to write unit tests in.
It does not require a lot of setup or additional work to write the tests.

Of course, unit testing also has some disadvantages.
One of which is the reality of the unit tests.
A software system rarily exists of a single class or fulfills a single logical purpose.
The large amount of classes in a system and the interaction between these classes can make the system behave differently in its real application than in the unit tests.
Hence, the unit test do not perfectly represent the real execution of a software system.
Another disadvantage that follows from this is the existence of bugs that cannot be caught using unit tests.
Some of these bugs are in the different components of the system working together.
These bugs cannot be caught with unit testing, as unit tests only exercise the components separately in isolation.

## System testing

Unit tests do not exercise the system in a realistic way.
To get a more realistic way of testing we use system testing.
This is also called black-box testing.

Instead of testing small parts of the system in isolation, system tests execute the system as a whole.
The system is started up as it normally would and all its components, for example client, server and database, are used.
We call system testing also black-box testing, because the system is some sort of black box to the tests.
With system testing, we do not care or know what goes on inside of the system (the black box) as long as we get the expected output for a given input.

The obvious advantage of system testing is how realistic the test are.
The system executes as if it is being used in a normal setting.
This is good, because when testing software we want to verify that the system will act correctly.
The more realistic the tests are, the higher the chance of it actually working will be.
The system tests also capture the user's perspective more than unit tests do.
Faults that the system tests find, can then be fixed before the users would notice the failures that are caused by these faults.

Like other testing methods, system testing also has its downsides.
System tests are slow.
Compared to unit tests system tests are way slower.
Having to start and run the whole system, with all its components, takes time which is not needed when executing unit tests.
System tests are also harder to write.
Some of the components, for example databases, will take some setup before they can be used in a testing scenario.
This takes additional code that is needed just for automating the tests.
Lastly, system tests tend to become flaky.
Flaky tests mean that the tests might pass one time, but fail the other time.
Flakiness of a test can be caused by various factors, which we will discuss in a later chapter.

## Integration testing

Unit and system testing are two extremes of test levels.
Unit tests focus on the smallest parts of the system, while system tests focus on the whole system at once.
To get a bit of both we want to have a level in between.
Integration testing offers such a level between unit and system testing.

When a system has an external component, e.g. a database, a class will be created to interact with this component.
Now instead of all the system's components we just test this class and its interaction with the component it is made for.
This is called integration testing.

In integration testing we test multiple components of a system, but not the whole system altogether.
The tests focus on the interaction between two components of the system.
With this focus, the integration testing has some aspects of unit testing.

In essence integration testing is testing where you test one components interacting with another component.
This other component usually is an external one, for example the database or a web service.
The advantage of this approach is that the interactions between the components is exercised.
This was actually one of the main disadvantages of unit testing: It did not find errors in the interactions between components.

The disadvantage of integration testing compared to unit testing is that it is harder to write the tests.
First the external component needs to be running.
Then this component has to be in a state, which is useful for the tests.
This often includes creating data for the test in this external component.
After the test, the component is no longer needed so it has to be cleaned up.
This is extra work that is always needed for integration tests.

Integration testing is a very useful testing method.
However, due to its trade offs (extra setup that is needed) it is important to decide how much integration testing has to be done.

## The Testing Pyramid

We have seen three levels of tests: unit, system and integration.
It is time to see how to use these test levels together and when to switch from one to the other.

We do this by using the so-called testing pyramid.

[//]: TODO: center image
![Testing pyramid](/assets/img/chapter6/testing_pyramid.svg)

Here the size of the pyramid slice represent the amount of test we would want of each test level.
A new test level is manual, which is having users try the program and record how they are using the system.
Unit test is at the bottom of the pyramid, which means that we want most tests to be unit tests.
Reasons for this have been discussed in the unit testing section.
Then we get integration tests, of which we want to make less than unit tests, mostly because of the extra effort integration tests take to make and execute.
Lastly we move on to system and manual tests for similar reasons.

Additional to the amount of tests of a level we can see that the further up the pyramid the closer to reality the tests become.
However, also the more complex the creation and execution of the tests becomes.
These are very large factors in determining what kind of tests to create for testing a system.

We will now go over a couple of guidelines you can use to determine what level of tests to write when testing a system.
We start at the unit level.
When you have implemented a clear algorithm that you want to test, unit tests are the way to go.
With an algorithm the parameters are easily controllable so with unit test you can test the different cases your algorithm might encouter.

Then, whenever the system is interacting with an external componenet, e.g. a database or web service, you can start using integration testing.
For each of the external components that the system uses, integration tests should be created to test the interaction between the system and the external component.

System tests are very costly, so these are generally not used to test the entire system at once.
However, for parts of the system that are absolutely critical and can never stop working system tests are useful.
If it is so important to know if this part of the system will keep running, the reality of the system tests is important.

As the testing pyramid shows, the manual tests are not done a lot compared to the other testing levels.
The main reason is that manual testing, as the name suggets, cannot be automated.
It is mainly used to do exploratory testing, which is a user testing the system to find issues that could not be found any other way.

[//]: TODO: Add reference to blog post on Martin Fowler's Wiki

### Ice cream cone

What we see in practice is that instead of the testing pyramid people use the so-called ice cream cone.
This is the testing pyramid, but put upside down.

[//]: TODO: center image
![Ice cream cone](/assets/img/chapter6/ice_cream_cone.svg)

Here we see that just a few unit tests and a lot of system tests are made.
Moreover a lot of manual testing is used to test the system.
By now, we have seen a lot of advantages of automated testing, so this is not the best way to test a system.
Instead of the ice cream cone, try to focus on the testing pyramid.

## Mocks

When unit testing a piece of code we want to test this code in isolation.
If the code requires some external dependency to run, this forms a problem.
We do not want to use this external component when we are just testing the piece of code that uses it.
To run the test without using external components we use mock objects.

Mocking an object creates a simulation of this object.
To handle external dependencies we mock (simulate) the class in the system that is used to interact with the dependency.
Instead of doing the actual work of the external components mock objects just returns fake results.
These return values can be configured inside of the test itself.
For testing, mock objects have some advantages.
Returning these pre-configured values is way faster than accessing an external component.
Simulating objects also gives a lot more control.
If we, for example, want to make sure the system keeps going even if one of its dependencies crashes, we can just tell the simulation to crash.

Mock objects are widely used in software testing, mainly to increase testability.
As we have discussed, external systems that the tested system relies on are often mocked.
These external systems include for example databases or webservices that are used by the system.
Mocks are also used to simulate exceptions that are hard to trigger in the actual system.
When using third party libraries that are hard to control we use mocks to simulate their behavior in certain ways that are useful to the tests.

Besides using mocks to simulate the behavior of components needed to run the system, mocks can be used to test the interaction of the system with a component easily.
This way we use mocks to increase the observability, i.e. we can observe the system's behavior easier.
Simulating behavior of components like we discussed earlier is using mocks to increase the controllability.

To use mocks in our tests we create a mock object.
Then, once it has been created, we give it to the class that normally uses an actual implementation of the mocked object.
This class is now using the mocked object while the tests are executed.
At first, the mock does not know how to do anything.
So, before running the tests, we have to tell it exactly what to do when a certain method is called.
In the next section we will look at how this is done in Java.

## Mockito

In Java the most used framework for mocking is Mockito ([mockito.org](https://site.mockito.org)).
To perform the steps we mentioned above we use a couple of methods provided by mockito:

- `mock(<class>)`: creates a mock object of the given runtime class. The runtime class can be retrieved from any class by `<ClassName>.class`.
- `when(<mock>.<method>).thenReturn(<value>)`: defines the behavior when the given method is called on the mock. In this case `<value>` will be returned.
- `verify(<mock>).<method>`: is a test that passes when the method is called on the mock and fails otherwise.

Much more functionalities are described in [mockito's documentation](https://javadoc.io/page/org.mockito/mockito-core/latest/org/mockito/Mockito.html).

{% include example-begin.html %}
Suppose we have a function that filters invoices.
These invoices are saved in a database and retrieved from the database by this function.
The invoices are filtered on their price.
All those above 100 are filtered.
Without mocks, to test the method we need to insert some testing invoices first:

```java
@Test
public void filterInvoicesTest() {
  InvoiceDao dao = new InvoiceDao();
  Invoice i1 = new Invoice("M", 20.0);
  Invoice i2 = new Invoice("A", 300.0);
  dao.save(i1);
  dao.save(i2);

  InvoiceFilter f = new InvoiceFilter(dao);
  List<Invoice> result = f.filter();

  assertEquals(1, result.size());
  assertEquals(i1, results.get(0));
  dao.close();
}
```

Now instead of using the database, we want to replace it with a mock object.
This way our test will be faster and we can more easily control what the Database-Access-Object returns.

```java
@Test
public void filterInvoicesTest() {
  InvoiceDao dao = mock(InvoiceDao.class);
  Invoice i1 = new Invoice("M", 20.0);
  Invoice i2 = new Invoice("A", 300.0);

  List<Invoice> list = Arrays.asList(i1, i2);
  when(dao.all()).thenReturn(list);

  InvoiceFilter f = new InvoiceFilter(dao);
  List<Invoice> result = f.filter();

  assertEquals(1, result.size());
  assertEquals(i1, results.get(0));
}
```

The InvoiceFilter uses the `all` method in the `InvoiceDao` to get the invoices.
With the mock we can easily give the two invoices that we want to test on.
Using this mock also makes sure we do not have to keep a database running while executing the tests.
{% include example-end.html %}

## Testability

Now that we know how to use mocks and what we can use them for it is time to take another look at the production code.
In the Mockito example it was very easy to make sure that the `InvoiceFilter` uses our mock instead of a normal instance of the class.
This is not always the case and we have to design our code in a way that it is easy to test the code.
Up to now we mostly need to make sure that our code can use mocks instead of actual instances.
After that we will look at some more ways to keep our code testable.

The testability of code indicates how easily the code can be tested in an automated way.
We have seen that automated tests are crucial in software development so it is essential that our code is testable.
Therefore code that is more testable is usually better code and it is very important to think about the testability while designing the system.
If the testability is only thought about when testing the code, a lot of it will have to be rewritten.

There are no ways with which we can determine the testability exactly, but we can use some methods to increase the overall testability.
In this section we will go over a couple of these methods.
By applying the methods while designing the code the program can be a lot easier to test.

### Dependency Injection

Dependency injection is one of the concepts we can use to make our code testable.
We will illustrate it by an analogy:

Say we need a hammer to perform a certain task.
When we are asked to do this task, we could go search and find the hammer.
Then once we have the hammer we can use it to perform the task.
However, another approach is to say that we need a hammer when it is asked to perform the task.
This way instead of getting the hammer ourselves we get it from the person that wants us to do the task.

We can do the same with dependencies in our code.
Instead of asking for a hammer we would be asking for an instance of a certain class by a parameter.
The example shows what this looks like in java.

{% include example-begin.html %}
In the Mockito example it was easy to make the `InvoiveFilter` use the mock.
Let's assume now that the `InvoiveFilter` is implemented as follows:

```java
public class InvoiceFilter {

  public void filter() {
    InvoiceDao dao = new InvoiceDao();

    // ...
  }

}
```

Now there is no way to give the mock to the `InvoiceFilter` and it will use the actual `InvoiceDao` in the tests.
As we cannot control the way the `InvoiceDao` operates, this makes it a lot harder to write automated tests.

Instead of writing the above, we can use dependency injection in our design:

```java
public class InvoiceFilter {

  private InvoiceDao invoiceDao;

  public InvoiceFilter(InvoiceDao invoiceDao) {
    this.invoiceDao = invoiceDao;
  }

  public void filter() {
    // ...
  }
}
```

Now we can create the `InvoiceFilter` with a mock in the automated tests and create it with the real `InvoiceDao` when the program is run normally.
This makes creating the tests easier and increases the testability of the code.
{% include example-end.html %}

Making the dependencies explicit like in the example and passing them through parameters is called dependency injection.
It makes the design of the class explicit and we can give whatever we want to the constructor.
Besides increasing the testability of the code it also makes the class more extensible.
If we ever want to change an object that is needed we just pass the new one.
This is also called the open/closed principle.
We will not go into detail of this principle.

In general try to make sure that dependencies can always be injected to the class.
This will make writing automated tests way easier.

### Ports and Adapters

The way a software system is designed influences how easy it is to test the system.
The idea of designing a system in a way that it is testable is called design for testability.
It is important that a software developer knows about certain ways to design for testability in order to implement systems well.
We will discuss a concept that is used in design for testability.

In general, design for testability comes down to separating the domain and the infrastructure of the systems.
Here the domain is the core of the system: The business rules, logic, and entities and relations of the system.
This is very specific to the system that is being build.
A system often makes use of a database or web-service.
These are part of the infrastructure: the code that talks to the database/web-service and connects them to the core system itself.
To design our system for testability we want to separate these as much as possible.
When the domain and infrastructure are being mixed together the system will be much harder to test.

To separate the domain and the infrastructure we can use Ports and Adapters, as named by Alistair Cockburn.
This is also called the Hexagonal Architecture.
With Ports and Adapters the domain (business logic) depends on Ports rather than directly on the infrastructure.
When programming these ports are just interfaces that define what the infrastructure is able to do.
These ports are completely separated from the implementation of the infrastructure.
In the schema below you can see that the ports are therefore part of the domain.

![Hexagonal Architecture](/assets/img/chapter6/hexagonal_architecture.svg)

The adapters are part of the infrastructure.
These are the implementations of the ports that talk to the database or webservice etc.
These Ports and Adapters help a lot with the testability of our code.
When a class depends on one of the ports we can easily mock the port and run our tests.

We call separating the domain and infrastructure in a system Domain-Driven Design.
The advantage of this design is not only the testability but also maintainability and evolvability.
In this design the domain is the most important part of the system.

### Practical Tips

We end this section with a couple of practical tips that you can use to create a well designed, testable software system.

- **Cohesion**: Cohesive classes are classes that do only one thing and are easy to test. If a class is not cohesive, but has a lot of responsibilities, you can split the class into multiple small cohesive classes. This way you can test each separate class more easily.
- **Coupling**: Coupling represents the amount of classes that a class depends on, i.e. a highly coupled class needs a lot of other classes to work. Coupling hurts testability. Imagine having to create ten mocks, define the behavior of these ten mocks and so forth to test just one class. To reduce coupling you can group some of the dependencies together and create bigger abstractions.
- **Complex Conditions**: When a condition is very large we like to split it into multiple conditions. Testing these simpler conditions is easier than testing one very complex condition.
- **Private methods**: A common question is whether to test private methods or not. The answer is usually no. In principal we like to test the private methods through the public methods that use them. This means that we test if the public method behaves correctly, not the private method. If you feel like you want to test the private method in isolation (because it might be a very large important method) this means that the method should probably have its own separate class. So then to test the private method you will have to refactor the code.
- **Static metods**: Static methods can hurt testability, as we cannot control the behavior of the static methods. Therefore we like to avoid using static methods where possible.
- **Layers**: When using other's code or external dependencies we like to create classes that facilitate between our own code and the other code. This makes the dependencies sort of fit our system. Do not be afraid to create these extra layers. They often increase the testability of the system.
- **Infrastructure**: Again, make sure not to mix the infrastructure with the domain. You can use the methods we discussed above.
- **Encapsulation**: Encapsulation is about bringing the behavior of a class close to the data. Encapsulation will help you identify the problems in the code easier.

## Test-Driven Development

Usually in software development we write some production code and once we are finished with a part of the system we move to writing the tests.
One disadvantage of this approach is that we might create the tests much later than the code.
After a long time we might not fully remember how the program we wrote works and then we cannot make good test cases.
With Test-Driven Development (TDD) we create the tests before we write the code.

We do this by first thinking about the test.
Then we write the test.
This test will fail, because we have not written the code yet.
Now that we have a failing test, we write code that makes the test pass.

We do all of this in the simplest way we can.
This simplicity means that we create the simplest implementation that solves the problem and we start with the simplest possible test case.
This way we can build the code by very small pieces.
Of course this is not always needed.
We can take larger steps, but when it becomes complicated it is important that we are able to take these small steps.

After we wrote the code that makes the test pass it is time to refactor the code we just made.
With refactoring we should not just focus on the production code, but also the way we wrote the test.
This refactoring can be done at a low level or a high level.
Low-level are changes like variable names, extracting methods from one another etc.
High-level is changing the structure of (part of) the system.
This is, for example, changing the class design or changing the way the classes work together.
The nice thing about refactoring is that is should not change the behavior of the code.
So, if the test passes before refactoring, it should also pass after refactoring.

The TDD cycle is illustrated in the diagram below.

![Test Driven Development Cycle](/assets/img/chapter6/tdd_cycle.svg)

Test driven development has some advantages.
By creating the test first, we also look at the requirements first.
This makes us write the code for the specific problem that it is supposed to solve.
In its turn, this prevents us from writing useless, unnecessary code.

We can control our pace of writing the production code.
Once we have a failing test, our goal is clear: To make the test pass.
With the test that we create, we can control the pace in which we write the production code.
If we are confident in how to solve the problem, we can make a big step by creating a complicated test.
However, if we are not sure how to tackle the problem, we can break it into small parts and start with the simpler pieces first by creating tests for those pieces.

The tests are derived from the requirements.
Therefore, we know that, when the tests pass, the code does what it is supposed to do.
When writing tests from the source code instead, the tests might pass while the code is not doing the right thing.
The tests also show us how easy it is to use the class we just made.
We are using the class directly in the tests so we know immediately when we can improve something.

Related to the previous point is the way we design the code when using TDD.
Creating the tests first makes us think about the way to test the classes before implementing them.
It changes the way we design the code.
This is why Test Driven Development is sometimes also called Test Driven Design.
Thinking about this design earlier is also better, because it is easier to change the design of a class early on.
You probably have to change less if you just start with a class than when the class is utilized by other parts of the system.

Writing tests first gives faster feedback on the code that we are writing.
Instead of writing a lot of code and then a lot of tests, i.e. getting a lot of feedback at once after a long period of time, we create a test and then write a small piece of code for that test.
Now we get feedback after each test that we write, which is usually after a piece of code that is much smaller than the pieces of code we test at once in the traditional approach.
Whenever we have a problem it will be easier to identify it, as the added code is smaller.
Moreover if we do not like anything it is easier to improve the code.

We already talked about the importance of controllability when creating automated tests.
By thinking about the tests before implementing the code we automatically make sure that the code is easy to control.
This improves the code quality as it will be easier to test the controllable code.

Finally, the tests that we write can indicate some problems in the code.
Too many tests for just one class can indicate that the class has too many functionalities and that it should be split up into more classes.
If we need too many mocks inside of the tests the class might be too coupled, i.e. it needs too many other classes to function.
If it is very complex to set everything up for the test, we may have to think about the pre-conditions that the class uses.
Maybe there are too many or maybe some are not necessary.

With all these advantages TDD sounds great.
So it looks like we should always use it from now on.
Unfortunately, as with a lot of testing strategies, there is not a universal answer.
Some argue that TDD does not really make a difference in the code quality and that the advantages are not as apparant as they should be.
In practice, developers do not use TDD 100% of the time.
Doing testing at all is more important than following TDD.
That being said, it is important to know about TDD and its advantages.
It is very good to try TDD and see where it is beneficial to software development.

## Exercises

Below you will find a couple of exercises to practise with the material covered in this chapter.
After each exercise you can find the answer to the question.

The first couple of exercises use the following requirement and corresponding implementation.

```text
A webshop runs a batch job, once a day, to deliver all orders that
have been paid. It also sets the delivery date, according to whether
the order is from a customer abroad.

Note: A batch job is a computer program that executes a (often huge) sequence of commands.
For example, processing all the orders that were made in a day.
```

```java
public class OrderDeliveryBatch {

  public void runBatch() {

    OrderDao dao = new OrderDao();
    DeliveryStartProcess delivery = new DeliveryStartProcess();

    List<Order> orders = dao.paidButNotDelivered();

    for (Order order : orders) {
      delivery.start(order);

      if (order.isInternational()) {
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
How can we improve the testability of the `OrderDeliveryBatch` class?

What technique can we apply?

What would the new implementation look like?

Think about what you would need to do to test the `OrderDeliveryBatch` class.
{% include answer-begin.html %}
To test just the `runBatch` method of `OrderDeliveryBatch` (for example in a unit test) we need to be able to use mocks for at least the `dao` and `delivery` objects.
In the current implementation this is not possible, as we cannot change `dao` or `delivery` from outside.
In other words: We want to improve the controllability to improve the testability.

The technique that we use to do so is called dependency injection.
We can give the `dao` and `delivery` in a parameter of the method:

```java
public class OrderDeliveryBatch {

  public void runBatch(OrderDao dao, DeliveryStartProcess delivery) {
    List<Order> orders = dao.paidButNotDelivered();

    for (Order order : orders) {
      delivery.start(order);

      if (order.isInternational()) {
        order.setDeliveryDate("5 days from now");
      } else {
        order.setDeliveryDate("2 days from now");
      }
    }
  }
}
```

Alternatively we can create fields for the `dao` and `delivery` and a constructor that sets the fields:

```java
public class OrderDeliveryBatch {

  private OrderDao dao;
  private DeliveryStartProcess delivery;

  public OrderDeliveryBatch(OrderDao dao, DeliveryStartProcess delivery) {
    this.dao = dao;
    this.delivery = delivery;
  }

  public void runBatch() {
    List<Order> orders = dao.paidButNotDelivered();

    for (Order order : orders) {
      delivery.start(order);

      if (order.isInternational()) {
        order.setDeliveryDate("5 days from now");
      } else {
        order.setDeliveryDate("2 days from now");
      }
    }
  }
}
```

{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
Which of the following Mockito lines would never appear in a test for the `OrderDeliveryBatch` class?

1. `OrderDao dao = Mockito.mock(OrderDao.class);`
2. `Mockito.verify(delivery).start(order);` (assume `order` is an instance of `Order`)
3. `Mockito.when(dao.paidButNotDelivered()).thenReturn(list);` (assume `dao` is an instance of `OrderDao` and `list` is an instance of `List<Order>`)
4. `OrderDeliveryBatch batch = Mockito.mock(OrderDeliveryBatch.class);`

{% include answer-begin.html %}
The correct answer is 4.

1. This line is required to create a mock for the `OrderDao` class.
2. With this line we check that the methods calls start with `order` on a `delivery` mock we defined. The method is supposed to start each order that is paid but not delivered.
3. With this line we define the behavior of the `paidButNotDelivered` method by telling the mock that it should return an earlier defined `list`.
4. We would never see this happen in a test that is testing the `OrderDeliveryBatch` class. By mocking the class we do not use any of its implementation. But the implementation is the exact thing we want to test. In general we never mock the class under test.

{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
Consider the following requirement and implementation.

```text
A webshop gives a discount of 15% whenever it's King's Day.
```

```java
public class KingsDayDiscount {

  public double discount(double value) {

    Calendar today = Calendar.getInstance();

    boolean isKingsDay = today.get(MONTH) == Calendar.APRIL
        && today.get(DAY_OF_MONTH) == 27;

    return isKingsDay ? value * 0.15 : 0;

  }
}
```

We want to create a unit test for this class.

Why does this class have bad testability?
What can we do to improve the testability?

I.e. what makes it very hard to test the method?
{% include answer-begin.html %}
The method and class lack controllability.
We cannot change the values that `Calender` gives in the method because the `getInstance` method is static.
Mockito cannot really mock static methods, which is why we tend to avoid using static methods.

We can use depencency injection to make sure we can control the `today` object by using a mock.
{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
We have the following skeleton for a diagram illustrating the Test Driven Development cycle.
What words/sentences should be at the numbers?

![Test Driven Development exercise skeleton](/assets/img/chapter6/exercises/tdd_skeleton.svg)

(Try to answer the question without scrolling up!)
{% include answer-begin.html %}

1. Write failing test
2. Failing test
3. Make test pass
4. Passing test
5. Refactor

From the explanation above:

![Test Driven Development Cycle](/assets/img/chapter6/tdd_cycle.svg)

{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
Now we have a skeleton for the testing pyramid.
What words/sentences should be at the numbers?

![Testing Pyramid exercise skeleton](/assets/img/chapter6/exercises/pyramid_skeleton.svg)

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
Sarah just joined a mobile app team that has been trying to write automated tests for a while.
The team wants to write unit tests for some part of their code, but "that's really hard", according to the developers.

After some code review, the developers themselves listed the following
problems in their codebase:

1. May classes mix infrastructure and business rules
2. The database has large tables and no indexes
3. Use of static methods
4. Some classes have too many attributes/fields

To increase the testability, the team has budget to work on two out of the four issues above.
Which items shouls Sarah recommend them to tackle first?

Note: All of the four issues should obviously be fixed.
However, try to prioritize the two most important onces: Which influence the testability the most?
{% include answer-begin.html %}
The correct answer is 1 and 3.

As we discussed it is very important to keep the domain and infrastructure separated for the testability.
This can be done, for example, by using Ports and Adapters.

Static methods cannot be mocked and are therefore very bad for the controllability of the code.
Code that has low controllability also has a low testability, so replacing the static methods by non-static ones will be very beneficial to the testability.

The large tables and lack of indices do not really influence the testability, especially not when talking about unit tests.
There we end up mocking the classes interacting with the database anyway.

Too many attributes/fields can hurt testability as we might need to create a lot of mocks for just one class under test.
However, the static methods and mixed domain and infrastructure are worse for the testability than a large amount of attributes/fields.
{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
Observability and controllability are two important concepts when it comes to software testing.
The three developers below could benefit from improving either the observability or the controllability of the system/class under test.

1. "I can't really assert that the method under test worked well."
2. "I need to make sure this class starts with that boolean set to false, but I simply can't do it."
3. "I just instantiated the mock object, but there's simply no way to inject it in the class."

For each developer's problem, is it related to observability or controllability?
{% include answer-begin.html %}

1. Observability: The developer needs to be able to better observe the result.
2. Controllability: The developer has to be able to change (control) a certain variable or field.
3. Controllability: The developer should be able to control what instance of a class the class under test uses.

{% include exercise-answer-end.html %}
