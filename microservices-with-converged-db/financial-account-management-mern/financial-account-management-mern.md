# Create and view accounts using MongoDB adapter/MERN stack and JSON Duality

## Introduction

[](youtube:qHVYXagpAC0?start=371)

*Watch the tutorial video above (starts at 6:11 mark)**

This lab showcases account creation and management using the MongoDB MERN stack (MongoDB, Express, React, Node.js) with Oracle's JSON Duality feature. The application demonstrates how you can seamlessly access Oracle Database using the MongoDB API, providing flexibility for developers familiar with MongoDB while leveraging Oracle's enterprise capabilities.

The lab features a React frontend with Express and Node.js backend, where you can create and query financial accounts using either MongoDB query syntax or SQL. This dual-API approach allows developers to choose their preferred method while working against the same Oracle Database.

Key features demonstrated:
- MongoDB API compatibility with Oracle Database
- JSON Duality for flexible data access
- MERN stack architecture with Oracle backend
- Interchangeable SQL and MongoDB query methods
- Real-time account creation and retrieval

The interactive code examples show how the same database operations can be performed using either MongoDB query language or SQL, with identical results. This demonstrates Oracle's commitment to supporting diverse development preferences while maintaining data consistency and enterprise features.

### Objectives

-  Understand MongoDB adapter/MERN stack and JSON Duality and how it can be used in financial applications and analytics


### Prerequisites

This lab only requires that you have an Oracle Autonomous Database

## Task 1: Build and deploy the service

Run `./build_and_deploy.sh` at [this location](https://github.com/paulparkinson/oracle-ai-for-sustainable-dev/tree/main/financial/graph-circular-payments).

1. Simply follow the directions here and use the MongoDB URL as you would any other in your MongoDB application

https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adbsb/mongo-using-oracle-database-api-mongodb.html

## Task 2: Run the application

1. Follow the steps in the README.md in `financial/bank-account-management-mergn` directory of the Github repos


## Migration

MongoDB Migrator will be published soon.

Also see Goldengate, MongoDB migration material.


## Scaling, Sizing, and Performance

See the following blogs for details...

https://blogs.oracle.com/datawarehousing/post/oracle-database-api-for-mongodb-best-practices

https://juliandontcheff.wordpress.com/2024/07/04/the-json-to-duality-migrator-in-oracle-database-23ai/


You may now proceed to the next lab.

## Learn More

* [Oracle Database](https://bit.ly/mswsdatabase)
* [Oracle Database API for MongoDB - Best Practices](https://blogs.oracle.com/datawarehousing/post/oracle-database-api-for-mongodb-best-practices)
* [Using Spring Data MongoDB with Oracle Database’s MongoDB API blog](https://blogs.oracle.com/developers/post/using-spring-data-mongodb-with-oracle-databases-mongodb-api)
* [SQL Meets JSON in Oracle Database: Unify Data with Duality Views, JSON Collections & MongoDB API workshop](https://livelabs.oracle.com/pls/apex/dbpm/r/livelabs/view-workshop?wid=4168)
* [Using the Oracle Database API for MongoDB workshop](https://apexapps.oracle.com/pls/apex/r/dbpm/livelabs/run-workshop?p210_wid=3152)
* [SQL Meets JSON in Oracle Database: Unify Data with Duality Views, JSON Collections & MongoDB API](https://apexapps.oracle.com/pls/apex/r/dbpm/livelabs/run-workshop?p210_wid=3635)
* [Full Python App Development with Autonomous JSON for MongoDB Developers workshop](https://apexapps.oracle.com/pls/apex/r/dbpm/livelabs/run-workshop?p210_wid=3272)

## Acknowledgements
* **Authors** - Paul Parkinson, Architect and Developer Advocate
* **Last Updated By/Date** - Paul Parkinson, 2025
