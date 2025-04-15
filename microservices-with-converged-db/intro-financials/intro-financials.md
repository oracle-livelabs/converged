# Introduction

## About this Workshop

This workshop will help you understand the technical capabilities of the Oracle Database in the Cloud Native / Open Source Space, focusing on financial verticals

Estimated Workshop Time: 180 minutes

### About Product/Technology

See table below for labs and corresponding technology used.
NOTE: More financial personas will be added (analyst vs customer vs data scientist vs (perhaps rename knowledge officer)....)

![Microservices Architecture](./images/architecture.png " ")

[//]: # (If you would like to watch us do the workshop, click [here]&#40;https://youtu.be/yLBEPjOWaz0&#41;.)

### Objectives


- Learn how to develop, migrate, scale, etc. financial solutions using Oracle Database 
- Learn about microservices, Kubernetes, and Cloud Native using Java, Python, JavaScript, .NET, Go, Rust, and PL/SQL, and Rest
- Learn about Oracle features in depth and how the facilitate financial sector (eg https://www.oracle.com/a/ocom/docs/database/fintech-transformation-with-globally-distributed-database.pdf)

| Lab | Financial Process                             | Oracle and other tech used                                             | Company using                                  | % complete/ETA |
|-----|-----------------------------------------------|------------------------------------------------------------------------|------------------------------------------------|----------------|
| 1   | Infra Setup                                   | Kubernetes, Oracle Database, Observability/Otel, Backend for MS and AI | LOLC                                           | 90% 4/14       |
| 2   | Create profile and bank account               | React, Spring Boot, JPA                                                |                                                | 90% 4/19       |
| 3   | External bank transfer                        | MicroTx, Lock-free reservations, Spring Boot                           | Early Warning, U of Naples, Shinhan Securities | 60% 4/17       |
| 4   | Transfer to internal and brokerage accounts   | Kafka vs TxEventQ using Spring Boot- Python, ADT TxEventQ              | Responsys, FSGBU                               | 90% 4/20       |
| 5   | Withdraw/Deposit Cash from ATM                | Polyglot                                                               |                                                | 10% 4/21       |
| 6   | Mobile Check Deposit                          | OCI Vision/document                                                    |                                                | 10% 4/22       |
| 7   | Purchase from retailer using credit card      | MongoDB relational duality, distributed db                             | Santander, ANZ Bank, Amex, BoA                 | 20% 4/23       |
| 8   | Bank Account Statement and Portfolio Analysis | Kafka, Flink, Iceberg, Data import, Redash/Metabase/Superset, etc.     | ANZ Bank, Bankinter                            | 20% 4/23       |
| 9   | Fraud alerts on credit card purchases         | OML, Graph, Knative Eventing, CloudEvents, Spatial                     | Caixabank                                      | 60% 4/23       |
| 10  | Money Laundering                              | Graph                                                                  | PaySafe, Garanti Bank, Mercardolibre           | 8% 4/19        |
| 11  | Financial PDF/doc search                      | Vector Search, RAG                                                     | recent customer reference just announced       | 70% 4/23       |
| 12  | Stock Ticker and Stock Purchases              | TrueCache, lock-free reservations, priority txs, session-less          | NYSE                                           | 20% 4/18       |
| 13  | FinTech APIs ORDS OpenAPI                     | ORDS OpenAPI                                                           | Financiera Maestra, Bank of India              | 80% 4/16       |
| 13  | "Speak with your (financial) data"            | Select AI, Vector Search (AI Explorer for Apps), Speech AI             |                                                | 80% 4/15       |


Maintain data consistency across microservices using Oracle MicroTx
https://apexapps.oracle.com/pls/apex/r/dbpm/livelabs/run-workshop?p210_wid=3445

Ensure data consistency in distributed transactions across ORDS applications using MicroTx
https://apexapps.oracle.com/pls/apex/r/dbpm/livelabs/view-workshop?wid=3886

Simplify distributed transactions with Oracle MicroTx to prevent inconsistent data and financial losses
https://apexapps.oracle.com/pls/apex/r/dbpm/livelabs/view-workshop?wid=3725

Oracle Sharding: Hyperscale Globally Distributed Database
https://apexapps.oracle.com/pls/apex/r/dbpm/livelabs/run-workshop?p210_wid=866

Oracle Globally Distributed Database with RAFT
https://apexapps.oracle.com/pls/apex/r/dbpm/livelabs/run-workshop?p210_wid=835

Oracle Sharding Quick Start
https://apexapps.oracle.com/pls/apex/r/dbpm/livelabs/run-workshop?p210_wid=854

https://docs.oracle.com/en/database/oracle/backend-for-microservices-and-ai/index.html
https://oracle.github.io/microservices-datadriven/spring/
https://oracle.github.io/microservices-datadriven/cloudbank/devenv/oractl/index.html


BaA and Amex distributed db as described in https://www.oracle.com/a/ocom/docs/database/fintech-transformation-with-globally-distributed-database.pdf

apache arabac datatype, python numpy, 0 cost converstion , so readonly into dataframes parquay delta lake - chris jones blog on medium 



### Prerequisites

 - An Oracle Cloud Account - Please view this workshop's LiveLabs landing page to see which environments are supported.

## Learn More

* [Oracle Database](https://bit.ly/mswsdatabase)

## Acknowledgements
* **Authors** - Paul Parkinson, Architect and Developer Advocate
* **Last Updated By/Date** - Paul Parkinson, 2024
