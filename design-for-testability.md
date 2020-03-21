---
chapter-number: 10
title: Design for Testability
layout: chapter
toc: true
author: Maurício Aniche
---

## Introduction

Now that we know how to use mocks and what we can use them for, 
it is time to take another look at how we design our software systems.

In the example of the Mocking chapter, it was very easy to make sure that the `InvoiceFilter` used our mock, instead of the concrete instance of the class.
This is not always the case. Note how we had to refactor the code for that happen.  **We have to design our code in a way that it makes it easy to test the code!**

Testability is related to the easeness of writing automated tests to that
code.
We know that automated tests are crucial in software development; therefore, it is essential that our code is testable.

In this chapter, we'll discuss some design practices that increases
the testability of our software systems.

<iframe width="560" height="315" src="https://www.youtube.com/embed/iVJNaG3iqrQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Dependency Injection

Dependency injection is a design choice we can use to make our code more testable.
We will illustrate what dependency injection is it by means of an analogy:

Say we need a hammer to perform a certain task.
When we are asked to do this task, we could go search and find the hammer.
Then, once we have the hammer, we can use it to perform the task.
However, another approach is to say that we need a hammer when someone asks us to perform the task.
This way, instead of getting the hammer ourselves, we get it from the person that wants us to do the task.

We can do the same when managing the dependencies in our code.
Instead of the class instantiating dependency itself, the class asks for the dependency (via constructor or a setter, for example).

We actually applied this idea in the Mocking chapter already. But let's revisit it:

{% include example-begin.html %}
In the Mockito example, it was easy to make the `InvoiveFilter` use the mock.
Let's assume that the `InvoiveFilter` is implemented as follows:

```java
public class InvoiceFilter {

  public void filter() {
    InvoiceDao dao = new InvoiceDao();

    // ...
  }

}
```

In other words, the `InvoiceFilter` itself instantiates the `InvoiceDao`. 
In this implementation, there is no way to pass the mock to the `InvoiceFilter`. Any test code we write will necessarily use a concrete `InvoiceDao`. 
As we cannot control the way the `InvoiceDao` operates, this makes it a lot harder to write automated tests.
Our tests
will need a working database to run!

Instead, we can design our class in a way that it allows dependencies
to be injected. Note how we receive the dependency via constructor now:

```java
public class InvoiceFilter {

  private InvoiceDao invoiceDao;

  public InvoiceFilter(InvoiceDao invoiceDao) {
    this.invoiceDao = invoiceDao;
  }

  public void filter() {
    // ...
  }
}
```

Now we can instantiate the `InvoiceFilter` and pass it a `InvoiceDao` mock in the test code. This `InvoiceFilter` also enables the production code to pass a concrete `InvoiceDao` when the program is run normally (after all, we want it to access the real database in production!).

This simple change in the design of the class makes the creation of
automated tests easier and, therefore, increases the testability of the code.
{% include example-end.html %}

The dependency injection principle improves our code in many ways:

* Enables us to mock the dependencies in the test code.
* Makes all the dependencies more explicit; after all, they all need to
be injected (via constructor, for example).
* The class becomes more extensible. As a client of the class, you can pass any dependency via the constructor. Suppose a class depends on a type `A` (and receives it via constructor). As a client, you can pass `A` or any implementation of `A`, e.g., if `A` is `List`, you can pass `ArrayList` or `LinkedList`. Your class now can work with many different implementations of `A`. (You should read more about the Open/Closed Principle).

<iframe width="560" height="315" src="https://www.youtube.com/embed/mGdsdBEWB5E" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


## Ports and Adapters

The way a software system is designed influences how easy it is to test the system.
As we discussed before, the idea of designing a system in a way that it is testable is called **design for testability**.
It is important that a software developer knows about certain ways to design for testability in order to implement systems well.

In general, design for testability comes down to separating the domain and the infrastructure of the systems.
The domain is the core of the system: The business rules, its logic, its entities, etc.
This is very specific to the system that is being built.

A system also commonly makes use of a database, or webservices, or any other external components.
We consider them as *infrastructure*. In our software systems,
we often have classes which the role is to make a bridge between the external component and the core of our sytem.

To increase testability, we need to separate these two layers (core/domain and infrastructure) as much as possible.
In practice, we observe that when domain code and infrastructure code are mixed up together, the system just gets harder to test.

