---
chapter-number: 7
title: Structural-Based Testing
layout: chapter
toc: true
---

Earlier we discussed how to test software using requirements, also called functional testing.
In this chapter, we will use a different source of information to create tests.
Instead of looking at the requirements of the software we will look at the source code itself.
This is called structural-based testing.

We cover a couple of different ways to do structural-based testing.
This comes down to different kinds of test coverage.
A certain amount of test coverage indicates the amount of code that is executed (or used by the program) when executing the tests.

We cover the following kinds of test coverage:

- Line coverage
- Statement coverage
- Branch coverage
- Condition coverage
- Path coverage
- MC/DC

## Line coverage

As the name suggests, when determining the line coverage we look at the amount of lines that are covered by the tests.
The amount of line coverage is computed as $$\text{line_coverage} = \frac{\text{lines_covered}}{\text{lines_total}} \cdot 100\%$$.
So if a set of tests executes all the lines in the code, the line coverage will be $$100\%$$.
We only count the lines inside of a method.
In other words we do not count the method declaration at the top.

{% include example-begin.html %}
We consider a piece of code that returns the points of the person that wins a game of [Black jack]("https://en.wikipedia.org/wiki/Blackjack").

```java
public class BlackJack {
  public int play(int left, int right) {
1.  int ln = left;
2.  int rn = right;
3.  if (ln > 21)
4.    ln = 0;
5.  if (rn > 21)
6.    rn = 0;
7.  if (ln > rn)
8.    return ln;
9.  else
10.   return rn;
  }
}
```

The `play(int left, int right)` method receives the amount of points of two players and returns the value like specified.
Now let's make two tests for this method.

```java
public class BlackJackTests {
  @Test
  public void bothPlayersGoTooHigh() {
    int result = new BlackJack().play(30, 30);
    assertThat(result).isEqualTo(0);
  }

  @Test
  public void leftPlayerWins() {
    int result = new BlackJack().play(10, 9);
    assertThat(result).isEqualTo(10);
  }
}
```

The first test executes lines 1-7, 9, and 10 as both values are higher than 21 and when the program arrives at line 7.
`ln` equals `rn` so the statement `ln > rn` is `false`.
This means that 9 out of the 10 lines are covered and the line coverage is $$\frac{9}{10}\cdot100\% = 90\%$$.
The second test, `leftPlayerWins`, executes lines 1-3, 5, 7 and 8.
Line 8 was the only line that the first test did not cover.
So when we execute both of our tests, the line coverage is $$100\%$$.
{% include example-end.html %}

## Statement coverage

The first way of determining test coverage we showed is with line coverage.
However, counting the covered lines is not always a good way of calculating the coverage.
The amount of lines in a piece of code is heavily dependent on the programmer that writes the code.
In java you can often write a whole method in just one line (for your future colleagues' sake, please don't).
In that case the line coverage would always be $$100\%$$ if you test the method.

{% include example-begin.html %}
We are again looking at Black jack.
The `play` method can also be written like this:

```java
public int play(int left, int right) {
1.  int ln = left;
2.  int rn = right;
3.  if (ln > 21) ln = 0;
4.  if (rn > 21) rn = 0;
5.  if (ln > rn) return ln;
6.  else return rn;
}
```

Now the method has only 6 lines.
The same `leftPlayerWins` test covered $$\frac{6}{10}$$ lines in the first `play` method.
Now it covers lines 1-5, so $$\frac{5}{6}$$ lines.
The line coverage went up from $$60\%$$ to $$83\%$$, while testing the same method with the same test.
{% include example-end.html %}

A slightly better way of calculating the test coverage is with statement coverage.
It has the same principle as line coverage, but instead of lines we count the statements.
So: $$\text{statement_coverage} = \frac{\text{statements_covered}}{\text{statements_total}} \cdot 100\%$$.

{% include example-begin.html %}
Again consider the `leftPlayerWins` test for the `play` method.
In the first version of the method each line has just one statement.
The statement coverage will then be the same as the line coverage: $$60\%$$.

