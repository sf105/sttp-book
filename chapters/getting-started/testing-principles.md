# Principles of software testing

In this chapter, we first provide some terminology to the reader. Using the right
terms help us in understanding each other better. We then discuss the differences
between verification and validation. Finally, we discuss a few testing principles
that will guide us (or, more specifically, force us to perform trade-offs whenever
we choose a testing technique) throughout the book.

## Failure, Fault and Error

It is common to hear different terms to indicate that a software system
is not behaving as expected.
Just to name a few: _error_, _mistake_, _defect_, _bug_, _fault_, and _failure_.
As we should be able to describe the events that led to a software crash more precisely, 
we need to agree on a certain vocabulary.
For now, this comes down to three terms: **failure**, **fault**, and **error**.

A **failure** is a component of the (software) system that is not behaving as expected.
Failures are often visible to the end user.
An example of a failure can be a mobile app that suddenly stopped working. 
Or a news website that suddenly started to provide yesterday news in the front page. 
The software system did something it was not supposed to do.

Failures are generally caused by _faults_.
**Faults** are also called _defects_ or _bugs_.
A fault is the flaw in the component of the system that caused the 
system to behave incorrectly. A fault is usually highly technical and in many cases
can be linked to the source code.
For example, the fault was a `>` that was in place, instead of `>=` in an `if` condition.

> Note that the existence of a fault in the source code does not necessarily lead to a failure.
> If the code containing the fault is never executed, it will never cause a failure.
> Failures only occur when the end user is using the system, when they 
> notice it not behaving as expected.

Finally, we have the **error**, also called **mistake**.
An error is the human action that caused the system to run not as expected.
For example, a developer that has forgotten to implement a certain corner case because
that was not clear enough in the requirement.

In short: A mistake done by a developer often leads to fault in the source code that will
eventually result in a failure.

> In the code example of the previous chapter, the failure was the program returning
> a large number. The fault was due to a bad `if/else if` condition. The mistake was 
> caused by me not dealing properly with that corner case.


{% set video_id = "zAty8Rpg92I" %}
{% include "/includes/youtube.md" %}



## Verification and Validation

**Verification** and **validation** are both about 
assessing the quality of a system. However, they do have a subtle difference,
which can be quickly described by a single question:

* **Validation: Are we building the right software?**
Validation concerns the features that our software system offers, and the customer (i.e., for whom the system is made).
Is the system under development, the system that users really want and/or need?
Is the system actually useful? Validation techniques, thus, focus on understanding
whether the software system is delivering the business values it should deliver. In this book,
we only briefly cover validation techniques (see chapters on Continuous Experimentation and on Behavior-Driven Development).

* **Verification: Are we building the system right?** 
Verification, on the other hand, 
is about the system behaving as it is supposed to, according to the specification. 
In simple words, this mostly means that the system behaves without any bugs.
Note that this does not guarantee that the system is useful: a system might work beautifully, bug-free, but does not deliver the features that customers really need.

Note how both _validation_ and _verification_ are fundamental for ensuring
the delivery of high-quality software systems.

{% set video_id = "LZ3Fb2Jq7yw" %}
{% include "/includes/youtube.md" %}


## Principles of software testing (or why software testing is so hard)

A simplistic view on software testing is that,
if we want our systems to be well-tested, all we need to do is to keep adding more tests until it is enough. We wish it were that simple.

Indeed, a very important part of any software testing process is 
to know _when to stop testing_.
After all, resources (e.g., money, developers, infrastructure) are limited. Therefore,
the goal should always be to maximize the number of bugs found while minimizing the 
amount of resources we had to spend in finding those bugs.
Creating too few tests might leave us with a software system that does not behave as intended (i.e., _full of bugs_).
On the other hand, creating tests after tests, without proper consideration might lead to ineffective tests (besides costing too much time and money).


Given resource constraints, we highlight an important principle in 
software testing: **exhaustive testing is impossible**. They might be impossible
even if we had unlimited resources. Imagine a software system that has "just" 128 different
flags (or configurations). Those flags can be set as either true or false (booleans) and
they can configured in all the possible ways. The software system behaves differently,
according to the combination that is set. This implies in testing all the possible
configurations. A simple math shows us that 2 configurations for each of the 128
different flags gives $$2^128$$ combinations that need to be tested. As a matter
of comparison, this number is higher than the estimated number of atoms in the universe.
In other words, this software system has more possible combinations to be tested than
we the universe has atoms.