To separate the domain and the infrastructure, we can use the idea of **Ports and Adapters**, as named by Alistair Cockburn.
Ports & Adapters is also called the **Hexagonal Architecture**.
Following this idea, the domain (business logic) depends on "Ports" rather than directly on the infrastructure.
These ports are just interfaces that define what the infrastructure is able to do.
These ports are completely separated from the implementation of the infrastructure.
The "adapters", on the other hand, are very close to the infrastructure. 
These are the implementations of the ports that talk to the database or webservice etc. They know how the infrastructure works and how to communicate with it.

In the schema below, you can see that the ports are therefore part of the domain.

![Hexagonal Architecture](/assets/img/design-for-testability/hexagonal_architecture.svg)
 
Ports and Adapters helps us a lot with the testability of our code.
After all, if our core domain depends only on ports, we can easily mock them!

To sum up, make sure your domain/core code does not depend on the infrastructure
directly. Create a layer that abstracts the infrastructure away! This layer can then be easily mocked.

*Note:* The idea of separating the domain and the infrastructure is also intensively
discussed in the Domain-Driven Design book (which we recommend you to read!).

<iframe width="560" height="315" src="https://www.youtube.com/embed/hv1XV87lJgA" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Design for testability tips

We end this chapter with a couple of practical tips that you can use to create a well designed, testable software system.

- **Cohesion**: Cohesive classes are classes that do only one thing. Cohesive classes tend to be easier to test. If one of your classes is not cohesive, you can split the class into multiple small cohesive classes. This way you can test each separate class more easily.

- **Coupling**: Coupling represents the amount of classes that a class depends on. A highly coupled class needs a lot of other classes to work. Coupling hurts testability. Imagine having to create ten mocks, define the behavior of these ten mocks just one class. Reducing coupling is tricky and maybe one of the biggest challenges in software design. To reduce coupling, you can, for example, group some of the dependencies together and/or create bigger abstractions.

- **Complex Conditions**: When conditions are very complex (i.e., are composed of multiple boolean operations), maybe it is better split them into multiple conditions. Testing these simpler conditions is easier than testing one very complex condition.

- **Private methods**: A common question is whether to test private methods or not. The answer is usually "no". In principle, we would like to test the private methods only through the public methods that use them. This means that we test if the public method behaves correctly, not the private method. If you feel like you want to test the private method in isolation (because it might be a very large important method), this might mean that the method should probably have its own separate class, which can be tested in isolation. 

- **Static metods**: Static methods can hurt testability, as we cannot control the behavior of the static methods (i.e., they are hard to mock). Therefore, we avoid using static methods whenever possible.

- **Layers**: When using other's code or external dependencies, creating layers/classes that abstract away the dependency might help you in increasing testability. Do not be afraid to create these extra layers (although they do add complexity). 

- **Infrastructure**: Again, make sure not to mix the infrastructure with the domain. You can use the methods we discussed above.

- **Encapsulation**: Encapsulation is about bringing the behavior of a class close to the data. Encapsulation will help you identify the problems in the code easier.

