---
chapter-number: 9
title: Mock Objects
layout: chapter
toc: true
author: Maurício Aniche
---

## Introduction

When unit testing a piece of code, we want to test it in isolation.
However, if the code requires some external dependency to run, e.g.,
a connection to a database or a webservice, this can be a problem.
We do not want to use this external component when we are just testing the piece of code that uses it. How can we do it? We can **simulate the external component**!
For that, we will use **mock objects**.

When we mock an object, we create a simulation of this object.
To handle external dependencies, we mock (simulate) the class in the system that interacts with the dependency.
Instead of doing the actual work of the external components, mock objects just return fake, hard-coded results.
These return values can be configured inside of the test itself. We will see how it works in practice soon.

The use of mock objects has some advantages.
Returning these pre-configured values is way faster than accessing an external component.
Simulating objects also gives us a lot more control.
If we, for example, want to make sure the system keeps going even if one of its dependencies crashes, we can just tell the simulation to crash; think of how hard would it be to crash a database just to test if your system reacts to that well (although techniques such as *chaos monkey* have become really popular!).

Mock objects are therefore widely used in software testing, mainly to increase testability.
As we have discussed, external systems that the system under test relies on are often mocked to increase controllability and observability. We often mock:

* External components that might be hard to control, or to slow to be used in a unit test, such as databases and webservices.
* To simulate exceptions that are hard to trigger in the actual system.
* To control the behavior of complex third party libraries.
* To test how the different components interact (i.e., exchange messages) among each other.


Implementation-wise, we follow some steps:

* We create a mock object.
* Once it has been created, we give it to the class that normally uses the concrete implementation of the mocked object.
This class is now using the mocked object while the tests are executed.
* At first, the mock does not know how to do anything.
So, before running the tests, we have to tell it exactly what to do when a certain method is called.
* We trigger the action on the class/method under test. During its execution, note that the mock replaces the external component.
* We make assertions on the mock object, often related to its execution.

## Mockito

