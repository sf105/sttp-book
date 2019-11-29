---
chapter-number: 11
title: Test-Driven Development
layout: chapter
toc: true
---

## Introduction

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