Note how there is a [deep synergy between well design production code and testability](https://www.youtube.com/watch?v=4cVZvoFGJTU)!

<iframe width="560" height="315" src="https://www.youtube.com/embed/VaScxLhsDBQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## References

* Cockburn, Alistair. The Hexagonal Architecture. https://wiki.c2.com/?HexagonalArchitecture

* Hevery, Misko. The Testability Guide. http://misko.hevery.com/attachments/Guide-Writing%20Testable%20Code.pdf


## Exercises


{% include exercise-begin.html %}
How can we improve the testability of the `OrderDeliveryBatch` class?

```java
public class OrderDeliveryBatch {

  public void runBatch() {

    OrderDao dao = new OrderDao();
    DeliveryStartProcess delivery = new DeliveryStartProcess();

    List<Order> orders = dao.paidButNotDelivered();

    for (Order order : orders) {
      delivery.start(order);

      if (order.isInternational()) {
        order.setDeliveryDate("5 days from now");
      } else {
        order.setDeliveryDate("2 days from now");
      }
    }
  }
}

class OrderDao {
  // accesses a database
}

class DeliveryStartProcess {
  // communicates with a third-party webservice
}
```

What techniques can we apply? What would the new implementation look like? Think about what you would need to do to test the `OrderDeliveryBatch` class.
{% include answer-begin.html %}
To test just the `runBatch` method of `OrderDeliveryBatch` (for example in a unit test) we need to be able to use mocks for at least the `dao` and `delivery` objects.
In the current implementation this is not possible, as we cannot change `dao` or `delivery` from outside.
In other words: We want to improve the controllability to improve the testability.

The technique that we use to do so is called dependency injection.
We can give the `dao` and `delivery` in a parameter of the method:

```java
public class OrderDeliveryBatch {

  public void runBatch(OrderDao dao, DeliveryStartProcess delivery) {
    List<Order> orders = dao.paidButNotDelivered();

    for (Order order : orders) {
      delivery.start(order);

      if (order.isInternational()) {
        order.setDeliveryDate("5 days from now");
      } else {
        order.setDeliveryDate("2 days from now");
      }
    }
  }
}
```

Alternatively we can create fields for the `dao` and `delivery` and a constructor that sets the fields:

```java
public class OrderDeliveryBatch {

  private OrderDao dao;
  private DeliveryStartProcess delivery;

  public OrderDeliveryBatch(OrderDao dao, DeliveryStartProcess delivery) {
    this.dao = dao;
    this.delivery = delivery;
  }

  public void runBatch() {
    List<Order> orders = dao.paidButNotDelivered();

    for (Order order : orders) {
      delivery.start(order);

      if (order.isInternational()) {
        order.setDeliveryDate("5 days from now");
      } else {
        order.setDeliveryDate("2 days from now");
      }
    }
  }
}
```

{% include exercise-answer-end.html %}



{% include exercise-begin.html %}
Consider the following requirement and implementation.

```text
A webshop gives a discount of 15% whenever it's King's Day.
```

```java
public class KingsDayDiscount {

  public double discount(double value) {

    Calendar today = Calendar.getInstance();

    boolean isKingsDay = today.get(MONTH) == Calendar.APRIL
        && today.get(DAY_OF_MONTH) == 27;

    return isKingsDay ? value * 0.15 : 0;

  }
}
```

We want to create a unit test for this class.

Why does this class have bad testability?
What can we do to improve the testability?

I.e. what makes it very hard to test the method?
{% include answer-begin.html %}
The method and class lack controllability.
We cannot change the values that `Calender` gives in the method because the `getInstance` method is static.
Mockito cannot really mock static methods, which is why we tend to avoid using static methods.

We can use depencency injection to make sure we can control the `today` object by using a mock.
{% include exercise-answer-end.html %}



{% include exercise-begin.html %}
Sarah just joined a mobile app team that has been trying to write automated tests for a while.
The team wants to write unit tests for some part of their code, but "that's really hard", according to the developers.

After some code review, the developers themselves listed the following
problems in their codebase:

1. May classes mix infrastructure and business rules
2. The database has large tables and no indexes
3. Use of static methods
4. Some classes have too many attributes/fields

To increase the testability, the team has budget to work on two out of the four issues above.
Which items should Sarah recommend them to tackle first?

Note: All of the four issues should obviously be fixed.
However, try to prioritize the two most important onces: Which influence the testability the most?
{% include answer-begin.html %}
The correct answer is 1 and 3.

As we discussed it is very important to keep the domain and infrastructure separated for the testability.
This can be done, for example, by using Ports and Adapters.

Static methods cannot be mocked and are therefore very bad for the controllability of the code.
Code that has low controllability also has a low testability, so replacing the static methods by non-static ones will be very beneficial to the testability.

The large tables and lack of indices do not really influence the testability, especially not when talking about unit tests.
There we end up mocking the classes interacting with the database anyway.

Too many attributes/fields can hurt testability as we might need to create a lot of mocks for just one class under test.
However, the static methods and mixed domain and infrastructure are worse for the testability than a large amount of attributes/fields.
{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
Observability and controllability are two important concepts when it comes to software testing.
The three developers below could benefit from improving either the observability or the controllability of the system/class under test.

1. "I can't really assert that the method under test worked well."
2. "I need to make sure this class starts with that boolean set to false, but I simply can't do it."
3. "I just instantiated the mock object, but there's simply no way to inject it in the class."

For each developer's problem, is it related to observability or controllability?
{% include answer-begin.html %}

1. Observability: The developer needs to be able to better observe the result.
2. Controllability: The developer has to be able to change (control) a certain variable or field.
3. Controllability: The developer should be able to control what instance of a class the class under test uses.

{% include exercise-answer-end.html %}
