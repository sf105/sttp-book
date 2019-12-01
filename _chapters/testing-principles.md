---
chapter-number: 3
title: Testing Principles 
layout: chapter
toc: true
---

Now that we have some basic tools to design and automate our tests, we can think more about some testing concepts.
We start with some precise definitions for certain terms.

## Failure, Fault and Error

We can use a lot of different words for a system that is not behaving correctly.
Just to name a few we have error, mistake, defect, bug, fault and failure.
As we like to be able to describe the problem in software precisely, we need to agree on a certain vocabulairy.
For now this comes down to three terms: **failure**, **fault**, and **error**.

A **failure** is a component of the (software) system that is not behaving as expected.
An example of a failure is the well-known blue screen of death.
We generally expect our pc to keep running, but it just crashes.

Failures are generally caused by faults.
**Faults** are also called defects or bugs.
A fault is a flaw, or mistake, in a component of the system that can cause the system to behave incorrectly.
We have a fault when we have, for example, a `>` instead of `>=` in a condition.

A fault in the code does not have to cause a failure.
If the code containing the fault is not being run, it can also not cause a failure.
Failures only occur when the end user is using the system, when they notice it not behaving as expected.

Finally we have the **error**, also called a **mistake**.
An error is a human action that cause the system to run not as expected.
For example someone can forget to think about a certain corner case that the code might run into.
This then creates a fault in the code, which can result in a failure.

<iframe width="560" height="315" src="https://www.youtube.com/embed/zAty8Rpg92I" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


## Verification and Validation

We keep extending our vocabulary a bit with two more concepts.
Here we introduce **verification** and **validation**.
Both concepts are about assessing the quality of a system and can be described by a single question.

**Validation: Are we building the right software?**
Validation concerns the features that our system offers and the costumer, for who the system is made.
Is the system that we are building actually the system that the users want?
Is the system actually useful?

**Verification** on the other hand is about the system behaving as it is supposed to according to the specification. 
This mostly means that the systems behaves without any bugs, like it is said it should behave.
This does not guarantee that the system is useful.
That is a matter of validation.
We can summarize verification with the question: **Are we building the system right?**

In this course, we mostly focus on verification.
However, validation is also very important when it comes to building successful software systems.

<iframe width="560" height="315" src="https://www.youtube.com/embed/LZ3Fb2Jq7yw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Tests, tests and more tests

If we want to test our systems well, we just keep adding more tests until it is enough, right?
Actually a very important part of software testing is knowing when to stop testing.
Creating too few tests will leave us with a system that might not behave as intended.
On the other hand, creating test after test without stopping will probably cost too much time to create and at some point will make the whole test suite too slow.
A couple of tests are executed in a very short amount of time, but if the amount of tests becomes very high the time needed to execute them will naturally increase as well.
We discuss a couple of important concepts surrounding this subject.

First, **exhaustive testing** is impossible.
We simply cannot test every single case a method might be executing.
This means that we have to prioritize the tests that we do run.

When prioritizing the test cases that we make, it is important to notice that **bugs are not uniformly distributed**.
If we have some components in our system, then they will not all have the same amount of bugs.
Some components probably have more bugs than others.
We should think about which components we want to test most when prioritizing the tests.

A crucial notion for software testing is that **testing shows the presence of defects;
however, testing does not show the absence of defects**.
So while we might find more bugs by testing more, we will never be able to say that our software is 100% bug-free, because of the tests.

To test our software we need a lot of variation in our tests.
When testing a method we want variety in the inputs, for example, like we saw in the examples above.
To test the software well, however, we also need variation in the testing strategies that we apply.
This is described by the **pesticide paradox**: "Every method you use to prevent or find bugs leaves a residue of subtler bugs against which those methods are ineffectual."
There is no testing strategy that guarantees that the tested software is bug-free.
So, when using the same strategy all the time, we will miss some of the defects that are in the software.
This is the residue that is talked about in the pesticide paradox.
From the pesticide paradox we learn that we have to use different testing strategies on the same software to minimize the bugs left in the software.
When learning the various testing strategies in this reader, keep in mind that you want to combine them when you are testing your software.

Combining these testing strategies is a great idea, but it can be quite challenging.
For example, testing a mobile app is very different from testing a web application or a rocket.
In other words: **testing is context-dependent**.
The way that we test depends on the context of the software that we test.

Finally, while we are mostly focusing on verification when we create tests, we should not forget that just having a low amount of bugs is not enough.
If we have a program that works like it is specified, but is of no use for its users, we still do not have good software.
This is called the **absence-of-errors fallacy**.
We cannot forget about the validation part, where we check if the software meets the users' needs.

<iframe width="560" height="315" src="https://www.youtube.com/embed/dkbvb_wTN-M" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## References

* Chapters 1-3 of the Foundations of software testing: ISTQB certification. Graham, Dorothy, Erik Van Veenendaal, and Isabel Evans, Cengage Learning EMEA, 2008.



## Exercises


{% include exercise-begin.html %}
Having a certain terminology helps testers to explain the problems they have with a program or in their software.

Below is a small conversation.
Fill each of the caps with: failure, fault, or error.

**Mark**: Hey, Jane, I just observed a (1) _ _ _ _ _ _ in our software: if the user has multiple surnames, our software doesn't allow them to sign in. \\
**Jane**: Oh, that's awful. Let me debug the code so that I can find the (2) _ _ _ _ _ _.\\
*(a few minutes later)*\\
**Jane**: Mark, I found it! It was my (3) _ _ _ _ _ _. I programmed that part, but never thought of this case.\\
**Mark**: No worries, Jane! Thanks for fixing it!
{% include answer-begin.html %}

1. Failure, the user notices the system/program behaving incorrectly.
2. Fault, this is a problem in the code, that is causing a failure in this case.
3. Error, the human mistake that created the fault.

{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
Kelly, a very experienced software tester, visits Books!, a social network focused on matching people based on books they read.
Users do not report bugs so often; Books! developers have strong testing practices in place.
However, users do say that the software is not really delivering what it promises.

What testing principle applies to this problem?
{% include answer-begin.html %}
The absence-or-error fallacy.
While the software does not have a lot of bugs, it is not giving the user what they want.
In this case the verification was good, but they need work on the validation.
{% include exercise-answer-end.html %}




{% include exercise-begin.html %}
Suzanne, a junior software testing, just joined a very large online payment company in the Netherlands. As a first task, Suzanne analyzed their past two years of bug reports.
Suzanne observes that more than 50% of bugs have been happening in the 'International payments module. 

Suzanne then promises her manager that she will design test cases that will completely cover the 'International payments' module, and thus, find 
all the bugs.

Which of the following testing principles might explain why this is **not** possible?

1. Pesticide paradox. 
2. Exhaustive testing.
3. Test early.
4. Defect clustering.
{% include answer-begin.html %}
Exhaustive testing is impossible.
{% include exercise-answer-end.html %}



{% include exercise-begin.html %}

John strongly believes in unit testing. In fact, this is the only type of testing he actually
does at any project he's in. All the testing principles below, but one, might help in convincing John that he should also focus on different types of testing. 

Which of the following **is the least related** related to help John in moving away from his 'only unit testing' approach?

1. Pesticide paradox. 
2. Tests are context-dependent.
3. Absence-of-errors fallacy.
4. Test early.
{% include answer-begin.html %}

Test early, although an important principle, is definitely not related to the problem of only doing unit tests. All others help people in understanding that variation, different types of testing, is important.
{% include exercise-answer-end.html %}