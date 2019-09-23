---
chapter-number: 6
title: Testability, Mocks, and TDD
layout: chapter
---

So far we have seen a lot of different ways of deriving tests.
We used specifications, models and even the source code itself to find proper test cases.
We use all these tests to find errors in the code and to then be able to fix these errors.
We have also seen that using just one of the methods is not enough to get a well tested system.

All the tests that we have looked at so are unit tests.
A unit test tests a small piece of code (usually one method) in isolation.
So a unit tests exercise this small piece of code without any interaction with the rest of the system.
This untested interaction might give problems.
In this chapter we will go different levels of testing, some of which do exercise this interaction.

Additionally in this chapter we go over a concept widely used in testing: mocks.
The chapter covers the advantages and disadvantages of using mocks in your tests.
Finally we look at testability of code and the development process called Test-Driven-Development (TDD).

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
Firstly, one advantage of unit test is the speed of execution.
One unit test usually takes just a couple of milliseconds to execute.
Fast tests give the ability to test huge portions of the system fast.
Secondly, unit test are easy to control.
A unit test tests the software by giving certain parameters to a method and then comparing the return value of a method to the expected result.
The parameters and expected result value are very easy to adapt in the test.
We have a lot of control on how the unit tests exercises the system.
Finally, unit tests are easy to write.
The jUnit test framework is a very nice and easy framework to write unit tests in.
It does not require a lot of setup or additional work to write the tests.

Of course, unit testing also has some disadvantages.
One of which is the reality of the unit tests.
A software system rarily exists of a single class or fulfills a single logical purpose.
By using a lot more classes than a single unit tests exercises a system can behave differently in reality than in the unit tests.
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
Faults that the system tests find, can then be fixed before the users would.

Like other testing methods, system testing also has its downsides.
System tests are slow.
Compared to unit tests system tests are way slower.
Having to start and run the whole system, with all its components, takes time which is not needed when executing unit tests.
System tests are harder to write.
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
This is called intergration testing.

In integration testing we test multiple components of a system, but not the whole system altogether.
The tests focus on the interaction between two components of the system.
With this focus, the integration testing has some aspects of unit testing.

In essence integration testing is testing where you test one components interacting with another component.
This other component usually is an external one, for example the database or a web service.
The advantage of this approach is that the interactions between the components.
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
![](/assets/img/chapter6/testing_pyramid.svg)

Here the size of the pyramid slice represent the amount of test we would want of each test level.
A new test level is manual, which is having users try the program and record how they are using the system.
Unit test is at the bottom of the pyramid, which means that we want most test to be unit tests.
Reasons for this have been discussed in the unit testing section.
Then we get integration tests, of which we want to make less than unit tests, mostly because of the extra effort integration tests take to make and execute.
Lastly we move on to system and manual tests in a similar way.

Additionally to the amount of tests of a level we can see that the further up the pyramid the closer to reality the tests become.
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
What we see in practise is that instead of the testing pyramid people use the so-called ice cream cone.
This is the testing pyramid, but put upside down.

[//]: TODO: center image
![](/assets/img/chapter6/ice_cream_cone.svg)

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
If we, for example, want to make sure the system keeps going even if one of its dependencies crash, we can just tell the simulation to crash.

Mock objects are widely used in software testing, mainly to increase testability.
As we have discussed, external systems that the tested system relies on are often mocked.
These external systems include for example databases or webservices that are used by the system.
Mocks ar also used to simulate exception that are hard to trigger in the actual system.
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
* `mock(<class>)`: creates a mock object of the given runtime class. The runtime class can be retrieved from any class by `<ClassName>.class`.
* `when(<mock>.<method>).thenReturn(<value>)`: defines the behavior when the given method is called on the mock. In this case `<value>` will be returned.
* `verify(<mock>).<method>`: is a test that passes when the method is called on the mock and fails otherwise.
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

    assertThat(result.size()).isEqualTo(1);
    assertThat(results.get(0)).isEqualTo(i1);
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

    assertThat(result.size()).isEqualTo(1);
    assertThat(results.get(0)).isEqualTo(i1);
}
```

The InvoiceFilter uses the `all` method in the `InvoiceDao` to get the invoices.
With the mock we can easily give the two invoices that we want to test on.
Using this mock also makes sure we do not have to keep a database running while executing the tests.
{% include example-end.html %}
