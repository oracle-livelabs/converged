# Transfer to internal and brokerage accounts

## Introduction


<iframe width="800" height="450" src="https://www.youtube.com/embed/qHVYXagpAC0?start=771" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

*Watch the tutorial video above*

This lab demonstrates asset inventory management using Oracle's Kafka-compatible Transactional Event Queues (TxEventQ). The application showcases how messaging and database operations can be conducted within the same local transaction, eliminating common distributed system challenges.

The demonstration involves two microservices - an order service and an inventory service - that handle both purchases and inventory adjustments. You can select an asset and amount to initiate transfers, allowing you to compare and contrast different messaging approaches. The application provides a side-by-side comparison between traditional Kafka with external databases (like PostgreSQL) versus Oracle's integrated TxEventQ solution.

A key feature of this demonstration is the crash scenario testing. You can intentionally trigger crashes at specific points in the transaction flow, such as after inventory is checked in the inventory service but before the inventory status message is sent back to the order service. This reveals critical differences between the two approaches:

With traditional Kafka and PostgreSQL implementations, crashes can result in duplicate messages that require additional custom code to handle properly. Developers must write extensive error-handling logic to ensure message delivery guarantees and prevent data inconsistencies.

However, with Oracle's TxEventQ, even though the application continues to use the standard Kafka API, the transactional nature of the underlying event queue system automatically handles these crash scenarios. No additional coding is required to manage duplicate messages or ensure consistency, as the database's ACID properties extend to the messaging layer.

This demonstration highlights how Oracle's converged architecture simplifies microservices development by providing reliable messaging capabilities with database-level consistency guarantees, reducing the complexity and potential for errors in distributed financial applications.

### Objectives

-  Understand Oracle TxEventQ and Kafka adapter in the context of financial operations and communication

### Prerequisites

This lab only requires that you have completed the setup lab.

## Task 1: Follow the Readme

Follow the readme at [this location](https://github.com/paulparkinson/oracle-ai-for-sustainable-dev/tree/main/financial/graph-circular-payments).

## Low-level side by side comparison with alternative

![Mongo & Postgress & Kafka to Oracle](images/mongopostgreskafka_vs_OracleAQ.png " ")

## Migration

   [Migrate Apache Kafka applications to Oracle Database blog by Anders Swanson](https://www.linkedin.com/pulse/migrate-apache-kafka-applications-oracledatabase-anders-swanson-fd6vc)

## Scaling, Sizing, and Performance

1) TxEventQ  - Scalability/Stress Testing Benchmarking - 19c | 70-Q | Single Consumer Qs
   A) Our OCI/On-prem RAC Cluster
   Clocked a Max Messaging throughput of 15-18K Msg/sec using TxEventQ with 2-3 Billion Message Volume sustained across 24-48 Hours
   19.7+MLR - 2N RAC/ASM (Traffic routed to a Single RAC Instance, 2nd instance idle/HA Failover)  on OCI (our On-prem H/w) | 70 Single Consumer Qs |  Single Shard - Global Ordering | Shared Servers
   | Msg Size: 512Bytes -1 KB
   Macro-Perf Stats:
   https://confluence.oraclecorp.com/confluence/display/SHARP/Performance+and+Metrics+details#PerformanceandMetricsdetails-Profilerunstatistics
   https://confluence.oraclecorp.com/confluence/display/SHARP/Performance+and+Metrics+details#PerformanceandMetricsdetails-Reliabilityrunstatistics
   System/Stress Testing Home - https://confluence.oraclecorp.com/confluence/display/SHARP/Responsys+emulated+AQ-JMS+System+Stress+testing#ResponsysemulatedAQJMSSystemStresstesting-TestSetup&SpecialWorkload/Scope
   DB/Q Parameter Tuning - https://confluence.oraclecorp.com/confluence/display/SHARP/Performance+and+Metrics+details#PerformanceandMetricsdetails-InitParameters:
   B) OCI/DBCS (Bare DB Service)
   16-18K Msg/Sec, 2-3B Msg Volume sustained for 48-hours (512B-1K Msg Size)
   https://confluence.oraclecorp.com/confluence/pages/viewpage.action?pageId=1841220906#OCI/DBCSTestingofAQResponsys-TEQPerformanceProfiling-DBCSvsOn-Prem        (Refer to SL# 2.3 and 3.1 )
   C) FS-GBU Autonomous DB (ADB-S) Cloud TxEQ Scale Testing
   Using a 16 OCPU ATP (Single instance), we clocked ~ 10K Msg/sec ENQ-DEQ throughput w/ 3Qs, 1K JMS-Byte msg
   https://confluence.oraclecorp.com/confluence/display/SHARP/FS+GBU+E2POD+ADB-S+Profiling
2) Classic Q Scale/Stress Testing Stats
   A)   FA-SaaS emulated Classic-Q Scale Testing w/ 96-Q for 24+ Hours, 1B+ Msg Volume | Scrambled DEQ and  Flow-control DEQ FA-Special CQ features enabled
   https://confluence.oraclecorp.com/confluence/pages/viewpage.action?pageId=7149906020#FACQJMSForegroundEnq/DeqMultiplefeatures-RUN7:96Queues
   B)   FA-SCM Emulated CQ (Varying Payloads) Performance Stats
   https://confluence.oraclecorp.com/confluence/display/SHARP/Classic+Q+FA+-+SCM+Performance+Evaluation

For sizing questions, we would start with the obvious ones such as 
(a) expected enqueue rate/dequeue rate 
(b) is global ordering required for application  
(c) payload size, # of subscribers, etc.

Typically queues with 2K msgs/sec or less enqueue/dequeue rate for a reasonable size workload (4K), and 10K msgs/sec or over, use TxEventQ.
Mileage will vary considerably based on # of topics, # of partitions per topic, size of the database hardware (Exadata being the extreme), etc.


You may now proceed to the next lab.

## Learn More

* [Oracle Database](https://bit.ly/mswsdatabase)
* [Workshop: Getting Started With Oracle Database Transactional Event Queues (TxEventQ)](https://apexapps.oracle.com/pls/apex/r/dbpm/livelabs/view-workshop?wid=1016)
* Python, ADT payload forTxEventQ

## Acknowledgements
* **Authors** - Paul Parkinson, Architect and Developer Advocate
* **Last Updated By/Date** - Paul Parkinson, 2025
