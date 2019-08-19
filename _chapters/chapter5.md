---
chapter-number: 5
title: Structural-Based Testing
layout: chapter
---

[//]: Called functional testing
Earlier we discussed how to test software using requirements.
In this chapter, we will use a different source of information when creating tests.
Instead of looking at the requirements of the software we will look at the source code itself.
This is called structural-based testing.

We cover a couple of different ways to do structural-based testing.
This comes down to different kinds of test coverage.
A certain amount of test coverage indicates the amount of code that is executed (or used by the program) when executing the tests.

We cover the following kinds of test coverage:
* Line coverage
* Statement coverage
* Branch coverage
* Condition coverage
* Path coverage
* MC/DC coverage

## Line coverage
As the name suggests, when determining the line coverage we look at the amount of lines that are covered by the tests.
The amount of line coverage is computed as $$\text{line_coverage} = \frac{\text{lines_covered}}{\text{lines_total}} \cdot 100\%$$.
So if a set of tests executes all the lines in the code, the line coverage will be $$100\%$$.
We only count the lines inside of a method. 
We do not count the method declaration at the top.

{% include example-begin.html %}
We consider a piece of code that returns the points of the person that wins a game of [Black jack]("https://en.wikipedia.org/wiki/Blackjack").
```java
public class BlackJack {
    public int play(int left, int right) {
1.      int ln = left;
2.      int rn = right;
3.      if (ln > 21)
4.          ln = 0;
5.      if (rn > 21)
6.          rn = 0;
7.      if (ln > rn)
8.          return ln;
9.      else
10.         return rn;
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
The first test executes lines 1-7 and 9, 10 as both values are higher than 21 and when the program arrives at line 7 ln equals rn so the statement `ln > rn` is `false`.
This means that 9 out of the 10 lines are covered and the line coverage is $$\frac{9}{10}\cdot100\% = 90\%$$.
The second test, `leftPlayerWins`, executes lines 1-3, 5, 7 and 8. 
Line 8 was the only line that the first test did not cover.
So when we execute both of our tests, the line coverage is $$100\%$$.
{% include example-end.html %}

## Statement coverage
The first way of determining test coverage we showed is with line coverage.
However, counting the covered lines is not always a good way of calculating the coverage.
The amount of lines in a piece of code is dependent on the programmer that writes the code.
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

**What are branches?** <br>
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
We write a program for the following problem: <br>
Given a sentence, you should count the number of words that end with either an “s” or an “r”. 
A word ends when a non-letter appears.

The code of the program is:
```java
public class CountLetters {
    public int count(String str) {
1.      int words = 0; 
2.      char last = ' ';
3.      for (int i = 0; i < str.length(); i++) {
4.          if (!Character.isLetter(str.charAt(i)) 
5.                  && (last == 's' || last == 'r')) {
6.              words++;
7.          }
8.          last = str.charAt(i);
9.      }
10.     if (last == 'r' || last == 's') 
11.         words++;
12.     return words;
    }
}
```
And we have the corresponding CFG:
<center> <img src="/assets/img/CFG-branch-example.svg"/> </center>
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

        assertThat(words).isEqualTo(2);
    }

    @Test
    public void lastWordDoesntMatch() {

        int words = new CountLetters()
            .count("cats|dog");

        assertThat(words).isEqualTo(1);
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
Once again we look at the program that counts the words ending with an r or an s.
Instead of branch coverage, we are interested in the condition coverage that the tests give.

We start by splitting the decisions in the CFG:
<center> <img src="/assets/img/CFG-condition-example.svg"/> </center>
There are quite a bit more conditions than branches.
This can also be seen in the coverages of the tests that we wrote earlier.

The first test now covers 7 conditions and the total amount of conditions is 12.
So the condition coverage is now: $$\frac{7}{12} \cdot 100\% = 58\%$$.
This is quite a bit less than the $$83\%$$ branch coverage, so we need some more tests to test the method well.
{% include example-end.html %}

Condition coverage is an improvement over the branch coverage.
However, we will try to do even better in the next section.


