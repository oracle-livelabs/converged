# Introduction

## About this Workshop

This workshop will help you understand Event Mesh using two message brokers and the technical capabilities inside the converged Oracle Database to support a scalable event-driven microservices architecture. "You will learn how to Kafka is similar to TxEventQ and how easy it is to convert an Apache Kafka Java microservice application to run with Oracle TxEventQ emulating a Kafka Broker."

You will create four event-driven microservices and two messaging brokers to allow communication between them. In the first lab, you will deploy an Apache Kafka broker to leverage the event-driven communication between two microservices written in Spring Boot. In the second lab, you will create an Oracle Transactional Event Queues (TxEventQ) and experience the Kafka APIs working in the Kafka compatibility mode. Likewise, this module has the Spring Boot producer and consumer microservices but with Kafka Java client for TxEventQ, using the okafka library. And finally, in the third lab, you will experiment with the concept of Event Mesh, building a bridge between Kafka and TxEventQ brokers, and see messages being produced on the Kafka side and consumed on the TxEventQ side.

Estimated Workshop Time: 50 minutes

### About Product/Technology

* [Oracle Transactional Event Queues](https://docs.oracle.com/en/database/oracle/oracle-database/21/adque/index.html) is a powerful messaging backbone offered by converged Oracle Database that allows you to build an enterprise-class data-centric microservices architecture.

* [Kafka](https://kafka.apache.org) is an open-source distributed event streaming platform used for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications.

* [okafka](https://docs.oracle.com/en/database/oracle/oracle-database/21/adque/Kafka_cient_interface_TEQ.html#GUID-94589C97-F323-4607-8C3A-10A0EDF9DA0D) library, contains Oracle specific implementation of Kafka Client Java APIs. This implementation is built on AQ-JMS APIs.

* The applications will be deployed on [Oracle Cloud Infrastructure](https://www.oracle.com/cloud/) [Cloud Shell](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/cloudshellintro.htm) using pre-installed Docker Engine.

### Objectives

* The second Lab reviews the Kafka and Spring Boot Microservice built to produce and consume messages.

* The third Lab will use Oracle Transactional Event Queues (TxEventQ) and okafka library and demonstrate the Kafka compatibility of TxEventQ. Also, this module has the same Spring Boot producer and consumer microservices but uses okafka in place of Kafka libraries and TxEventQ in the database in place of Kafka broker.

* The fourth Lab will interconnect the Kafka broker and the Oracle Transactional Event Queues (TxEventQ), applying Kafka connector and Oracle Database Messaging libraries. This lab demonstrates the interoperability between the two brokers, with events flowing from the Kafka side to TxEventQ, consumed at the TxEventQ side.

### Prerequisites

* This workshop assumes you have an Oracle Cloud Account - Please view this workshop's LiveLabs landing page to see which environments are supported.

>**Note:** If you have a **Free Trial** account, when your Free Trial expires, your account will be converted to an **Always Free** account. You will not be able to conduct Free Tier workshops unless the Always Free environment is available.
**[Click here for the Free Tier FAQ page.](https://www.oracle.com/cloud/free/faq.html)**

## Event Mesh Architecture Overview

As shown in the following diagram, we have:

* A Kafka Broker and a set of microservices consuming and producing messages on Kafka Topics.
* An Oracle TxEventQ Broker with another set of microservices consuming and producing messages on TxEventQ Queues.
* A connector between Kafka and Oracle TxEventQ enabling messages to flow from Kafka Topic to TxEventQ Queue

![Kafka and Oracle TxEventQ Event Mesh](images/eventmesh-txeventq-kafka.drawio.png " ")

You may now **proceed to the next lab**

## Want to Learn More?

* [Multitenant Database–Oracle 19c](https://www.oracle.com/database/technologies/multitenant.html)
* [Oracle Transactional Event Queues](https://docs.oracle.com/en/database/oracle/oracle-database/21/adque/index.html)
* [Microservices Architecture with the Oracle Database](https://www.oracle.com/technetwork/database/availability/trn5515-microserviceswithoracle-5187372.pdf)
* [https://developer.oracle.com/](https://developer.oracle.com/)

## Acknowledgements

* **Authors** - Paulo Simoes, Developer Evangelist; Andy Tael, Developer Evangelist; Paul Parkinson, Developer Evangelist; Richard Exley, Consulting Member of Technical Staff, Oracle MAA and Exadata
* **Contributors** - Mayank Tayal, Developer Evangelist; Corrado De Bari, Developer Evangelist; Sanjay Goil, VP Microservices and Oracle Database
* **Last Updated By/Date** - Andy Tael, Oct 2022
