---
chapter-number: 9
title: Mocking
layout: chapter
toc: true
---

## Mocks

When unit testing a piece of code we want to test this code in isolation.
If the code requires some external dependency to run, this forms a problem.
We do not want to use this external component when we are just testing the piece of code that uses it.
To run the test without using external components we use mock objects.

Mocking an object creates a simulation of this object.
To handle external dependencies we mock (simulate) the class in the system that is used to interact with the dependency.
Instead of doing the actual work of the external components mock objects just returns fake results.
These return values can be configured inside of the test itself.
For testing, mock objects have some advantages.
Returning these pre-configured values is way faster than accessing an external component.
Simulating objects also gives a lot more control.
If we, for example, want to make sure the system keeps going even if one of its dependencies crashes, we can just tell the simulation to crash.

Mock objects are widely used in software testing, mainly to increase testability.
As we have discussed, external systems that the tested system relies on are often mocked.
These external systems include for example databases or webservices that are used by the system.
Mocks are also used to simulate exceptions that are hard to trigger in the actual system.
When using third party libraries that are hard to control we use mocks to simulate their behavior in certain ways that are useful to the tests.

Besides using mocks to simulate the behavior of components needed to run the system, mocks can be used to test the interaction of the system with a component easily.
This way we use mocks to increase the observability, i.e. we can observe the system's behavior easier.
Simulating behavior of components like we discussed earlier is using mocks to increase the controllability.

To use mocks in our tests we create a mock object.
Then, once it has been created, we give it to the class that normally uses an actual implementation of the mocked object.
This class is now using the mocked object while the tests are executed.
At first, the mock does not know how to do anything.
So, before running the tests, we have to tell it exactly what to do when a certain method is called.
In the next section we will look at how this is done in Java.

## Mockito

