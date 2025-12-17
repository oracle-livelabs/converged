# Create and view accounts using MongoDB adapter/MERN stack and JSON Duality

## Introduction

[](youtube:qHVYXagpAC0)

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


## Task 1: Database Setup

1. If you have not already done so, create an Oracle Database and obtain the MongoDB URL that points to the Oracle Database API for MongoDB. The directions for obtaining it can be found here:
   https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adbsb/mongo-using-oracle-database-api-mongodb.html
2. Run the admin.sql, financial.sql, and mongodb-jsonduality.sql scripts located in the `financial/sql` directory.


## Task 2: Option 1, Run Locally

1. If you have not already done so, create a copy of the `financial\.env.example` file in the repos (eg `.env`)
2. Update the `.env` file with your Oracle Autonomous Database details for `username`, `password`, and `host`, `url`
3. Source the `.env` file, e.g. `source .env`
4. cd to the `mongodb-mern-bank-account/springboot-relational-stack` directory
5. Run `.build_and_run_local.sh`
6. Open a browser and navigate to `http://localhost:8080` . Try to access http://localhost:8080/accounts/accounts to see all accounts in JSON format.
7. If you have installed the React frontend, you should be able to access this page from there as well. You can override the `REACT_APP_MERN_SQL_ORACLE_SERVICE_URL` variable in the `.env` file if needed.
8. cd to the `mongodb-mern-bank-account/mern-stack` directory
9. Update the `.env` file with your Oracle Autonomous Database details for `MONGODB_URL` (obtained during the setup task earlier). Notice the need for escaped characters when doing the password, e.g. `@` becomes `%40`. An example is shown in the `.env.example` file.
10. Run `.build_and_run_local.sh`
11. Open a browser and navigate to `http://localhost:5001` . Try to access http://localhost:5001/api/accounts to see all accounts in JSON format.
12. If you have installed the React frontend, you should be able to access this page from there as well. You can override the `REACT_APP_MERN_MONGODB_JSONDUALITY_ORACLE_SERVICE_URL` variable in the `.env` file if needed.

## Task 3: Option 2, Run On Kubernetes

1. Run `./build_and_deploy.sh` at [this location](https://github.com/paulparkinson/oracle-ai-for-sustainable-dev/tree/main/financial/graph-circular-payments).


## Migration

MongoDB Migrator will be published soon.

Also see Goldengate, MongoDB migration material.


## Scaling, Sizing, and Performance

See the following blogs for details...

https://blogs.oracle.com/datawarehousing/post/oracle-database-api-for-mongodb-best-practices

https://juliandontcheff.wordpress.com/2024/07/04/the-json-to-duality-migrator-in-oracle-database-26ai/


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
