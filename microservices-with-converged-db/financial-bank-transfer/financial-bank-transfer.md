# External bank transfer

## Introduction




This lab will demonstrate how to use MicroTx, Lock-free reservations, and Spring Boot to build a financial application that can handle bank transfers between accounts with auto-compensating sagas.
The following is the MicroTx architecture.


<iframe width="800" height="450" src="https://www.youtube.com/embed/qHVYXagpAC0?start=466" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

*Watch the tutorial video above*

This lab demonstrates external bank transfer functionality using Oracle MicroTx and the lock-free reservations feature. The application showcases how these powerful technologies simplify complex financial transaction scenarios that typically require extensive custom coding.

In traditional systems, developers must write complex compensation logic to handle journal entries and maintain consistency during transactions involving multiple microservices. This lab shows how Oracle's lock-free reservations mechanism dramatically simplifies this process through automatic compensation.

The application implements a saga transaction pattern where you can initiate crashes to observe the resilient behavior. You'll see the stark contrast between manual error-prone coding approaches and Oracle's automated compensation data types that handle failure scenarios seamlessly.

Key features demonstrated:
- Oracle MicroTx for distributed transaction management
- Lock-free reservations for improved performance
- Automatic compensation logic handling
- Saga transaction patterns
- Crash recovery and consistency maintenance
- Simplified developer experience for complex transactions

The code examples show how minimal configuration replaces hundreds of lines of custom compensation code, reducing both development time and the potential for bugs in critical financial operations.

### Objectives

- Understand MicroTx, Lock-free reservations, Spring Boot, and Oracle Backend As A Service


### Prerequisites

This lab only requires that you have completed the setup lab.

## Task 1: Follow the Readme

Follow the readme at [this location](https://github.com/paulparkinson/oracle-ai-for-sustainable-dev/tree/main/financial/graph-circular-payments).

You may now **proceed to the next lab.**

## Learn More
* [Developing Event-Driven, Auto-Compensating Saga Transactions For Microservices](https://dzone.com/articles/developing-saga-transactions-for-microservices)
* [Source repos](https://github.com/paulparkinson/saga-examples)
* [Lock-Free Reservation Capability with Oracle Database 23ai](https://blogs.oracle.com/dbstorage/post/new-lockfree-reservation-capability-with-oracle-database-23ai)
* https://docs.oracle.com/en/database/oracle/transaction-manager-for-microservices/24.4/tmmdg/configure-values-yaml-file.html
* [Develop Applications with XA](http://docs.oracle.com/en/database/oracle/transaction-manager-for-microservices/23.4.1/tmmdg/develop-xa-applications.html#GUID-D9681E76-3F37-4AC0-8914-F27B030A93F5)
* [Maintain data consistency across microservices using Oracle MicroTx](https://apexapps.oracle.com/pls/apex/r/dbpm/livelabs/run-workshop?p210_wid=3445)
* [Ensure data consistency in distributed transactions across ORDS applications using MicroTx](https://apexapps.oracle.com/pls/apex/r/dbpm/livelabs/view-workshop?wid=3886)
* [Simplify distributed transactions with Oracle MicroTx to prevent inconsistent data and financial losses](https://apexapps.oracle.com/pls/apex/r/dbpm/livelabs/view-workshop?wid=3725)

## Acknowledgements
* **Authors** - Paul Parkinson, Architect and Developer Advocate
* **Last Updated By/Date** - Paul Parkinson, 2025
