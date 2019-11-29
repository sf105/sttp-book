---
chapter-number: 10
title: Design for Testability
layout: chapter
toc: true
---

## Testability

Now that we know how to use mocks and what we can use them for it is time to take another look at the production code.
In the Mockito example it was very easy to make sure that the `InvoiceFilter` uses our mock instead of a normal instance of the class.
This is not always the case and we have to design our code in a way that it is easy to test the code.
Up to now we mostly need to make sure that our code can use mocks instead of actual instances.
After that we will look at some more ways to keep our code testable.

The testability of code indicates how easily the code can be tested in an automated way.
We have seen that automated tests are crucial in software development so it is essential that our code is testable.
Therefore code that is more testable is usually better code and it is very important to think about the testability while designing the system.
If the testability is only thought about when testing the code, a lot of it will have to be rewritten.

There are no ways with which we can determine the testability exactly, but we can use some methods to increase the overall testability.
In this section we will go over a couple of these methods.
By applying the methods while designing the code the program can be a lot easier to test.

### Dependency Injection

Dependency injection is one of the concepts we can use to make our code testable.
We will illustrate it by an analogy:

Say we need a hammer to perform a certain task.
When we are asked to do this task, we could go search and find the hammer.
Then once we have the hammer we can use it to perform the task.
However, another approach is to say that we need a hammer when it is asked to perform the task.
This way instead of getting the hammer ourselves we get it from the person that wants us to do the task.

We can do the same with dependencies in our code.
Instead of asking for a hammer we would be asking for an instance of a certain class by a parameter.
The example shows what this looks like in java.

{% include example-begin.html %}
In the Mockito example it was easy to make the `InvoiveFilter` use the mock.
Let's assume now that the `InvoiveFilter` is implemented as follows:

```java
public class InvoiceFilter {

  public void filter() {
    InvoiceDao dao = new InvoiceDao();

    // ...
  }

}
```

Now there is no way to give the mock to the `InvoiceFilter` and it will use the actual `InvoiceDao` in the tests.
As we cannot control the way the `InvoiceDao` operates, this makes it a lot harder to write automated tests.

Instead of writing the above, we can use dependency injection in our design:

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

Now we can create the `InvoiceFilter` with a mock in the automated tests and create it with the real `InvoiceDao` when the program is run normally.
This makes creating the tests easier and increases the testability of the code.
{% include example-end.html %}

Making the dependencies explicit like in the example and passing them through parameters is called dependency injection.
It makes the design of the class explicit and we can give whatever we want to the constructor.
Besides increasing the testability of the code it also makes the class more extensible.
If we ever want to change an object that is needed we just pass the new one.
This is also called the open/closed principle.
We will not go into detail of this principle.

In general try to make sure that dependencies can always be injected to the class.
This will make writing automated tests way easier.

### Ports and Adapters

The way a software system is designed influences how easy it is to test the system.
The idea of designing a system in a way that it is testable is called design for testability.
It is important that a software developer knows about certain ways to design for testability in order to implement systems well.
We will discuss a concept that is used in design for testability.

In general, design for testability comes down to separating the domain and the infrastructure of the systems.
Here the domain is the core of the system: The business rules, logic, and entities and relations of the system.
This is very specific to the system that is being build.
A system often makes use of a database or web-service.
These are part of the infrastructure: the code that talks to the database/web-service and connects them to the core system itself.
To design our system for testability we want to separate these as much as possible.
When the domain and infrastructure are being mixed together the system will be much harder to test.

To separate the domain and the infrastructure we can use Ports and Adapters, as named by Alistair Cockburn.
This is also called the Hexagonal Architecture.
With Ports and Adapters the domain (business logic) depends on Ports rather than directly on the infrastructure.
When programming these ports are just interfaces that define what the infrastructure is able to do.
These ports are completely separated from the implementation of the infrastructure.
In the schema below you can see that the ports are therefore part of the domain.

![Hexagonal Architecture](/assets/img/chapter6/hexagonal_architecture.svg)

The adapters are part of the infrastructure.
These are the implementations of the ports that talk to the database or webservice etc.
These Ports and Adapters help a lot with the testability of our code.
When a class depends on one of the ports we can easily mock the port and run our tests.

We call separating the domain and infrastructure in a system Domain-Driven Design.
The advantage of this design is not only the testability but also maintainability and evolvability.
In this design the domain is the most important part of the system.

### Practical Tips

We end this section with a couple of practical tips that you can use to create a well designed, testable software system.

- **Cohesion**: Cohesive classes are classes that do only one thing and are easy to test. If a class is not cohesive, but has a lot of responsibilities, you can split the class into multiple small cohesive classes. This way you can test each separate class more easily.
- **Coupling**: Coupling represents the amount of classes that a class depends on, i.e. a highly coupled class needs a lot of other classes to work. Coupling hurts testability. Imagine having to create ten mocks, define the behavior of these ten mocks and so forth to test just one class. To reduce coupling you can group some of the dependencies together and create bigger abstractions.
- **Complex Conditions**: When a condition is very large we like to split it into multiple conditions. Testing these simpler conditions is easier than testing one very complex condition.
- **Private methods**: A common question is whether to test private methods or not. The answer is usually no. In principal we like to test the private methods through the public methods that use them. This means that we test if the public method behaves correctly, not the private method. If you feel like you want to test the private method in isolation (because it might be a very large important method) this means that the method should probably have its own separate class. So then to test the private method you will have to refactor the code.
- **Static metods**: Static methods can hurt testability, as we cannot control the behavior of the static methods. Therefore we like to avoid using static methods where possible.
- **Layers**: When using other's code or external dependencies we like to create classes that facilitate between our own code and the other code. This makes the dependencies sort of fit our system. Do not be afraid to create these extra layers. They often increase the testability of the system.
- **Infrastructure**: Again, make sure not to mix the infrastructure with the domain. You can use the methods we discussed above.
- **Encapsulation**: Encapsulation is about bringing the behavior of a class close to the data. Encapsulation will help you identify the problems in the code easier.
