---
chapter-number: 7
title: Design by Contracts
layout: chapter
---

[//]: TODO: add introduction to the chapter

## Self Testing
A self testing system is in principal a system that tests itself.
This may sound a bit weird so let's take a step back first.

The way we tested systems so far was by creating separate classes for the tests.
The production code and test code were completely separated.
The test suite (consisting of the test classes) exercises and then observes the system under test to check whether it is acting correctly.
If the system does something that is not expected by the test suite it gives an error, because one of the tests have failed.
The code in the test suite is completely redundant.
It does not add any behavior to the system.

With self-testing we move a bit of the test suite into the system itself.
We add some redundant code to the system.
This code, being redundant, does not change the functionalities of the code.
However, it does allow the system to check if it is running correclty by itself.
We do not have to run the test suite, but instead the system can check (part of) its behavior during the normal execution of the system.
Like with the test suite, if anything is not acting as expected, and error will be thrown because one of the self-tests is failing.
In software testing the self-tests are used as an additional check in the system additional to the test suite.

The simplest form of this self-testing is the assertion.
An assertion basically says that a certain condition has to be true at the time the assertion is executed.
In Java, to make an assertion we use the `assert` keyword:
```java
assert <condition> : "<message>";
```
Now the `assert` keywords checks if the `<condition>` is true.
If it is, nothing happens.
The program just continues its execution as everything is according to plan.
However, if the `<condition>` yields false, the `assert` throws an `AssertionError`.
In this error the assertion's message is also included.
This message is optonal, but can be very helpful to yourself and other's working with your code to find solutions to problems that they might face.
So try to always include a message that describes what is going wrong if the assertion is failing.

{% include example-begin.html %}
We have implemented a class representing a stack, we just show the `pop` method:
```java
public class MyStack {
    public Element pop() {
        assert count() > 0 : " The stack does not have any elements to pop."

        // ... actual method body ...

        assert count() == oldCount - 1;
    }
}
```
We did not include a message in the second assert for illustrative purposes.

In this method we check if a condition holds at the start: The stack should have at least one element.
Then after the actual method we check whether the count is now one lower than before popping.

These conditions are also known as pre- and postconditions.
We cover these in the following section.
{% include example-end.html %}

In Java asserts can be enabled or disabled.
If the asserts are disabled, they will never throw an `AssertionError` even if their conditions are false.
The default in Java is to disable the assertions.
This makes it very important to have assertions that are absolutely redundant.
They should not be needed for the system's execution.
To enable the asserts we have to run Java with a special argument in one of these two ways: `java -enableassertions` or `java -ea`.
When using Maven or IntelliJ the assertions are enabled automatically when running tests.
With Eclipse or Gradle we have to change some settings.
To run the system normally with assertions enabled you always have to change some settings.

The assertions are mostly an extra safety measure.
If it is crucial that a system runs correctly, we can use the asserts to add some additional testing during the system's execution.

## Pre- and Postconditions
We briefly mentioned pre- and postcondition in an example.
Now it is time to formalize the idea and see how to create good pre- and postconditions and their influence on the code that we are writing.

Tony Hoare pioneered reasoning about programs with assertions.
He proposed the now so-called Hoare Triples.
A Hoare Triple consist of a set of preconditions $$\{ P \}$$, a program $$A$$ and a set of postconditions $$\{ Q \}$$
Now we can express the Hoare Triple as follows: $$\{ P \}\ A\ \{ Q \}$$.
This can be read as: If we know that $$P$$ holds, and we execute $$A$$ then we end up in a state where $$Q$$ holds.
If there are no preconditions, i.e. no assumptions needed for the execution of $$A$$, we can simply set $$P$$ to true.

In a Hoare Triple the $$A$$ can be a single statement or span a whole program.
We look at $$A$$ as a method.
Then $$P$$ and $$Q$$ are the pre- and postcondition of the method $$A$$ respectively.
Now we can write the Hoare Triple as: { preconditions } method { postconditions}.

### Preconditions
When writing a method, each condition that need to hold for the method to successfully execute can be a preconditions.
In the code we turn each precondition to an assertion.

{% include example-begin.html %}
We have implemented a class to keep track of our favorite books.
We want to define some preconditions for the merge method.
This method adds the given books to the list of favorite books and then sends some notification to, for example, a phone.
```java
public class FavoriteBooks {
    List<Book> favorites;

    // ...

    public void merge(List<Book> books) {
        favorites.addAll(books);
        pushNotification.booksAdded(books);
    }
}
```
When creating pre-conditions we have to think about what needs to hold to let the method execute.
We can focus on the parameter `books` first.
This cannot be `null`, because then the `addAll` method will throw a `NullPointerException`.
It should also not be empty, because then we cannot add any books.
Finally, adding books that we already have does not make sense, so the `books` should not all be present in the `favorites` already.

Now we can take a look at the `favorites`.
This also cannot be `null` because then we cannot call `addAll` on favorites.

This gives us 4 preconditions and then also 4 asserts in the method:
```java
public class FavoriteBooks {
    // ...

    public void merge(List<Book> books) {
        assert books != null;
        assert favorites != null;
        assert !books.isEmpty();
        assert !favorites.containsAll(books);

        favorites.addAll(books);
        pushNotification.booksAdded(books);
    }
}
```
{% include example-end.html %}

#### Weakening preconditions
The amount of assumption made before a method can be executed (and with that the amount of preconditions) is a design choice.
We can generalize a method, such that it is able to be executed in more situations.
Then we can remove a precondition as the method itself can handle the situation where the precondition would be false.
This makes the method more generally applicable, but is also increases its complexity.
The method always have to check some extra things to handle the cases that would have been preconditions.
Finding the balance between the amount of preconditions and complexity of the method is part of designing the system.

{% include example-begin.html %}
We can remove some of the preconditions of the `merge` method by adding some if-statements to the method.
First, we can try to remove the `!books.isEmpty()` assertions.
This means that the method `merge` has to handle empty `books` lists itself.
```java
public class FavoriteBooks {
    // ...

    public void merge(List<Book> books) {
        assert books != null;
        assert favorites != null;
        assert !favorites.containsAll(books);

        if (!books.isEmpty()) {
            favorites.addAll(books);
            pushNotification.booksAdded(books);
        }
    }
}
```
Now, by generalizing the `merge` method, we have removed one of the preconditions.
We can even remove the `!favorites.containsAll(books)` assertion by adding some more functionality to the method.
```java
public class FavoriteBooks {
    // ...

    public void merge(List<Book> books) {
        assert books != null;
        assert favorites != null;

        List<Book> newBooks = books.removeAll(favorites);

        if (!newBooks.isEmpty()) {
            favorites.addAll(newBooks);
            pushNotification.booksAdded(newBooks);
        }
    }
}
```
Now by making the method complexer and removing some of its preconditions, the method is easier to call.
This does come at the cost that the method always has to filter the `books` list and check if this filtered list is empty or not.
{% include example-end.html %}

### Postconditions
If the preconditions of a method hold and the method is called, then at the end of the method its postconditions should hold.
It is important to realise that these postconditions only have to hold if the preconditions held when the method was called.
Postconditions formalize the effects that a method guarantees to have when it is done with its execution.
Postconditions can be hard to formalize to a boolean expression.
The effects of a method are just too hard to observe in the class itself sometimes.
This is why postconditions do not always cover all the effects of a method.
Similarly preconditions may not always have all the assumptions needed for a method.

{% include example-begin.html %}
The `merge` method of the previous examples does two things.
It adds the new books to the `favorites` list.
We can turn this into a boolean expression so we can formulate this as a postcondition.
The other effect of the method is the notification that is sent.
Unfortunately we cannot easily see if that has actually happened in the method.
In a test suite we would probably mock the `pushNotification` and then use `Mockito.verify` to verify that `booksAdded` was called.
We cannot do this in postconditions or assertions so we can add just one post condition.
```java
public class FavoriteBooks {
    // ...

    public void merge(List<Book> books) {
        assert books != null;
        assert favorites != null;

        List<Book> newBooks = books.removeAll(favorites);

        if (!newBooks.isEmpty()) {
            favorites.addAll(newBooks);
            pushNotification.booksAdded(newBooks);
        }

        assert favorites.containsAll(books);
    }
}
```
{% include example-end.html %}

#### Composite postconditions
For complex methods, the postconditions also become more complex.
If a method has multiple return statements, it is good to think if these are actually needed.
Maybe it is possible to combine them to one return statement with a general postcondition.
Otherwise, the postcondition essentially becomes a disjunction of propositions.
Each return statement forms a possible postcondition (proposition) and the method guarantees that one of these postconditions is met.

{% include example-begin.html %}
We have a method body that has three conditions and three different return statements.
This also gives us three postconditions.
The placing of these post conditions now becomes quite important, so the whole method is becoming rather complex with the postconditions.
```java
if (A) {
    // ...
    if (B) {
        // ...
        assert PC1;
        return ...;
    } else {
        // ...
        assert PC2;
        return ...;
    }
}
// ...
assert PC3;
return ...;
```
Now if `A` and `B` are true postcondition 1 should hold.
If `A` is true and `B` is false, postcondition 2 should hold.
Finally, if `A` is false, postcondition 3 should hold.
{% include example-end.html %}

## Invariants
We have seen preconditions that need to hold before a method's execution and postconditions that need to hold after a method's execution.
Now we move to conditions that always have to hold, so before and after a method's execution.
These conditions are called invariants.
An invariant is thus a condition that holds throughout the entire lifetime of a system, an object or a datastructure.

A simple way of using invariants is by creating a checker method.
This method will go through the datastructure/object/system and asserts whether the invariants hold.
If an invariant does not hold it will then throw an `AssertionError`.
For simpler invariant we can also use a boolean method that checks it he datastructure/object/system is still okay.
This looks like the same method, but an important difference is that the boolean method only returns true or false and in the checker method an `AssertionError` is thrown at a certain place where it went wrong.
We can also add messages to these errors so in general it is easier to find out what the problem is with the checker method.

{% include example-begin.html %}
Let's say we have a binary tree datastructure.
An invariant for this datastructure would be that each when a parent points to a child, then the child should point to this parent.

We can make a method that checks if this representation is correct in the given binary tree.
```java
public void checkRep(BinaryTree tree) {
    BinaryTree left = tree.getLeft();
    BinaryTree right = tree.getRight();
    
    assert (left == null || left.getParent() == tree) && 
        (right == null || right.getParent() == tree)
    
    if (left != null) {
        checkRep(left);
    }
    if (right != null) {
        checkRep(right);
    }
}
```

First we check if the children nodes of the current node are pointing to this node as parent.
Then we continue by checking the child nodes the same way we checked the current node.
{% include example-end.html %}

### Class invariant
In Object-Oriented-Programming these checks on representations can also be applied at the class levels.
This gives us class invariants.
A class variant ensures that its condition will be true throughout the entire lifetime of each object of that class.
The first time it should be true is after the constructor is done.
Then after each public method is done the class invariant should still hold.
This means that a private method invoked by a public method can leave the object with the class invariant being false.
However, the public method that invoked the private method should then fix this and end with the class invariant again being true.
Finally, the methods can assume that, when they start, the class invariant holds.

This is all formalized by Bertrand Meyer as: The class variant indicates that a proposition P can be a class invariant if it holds after construction, and before and after any call to a public method assuming that the public methods are called with their preconditions being true.

Of course, we want to know how to implement these class invariants.
To implement simple class invariant in Java we can use the boolean method that checks if the representation is okay.
We usually call this method `invariant`.
Then we assert the return value of this method after the constructor, and before and after each public method.
In these public methods the only preconditions and postconditions that have to hold additionally are the onces that are not in the invariant.

{% include example-begin.html %}
We return to the `FavoriteBooks` with the `merge` method.
We had a precondition saying that `favorites != null`.
Actually this should always be true, so we can turn it into a class variant.
Additionally we can add the condition that `pushNotification != null`.
```java
public class FavoriteBooks {
    List<Book> favorites;
    Listener pushNotification;

    public FavoriteBooks(...) {
        favorites = ...;
        pushNotification = ...;

        // ...

        assert invariant();
    }

    public void merge(List<Book> books) {
        assert invariant();

        // Remaining preconditions
        assert books != null;

        List<Book> newBooks = books.removeAll(favorites);

        if (!newBooks.isEmpty()) {
            favorites.addAll(newBooks);
            pushNotification.booksAdded(newBooks);
        }

        // Remaining postconditions
        assert favorites.containsAll(books);

        assert invariant();
    }

    protected boolean invariant() {
        return favorites != null && pushNotification != null;
    }
}
```
You can see that the `invariant` method checks the two conditions.
Then we call `invariant` before and after `merge` and we only assert the pre- and postconditions that are not covered in the `invariant` method.
At the end of the constructor we also asser the `invariant` method.
{% include example-end.html %}
