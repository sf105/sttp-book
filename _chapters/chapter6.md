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
Unit test do not exercise the system in a realistic way.
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
