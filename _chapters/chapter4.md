---
chapter-number: 4
title: Model- and State-based testing
layout: chapter
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

While it might seem that the amount of tests needed for MC/DC is $$2N$$ for $$N$$ conditions, we can in fact reuse some test cases from a conditions when testing another conditions.
By efficiently choosing the test cases, we need $$N+1$$ test cases for MC/DC.
This is way better than $$2^N$$ test cases, while still testing the important logic from the decision table.

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
Testing both combinations of any of these pairs would give MC/DC for the first condition. \\
Moving to Auto-renewal we find the pairs: {v2, v4}, {v6, v8}. For this condition {v1, v3} and {v5, v7} are not viable pairs, because the action is the same among the two combinations. \\
The last condition, Loyal, gives the following pairs: {v3, v4}, {v7, v8}. \\
By choosing the test cases efficiently we should be able to achieve full MC/DC by choosing four of the combinations. If we take v2 and v4 we cover Auto-renewal. Then to cover loyal we acn add v3 and finally to cover International we add v8. Now we have the following combinations: v2, v3, v4, v8. For each conditions at least one pair of combinations is tested so we have full MC/DC if we test these combinations.
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
    "true, 5, 8.0, ...", // test 1
    "false, 2, 0.6, ...", // test 2
    "true, 1, 5.3, ...", // test 3
    "true, 3, 4.7, ..."  // test 4
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
    "true, true, false, 30", // v2
    "true, false, true, 30", // v3
    "true, false, false, 32", // v4
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
