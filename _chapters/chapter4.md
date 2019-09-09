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