In Java the most used framework for mocking is Mockito ([mockito.org](https://site.mockito.org)).
To perform the steps we mentioned above we use a couple of methods provided by mockito:

- `mock(<class>)`: creates a mock object of the given runtime class. The runtime class can be retrieved from any class by `<ClassName>.class`.
- `when(<mock>.<method>).thenReturn(<value>)`: defines the behavior when the given method is called on the mock. In this case `<value>` will be returned.
- `verify(<mock>).<method>`: is a test that passes when the method is called on the mock and fails otherwise.

Much more functionalities are described in [mockito's documentation](https://javadoc.io/page/org.mockito/mockito-core/latest/org/mockito/Mockito.html).

{% include example-begin.html %}
Suppose we have a function that filters invoices.
These invoices are saved in a database and retrieved from the database by this function.
The invoices are filtered on their price.
All those above 100 are filtered.
Without mocks, to test the method we need to insert some testing invoices first:

```java
@Test
public void filterInvoicesTest() {
  InvoiceDao dao = new InvoiceDao();
  Invoice i1 = new Invoice("M", 20.0);
  Invoice i2 = new Invoice("A", 300.0);
  dao.save(i1);
  dao.save(i2);

  InvoiceFilter f = new InvoiceFilter(dao);
  List<Invoice> result = f.filter();

  assertEquals(1, result.size());
  assertEquals(i1, results.get(0));
  dao.close();
}
```

Now instead of using the database, we want to replace it with a mock object.
This way our test will be faster and we can more easily control what the Database-Access-Object returns.

```java
@Test
public void filterInvoicesTest() {
  InvoiceDao dao = mock(InvoiceDao.class);
  Invoice i1 = new Invoice("M", 20.0);
  Invoice i2 = new Invoice("A", 300.0);

  List<Invoice> list = Arrays.asList(i1, i2);
  when(dao.all()).thenReturn(list);

  InvoiceFilter f = new InvoiceFilter(dao);
  List<Invoice> result = f.filter();

  assertEquals(1, result.size());
  assertEquals(i1, results.get(0));
}
```

The InvoiceFilter uses the `all` method in the `InvoiceDao` to get the invoices.
With the mock we can easily give the two invoices that we want to test on.
Using this mock also makes sure we do not have to keep a database running while executing the tests.
{% include example-end.html %}



## Exercises

Below you will find a couple of exercises to practise with the material covered in this chapter.
After each exercise you can find the answer to the question.

The first couple of exercises use the following requirement and corresponding implementation.

```text
A webshop runs a batch job, once a day, to deliver all orders that
have been paid. It also sets the delivery date, according to whether
the order is from a customer abroad.

Note: A batch job is a computer program that executes a (often huge) sequence of commands.
For example, processing all the orders that were made in a day.
```

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

{% include exercise-begin.html %}
As a tester, you have to decide which test level (i.e., unit, integration, or system test) you will apply.
Which of the following statements is true?

1. Integration tests, although more complicated (in terms of automation) than unit tests, would better help in finding bugs in the communication with the webservice and/or the communication with the database.
2. Given that unit tests could be easily written (by using mocks) and they would cover as much as integration tests would, it is the best choice in this problem.
3. The most effective way to find bugs in this code is through system tests. In this case, the tester should run the entire system and exercise the batch process. Given that this code can be easily mocked, system tests would also be cheap.
4. While all the test levels can be used for this problem, testers would likely find more bugs if they choose one level and explore all the possibilities and corner cases there.

{% include answer-begin.html %}
The correct answer is 1.

1. This is correct. The primary use of integration tests is to find mistakes in the communication between a system and its external dependencies
2. Unit tests do not cover as much as integration tests. They cannot cover the communication between different components of the system.
3. When using system tests the bugs will not be easy to identify and find, because it can be anywhere in the system if the test fails. Additionally, system tests want to execute the whole system as if it is run normally, so we cannot just mock the code in a system test.
4. The different test levels do not find the same kind of bugs, so settling down on one of the levels is not a good idea.

{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
How can we improve the testability of the `OrderDeliveryBatch` class?

What technique can we apply?

What would the new implementation look like?

Think about what you would need to do to test the `OrderDeliveryBatch` class.
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
Which of the following Mockito lines would never appear in a test for the `OrderDeliveryBatch` class?

1. `OrderDao dao = Mockito.mock(OrderDao.class);`
2. `Mockito.verify(delivery).start(order);` (assume `order` is an instance of `Order`)
3. `Mockito.when(dao.paidButNotDelivered()).thenReturn(list);` (assume `dao` is an instance of `OrderDao` and `list` is an instance of `List<Order>`)
4. `OrderDeliveryBatch batch = Mockito.mock(OrderDeliveryBatch.class);`

{% include answer-begin.html %}
The correct answer is 4.

1. This line is required to create a mock for the `OrderDao` class.
2. With this line we check that the methods calls start with `order` on a `delivery` mock we defined. The method is supposed to start each order that is paid but not delivered.
3. With this line we define the behavior of the `paidButNotDelivered` method by telling the mock that it should return an earlier defined `list`.
4. We would never see this happen in a test that is testing the `OrderDeliveryBatch` class. By mocking the class we do not use any of its implementation. But the implementation is the exact thing we want to test. In general we never mock the class under test.

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
We have the following skeleton for a diagram illustrating the Test Driven Development cycle.
What words/sentences should be at the numbers?

![Test Driven Development exercise skeleton](/assets/img/chapter6/exercises/tdd_skeleton.svg)

(Try to answer the question without scrolling up!)
{% include answer-begin.html %}

1. Write failing test
2. Failing test
3. Make test pass
4. Passing test
5. Refactor

From the explanation above:

![Test Driven Development Cycle](/assets/img/chapter6/tdd_cycle.svg)

{% include exercise-answer-end.html %}

{% include exercise-begin.html %}
Now we have a skeleton for the testing pyramid.
What words/sentences should be at the numbers?

![Testing Pyramid exercise skeleton](/assets/img/chapter6/exercises/pyramid_skeleton.svg)

(Try to answer the question without scrolling up!)
{% include answer-begin.html %}

1. Manual
2. System
3. Integration
4. Unit
5. More reality (interchangeable with 6)
6. More complexity (interchangeable ith 5)

See the diagram in the Testing Pyramid section.
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
Which items shouls Sarah recommend them to tackle first?

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
