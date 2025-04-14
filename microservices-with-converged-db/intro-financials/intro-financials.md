# Introduction

## About this Workshop

[](youtube:v0nYRueADbo)

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

| Lab | Financial Process                             | Oracle and other tech used                                    | Company using                                  | % complete |
|-----|-----------------------------------------------|---------------------------------------------------------------|------------------------------------------------|------------|
| 1   | Infra Setup                                   | Kubernetes, Oracle Database, Vault, Observability/Otel        | LOLC                                           | 90%        |
| 2   | Create profile and bank account               | React, Spring Boot, JPA                                       |                                                | 90%        |
| 3   | External bank transfer                        | MicroTx, Lock-free reservations, Spring Boot                  | Early Warning, U of Naples, Shinhan Securities | 60%        |
| 4   | Transfer to internal and brokerage accounts   | Kafka vs TxEventQ using Spring Boot                           | Responsys, FSGBU                               | 90%        |
| 5   | Withdraw/Deposit Cash from ATM                | Rust or C++ (polyglot)                                        |                                                | 10%        |
| 6   | Mobile Check Deposit                          | OCI Vision/document                                           |                                                | 10%        |
| 7   | Purchase from retailer using credit card      | MongoDB relational duality, distributed db                    | Santander, ANZ Bank, Amex, BoA                 | 20%        |
| 8   | Bank Account Statement and Portfolio Analysis | Kafka, Apache Flink, Iceberg, Data import, etc.               | ANZ Bank, Bankinter                            | 20%        |
| 9   | Fraud alerts on credit card purchases         | OML, Graph, Knative Eventing, CloudEvents, Spatial            | Caixabank                                      | 60%        |
| 10  | Money Laundering                              | Graph                                                         | PaySafe, Garanti Bank, Mercardolibre           | 8%         |
| 11  | Financial PDF/doc search                      | Vector Search, RAG                                            | recent customer reference just announced       | 70%        |
| 12  | Stock Ticker and Stock Purchases              | TrueCache, lock-free reservations, priority txs, session-less | NYSE                                           | 20%        |
| 13  | FinTech APIs ORDS OpenAPI                     | ORDS OpenAPI                                                  | Financiera Maestra, Bank of India              | 80%        |
| 13  | "Speak with your (financial) data"            | Select AI, Vector Search (AI Explorer for Apps), Speech AI    |                                                | 80%        |



BaA and Amex distributed db as described in https://www.oracle.com/a/ocom/docs/database/fintech-transformation-with-globally-distributed-database.pdf


### Prerequisites

 - An Oracle Cloud Account - Please view this workshop's LiveLabs landing page to see which environments are supported.

## Learn More

* [Oracle Database](https://bit.ly/mswsdatabase)

## Acknowledgements
* **Authors** - Paul Parkinson, Architect and Developer Advocate
* **Last Updated By/Date** - Paul Parkinson, 2024
