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
