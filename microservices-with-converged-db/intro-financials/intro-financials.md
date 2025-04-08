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

| Lab | Financial Process                                                                    | Oracle and other tech used                                      | Company using                                        | Script                                                                |
|-----|--------------------------------------------------------------------------------------|-----------------------------------------------------------------|------------------------------------------------------|-----------------------------------------------------------------------|
| 1   | Create/Update profile                                                                | React, Spring Boot, OAuth, Vault (*these are used throughout)   | ABC company                                          |                                                                       |
| 2   | Create a bank Account                                                                | Relational                                                      |                                                      |                                                                       |
| 3   | Transfer money from an external to internal bank account                             | MicroTx, Lock-free reservations, Spring Boot                    | Early Warning, LOLC, U of Naples, Shinhan Securities |                                                                       |
| 4   | Transfer funds to internal bank accounts                                             | Kafka vs TxEventQ using Spring Boot                             | Responsys                                            |                                                                       |
| 5   | Withdraw Cash from ATM                                                               | Rust or C++ (polyglot)                                          |                                                      |                                                                       |
| 6   | Depositing Check at ATM                                                              | Rust or C++  (polyglot)                                         |                                                      |                                                                       |
| 7   | Mobile Check Deposit                                                                 | OCI Vision/document                                             |                                                      |                                                                       |
| 8   | Purchasing an item from retailer using a debit/credit card                           | MongoDB relational duality,                                     | Santander  , Amex, ANZ Bank                          |                                                                       |
| 9   | Generating Bank Statement                                                            | relational duality                                              | ANZ Bank                                             |                                                                       |
| 10  | Fraud alerts on credit card purchase                                                 | OML, Graph                                                      | Caixabank                                            |                                                                       |
| 11  | Money Laundering & Money Mules                                                       | Graph                                                           | PaySafe, Garanti Bank,Mercardolibre                  |                                                                       |
| 12  | Alerts on suspected transactions                                                     |                                                                 |                                                      |                                                                       |
| 13  | Analytics on spend by category                                                       | Flink Iceberg                                                   |                                                      |                                                                       |
| 14  | Transaction search & internal knowledge repository FAQs                              | Vector                                                          |                                                      |                                                                       |
| 15  | Use Case X1                                                                          | distributed db                                                  | BoA, Amex                                            |                                                                       |
| 16  | Use Case X2 - stock purchases                                                        | TrueCache                                                       | NYSE                                                 |                                                                       |
| 17  | Portfolio analysis (across accounts)                                                 | Kafka, Apache Flink, Iceberg Data import, external tables, etc. | Bankinter (for process not tech)                     | Shows advantage of unified view and cross-platform data accessibility |
| 28  | FinTech APIs ORDS OpenAPI                                                            | Simple, “current loan interest rate” type API call              | Financiera Maestra                                   | Perhaps exposed in API Gateway at some point.                         |




### Prerequisites

 - An Oracle Cloud Account - Please view this workshop's LiveLabs landing page to see which environments are supported.

## Learn More

* [Oracle Database](https://bit.ly/mswsdatabase)

## Acknowledgements
* **Authors** - Paul Parkinson, Architect and Developer Advocate
* **Last Updated By/Date** - Paul Parkinson, 2024