[//]: Do we consider else to be a statement?
Now if we look at the second version of the `play` method, lines 3-6 all contain two statements.
The test executes all statements in lines 1, 2, 5 and one of the two statements in lines 3 and 4.
In total 6 out of 10 statements are executed.
Therefore the statement coverage of `leftPlayerWins` in the second `play` method is $$\frac{6}{10}=60\%$$.

The statement coverage is the same in both `play` methods, while the line coverage differs between the methods.
{% include example-end.html %}

## Branch coverage

Complex programs often use a lot of conditions (e.g. if-statements).
When testing these programs, the line or statement coverage often is not enough to test the program well.
With branch coverage you can test such complex programs a bit better.

Branch coverage works the same as line and statement coverage.
This time, however, we do not count lines or statements, but we are counting branches.

**What are branches?**\\
If a program has an if-statement, it acts differently based on the outcome of the condition inside of the if-statement.
There are, so to speak, different routes that the program can take while execution.
These routes are the branches that we want to count.
It can be hard to find the branches by just looking at the source code.
This is why we use Control-Flow graphs (CFG)

### Control-Flow Graph

A Control-Flow graph consists of blocks, and arrows that connect these blocks.
A piece of code that has no conditions and always executes the same way is placed in a rectangular block.
The conditions are placed in diamonds.
These diamonds have two outgoing arrows, one for true and one for false, indicating the next step of the program based on the decision.
Each rectangular block with a normal piece of code has an outgoing arrow showing what happens after the code is executed (with the exception of return statements).

You can see an example of a CFG below.

{% include example-begin.html %}
We write a program for the following problem:\\
Given a sentence, you should count the number of words that end with either an “s” or an “r”.
A word ends when a non-letter appears.

Our implementation of a program solving this program is:

```java
public class CountLetters {
  public int count(String str) {
1.  int words = 0;
2.  char last = ' ';
3.  for (int i = 0; i < str.length(); i++) {
4.    if (!Character.isLetter(str.charAt(i))
5.        && (last == 's' || last == 'r')) {
6.      words++;
7.    }
8.    last = str.charAt(i);
9.  }
10. if (last == 'r' || last == 's')
11.   words++;
12. return words;
  }
}
```

And we have the corresponding CFG:

![Control flow graph example]("/assets/img/chapter5/examples/CFG-branch-example.svg")

Note that we split the for-loop into two blocks and a decision.
Every decision has one outgoing arrow for true and one for false, indicating what the program will do based on the condition.
`return words;` does not have an outgoing arrow as the program stops after that statement.
{% include example-end.html %}

Branches are easy to find in a CFG.
Each arrow with true of false (so each arrow going out of a decision) is a branch.
To get the branch coverage of a test all that is needed is to count the amount of covered branches and divide that by the total amount of branches: $$\text{branch_coverage}=\frac{\text{branches_covered}}{\text{branches_total}} \cdot 100\%$$

{% include example-begin.html %}
Now we write some tests for the `count` method above.

```java
public class CountLettersTests {
  @Test
  public void multipleMatchingWords() {

    int words = new CountLetters()
        .count("cats|dogs");

    assertEquals(2, words);
  }

  @Test
  public void lastWordDoesntMatch() {

    int words = new CountLetters()
        .count("cats|dog");

    assertEquals(1, words);
  }
}
```

The first test covers all the branches in the left part of the CFG.
At the right part it covers the top false branch, because at some point `i` will equal `str.length()`.
Then dogs ends with an s, so it also covers the true branch on the right.
This gives the test $$\frac{5}{6} \cdot 100\% = 83\%$$ branch coverage.
The only branch that is not covered is the false branch at the bottom right of the CFG.
This branch is executed when the last word does not end with an r or an s.
The second test executes this branch so the two tests together have a branch coverage of $$100\%$$.
{% include example-end.html %}

## Condition coverage

Branch coverage gives two branches for each decision, no matter how complicated this decision is.
When a decision gets complicated, branch coverage is too simple to get good tests for the decision.

With condition coverage we split the decisions into single conditions.
Then it works the same as branch coverage, but with the conditions instead of branches: count the covered conditions and divide by the total amount of conditions: $$\text{conditions_coverage} = \frac{\text{conditions_covered}}{\text{conditions_total}} \cdot 100\%$$

A CFG can again be used to spot the conditions.
Each decision with multiple conditions should be split into decisions with each just one condition.
Then, like the CFG for branch coverage, each arrow going out of a decision is a condition.

{% include example-begin.html %}
Once again we look at the program that counts the words ending with an "r" or an "s".
Instead of branch coverage, we are interested in the condition coverage that the tests give.

We start by splitting the decisions in the CFG:

![Control Flow Graph example with conditions]("/assets/img/chapter5/examples/CFG-condition-example.svg")

There are quite a bit more conditions than branches.
This can also be seen in the coverages of the tests that we wrote earlier.

The first test now covers 7 conditions and the total amount of conditions is 12.
So the condition coverage is now: $$\frac{7}{12} \cdot 100\% = 58\%$$.
This is quite a bit less than the $$83\%$$ branch coverage, so we need some more tests to test the method well.
{% include example-end.html %}

Condition coverage is an improvement over the branch coverage.
However, we will try to do even better in the next section.

## Path coverage

With condition coverage we looked at each condition individually.
When some test makes this condition true and false at any point, it would be fully covered.
This does not cover all the important cases on which the program can execute.

Path coverage does not consider the conditions individually, but considers the combination of the conditions in a decision.
Each of these combinations is a path.
The calculation is the same as the other coverages: $$\text{path_coverage} = \frac{\text{paths_covered}}{\text{paths_total}} \cdot 100\%$$

Please see the example below.

{% include example-begin.html %}
In this example we focus on a small piece of the `count` method:

```java
if (!Character.isLetter(str.charAt(i)) 
        && (last == 's' || last == 'r')) {
    words++;
}
```

The decision of this if-statement contains three conditions and can be generalized to (A && ( B || C)), with A = `!Character.isLetter(str.charAt(i))`, B = `last == 's'` and C = `last == 'r'`.
To get $$100\%$$ path coverage, we would have to test all the possible combinations of these three conditions.
We construct a truth table to find the combinations:

<table style="width:50%">
    <tr><th>Tests</th><th>A</th><th>B</th><th>C</th><th>Outcome</th></tr>
    <tr><td>1</td><td>T</td><td>T</td><td>T</td><td>T</td></tr>
    <tr><td>2</td><td>T</td><td>T</td><td>F</td><td>T</td></tr>
    <tr><td>3</td><td>T</td><td>F</td><td>T</td><td>T</td></tr>
    <tr><td>4</td><td>T</td><td>F</td><td>F</td><td>F</td></tr>
    <tr><td>5</td><td>F</td><td>T</td><td>T</td><td>F</td></tr>
    <tr><td>6</td><td>F</td><td>T</td><td>F</td><td>F</td></tr>
    <tr><td>7</td><td>F</td><td>F</td><td>T</td><td>F</td></tr>
    <tr><td>8</td><td>F</td><td>F</td><td>F</td><td>F</td></tr>
</table>

This means that for full path coverage we would need 8 tests just to cover this if-statement.
That is quite a lot!
{% include example-end.html %}

By thinking about the path coverage of our test suite, we can come up of quite some good tests.
The main problem with path coverage is that it is not always feasable to test each path.
In the example we needed 8 tests for an if-statement that contains 3 conditions.
The amount of tests needed for full path coverage will grow exponentially with the amount of conditions in a decision.

For the last time, we will look at a better way of measuring test coverage in the next section.

## MC/DC

Modified condition/decision coverage, MC/DC from now on, looks at the combinations of conditions like path coverage does.
Instead of wanting to test each of the combinations, we take a certain selection of important combinations.
This deals with the feasability problem we found with the path coverage.

The idea of MC/DC is to exercise each condition that could independently affect the outcome of the entire decision.
To get the combinations of conditions needed for this, we first select certain pairs of two combinations for each condition.
In these pairs, only the condition we are selecting for should change and the outcome of the decision should change as well.
The other conditions have to stay the same, because we want the condition to independently affect the outcome.
This should become clearer with the example below.

After the pairs have been determined, we select the tests.
For each condition at least one of the found pairs should be fully covered and we try to select as few tests as possible.
The next example illustrates this process.

{% include example-begin.html %}
We consider the decision of the previous example with the corresponding truth table also given here:

<table style="width:50%">
    <tr><th>Tests</th><th>A</th><th>B</th><th>C</th><th>Outcome</th></tr>
    <tr><td>1</td><td>T</td><td>T</td><td>T</td><td>T</td></tr>
    <tr><td>2</td><td>T</td><td>T</td><td>F</td><td>T</td></tr>
    <tr><td>3</td><td>T</td><td>F</td><td>T</td><td>T</td></tr>
    <tr><td>4</td><td>T</td><td>F</td><td>F</td><td>F</td></tr>
    <tr><td>5</td><td>F</td><td>T</td><td>T</td><td>F</td></tr>
    <tr><td>6</td><td>F</td><td>T</td><td>F</td><td>F</td></tr>
    <tr><td>7</td><td>F</td><td>F</td><td>T</td><td>F</td></tr>
    <tr><td>8</td><td>F</td><td>F</td><td>F</td><td>F</td></tr>
</table>

We start with selecting the pairs of combinations (or tests) for condition A:\\
In test 1: A, B and C are all true and the outcome is true as well.
The test where A is changed and B and C are the same is test 5, as there A is false and B and C are still true.
The outcome of test 5 is false, which is a different outcome than test 1 so we have found the pair {1, 5}.\\
Now we try the next test.
In test 2 A is again true, B is true and C is false.
The test where B and C are the same is test 6.
The outcome from test 6 (false) is not the same as the outcome of test 2 (true) so we also have the pair {2, 6}.\\
We continue with the other combinations and find the pair {3, 7}.

Now we can go to B and we do the same as we did for A.
This time the possible pairs of combinations will be different:\\
In the first one all the conditions are true, so we need to find the test where B is false and A and C are true.
This is test 3, which has the same outcome so we cannot use this set.
If you continue with the other combinations you will only find the pair {2, 4}.

The final one is condition C.
Here also only one pair of combinations will work, which is {3, 4}.
We now have all the pairs for each of the conditions:

- A: {1, 5}, {2, 6}, {3, 7}
- B: {2, 4}
- C: {3, 4}

Now we are ready to select the combinations that we want to test.
For each condition we have to cover at least one of the pairs and we want to minimize the total amount of tests.
We do not have any choices with conditions B and C, as we only found one pair for each.
This means that we have to test combinations 2, 3 and 4.
Now we need to make sure to cover a pair of A.
To do so we can either add combination 6 or 7.
Let's pick 6: The combinations that we need for MC/DC are {2, 3, 4, 6}.

These are only 4 combinations/tests.
This is a lot better than the 8 tests we needed for the path coverage.
{% include example-end.html %}

In the example we saw that we need fewer tests when using MC/DC instead of path coverage.
In fact for path coverage $$2^n$$ tests are needed, while only $$n + 1$$ tests are needed for MC/DC with $$n$$ being the amount of conditions.
This is very significant for decisions with a lot of conditions.

## Exercises

Below you will find exercises with which you can practise the material you just learned.
You can view the answer to the question by clicking the button.

For the first couple of exercises we use the following code:

```java
public boolean remove(Object o) {
01.  if (o == null) {
02.    for (Node<E> x = first; x != null; x = x.next) {
03.      if (x.item == null) {
04.        unlink(x);
05.        return true;
         }
       }
06.  } else {
07.    for (Node<E> x = first; x != null; x = x.next) {
08.      if (o.equals(x.item)) {
09.        unlink(x);
10.        return true;
         }
       }
     }
11.  return false;
}
```

This is the implementation of JDK8's LinkedList remove method. Source: [OpenJDK](http://hg.openjdk.java.net/jdk8/jdk8/jdk/file/687fd7c7986d/src/share/classes/java/util/LinkedList.java).

{% include exercise-begin.html %}
Give a test suite (i.e. a set of tests) that achieves $$100\%$$ **line** coverage on the `remove` method.
Use as few tests as possible.

The documentation on Java 8's LinkedList methods, that may be needed in the tests, can be found in its [Javadoc](https://devdocs.io/openjdk~8/java/util/linkedlist).
{% include answer-begin.html %}
Example of a test suite that achieves $$100\%$$ line coverage:

```java
@Test
public void removeNullInListTest() {
    LinkedList<Integer> list = new LinkedList<>();

    list.add(null);

    assertTrue(list.remove(null));
}

@Test
public void removeElementInListTest() {
    LinkedList<Integer> list = new LinkedList<>();

    list.add(7);

    assertTrue(list.remove(7));
}

@Test
public void removeElementNotPresentInListTest() {
    LinkedList<Integer> list = new LinkedList<>();

    assertFalse(list.remove(5))
}
```

Note that there exists a lot of test suites that achieve $$100\%$$ line coverage, this is just an example.

You should have 3 tests.
At least one test is needed to cover lines 4 and 5 (`removeNullInListTest` in this case).
This test will also cover lines 1-3.

Then a test for lines 9 and 10 is needed (`removeElementInListTest`).
This test also covers lines 6-8.

Finally a third test is needed to cover line 11 (`removeElementNotPresentInListTest`).
{%include exercise-answer-end.html %}

{% include exercise-begin.html %}
Create the Control Flow Graph (CFG) for the `remove` method.
{% include answer-begin.html %}
![LinkedList exercise CFG](/assets/img/chapter5/exercises/CFG-LinkedList.svg)
L\<number\> in the diagram represents the line number of the code that is in the block or decision.
{%include exercise-answer-end.html %}

{% include exercise-begin.html %}
Give a test suite (i.e. a set of tests) that achieves $$100\%$$ **branch** coverage on the `remove` method.
Use as few tests as possible.

The documentation on Java 8's LinkedList methods, that may be needed in the tests, can be found in its [Javadoc](https://devdocs.io/openjdk~8/java/util/linkedlist).
{% include answer-begin.html %}
Example of a test suite that achieves $$100\%$$ branch coverage:

```java
@Test
public void removeNullAsSecondElementInListTest() {
  LinkedList<Integer> list = new LinkedList<>();

  list.add(5);
  list.add(null);

  assertTrue(list.remove(null));
}

@Test
public void removeNullNotPresentInListTest() {
  LinkedList<Integer> list = new LinkedList<>();

  assertFalse(list.remove(null));
}

@Test
public void removeElementSecondInListTest() {
  LinkedList<Integer> list = new LinkedList<>();

  list.add(5);
  list.add(7);

  assertTrue(list.remove(7));
}

@Test
public void removeElementNotPresentInListTest() {
  LinkedList<Integer> list = new LinkedList<>();

  assertFalse(list.remove(3));
}
```

This is just one example of a possible test suite.
Other tests can work just as well.
You should have a test suite of 4 tests.

With the CFG you can see that there are decisions in lines 1, 2, 3, 7 and 8.
To achieve $$100\%$$ branch coverage each of these decisions must evaluate to true and to false at least once in the test suite.

For the decision in line 1, we need to remove `null` and something else than `null`. This is done with the `removeElement` and `removeNull` tests.

Then for the decision in line 2 the node that `remove` is looking at should not be null and null at least once in the tests.
The node is `null` when the end of the list had been reached.
That only happens when the element that shouls be removed is not in the list.
Note that the decision in line 2 only gets executed when the element to remove is `null`.
In the tests, this means that the element should be found and not found at least once. 

The decision in line 3 checks if the node thet the method is at now has the element that should be deleted.
The tests should cover a case where the element is not the item that has to be removed and a case where the element is the item that should be removed.

The decisions in lines 7 and 8 are the same as in lines 2 and 3 respectively.
The only difference is that lines 7 and 8 will only be executed when the item to remove is not `null`.
{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
Consider the decision (A | C) & B with the corresponding decision table:

<table style="width:50%">
    <tr><th>Decision</th><th>A</th><th>B</th><th>C</th><th>(A | C) & B</th></tr>
    <tr><td>1</td><td>T</td><td>T</td><td>T</td><td>T</td></tr>
    <tr><td>2</td><td>T</td><td>T</td><td>F</td><td>T</td></tr>
    <tr><td>3</td><td>T</td><td>F</td><td>T</td><td>F</td></tr>
    <tr><td>4</td><td>T</td><td>F</td><td>F</td><td>F</td></tr>
    <tr><td>5</td><td>F</td><td>T</td><td>T</td><td>T</td></tr>
    <tr><td>6</td><td>F</td><td>T</td><td>F</td><td>F</td></tr>
    <tr><td>7</td><td>F</td><td>F</td><td>T</td><td>F</td></tr>
    <tr><td>8</td><td>F</td><td>F</td><td>F</td><td>F</td></tr>
</table>

What is the set with the minimum amount of tests needed for $$100\%$$ MC/DC (Modified Condition / Decision Coverage)?
{% include answer-begin.html %}
First, we find the pairs of tests that can be used for each of the conditions:

- A: {2, 6}
- B: {1, 3}, {2, 4}, {5, 7}
- C: {5, 6}

For A and C we need the decisions 2, 5 and 6.
Then you can choose to add either 4 or 7 to cover condition B.

The possible answers are: {2, 4, 5, 6} or {2, 5, 6, 7}.
{% include exercise-answer-end.html %}

For the next three exercises use the code below.
This method returns the longest substring that appears at both the beginning and end of the string without overlapping.
For example, `sameEnds("abXab")` returns `"ab"`.

```java
public String sameEnds(String string) {
01. int length = string.length();
02. int half = length / 2;

03. String left = "";
04. String right = "";

05. int size = 0;
06. for (int i = 0; i < half; i++) {
07.   left = left + string.charAt(i);
08.   right = string.charAt(length - 1 - i) + right;

09.   if (left.equals(right)) {
10.     size = left.length();
      }
    }

11. return string.substring(0, size);
}
```

This code is based on the [same ends problem](https://codingbat.com/prob/p131516).

{% include exercise-begin.html %}
Draw the Control Flow Graph of the source code above.
{% include answer-begin.html %}
![Control Flow Graph answer](/assets/img/chapter5/exercises/CFG-sameEnds.svg)

L\<number\> represents the line numbers that the code blocks cover.
{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
Give a test case (by the input string and expected output) that achieves 100% line coverage.
{% include answer-begin.html %}
A lot of input strings give 100% line coverage.
A very simple one is `"aa"`.
As long as the string is longer than one character and makes the condition in line 9 true, it will give 100% line coverage.
For `"aa"` the expected output is `"a"`.
{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
Given the source code of the `sameEnds` method. Which of the following statements is **not correct**?

1. It is possible to devise a single test case that achieves 100% line coverage and 100% decision coverage.
2. It is possible to devise a single test case that achieves 100% line coverage and 100% (basic) condition coverage.
3. It is possible to devise a single test case that achieves 100% line coverage and 100% decision + condition coverage.
4. It is possible to devise a single test case that achieves 100% line coverage and 100% path coverage.

{% include answer-begin.html %}
Answer 4. is correct.
The loop in the method makes it impossible to achieve 100% path coverage.
This would require us to test all possible number of iterations.
For the other answers we can come up with a test case: `"aXYa"`
{% include exercise-answer-end.html %}

Now consider this piece of code for the FizzBuzz problem.
Given an `int n`, it returns the string form of the number followed by "!".
So the int 6 would yield "6!".
Except if the number is divisable by 3 it returns "Fizz!" and if it is divisable by 5 it returns "Buzz!".
If the number is divisable by both 3 and 5 it returns "FuzzBuzz!"
Based on a [CodingBat problem](https://codingbat.com/prob/p115243)

```java
public String fizzString(int n) {
1.  if (n % 3 == 0 && n % 5 == 0)
2.       return "FizzBuzz!";
3.  if (n % 3 == 0)
4.      return "Fizz!";
5.  if (n % 5 == 0)
6.      return "Buzz!";
7.  return n + "!";
}
```

{% include exercise-begin.html %}
Assume we have two test cases with an input integer: T1 = 15 and T2 = 8.

What is the condition coverage these test cases give combined?

What is the decision coverage?
{% include answer-begin.html %}
First the condition coverage.
We have 8 conditions:

1. Line 1: `n % 3 == 0`, true and false
2. Line 1: `n % 5 == 0`, true and false
3. Line 3: `n % 3 == 0`, true and false
4. Line 5: `n % 5 == 0`, true and false

T1 makes conditions 1 and 2 true and then does not cover the other conditions.
T2 makes all the conditions false.
In total these test cases then cover $$2 + 4 = 6$$ conditions so the condition coverage is $$\frac{6}{8} \cdot 100\% = 75\%$$

Now the decision coverage.
We have 6 decision:

1. Line 1: `n % 3 == 0 && n % 5 == 0`, true and false
2. Line 3: `n % 3 == 0`, true and false
3. Line 5: `n % 5 == 0`, true and false

Now T1 makes decision 1 true and does not cover the other decisions.
T2 makes all the decision false.
Therefore the coverage is $$\frac{4}{6} \cdot 100\% = 66\%$$.
{% include exercise-answer-end.html %}

The next couple of exercises use Java's implementation of the LinkedList's computeIfPresent method.

```java
public V computeIfPresent(K key, BiFunction<? super K, ? super V, ? extends V> rf) {
01. if (rf == null) {
02.   throw new NullPointerException();
    }
  
03. Node<K,V> e;
04. V oldValue;
05. int hash = hash(key);
06. e = getNode(hash, key);
07. oldValue = e.value;
  
08. if (e != null && oldValue != null) {
  
09.   V v = rf.apply(key, oldValue);
  
10.   if (v != null) {
11.     e.value = v;
12.     afterNodeAccess(e);
13.     return v;
      }
      else {
14.     removeNode(hash, key, null, false, true);
      }
    }
15. return null;
}
```

{% include exercise-begin.html %}
Draw the Control Flow Graph (CFG) of the method above.
{% include answer-begin.html %}

![Control Flow Graph answer](/assets/img/chapter5/exercises/CFG-computeIfPresent.svg)

The L\<number\> in the blocks represent the line number corresponding to the blocks.
{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
How many tests do we need **at least** to achieve $$100\%$$ line coverage?
{% include answer-begin.html %}
3.

One test to cover lines 1 and 2.
Another test to cover lines 1, 3-7 and 8-13.
Finally another test to cover lines 14 and 15. This test will also automatically cover lines 1, 3-10.
{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
How many tests do we need **at least** to achieve $$100\%$$ branch coverage?
{% include answer-begin.html %}
4.

From the CFG we can see that there are 6 branches.
We need at least one test to cover the true branch from teh decision in line 1.
Then with another test we can cover false from L1 and false from L8.
We add another test to cover false from the decision in line 10.
Finally an additional test is needed to cover the true branch out of the decision in line 10.
This gives us a minimum of 4 tests.
{% include exercise-answer-end.html %}
