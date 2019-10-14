---
chapter-number: 7
title: Design by Contracts and Property-Based Testing
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
However, it does allow the system to check if it is running correctly by itself.
We do not have to run the test suite, but instead the system can check (part of) its behavior during the normal execution of the system.
Like with the test suite, if anything is not acting as expected, and error will be thrown because one of the self-tests is failing.
In software testing the self-tests are used as an additional check in the system additional to the test suite.

### Assertions
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
With Eclipse or Gradle we have to enable it ourselves.
To run the system normally with assertions enabled you always have to enable it manually.

When running the system with assertions enabled, we increase the fault sensitivity of the system.
This might seem undesirable, but when executing tests we want the tests to fail.
After all, if a test fail we find another fault in the system that we can then fix.

The assertions are a test oracle; software that informs us whether a test passes.
Oracles can be made with different approaches:
* Value comparison is most common. We know what the outcome is and verify that it is returned by, for example, a method. This is used in most unit testing.
* Version comparisons. In this case we do not know the direct value (in assertions we do not have a specific case as we have in tests), but we might have an older version that we know is correct. We can then use this older version to check the newer version.
* Property checks. Instead of focussing on a certain case like value comparison, property checks are more general rules (properties) that we assert on our code. For example, if we take square a number and then take the root, it should return the same number.

The assertions are mostly an extra safety measure.
If it is crucial that a system runs correctly, we can use the asserts to add some additional testing during the system's execution.
Assertions provide test oracles during the execution.
This means that we still need unit tests to actually exercise the system.
Assertions cannot replace these test cases.
Moreover, the assertions are often of a more general nature.
We still need the specific cases in the unit tests.

#### Tests from assertions
By considering the assertions in the code we can derive new test cases.
There are two cases that can be considered.
The assertion can be a disjunction of two conditions.
Then the test cases should trigger both of the possibilities in this assertion.
The assertions can also have boundaries.
For example when the assertions is checking if a value is in a certain range.
Now our test cases should give inputs that exercise these boundaries.

It might be tempting to make tests that make the assertions fail.
This, however, can never happen.
The assertions are meant to always be true.
If they fail, there is a bug in the system.
Therefore creating tests, that give inputs under which the assertions fail, makes no sense.

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
The method always has to check some extra things to handle the cases that would have been preconditions.
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
In Object-Oriented-Programming these checks on representations can also be applied at the class level.
This gives us class invariants.
A class invariant ensures that its condition will be true throughout the entire lifetime of each object of that class.
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
When handling more complicated invariants, we can split the invariant into more methods.
Then we use these methods in the `invariant` method.

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

## Design by Contracts
When creating a software system you often use external dependencies, such as a webservice.
In the remainder of this section we call the system that makes use of the external dependency the client.
The external system itself is called the server.

The client and server are bound by a contract.
The server does its job, as long as its methods are used properly by the client.
This relates strongly to the pre- and postconditions discussed earlier.
The client has to use the server's methods in a way that its preconditions hold.
Then the server guarantees that its postconditions hold after it is done with the method, i.e. it makes sure its method has the promised effect.
Now we can describe the system's behavior by the pre- and postconditions and use this way to form the contract.

Designing a system following such contracts is called Design by Contracts.
In such a design the contracts are represented by interfaces.
These interfaces are used by the client and implemented by the server.
The UML diagram illustrates this design.

![](/assets/img/chapter7/dbc_uml.svg)

### Subcontracting
In the UML diagram above we find that the implementation can have different pre-, postconditions, and invariant than its interface.
We specify the relative strength of these implementated conditions/invariants and the ones in the interface.
This is was subcontracting does.

The implementation must be able to work with the preconditions specified in the interface.
After all, the interface is the only thing the client sees of the system.
So, the implementation cannot add any preconditions to the server's preconditions.
In terms of strength, we now know that $$P'$$ has to be **weaker** than (or as weak as) $$P$$.

The postcondition work the other way around.
The implementation must do at least the same work as the interface, but it is allowed to do a bit more.
Therefore, $$Q'$$ should be **stronger** than (or as strong as) $$Q$$.

Finally, the interface guarantees that the invariant always holds.
Then, the implementation should also guarentee that at least the interface's invariant holds.
So, $$I'$$ should be **stronger** than (or as strong as) $$I$$.

