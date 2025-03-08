# Introduction

## About this Workshop

This workshop is designed to help you get started with [Oracle Database Transactional Event Queues (TxEventQ)](https://www.oracle.com/database/advanced-queuing/), a messaging platform designed for event-driven architectures and microservice communication that runs within Oracle Database.

TxEventQ includes APIs in numerous languages and protocols, including PL/SQL, Java, REST, and many others. The focus of this workshop will be using the PL/SQL API to manage and work with TxEventQ in common application scenarios.

Estimated Workshop Time: 40 minutes

![TxEventQ Application Events](images/microservice-events.png " ")

### About Product/Technology

[Oracle Database Transactional Event Queues (TxEventQ)](https://docs.oracle.com/en/database/oracle/oracle-database/23/adque/aq-introduction.html) is a high-throughput, reliable messaging service that runs within Oracle Database. TxEventQ supports multiple producers and consumers, exactly-once messaging, transactional messaging, and robust event streaming capabilities.

![TxEventQ Logo](images/txeventq-logo.png " ")

### Objectives

In this workshop, you will gain first-hand experience of how Oracle Database can be used as event streaming system using the PL/SQL API of TxEventQ.

Once you complete your setup, the next lab will cover:

* The [DBMS_AQADM PL/SQL package](https://docs.oracle.com/en/database/oracle/oracle-database/23/arpls/DBMS_AQADM.html), which provides procedures to manage TxEventQ, including queue creation
* Necessary database permissions for TxEventQ users
* Create and start Transactional Event Queues
* Understanding queue message payload types

The following labs will cover enqueue and dequeue operations with queues, and additional messaging features of Transactional Event Queues.

### Prerequisites

* An Oracle Cloud Account - Please view this workshop's LiveLabs landing page to see which environments are supported

*Note: If you have a **Free Trial** account, when your Free Trial expires your account will be converted to an **Always Free** account. You will not be able to conduct Free Tier workshops unless the Always Free environment is available. **[Click here for the Free Tier FAQ page.](https://www.oracle.com/cloud/free/faq.html)***


You may now **proceed to the next lab**

## Want to Learn More?

* [Oracle Database Transactional Event Queues Homepage](https://docs.oracle.com/en/database/oracle/oracle-database/23/adque/index.html)
* [Transactional Event Queues Developer Guide](https://oracle.github.io/microservices-datadriven/transactional-event-queues/)
* [Microservices Architecture with the Oracle Database](https://www.oracle.com/technetwork/database/availability/trn5515-microserviceswithoracle-5187372.pdf)
* [https://developer.oracle.com/](https://developer.oracle.com/)

## Acknowledgements

* **Authors** - Anders Swanson, Developer Evangelist
* **Contributors** - Anders Swanson, Developer Evangelist
* **Last Updated By/Date** - Anders Swanson, Feb 2025