In Java the most used framework for mocking is Mockito ([mockito.org](https://site.mockito.org)).
To perform the steps we mentioned above, we use a couple of methods provided by Mockito:

- `mock(<class>)`: creates a mock object of the given class. The class can be retrieved from any class by `<ClassName>.class`.
- `when(<mock>.<method>).thenReturn(<value>)`: defines the behavior when the given method is called on the mock. In this case `<value>` will be returned.
- `verify(<mock>).<method>`: asserts that the mock object was exercised in the expected way.

Much more functionalities are described in [Mockito's documentation](https://javadoc.io/page/org.mockito/mockito-core/latest/org/mockito/Mockito.html).

{% include example-begin.html %}
Suppose we have a method that filters invoices.
These invoices are saved in a database and retrieved from the database by this function.
The invoices are filtered on their price.
All those above 100 are filtered.

```java
public class InvoiceFilter {

    public List<Invoice> filter() {

        InvoiceDao invoiceDao = new InvoiceDao();
        List<Invoice> allInvoices = invoiceDao.all();

        List<Invoice> filtered = new ArrayList<>();

        for(Invoice inv : allInvoices) {
            if(inv.getValue() < 100.0)
                filtered.add(inv);
        }

        return filtered;

    }
}
```


Without mocks, the test would need to insert some testing invoices in the database first:

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

And of course, clear the database afterwards. Otherwise the test will break in the second run, as there will be two invoices stored in the database! (The database stores data permanenty; so far, we never had to 'clean' the objects; after all, they were always stored in-memory only.)

<iframe width="560" height="315" src="https://www.youtube.com/embed/0WY7IWbANd8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Now instead of using the database, we want to replace it with a mock object.
This way our test will be faster and we can more easily control what the Database-Access-Object returns.

For that to happen, we first need to make sure we can inject the `InvoiceDao`
to the `InvoiceFilter` class. Instead of instantiating it, we'll change the `InvoiceFilter` class to actually receive `InvoiceDao` via constructor. 

```java
public class InvoiceFilter {

    private InvoiceDao dao;

    public InvoiceFilter (InvoiceDao dao) {
        this.dao = dao;
    }

    public List<Invoice> filter() {

        List<Invoice> allInvoices = dao.all();

        List<Invoice> filtered = new ArrayList<>();

        for(Invoice inv : allInvoices) {
            if(inv.getValue() < 100.0)
                filtered.add(inv);
        }

        return filtered;

    }
}
```

Now, we can mock the `InvoiceDao` class and pass the mocked instance
to the `InvoiceFilter`:

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

Note how we now have full control over the `InvoiceDao` class.
The `InvoiceFilter` uses the `all()` method of the `InvoiceDao` to get the invoices.
With the mock, we can easily give the two invoices that we want to test on (note how
we are passing `i1` and `i2`.
Note also how we do not have to keep a database running while executing the tests!

{% include example-end.html %}

<iframe width="560" height="315" src="https://www.youtube.com/embed/kptTWbeLZ3E" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<iframe width="560" height="315" src="https://www.youtube.com/embed/baunKy04deM" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


## More about Mockito

{% assign todo = "Add one more example with Mockito here, using the verify()" %}
{% include todo.html %}

{% assign todo = "Add one more example with Mockito here, using the spy()" %}
{% include todo.html %}

## Dealing with static methods

{% assign todo = "Discuss how to add an abstraction on top of a static method, so that testing becomes easier." %}
{% include todo.html %}

## Dealing with APIs you don't control

{% assign todo = "Discuss how to add an abstraction on top of things you don't control, e.g., Clock." %}
{% include todo.html %}

## Mocking in practice: when to mock?

{% assign todo = "Discuss here when to mock" %}
{% include todo.html %}

Mocks are a useful tool when it comes to write real isolated unit tests.

## References

* Fowler, Martin. Mocks aren't stubs. https://martinfowler.com/articles/mocksArentStubs.html

* Mockito's website: https://site.mockito.org



## Exercises

{% include exercise-begin.html %}

See the following class:

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

You are testing a system that triggers advanced events based on complex combinations of Boolean external conditions relating to the weather (outside temperature, amount of rain, wind, ...). 
The system has been cleanly designed and consists of a set of cooperating classes that each have a single responsibility.
You create a decision table for this logic, and decide to test it using mocks. Which is a valid test strategy?


1. You use mocks to support observing the external conditions.
2. You create mock objects to represent each variant you need to test.
3. You use mocks to control the external conditions and to observe the event being triggered.
4. You use mocks to control the triggered events.

{% include answer-begin.html %}

You need mocks to both control and observe the behavior of the (external) conditions you mocked.

{% include exercise-answer-end.html %}





{% include exercise-begin.html %}
Below, we show the `InvoiceFilter` class. This class is responsible for returning all the invoices that have an amount smaller than 100.0. It makes use of the InvoiceDAO class, which is responsible for the communication with the database.

```java
public class InvoiceFilter {

    private InvoiceDao invoiceDao;

    public InvoiceFilter(InvoiceDao invoiceDao) {
        this.invoiceDao = invoiceDao;
    }

    public List<Invoice> filter() {
        List<Invoice> filtered = new ArrayList<>();
        List<Invoice> allInvoices = invoiceDao.all();

        for(Invoice inv : allInvoices) {
            if(inv.getValue() < 100.0)
                filtered.add(inv);
        }

        return filtered;
    }
}
```

Which of the following statements is **false** about this class?


1. Integration tests would help us achieve a 100% branch coverage, which is not possible solely via unit tests.
2. Its implementation allows for dependency injection, which enables mocking.
3. It is possible to write completely isolated unit tests for it by, e.g., using mocks.
4. The InvoiceDao class (a direct dependency of the InvoiceFilter) itself should be tested by means of integration tests.
{% include answer-begin.html %}

Option 1 is the false one. We can definitely get to 100% branch coverage there with the help of mocks.
{% include exercise-answer-end.html %}





{% include exercise-begin.html %}

Class A depends on a static method in another class B.
Suppose you want to test class A, which approach(es) can you take to be able to test properly?

1. Mock class B to control the behavior of the methods in class B.
2. Refactor class A, so the outcome of the method of class B is now used as an parameter.

1. Only approach 1.
2. Neither.
3. Only approach 2.
1. Both.


{% include answer-begin.html %}

Only approach 2.

{% include exercise-answer-end.html %}