In short, using the notation of the UML diagram:
* $$P'$$ **weaker** than $$P$$
* $$Q'$$ **stronger** than $$Q$$
* $$I'$$ **stronger** than $$I$$

The subcontract (the implementation) requires no more and ensures no less than the actual contract (the interface).

## Liskov Substitution Principle
The subcontracting follows the general notion of behavioral subtyping, proposed by Barbara Liskov.
The behavioral subtyping states that if we have a class `T` and this class has some subclasses.
Then the clients or users of this class `T` should be able to choose any of `T`'s subclasses.
All the public methods of class `T` have to do the same thing in all the subclasses.

This notion of behavioral subtyping is now known as the Liskov Substitution Principle (LSP).
The LSP states that if you use a class, you should be able to replace this class by one of its subclasses.
The sub-contracting we discussed earlier is just a formalization of this principle.
Proper class hiercies follow the Liskov Substitution Principle.
It is good to keep LSP in mind when designing and implementating a software system.

### Testing
We want to make sure that our class hierchies follow the Liskov Substitution Principle.
To do so we can create tests.
To test the LSP we have to make some test cases for the public methods of the super class and execute these tests with all its subclasses.
We could just create add the same tests to each of the subclasses' test suites.
This, however, leads to a lot of code duplication in the test code, which we would like to avoid.

{% include example-begin.html %}
In Java, the List interface is implemented by various subclasses.
Two examples are the ArrayList and LinkedList.
Creating the tests for each of the subclasses separately will result in the following structure.

![](/assets/img/chapter7/examples/subclass_test.svg)

The ArrayList and LinkedList will behave the same for the methods defined in List.
Therefore there will be duplicate tests for these methods.
{% include example-end.html %}

To avoid this code duplication we can create a test suite just for the superclass.
This test suite tests just the public methods of the super class.
The tests in this test suite should then be executed by for each of the subclasses of the superclass.

We want the test classes corresponding to the subclasses to execute the test cases of the super class.
This can be done by making the test classes extend the "super test class".
Then the "sub test class" will have all the common tests defined in the "super test class" and its own specific tests.
Moving the common implementation over multiple classes to the interface level (the super class) can be callled "Extract Superclass" refactoring.
We extract the common test cases and place it in a super class.

{% include example-begin.html %}
By using the inheritance in the test classes we get a new architecture.

![](/assets/img/chapter7/examples/parallel_architecture.svg)

Here the ArrayListTest and LinkedListTest extend the ListTest.
List is an interface, so the ListTest should be abstract.
We cannot make a List itself, so we should not be able to execute the ListTest without a test class corresponding to one of List's subclasses.
ListTest contains all the common tests of ArrayListTest and LinkedListTest.
ArrayListTest and LinkedListTest each can contain tests specific to the subclass.
{% include example-end.html %}

In the example you can see that the hierarchy of the test classes is similar to the hierarchy of the classes they test.
Therefore we say that we use a parallel class hierarchy in our test classes.

Now we have one problem.
How do we make sure that the "super test class" execute its tests with the correct subclass?
This depends on the test class that is executed and the subclass it is testing.
If we have class `T`, with subclasses `A` and `B`, then when executing tests for `A` we need the testclass for `T` to use an instance of `A` and when executing tests for `B` we need the testclass for `T` to use an instance of `B`.

One way to achieve this behavior is by using the Factory Method design pattern.
The factory method design pattern works as follows:
In the testclass for the interface level (the "super test class") we define an abstract method that returns an instance with the interface type.
By making the method abstract we force the testclasses for the concrete implementations to override this method.
In the overriden methods an instance of the specific subclass is returned.
This instance is then used to execute the tests in the interface level test class.

{% include example-begin.html %}
We want to use the Factory Method design pattern in our tests for the List.
We start by the interface level test class.
Here we define the abstract method that gives us a List.

```java
public abstract class ListTest {

    private List list;

    protected abstract List createList();

    @BeforeEach
    public void setUp() {
        list = createList();
    }

    // Common List tests using list
}
```

Then for this example we create a class to test the ArrayList.
We have to override the createList method and we can define any tests specific for the ArrayList.

```java
public class ArrayListTest extends ListTest {
    
    @Override
    protected List createList() {
        return new ArrayList();
    }

    // Tests specific for the ArrayList
}
```

