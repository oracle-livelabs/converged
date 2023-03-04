# Manage Saga Transactions across Microservices

## Introduction

This lab walks you through implementing the [Saga pattern](https://microservices.io/patterns/data/saga.html) using a [Long Running Action](https://download.eclipse.org/microprofile/microprofile-lra-1.0-M1/microprofile-lra-spec.html) to manage transactions across microservices.

> **Note**: Hello LiveLab QA testers!  This lab did not make the deadline, but don't worry!  You can skip this lab and move on to the next one as if nothing happened :)  We will be adding this lab before the Level Up 23 event - probably by 3/8/2023.

Estimated Time: 30 minutes

### Objectives

In this lab, you will:
* Learn about the Saga pattern
* Learn about the Long Running Action specification
* Add new endpoints to the Account service for deposits and withdrawals that act as LRA participants
* Create a Transfer service that will initiate the LRA

### Prerequisites

This lab assumes you have:
* An Oracle Cloud account
* All previous labs successfully completed

## Task 1: Learn about the Saga pattern

When you adopt microservices architecture and start to apply the patterns, you rapidly run into a situation where you have a business transaction that spans across multiple services.  

### Database per service

The [Database per service](https://microservices.io/patterns/data/database-per-service.html) pattern is a generally accepted best practice which dictates that each service must have its own "database" and that the only way other services can access its data is through its public API.  This helps to create loose coupling between services, which in turn makes it easier to evolve them independently and prevents the creation of a web of dependencies that make application changes increasingly difficult over time.  In reality, this pattern may be implemented with database containers, or even schema within one database with strong security isolation, to prevent the proliferation of database instances and the associated management and maintenance cost explosion. 

### Transactions that span services

The obvious challenge with the Database per service pattern is that a database transaction cannot span databases, or services.  So if you have a scenario where you need to perform operations in more than one service's database, you need a solution for this challenge.

A saga is a sequence of local transactions.  Each service performs local transactions and then triggers the next step in the saga.  If there is a failure due to violating a business rule (e.g. trying to withdraw more money than is in an account) then the saga executes a series of compensating transactions to undo the changes that were already made.

### Saga coordination

There are two ways of coordination sagas:

* Choreography - each local transaction publishes domain events that trigger local transactions in other services
* Orchestration - an orchestrator (object) tells the participants what local transactions to execute

> **Note**: You can learn more about the saga pattern at [microservices.io](https://microservices.io/patterns/data/saga.html).

### The Cloud Cash Transfer Saga

In this lab you will implement a saga that will manage transfering funds from one user to another.  The CloudBank mobile application will have a feature called "Cloud Cash" that allows users to instantly transfer funds to anyone.  They will do this by choosing a source account and entering the email address of the person they wish to send funds to, and the amount.

![Cloud Cash screen](images/obaas-flutter-cloud-cash-screen-design.png)

When the user submits their request, a microservice will pick up the request and invoke the **Transfer** service (which you will write in this lab) to process the transfer.

The Transfer service will need to find the target customer using the provided email address, then perform a withdrawal and a deposit.  It will need to coordinaate these actions to make sure they all occur, and to perform compensation if there is a problem. 


## Task 2: Learn about Long Running Actions

There are different models that can be used to coordinate transactions across services.  Three of the most common are XA (Extended Architcture) which focuses on strong consistency, LRA (Long Running Action) which provides eventual consistency, and TCC (Try-Confirm/Cancel) which uses a reservation model.  Oracle Backend for Spring Boot includes [Oracle Transaction Manager for Microservices](https://www.oracle.com/database/transaction-manager-for-microservices/) which supports all three of these options. 

In this lab, you will explore the Long Running Action model.  In this model there is a logical coordinator and a number of participants.  Each participant is responsible for performing work and being able to compensate if necessary.  The coordinator essentially manages the lifecycle of the LRA, for example by telling participants when to cancel or complete.

![The Cloud Cash LRA](images/obaas-lra.png)

You will create the **Transfer service** in the diagram above, and the participant endpoints in the Account service (**deposit** and **withdraw**).  Oracle Transaction Manager for Microservices (also known as "MicroTx") will coorindate the LRA.

You will implement the LRA using the Eclipse Microprofile LRA library which provides an annotation-based approach to managing the LRA, which is very familiar for Spring Boot developers.  

> **Note**: The current version of the library (at the time of the Level Up 2023 event) uses JAX-RS, not Spring Boot's REST annotations provided by `spring-boot-starter-web`, so until a version of the library with better support for Spring is available, we will need to do a little extra work to use JAX-RS.

The main annotations used in an LRA application are as follows: 

* `@LRA` - Controls the life cycle of an LRA.
* `@Compensate` - Indicates that the method should be invoked if the LRA is cancelled.
* `@Complete` - Indicates that the method should be invoked if the LRA is closed.
* `@Forget` - Indicates that the method may release any resources that were allocated for this LRA.
* `@Leave` - Indicates that this class is no longer interested in this LRA.
* `@Status` - When the annotated method is invoked it should report the status.

If you would like to learn more, there is a lot of detail in the [Long Running Action](https://download.eclipse.org/microprofile/microprofile-lra-1.0-M1/microprofile-lra-spec.html) specification.

You will now start implementing the Cloud Cash Payment LRA.

## Task 3: Add LRA partipant endpoints to the Account Service

TODO what thing

1. This thing

  TODO how.

## Task 4: Create the Transfer Service

TODO what thing

1. This thing

  TODO how.

## Task 5: Run LRA test cases

TODO what thing

1. This thing

  TODO how.


## Learn More

* [Oracle Transaction Manager for Microservices](https://www.oracle.com/database/transaction-manager-for-microservices/)
* [Saga pattern](https://microservices.io/patterns/data/saga.html)
* [Long Running Action](https://download.eclipse.org/microprofile/microprofile-lra-1.0-M1/microprofile-lra-spec.html)


## Acknowledgements
* **Author** - Paul Parkinson, Mark Nelson, Developer Evangelists, Oracle Database
* **Contributors** - [](var:contributors)
* **Last Updated By/Date** - Mark Nelson, March 2023
