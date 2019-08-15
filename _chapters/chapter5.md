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
The amount of line coverage is computed as $$\frac{\text{lines_covered}}{\text{lines_total}} \cdot 100\%$$.
So if a set of tests executes all the lines in the code, the line coverage will be $$100\%$$.

{% include example-begin.html %}
We consider a piece of code that returns the points of the person that wins a game of [Black jack]("https://en.wikipedia.org/wiki/Blackjack").
{% highlight java %}
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
{% endhighlight %}
The `play()` method receives the amount of points of two players and returns the value like specified.
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



{% include exercise-begin.html %}
This is an exercise
{% include answer-begin.html %}
And this is the answer to the exercise
{% include exercise-answer-end.html %}