Given that exhaustive testing is impossible,
software testers have to then prioritize the tests they will perform.

When prioritizing the test cases, we note that **bugs are not uniformly distributed**.
Empirically, we observe that some components in some software systems present more
bugs than other components.

Another crucial consequence of the fact that exhaustive testing is impossible, 
as Dijkstra used to say, is that
**testing shows the presence of defects;
however, testing does not show the absence of defects**.
In other words, while we might find more bugs by simply testing more, our test suites,
however large it might be,
will never ensure us that the software system is 100% bug-free. It will only ensure us
that these cases we test for do behave as expected.

To test our software we need a lot of variation in our tests.
When testing a method we want variety in the inputs, for example, 
like we saw in the examples above.
To test the software well, however, we also need variation in 
the testing strategies that we apply.

Moreover, calling a software fault a bug might indeed be a good analogy. Another 
interesting empirical finding is that, if testers apply the same testing techniques over and over,
at some point they will lose their efficacy. 
This is described by what is known as the **pesticide paradox**: 
_"Every method you use to prevent or find bugs leaves a residue of 
subtler bugs against which those methods are ineffectual."_
In practice, this means that there is no single testing strategy 
can guarantee that the software under test is bug-free.
A concrete example might be a team that solely relies on unit testing techniques.
At some point, maybe all the bugs that can be captured at unit test level will be found
by the team; however, the team might miss bugs that only occur at integration level.
From the pesticide paradox, we thus conclude that testers have to use 
different testing strategies to minimize the bugs left in the software.
When studying the various testing strategies that we present in this book, 
keep in mind that combining them all might be a wise decision.

The context also plays an important role in how one devises test cases.
For example, devising test cases for a mobile app is very different 
from devising test cases for a web application. Or for a rocket.
In other words: **testing is context-dependent**.

Again, while this book mostly focuses on verification techniques, 
let us not forget that having a low amount of bugs is not enough for a good software.
As we have said before, a program that works flawlessly, but is of no use for its users, 
is still not a good software.
That is a common fallacy (also known as the **absence-of-errors fallacy**) that software testers face when they decide to focus solely
on verification and not so much on validation.

{% set video_id = "dkbvb_wTN-M" %}
{% include "/includes/youtube.md" %}


## Exercises

**Exercise 1.**
Having a certain terminology helps testers to explain the problems they have with a program or in their software.

Below is a small conversation.
Fill each of the caps with: failure, fault, or error.

* **Mark**: Hey, Jane, I just observed a (1) _ _ _ _ _ _ in our software: if the user has multiple surnames, our software doesn't allow them to sign in. 
* **Jane**: Oh, that's awful. Let me debug the code so that I can find the (2) _ _ _ _ _ _.
*(a few minutes later)*
* **Jane**: Mark, I found it! It was my (3) _ _ _ _ _ _. I programmed that part, but never thought of this case.
* **Mark**: No worries, Jane! Thanks for fixing it!


**Exercise 2.**
Kelly, a very experienced software tester, visits Books!, a social network focused on matching people based on books they read.
Users do not report bugs so often; Books! developers have strong testing practices in place.
However, users do say that the software is not really delivering what it promises.

What testing principle applies to this problem?

**Exercise 3.**
Suzanne, a junior software testing, just joined a very large online payment company in the Netherlands. As a first task, Suzanne analyzed their past two years of bug reports.
Suzanne observes that more than 50% of bugs have been happening in the 'International payments module. 

Suzanne then promises her manager that she will design test cases that will completely cover the 'International payments' module, and thus, find 
all the bugs.

Which of the following testing principles might explain why this is **not** possible?

1. Pesticide paradox. 
2. Exhaustive testing.
3. Test early.
4. Defect clustering.

**Exercise 4.**
John strongly believes in unit testing. In fact, this is the only type of testing he actually
does at any project he's in. All the testing principles below, but one, might help in convincing John that he should also focus on different types of testing. 

Which of the following **is the least related** related to help John in moving away from his 'only unit testing' approach?

1. Pesticide paradox. 
2. Tests are context-dependent.
3. Absence-of-errors fallacy.
4. Test early.



## References

* * Graham, D., Van Veenendaal, E., & Evans, I. (2008). Foundations of software testing: ISTQB certification. Cengage Learning EMEA. Chapters 1, 2, 3.

