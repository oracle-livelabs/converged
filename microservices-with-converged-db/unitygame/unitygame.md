# Build a retro video game using Unity, Kubernetes, and Oracle Database

## Introduction

The illustration below shows four microservices: Order, Inventory, Delivery, Supplier, and the infrastructure required to run them.

![Microservices Architecture](images/architecture.png " ")

For more information on microservices visit http://developer.oracle.com/microservices

In this workshop, you'll switch the Inventory microservice to a Python, Node.js, .NET, Go, Spring Boot or Java Helidon SE implementation while retaining the same application functionality.

Estimated Time: 10 minutes

The following video provides a quick walk-through of how to switch the Inventory microservice to Python while retaining the same application functionality.

[](youtube:zltpjX721PA)

### Objectives

-   Undeploy the existing Java Helidon MP Inventory microservice
-   Deploy an alternate implementation of the Inventory microservice and test the application functionality

### Prerequisites

This lab assumes you have already completed the earlier labs.


## Task 1: Make a Clone of the Pods Of Kon git repos

1. CD to your root or other directory and make a clone from the GitHub repository using the following command.

   ```
   <copy>
   cd ~/ ; git clone https://bit.ly/pokgitfile
   </copy>
   ```
   You should now see the directory `podsofkon` in the directory that you created.

2. Follow the directions in the `podsofkon/doc/build.md` file.

You may now proceed to the next lab.

## Learn More

* [Oracle Database](https://bit.ly/mswsdatabase)

## Acknowledgements
* **Authors** - Paul Parkinson, Architect and Developer Advocate
* **Last Updated By/Date** - Paul Parkinson, 2024

