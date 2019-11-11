---
chapter-number: 4
title: Model- and State-based Testing
layout: chapter
toc: true
---

In model based testing a model is used to derive tests for a piece of software.
Model based testing gives another way of looking at the program when deriving tests.
This allows us to come up with a better test suite and therefore with better tested software.

In this chapter we briefly show what a model is, then we will go over some of the models used in software testing.
The two models covered in this chapter are decision tables and state machines.

## Model
In software testing a model is a simpler way of describing the program under test.
However, a model holds some of the attributes of the program that the model was made of.
Because the model preserves some of the orginal attributes it can be used to perform analysis on the program.
With software testing the model generally preserves the behavior of the software.
The behavior of the software is what we test after all.

If we want to analyze the program, why use models at all?
From source code or system requirements it can be hard to see what a program is supposed to do.
Therefore, by creating a model we make it easier to view how a program operates or should operate.
This way, with models, we can systematically analyze the program that we want to test.

[//]: Add an example of a software model

Models can be made in two ways; from requirements and from code.
Models from requirements are used to create tests that exercise the required behavior.
These can also be used to structure the requirements of the software in a better way.
The developers can use the tests to verify that the program does what it is supposed to do.
The models from code are used to create tests that exercise the implemented behavior.
Developers use these models to derive test cases that exercise the aspects of the code base that are reflected in the model.

## Decision Tables
Decision tables are used to model how a combination of conditions should lead to a certain action.
These tables are easy to understand and can be validated by the client that the software is created for. 
Developers can use the decision tables to derive tests that verify tthe correct implementation of the requirements with respect to the conditions.

### Derive
A decision table is a table containing the conditions and the actions performed for each of the combinations of condition outcomes.

In general a decision table looks like the following:
<table>
  <tr><th></th><th></th><th colspan="4">Variants</th></tr>
  <tr><td rowspan="2"><br><i>Conditions</i></td>
      <td>&lt;Condition1&gt;</td><td>T</td><td>T</td><td>F<br></td><td>F</td></tr>
  <tr><td>&lt;Condition2&gt;</td><td>T<br></td><td>F</td><td>T</td><td>F</td></tr>
  <tr><td><i>Action</i></td><td>&lt;Action&gt;</td><td>value1<br></td><td>value2</td><td>value3</td><td>value4</td></tr>
</table>

The chosen conditions should always be indepent from one another.
The order of the conditions should never matter.
So we can make <Condition2> true and <Condition1> false or we can make <Condition1> false and afer that <Condition2> true.
This should not influence the action depicted in the decision table.
If the other does matter in some way, a state machine might be a better model.
We cover state machines later in this chapter.

{% include example-begin.html %}
When choosing a phone subscription there are a couple of options you could choose.
Depending on these options a price per month is given.
We consider the two options: 
* International services
* Auto-renewal

In the decision table these will be turned into conditions.
True then corresponds to a chosen option and false corresponds to a option that is not chosen.
Taking international should increase the price per month.
Auto-renewal decreases the price per month.

The decision tables is the following:

<table>
  <tr><th></th><th></th><th colspan="4">Variants</th></tr>
  <tr><td rowspan="2"><br><i>Conditions</i></td>
      <td>International</td><td>F</td><td>F</td><td>T<br></td><td>T</td></tr>
  <tr><td>Auto-renewal</td><td>T<br></td><td>F</td><td>T</td><td>F</td></tr>
  <tr><td><i>Action</i></td><td>price/month</td><td>10<br></td><td>15</td><td>30</td><td>32</td></tr>
</table>

You can see the different prices for the combinations of international and auto-renewal.
{% include example-end.html %}

#### Don't Care
In some cases the value of a condition might not influence the action.
This is represented as a don't care value, often abbreviated to dc.

Essentially dc is an abbreviation of two columns.
These two columns have the same values for the other conditions and the same result.
Only the condition that had the dc value has different values in the expanded form.

<table>
  <tr><th></th><th></th><th colspan="3">Variants</th></tr>
  <tr><td rowspan="2"><br><i>Conditions</i></td>
      <td>&lt;Condition1&gt;</td><td>T</td><td>dc</td><td>F<br></td></tr>
  <tr><td>&lt;Condition2&gt;</td><td>dc</td><td>T</td><td>F</td></tr>
  <tr><td><i>Action</i></td><td>&lt;Action&gt;</td><td>value1<br></td><td>value1</td><td>value2</td></tr>
</table>
can be expanded to
<table>
  <tr><th></th><th></th><th colspan="5">Variants</th></tr>
  <tr><td rowspan="2"><br><i>Conditions</i></td>
      <td>&lt;Condition1&gt;</td><td>T</td><td>T</td><td>T<br></td><td>F</td><td>F</td></tr>
  <tr><td>&lt;Condition2&gt;</td><td>T<br></td><td>F</td><td>T</td><td>T</td><td>F</td></tr>
  <tr><td><i>Action</i></td><td>&lt;Action&gt;</td><td>value1<br></td><td>value1</td><td>value1</td><td>value1</td><td>value2</td></tr>
</table>
Then after expanding we can remove the duplicate columns.
We end up with the decision table below.
<table>
  <tr><th></th><th></th><th colspan="4">Variants</th></tr>
  <tr><td rowspan="2"><br><i>Conditions</i></td>
      <td>&lt;Condition1&gt;</td><td>T</td><td>T</td><td>F<br></td><td>F</td></tr>
  <tr><td>&lt;Condition2&gt;</td><td>T<br></td><td>F</td><td>T</td><td>F</td></tr>
  <tr><td><i>Action</i></td><td>&lt;Action&gt;</td><td>value1<br></td><td>value1</td><td>value1</td><td>value2</td></tr>
</table>

{% include example-begin.html %}
We add another condition to the example above.
A loyal costumer receives the same discount as a costumer who chooses the auto-renewal option. 
However, a costumer only gets the discount from one of the two.
The new decision table is below:
<table>
  <tr><th></th><th></th><th colspan="6">Variants</th></tr>
  <tr><td rowspan="3"><br><i>Conditions</i></td>
      <td>International</td><td>F</td><td>F</td><td>F</td><td>T</td><td>T</td><td>T</td></tr>
  <tr><td>Auto-renewal</td><td>T</td><td>dc</td><td>F</td><td>T</td><td>dc</td><td>F</td></tr>
  <tr><td>Loyal</td><td>dc</td><td>T</td><td>F</td><td>dc</td><td>T</td><td>F</td></tr>
  <tr><td><i>Action</i></td><td>price/month</td><td>10</td><td>10</td><td>15</td><td>30</td><td>30</td><td>32</td></tr>
</table>
Note that when auto-renewal is true, the loyal condition does not change the outcome anymore and vice versa.
{% include example-end.html %}

#### Default behavior
Usually, $$N$$ conditions lead to $$2^N$$ combinations or columns.
Often, however, the number of columns that are specified in the decision table can be smaller.
Even if we expand all the dc values.

This is done by using a default action.
A default value means that if a combination of condition outcomes is not present in the decision table, the default action should be the result.

{% include example-begin.html %}
If we set the default charge rate to 10 per month the new decision table can be a bit smaller:
<table>
  <tr><th></th><th></th><th colspan="4">Variants</th></tr>
  <tr><td rowspan="3"><br><i>Conditions</i></td>
      <td>International</td><td>F</td><td>T</td><td>T</td><td>T</td></tr>
  <tr><td>Auto-renewal</td><td>F</td><td>T</td><td>dc</td><td>F</td></tr>
  <tr><td>Loyal</td><td>F</td><td>dc</td><td>T</td><td>F</td></tr>
  <tr><td><i>Action</i></td><td>price/month</td><td>15</td><td>30</td><td>30</td><td>32</td></tr>
</table>
{% include example-end.html %}

### Testing
Using the decision tables we can derive tests, such that we test whether the expected logic is implemented correctly.
There are multiple ways to derive tests for a decision table:
* All explicit variants: derive one test case for each column. The amount of tests is the amount of columns in the decision table.
* All possible variants: derive a test case for each possible combination of condition values. For $$N$$ conditions this leads to $$2^N$$ test cases. Often, this approach is unrealistic because of the exponential relation between the number of conditions and the number of test cases.
* Every unique outcome / All decisions: One test case for each unique outcome or action. The amount of tests depends on the actions in the decision table.
* Each condition T/F: Make sure that each conditions is true and false at least once in the test suite. This often results in two tests: All conditions true and all conditions false.

#### MC/DC
One more way to derive test cases from a decision table is by using Modified Condition / Decision Coverage (MC/DC).
This is a combination of the last two ways of deriving tests shown above.

MC/DC has the two characteristics of All devisions and Each condition T/F with an additional characteristic that makes MC/DC special:
1. Each condition is at least once true and once false in the test suite
2. Each unique action should be tested at least once
3. Each condition should individually determine the action or outcome

The third point is realized by making two test cases for each condition.
In these two test cases, the condition under test should have a different value, the outcome should be different, and the other conditions should have the same value in both test cases.
This way the condition that is under test individually influences the outcome, as the other conditions stay the same and therefore do not influence the outcome.

By choosing the test cases efficiently MC/DC needs less tests than all variants, while still exercising the important parts of the system.
Less tests of course means less time taken to write the tests and a faster execution of the test suite.

{% include example-begin.html %}
To derive the tests we expand and rearrange the decision table of the previous example:
<table>
  <tr><th></th><th></th><th>v1</th><th>v2</th><th>v3</th><th>v4</th><th>v5</th><th>v6</th><th>v7</th><th>v8</th></tr>
  <tr><td rowspan="3"><br><i>Conditions</i></td>
      <td>International</td><td>T</td><td>T</td><td>T</td><td>T</td><td>F</td><td>F</td><td>F</td><td>F</td></tr>
  <tr><td>Auto-renewal</td><td>T</td><td>T</td><td>F</td><td>F</td><td>T</td><td>T</td><td>F</td><td>F</td></tr>
  <tr><td>Loyal</td><td>T</td><td>F</td><td>T</td><td>F</td><td>T</td><td>F</td><td>T</td><td>F</td></tr>
  <tr><td><i>Action</i></td><td>price/month</td><td>30</td><td>30</td><td>30</td><td>32</td><td>10</td><td>10</td><td>10</td><td>15</td></tr>
</table>
First we look at the first condition and we try to find pairs of combinations that would cover this condition according to MC/DC.
We look voor combinations where only International and the  price/month changes.

The possible pairs are: {v1, v5}, {v2, v6}, {v3, v7} and {v4, v8}.
Testing both combinations of any of these pairs would give MC/DC for the first condition.

Moving to Auto-renewal we find the pairs: {v2, v4}, {v6, v8}. For this condition {v1, v3} and {v5, v7} are not viable pairs, because the action is the same among the two combinations.

The last condition, Loyal, gives the following pairs: {v3, v4}, {v7, v8}.

By choosing the test cases efficiently we should be able to achieve full MC/DC by choosing four of the combinations. 
We want to cover all the actions in the test suite.
Therefore we need at least v4 and v8.
With these decision we have covered the International condition as well.
Now we need one of v1, v2, v3 and one of v5, v6, v7.
To cover Loyal we add v7 and to cover Auto-renewal we add v2.
Now we also cover all the possible actions.

Now, for full MC/DC, we test the decisions: v2, v4, v7, v8.
{% include example-end.html %}

### Implementation
Now that we know how to derive the test cases from the decision tables it is time to implement these test cases. 
We will see how we can implement these test cases in an efficient manner.

The most obvious way to test the combinations is to create a single test for each of the conditions. 

{% include example-begin.html %}
We continue with the example we created the decision table for earlier.
To start we write the tests for combinations v2 and v3.
Assuming that we can use some implemented methods in a PhonePlan class the tests look like this:
```java
@Test
public void internationalAutoRenewalTest() {
  PhonePlan plan = new PhonePlan();

  plan.setInternational(true);
  plan.setAutoRenewal(true);
  plan.setLoyal(false);

  assertThat(plan.pricePerMonth()).isEqualTo(30);
}

@Test
public void internationalLoyalTest() {
  PhonePlan plan = new PhonePlan();

  plan.setInternational(true);
  plan.setAutoRenewal(false);
  plan.setLoyal(true);

  assertThat(plan.pricePerMonth()).isEqualTo(30);
}
```
{% include example-end.html %}
As you can see in the example above, the different tests for the different combinations are very similar.
The tests do the exact same thing, but just with different values.
To avoid the code duplication that comes with this approach to implementing decision table tests, we can use parameterized tests.

#### Parameterized Testing
Instead of implementing a single test for each of the combinations, we want to implement a single test for all the combinations.
Then for each combination we execute this test with the correct values.
This is done with a parameterized test.

In JUnit 5 this is done using the `ParameterizedTest` annotation.
Additionally, a `Source` is needed, which is given by another annotation.
In general this will look like the following:
```java
@ParameterizedTest
@CsvSource({
    "true, 5, 8.0, ...",  // test 1
    "false, 2, 0.6, ...", // test 2
    "true, 1, 5.3, ...",  // test 3
    "true, 3, 4.7, ..."   // test 4
})
public void someTest(boolean param1, int param2, double param3, ...) {
  // Arrange
  SomeObject some = new SomeObject();

  // Act
  double result = some.method(param1, param2);

  // Assert
  assertThat(result).isEqualsTo(param3);
}
```
For testing the combinations out of decision tables, usually the `CsvSource` is most convienient. Other sources can be found in the [JUnit 5 docs](https://junit.org/junit5/docs/current/user-guide/#writing-tests-parameterized-tests-sources). Each string in the `CsvSource` gives one test. Such a string consists of the, comma separated, parameters for the test function. The first value is the first parameter, the second value the second parameters etc.

{% include example-begin.html %}
With the parameterized test we can easily create all tests we need for MC/DC of the decision table in the previous examples.
```java
@ParameterizedTest
@CsvSource({
    "true, true, false, 30",   // v2
    "true, false, true, 30",   // v3
    "true, false, false, 32",  // v4
    "false, false, false, 15"  // v8
})
public void pricePerMonthTest(boolean international, boolean autoRenewal, 
    boolean loyal, int price) {
  
  PhonePlan plan = new PhonePlan();

  plan.setInternational(international);
  plan.setAutoRenewal(autoRenewal);
  plan.setLoyal(loyal);

  assertThat(plan.pricePerMonth()).isEqualTo(price);
}
```
You can see that the test is very similar as the tests in the previous example.
Instead of directly using the values for one combination we use the parameters with the `CsvSource` to execute multiple tests.
{% include example-end.html %}

[//]: TODO: not sure if cucumber, non-binary choices, or observability vs controllability (seems more something for when discussing mockito) is needed (here)

## State Machines
The state machine is a model that describes the software system by describing its states.
A system often has multiple states and various transitions between these states.
The state machine model uses these states and transitions to illustrate the system's behavior.

The main focus of a state machine is, as the name suggests, the states of a system. 
So it is useful to think about what a state actually is.
The states in a state machine model describe where a program is in its execution.
If we need X to happen before we can do Y, we can use a state.
X would then cause the transition to this state.
From the state we can do Y, as we know that in this state X has happened.
We can use as many states as we need to describe the system's behavior well.

Besides states and transitions a state machine has an initial state and events.
The initial state is the state that a system starts in.
From that state the system can transition to other states.
Each transition is paired with an event. 
This event is usually one or two words that describe what has to happen to make the transition.

Of course there are some agreements on how to make the models.
The notation we use is the Unified Modeling Language, UML.
For the state diagrams that means we use the following symbols:
* State: ![](/assets/img/chapter4/uml/state_symbol.svg)
* Transition: ![](/assets/img/chapter4/uml/transition_symbol.svg)
* Event: ![](/assets/img/chapter4/uml/event_symbol.svg)
* Initial state: ![](/assets/img/chapter4/uml/initial_state_symbol.svg)

{% include example-begin.html %}
For the coming examples we model a (part of a) phone.
We start very simple with a state machines that models the phone's ability to be locked or unlocked.

A phone that can be either locked or unlocked has two states; locked and unlocked.
Before all the face and finger sensors you had to enter a password to unlock the phone.
A correct password unlocks the phone and if an incorrect password is given the phone stays locked.
Finally, an unlocked phone can be locked again by pushing the lock button.
We can use these events in the state machine.

![](/assets/img/chapter4/examples/locked_unlocked_machine.svg)

In the diagram the initial state is `LOCKED`.
Usually when someone starts using their phone, it is locked.
Therefore the initial state of the state machine should also be `LOCKED`.
{% include example-end.html %}

Sometimes an event can lead to multiple states, depending on a certain condition.
To model this in the state machines we use conditional transitions.
These transitions are only performed if the event happens and if the condition is true.
The conditions often depend on a certain value used in the state machine.
To modify these values when a transition is taken in the state machine we use actions.
Actions are associated with a transition and are performed when the system uses that transition to go into another state.
The notation for conditions and actions is as follows:
* Conditional transition: ![](/assets/img/chapter4/uml/conditional_symbol.svg)
* Action: ![](/assets/img/chapter4/uml/action_symbol.svg)

{% include example-begin.html %}
When a user types the wrong password for four times in a row, the phone gets blocked. We use `n` in the model to represent the amount of failed attempts. Let's look at the conditional transitions that we need to model this behavior first.

![](/assets/img/chapter4/examples/blocked_condition_machine.svg)

When `n` (the number of failed unlock attempts) is smaller than 3 the phone stays in `LOCKED` state. However, when `n` is equal to 3 the phone goes to `BLOCKED`. Here we have an event, wrong password, than can lead to different states based on the condition.

In the previous state machine, `n` never changes. This means that the phone will never go in its `BLOCKED` state, as that requires `n` to be equal to 3. We can add actions to the state machine to make `n` change correctly.

![](/assets/img/chapter4/examples/blocked_complete_machine.svg)

The added actions are setting `n` to `n+1` when an incorrect password is given and to 0 when a correct password is given.
This way the state machine will be in the `BLOCKED` state when a wrong password is given for four times in a row.
{% include example-end.html %}

### Testing
Like the decision tables we want to use the state machine model to derive tests for our software system.
First we will have a look at what might be implemented incorrectly.

An obvious error that can be made is a transition going to the wrong state.
This will cause the system to act incorrectly so we want the tests to catch such errors.
Additionally, the conditions in conditional transitions and the actions in transition can be wrong.
Finally, the behavior of a state should stay the same at all times.
This means that moving from and to a state should not change the behavior of that state.

For state machines we have a couple of test coverages.
In this chapter we go over three mainly used ways of defining test coverage:
* State coverage: each state has to be reached at least once
* Transition coverage: each transition has to be exercised at least once
* Paths: not exactly a way of describing test coverage, but we use paths to derive test cases

To implement the state coverage we generally bring the system in a state through transitions and then assert that the system is in that state. To test a single transition a bit more steps are needed:
1. Bring system in state that the transition goes out of
2. Assert that the system is indeed in that state
3. Trigger the transition's event.
4. If there is an action: check if this action has happened
5. Assert that the system now is in the new state that the transition points to

{% include example-begin.html %}
To achieve full state coverage we need to arrive in each state once.
For the phone example we have three states so we can make three tests.
* Check that the system is `LOCKED` when it is started
* Give the correct password and check that the system is `UNLOCKED`
* Give an incorrect password four times and check that the system is `BLOCKED`

With these three tests we achieve full state coverage, as the system is in each state at some point.

With the tests above we have covered most of the transitions as well.
The only untested transition is the `lock button` from `UNLOCKED` to `LOCKED`.
To test this transition, we bring the system in `UNLOCKED` by giving the correct password.
Then we trigger the `lock button` and assert that the system is in `LOCKED`.
{% include example-end.html %}

#### Paths and Transition trees
Besides the individual transitions, we can also test the combinations of transitions.
These combinations of transitions are called paths.
A logical thought might be: Let's test all the paths in the state machine!
While this looks like a good objective, the number of paths will most likely be too high.
Take a state machine that has a loop, i.e. a transition from state X to Y and a transition from state Y to X.
When creating paths we can keep going back and forth these two states.
This leads to an infinite amount of paths. 
Obviously we cannot test all the paths, we will need to take a different approach.

The idea is that when using paths to derive test cases, we want each loop to be executed once.
This way we have a finite amount of paths to create test cases for.
We derive these tests by using a transition tree, which spans the graph of the state machine.
Such a transition tree is created as follows:
1. The root node is named as the initial state of the state machine
2. For each of the nodes at the lowest level of the transition tree:
  * If the state that the node corresponds to has not been covered before: \\
    For each of the outgoing transitions of this node's state: \\
      Add a child node that has the name of the state the transition points to. If this state is already in the tree, add or increment a number after the state's name to keep the node unique
  * If any nodes were added: \\
     Repeat from step 2.

This is also demonstrated in the example below.

{% include example-begin.html %}
To make the transition table a bit more interesting we modify the phone's state machine to have an `OFF` state instead of a `BLOCKED` state. See the state machine below:

![](/assets/img/chapter4/examples/phone_off_machine.svg)

The root node of the transition tree is the initial state of the state machine.
We append some number to make it easier to distinguish this node from other nodes of the same state.

![](/assets/img/chapter4/examples/transition_tree/transition_tree_0.svg)

Now we for each outgoing transition we add a child node to `OFF_0`.

![](/assets/img/chapter4/examples/transition_tree/transition_tree_1.svg)

One node was added, so we continue by adding childs to that node.
![](/assets/img/chapter4/examples/transition_tree/transition_tree_2.svg)

Now, the only state we have not seen yet is `UNLOCKED` in the `UNLOCKED_0` node.
Therefore this is the only node we should add childs to.
![](/assets/img/chapter4/examples/transition_tree/transition_tree_3.svg)

Now states of the nodes in the lowest layer have all been visited before so the transition tree is done.
{% include example-end.html %}

From a transition tree we can derive tests.
Each leaf node in the transition tree represents one path to test.
This path is given by going from the root node to this leaf node.
With the state machine we can find the events we need to trigger to follow the path.
In the tests we typically assert that we start in the correct state.
Then we trigger the next event that is needed for the given path and assert that we are in the next correct state.
Then this is done until the whole path is followed.

{% include example-begin.html %}
In the transition tree of the previous example there are four leaf nodes: `OFF_1`, `OFF_2`, `LOCKED_1`, `LOCKED_2`.
We want a test for each of these leaf nodes, that follows the path leading to that node.
For `OFF_1` the test should 'move' the system from `OFF` to `LOCKED` and again to `OFF`.
Looking at the state machine this gives the events `home`, `long lock button`.
In the test we would assert that the system is in `OFF`, then trigger `home`, assert that the system is in `LOCKED`, trigger `long lock button` and finally assert that the system is in `OFF`.

The tests for the other three paths can be derived in similar fashion.
{% include example-end.html %}

Using the transition tree, each loop that is in the state machine is executed once.
Now the amount of tests are managable, while testing most of the important paths in the state machine.

Next we will look at additional approaches to testing the paths in a state machine.

#### Sneak paths and Transition tables
In the previous section we discussed transition trees and how to use them to derive tests.
These tests check if the system behaves correctly when following different paths in the state machine.
With this way of testing we check if the existing transitions in a state machine behave correctly.
We do not check if there exists any more transitions, that should not exist.
Such a transition is called a sneak path.

A sneak path is a path in the state machine that should not exist.
So for example we have state X and Y and the system should not be able to transition directly from X to Y.
If the system can in some way transition directly from X to Y, there exists a sneak path.
Of course, we want to test if such sneak paths exist in the system.
To this end we make use of transition tables.

A transition table is a table containing each transition that is in the state machine. 
The transition is given by the state it's going out of, the event that triggers the transition, and the state the transition goes to.
A transition table typically looks somewhat like the following:
<table>
  <tr>
    <td>STATES</td>
    <td colspan="3">Events</td>
  </tr>
  <tr>
    <td></td>
    <td>event1</td>
    <td>event2</td>
    <td>event3</td>
  </tr>
  <tr>
    <td>STATE1</td>
    <td>STATE1</td>
    <td></td>
    <td>STATE2</td>
  </tr>
  <tr>
    <td>STATE2</td>
    <td></td>
    <td>STATE1</td>
    <td></td>
  </tr>
</table>

We construct a transition table as follows:
* List all the state machine's states along the rows
* List all events along the columns
* For each transition in the state machine note its destination state in the correct cell of the transition table.

{% include example-begin.html %}
We take a look at the same state machine we created a transition table for:
![](/assets/img/chapter4/examples/phone_off_machine.svg)

To make the transition table we list all the states and events in the table:

<table>
  <tr>
    <td>STATES</td>
    <td colspan="5">Events</td>
  </tr>
  <tr>
    <td></td>
    <td>home</td>
    <td>wrong password</td>
    <td>correct password</td>
    <td>lock button</td>
    <td>long lock button</td>
  </tr>
  <tr>
    <td>OFF</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>LOCKED</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>UNLOCKED</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
</table>
Then we fill the table with the states that the transitions in the state machine point to:
<table>
  <tr>
    <td>STATES</td>
    <td colspan="5">Events</td>
  </tr>
  <tr>
    <td></td>
    <td>home</td>
    <td>wrong password</td>
    <td>correct password</td>
    <td>lock button</td>
    <td>long lock button</td>
  </tr>
  <tr>
    <td>OFF</td>
    <td>LOCKED</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>LOCKED</td>
    <td></td>
    <td>LOCKED</td>
    <td>UNLOCKED</td>
    <td></td>
    <td>OFF</td>
  </tr>
  <tr>
    <td>UNLOCKED</td>
    <td></td>
    <td></td>
    <td></td>
    <td>LOCKED</td>
    <td>OFF</td>
  </tr>
</table>

Now for example we can see that there is a transition frmo `UNLOCKED` to `LOCKED` when the event `lock button` is triggered.
{% include example-end.html %}

Now that we have the transition table, we have to decide the intended behavior for the cells that are empty.
The default is to just ignore the event and stay in the same state. 
In some cases one might want the system to throw an exception.
These decisions depend on the project and the customer's needs.

As discussed earlier, we can use the transition table to derive tests for sneak paths.
Usually, we want the system to remain in its current state when we trigger an event that has an empty cell in the transition table.
To test for all possible sneak paths, we create a test case for each empty cell in the transition table.
This test will first bring the system to the state corresponding to the empty cell's row (you can use the transition table to find a suitable path), then trigger the event that corresponds to the empty cell's column, and finally the test asserts that the system is in the same state as before triggering the event.
The amount of 'sneak path tests' is the amount of empty cells in the transition table.

Now that we have tests that verify both existing and non-existing paths we can derive proper test suite for our state machines.
So far, we looked at rather simple and small state machine.
Next, we will discuss larger, more complicated state machines and how to properly structure them.

### Super states and Regions
When the modeled system becomes large and complex, typically so does the state machine.
At some point the state machine will consist of a lot of states and transitions, which makes it unclear and impractical to work with.
To resolve this issue and make a state machine more scalable we can use super states and regions.

#### Super states
A super state is a state that consist of a state machine.
Basically, we wrap a state machine in a super-state which we can then use as a state in another state machine.

The notation of the super-state is as follows: ![](/assets/img/chapter4/uml/super_state_symbol.svg)

Because the super state is in essence a state machine that can be used as a state, we know what should be inside of a super state.
The super state usually consists of multiple states and transitions, and has to have an initial state.
Any transition going into the super state essentially goes to the initial state of the super state.
A transition going out of the super state means that if the event on this transition is triggered in any of the super state's states, the system transitions into the state the transition points to.

Now that we have a super state we can choose to show it fully or we can collapse it.
A collapsed super state is just a normal state in the state machine.
This state has the super state's name and the same incoming and outgoing transitions as the super state.

With the super states and the collapsing of super states we can modularize and combine state machines.
This allows us to shift the state machine's focus to different parts of the system's behavior.

{% include example-begin.html %}
Even in the small example of a phone's state machine we can use a super state.
The two states `LOCKED` and `UNLOCKED` both represent the system in some sort of `ON` state.
We can use this to create a super state called `ON`.

![](/assets/img/chapter4/examples/phone_super_state.svg)

Now we can also simplify the state machine by collapsing the super state:

![](/assets/img/chapter4/examples/phone_collapsed.svg)
{% include example-end.html %}

#### Regions
So far we have had super states that contain one state machine.
Here the system is in only one state of the super state at once.
In some cases it may be useful to allow the system to be in multiple states at once.
This is done with regions.

A super state can be split up into multiple regions.
These are orthogonal regions, meaning that the state machines in the regions are independent from each other; they do not influence the state machines in other regions.
Each region contains one state machine.
When the systems enters the super state, it enters all the initial states of the regions.
This means that the system is in multiple states at once.

The notation of regions is: ![](/assets/img/chapter4/uml/region_symbol.svg)

Expanding regions is possible, but highly impractical and usually not wanted.
Expanding the region requires creating a state for each combination of states in the different regions.
This causes the number of states and transitions to quickly explode.
We will not cover how to expand the regions because of these reasons.

In general it is best to use small state machine and link these together using super states and regions.

{% include example-begin.html %}
So far when the phone was `ON` we modeled the `LOCKED` and `UNLOCKED` state.
When the phone is on it drains the battery.
The system keeps track of the level of the battery.
Let's assume that our phone has two battery levels: low battery and normal battery.
The draining of the battery and the transitions between the states of this battery runs in parallel to the phone being locked or unlocked.
With parallel behavior like this we can use the regions in our state machine model.
With the new battery states and the regions the state machine looks like:

![](/assets/img/chapter4/examples/phone_region.svg)

You can see that we assumed the battery to start in the normal level state.
Therefore, when the system transitions to the `ON` state it will be in the `LOCKED` and `NORMAL BATTERY` states.
{% include example-end.html %}

## Exercises
Here you find some exercises to practise the material of this chapter with.
For each of the exercises the answers are provided directly beneath the question.

{% include exercise-begin.html %}
The *ColdHot* air conditioning system has the following requirements:
* When the user turns it on, the machine is in an *idle* state.
* If it's *too hot*, then, the *cooling* process starts. It goes back to *idle* when the defined *temperature is reached*.
* If it's *too cold*, then, the *heating* process starts. It goes back to *idle* when the defined *temperature is reached*.
* If the user *turns it off*, the machine is *off*. If the user *turns it on* again, the machine is back to *idle*.

Draw a minimal state machine to represent these requirements.
{% include answer-begin.html %}

![](/assets/img/chapter4/exercises/coldhot_state_machine.svg)

You should not need more than 4 states.
{% include exercise-answer-end.html %}


{% include exercise-begin.html %}
Derive the transition tree from the state machine of the assignment above.
{% include answer-begin.html %}

![](/assets/img/chapter4/exercises/coldhot_transition_tree.svg)

{% include exercise-answer-end.html %}


{% include exercise-begin.html %}
Now derive the transition table of the *ColdHot* state machine.

How many sneaky paths can we test based on the transition table?
{% include answer-begin.html %}
<table>
  <tr>
    <td></td>
    <td>temperature reached</td>
    <td>too hot</td>
    <td>too cold</td>
    <td>turn on</td>
    <td>turn off</td>
  </tr>
  <tr>
    <td>Idle</td>
    <td></td>
    <td>Cooling</td>
    <td>Heating</td>
    <td></td>
    <td>Off</td>
  </tr>
  <tr>
    <td>Cooling</td>
    <td>Idle</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>Heating</td>
    <td>Idle</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>Off</td>
    <td></td>
    <td></td>
    <td></td>
    <td>Idle</td>
    <td></td>
  </tr>
</table>

There are 14 empty cells in the table, so there are 14 sneaky paths that we can test.
{% include exercise-answer-end.html %}


{% include exercise-begin.html %}
Draw the transition tree of the following state machine:

![](/assets/img/chapter4/exercises/order_state_machine.svg)

Use sensible naming for the states in your transition tree.
{% include answer-begin.html %}
![](/assets/img/chapter4/exercises/order_transition_tree.svg)
{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
With the transition tree you devised in the previous exercise and the state machine in that exercise.
What is the transition coverage of a test that the following events: [order placed, order received, order fullfiled, order delivered]?
{% include answer-begin.html %}
We have a total of 6 transitions.
Of these transitions the four given in the test are covered and order cancelled and order resumed are not.
This coves a transition coverage of $$\frac{4}{6} \cdot 100\% = 66.7\%$$
{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
Devise the decision table of the state machine that was given in the exercise above.
Ignore the initial transition `Order placed`.
{% include answer-begin.html %}
<table>
  <tr>
    <td>STATES</td>
    <td colspan="5">Events</td>
  </tr>
  <tr>
    <td></td>
    <td>Order received</td>
    <td>Order cancelled</td>
    <td>Order resumed</td>
    <td>Order fulfilled</td>
    <td>Order delivered</td>
  </tr>
  <tr>
    <td>Submitted</td>
    <td>Processing</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>Processing</td>
    <td></td>
    <td>Cancelled</td>
    <td></td>
    <td>Shipped</td>
    <td></td>
  </tr>
  <tr>
    <td>Cancelled</td>
    <td></td>
    <td></td>
    <td>Processing</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>Shipped</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td>Completed</td>
  </tr>
  <tr>
    <td>Completed</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
</table>
{% include exercise-answer-end.html %}


{% include exercise-begin.html %}
How many sneak paths are there in the state machine we used in the previous exercises?
Again ignoring the initial `Order placed` transition.
{% include answer-begin.html %}
20.

There are 20 empty cells in the decision table.

Also we have 5 states.
This means $$5 \cdot 5 = 25$$ possible transitions.
The state machine gives 5 explicit transitions so we have $$25 - 5 = 20$$ sneak paths.
{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
Consider the following decision table:
<table>
  <tr><th>Criteria</th><th colspan="6">Options</th></tr>
  <tr><td>C1: Employed for 1 year</td><td>T</td><td>F</td><td>F</td><td>T</td><td>T</td><td>T</td></tr>
  <tr><td>C2: Achieved last year's goal</td><td>T</td><td>dc</td><td>dc</td><td>F</td><td>T</td><td>F</td></tr>
  <tr><td>C3: Positive evaluation from peers</td><td>T</td><td>F</td><td>T</td><td>F</td><td>F</td><td>T</td></tr>
  <tr><td></td><td>10%</td><td>0%</td><td>5%</td><td>2%</td><td>6%</td><td>3%</td></tr>
</table>

Which decision do we have to test for full MC/DC?

Use as few decisions as possible.
{% include answer-begin.html %}

First we find pairs of decisions that are suitable for MC/DC: (We indicate a decision as a sequence of T and F. TTT would mean all conditions true and TFF means C1 true and C2, C3 false)
* C1: {TTT, FTT}, {FTF, TTF}, {FFF, TFF}, {FFT, TFT}
* C2: {TTT, TFT}, {TFF, TTF}
* C3: {TTT, TTF}, {FFF, FFT}, {FTF, FTT}, {TFF, TFT},

All condition can use the TTT decision, so we will use that.
Then we can add FTT, TFT and TTF. 
Now we test each condition individually with it changing the outcome.

It might look line we are done, but MC/DC requires each action to be covered at least once.
To achieve this we add the FFF and TFF decision as test cases.

In this case we need to test each explicit decision in the decision table.

{% include exercise-answer-end.html %}


{% include exercise-begin.html %}
See the following generic state machine.

![](/assets/img/chapter4/exercises/generic_state_machine.svg)

Draw the transition tree of this state machine.
{% include answer-begin.html %}

![](/assets/img/chapter4/exercises/generic_transition_tree.svg)

{% include exercise-answer-end.html %}
