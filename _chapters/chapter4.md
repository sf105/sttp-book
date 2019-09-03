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

Models can be made in two ways: from requirements and from code.
Models from requirements are used to create tests that exercise the required behavior, while models from code are used to exercise the implemented behavior.
