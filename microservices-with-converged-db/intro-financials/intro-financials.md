# Introduction

## About this Workshop

[](youtube:v0nYRueADbo)

This workshop will help you understand the technical capabilities inside and outside the Oracle converged database to support a scalable data and event-driven microservices architecture.

Estimated Workshop Time: 75 minutes

### About Product/Technology

Backend microservices and a Javascript front-end will be deployed on Oracle Cloud Infrastructure Kubernetes cluster (OKE) and access pluggable Oracle Autonomous Transaction Processing databases. REST and messaging are being used for communication 

![Microservices Architecture](./images/architecture.png " ")

If you would like to watch us do the workshop, click [here](https://youtu.be/yLBEPjOWaz0).

### Objectives


- Learn how to develop, migrate, scale, etc. financial solutions using Oracle Database 
- Learn about microservices, Kubernetes, and Cloud Native using Java, Python, JavaScript, .NET, Go, Rust, and PL/SQL, and Rest
- Learn about Oracle features in depth and how the facilitate financial sector (eg https://www.oracle.com/a/ocom/docs/database/fintech-transformation-with-globally-distributed-database.pdf)

| Lab | Financial Process                           | Oracle and other tech used                                   | Company using                                  | 
|-----|---------------------------------------------|--------------------------------------------------------------|------------------------------------------------|
| 1   | Create/Update profile                       | React, Spring Boot, OTel, Vault (*these are used throughout) | LOLC                                           |                                                    
| 2   | Create a bank Account                       | Relational, Application Continuity, DataGuard                |                                                |
| 3   | External bank transfer                      | MicroTx, Lock-free reservations, Spring Boot                 | Early Warning, U of Naples, Shinhan Securities | 
| 4   | Transfer to internal and brokerage accounts | Kafka vs TxEventQ using Spring Boot                          | Responsys, FSGBU                               |
| 5   | Withdraw Cash from ATM                      | Rust or C++ (polyglot)                                       | Chris to provide                               |
| 6   | Depositing Check at ATM                     | Rust or C++  (polyglot)                                      | Chris to provide                               |
| 7   | Mobile Check Deposit                        | OCI Vision/document                                          |                                                |
| 8   | Purchase from retailer using credit card    | MongoDB relational duality, distributed db                   | Santander, Amex, ANZ Bank, BoA                 |
| 9   | Generate Bank Statement                     | relational duality                                           | ANZ Bank                                       |
| 10  | Fraud alerts on credit card purchase        | OML, Graph                                                   | Caixabank                                      |
| 11  | Money Laundering & Money Mules              | Graph                                                        | PaySafe, Garanti Bank,Mercardolibre            |
| 12  | Alerts on suspected transactions            | Knative Eventing, CloudEvents, Spatial                       |                                                |
| 13  | Analytics on spend by category              | Grafana, OpenTelemetry                                       |                                                |
| 14  | Financial PDF/doc search                    | Vector                                                       |                                                |
| 15  | Stock Ticker and Stock Purchases            | TrueCache, lock-free reservations, priority txs,session-less | NYSE                                           |
| 16  | Portfolio analysis (across accounts)        | Kafka, Apache Flink, Iceberg Data import, etc.               | Bankinter                                      |
| 17  | FinTech APIs ORDS OpenAPI                   | ORDS OpenAPI                                                 | Financiera Maestra, Bank of India              |




### Prerequisites

 - An Oracle Cloud Account - Please view this workshop's LiveLabs landing page to see which environments are supported.

## Learn More

* [Oracle Database](https://bit.ly/mswsdatabase)

## Acknowledgements
* **Authors** - Paul Parkinson, Architect and Developer Advocate
* **Last Updated By/Date** - Paul Parkinson, 2024