Now the ArrayListTest inherits all the ListTest's tests, so these will be executed when we execute the ArrayListTest test suite.
Because the createList method returns an ArrayList the common test classes will use an ArrayList.
{% include example-end.html %}

## Property-Based Testing
In the assertions section we briefl mentioned property checks.
There we used the properties in assertions.
We can also use the properties for test cases instead of just assertions.

Properties should always hold, so we can test the properties with any input that we like.
To try a lot of inputs, without having to write them all ourselves, we typically make use of a generator.
This generator creates a series of random input values for a test function.
The test function then checks if the property holds using an assertion.
For each of the generated input values this assertion is checked and if one of them fails, the property does not hold.

The first implementation of this idea is called QuickCheck and was originally developed for Haskell.
Nowadays a lot of languages have an implementation of QuickCheck, including Java.
The Java implementation is made by Paul Holser and is available on his [github](https://github.com/pholser/junit-quickcheck).
All implementations of QuickCheck follow the same idea, but we will focus on the Java implementation.
First, we need to be able to define properties.
Similar to defining test methods we use an annotation on a method with an assertion to define a property: `@Property`.
Second, QuickCheck includes a number of generators for various types. 
For example: Strings, Integers, Lists, Dates etc.
To generate values we can simply add some parameters to the annotated method.
The arguments for these parameters will then be automatically generated by QuickCheck.
Third, we can define our own generators.
If we want to use one of our own classes in property-based testing, we can create a custom generator which generates random values for this class.
Fourth, there is a risk in generating random values for the test input.
The generator might create too much data to efficiently handle while testing.
Therefore QuickChecks has some ways to limit the amount of generated inputs.
We can even specify certain values or type of values to generate the input with.
Finally, QuickCheck has a process called shrinking.
Using random input values can result in very large inputs.
For example lists that are very long or strings with a lot of characters.
These inputs can be very hard to debug, so we would like to have smaller inputs.
When an input makes the property fail, QuickCheck tries to find shrink this input while it still makes the property fail.
That way it gets the small part of the larger input that actually causes the problem.

{% include example-begin.html %}
A property of Strings is that if we add two strings together the length of the result will be the same as the sum of the lengths of the two strings summed.
We can use property-based testing and the QuickCheck's implementation to make tests for this property.

```java
@Runwith(JUnitQuickcheck.class)
public class PropertyTest {

    @Property
    public void concatenationLength(String s1, String s2) {
        assertEquals(s1.length() + s2.length(), (s1 + s2).length())
    }
}
```
`concatenationLength` had the `Property` anotation, so QuickCheck will generate random values for `s1` and `s2` and execute the test with those values.
{% include example-end.html %}

Property-based testing changes the way we automate our test.
Usually we just automate the execution of the tests.
With property-based testing and by using QuickCheck's implementation we also automatically generate the inputs of the tests.
QuickCheck also allows us to make this part of the automated tests smaller, as we can define our own generators and constrain the existing ones.
To make these generators better, we can look at the entire test suite rather than just a single generator.
For example when the entire test suite has 60% code coverage, we can think about what inputs or combination of inputs might be needed to increate this coverage to 70%.

A lot of today's research goes into a search-based perspective on generating good input values for the tests.
We try to apply artificial intelligence to find inputs that exercise an important parts of the system.
More specifically, we can use evolutionary algorithms.
We have to define a fitness functions, which basically gives a value indicating how well a test case is. 
This fitness function is then applied to different test suites and used to compare them.
We start with a totally random test suite and by combining and mutating the good test suites we try to find the best test suite we can.

While the research's results are very promising, there still exist difficulties with this test approach.
The main problem is that if the input is randomized, how do we know for sure that the outcome is correct?
With the unit test we made so far we took certain inputs, thought about the correct outcome, and made the assertion use that outcome.
When generating random inputs we cannot think about the outcome every time.
The pre- and postconditions, contracts, and properties we discussed in this chapter can help us solve the problem.
By well defining the system in these terms we can use them as oracles in the test cases.
The conditions we made always have to be true, so we can use them in all the randomly generated test cases.

In the future, automatically generating test inputs will become more and more common.
To be able to use these generated inputs we need the oracles.
Therefore it is becoming more and more important to explicitly and well define the contracts and properties for the code that you are making.
