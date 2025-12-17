# FinTech/Bank APIs

## Introduction

[](youtube:qHVYXagpAC0)

*Watch the tutorial video above (starts at 5:27 mark)*

This lab demonstrates how to publish financial APIs using Oracle REST Data Services (ORDS) and OpenAPI. ORDS is particularly popular in the financial industry for quickly exposing database objects and processes as REST APIs without complex coding.

In this example, you'll see how simple it is to REST-enable any database objects or stored procedures. The lab shows practical REST calls to retrieve financial data, such as account information, demonstrating the ease of API creation and consumption.

Key features demonstrated:
- Simple REST enablement of database objects
- OpenAPI specification generation
- Real-time API testing and validation
- Financial data exposure through secure REST endpoints

The code examples on the right side show how minimal configuration is required to transform database operations into production-ready APIs that can be consumed by web applications, mobile apps, or other microservices.

### Objectives

-  Understand ORDS and how it can be used to easily publish financial data and process APIs

### Prerequisites

This lab only requires that you have completed the setup lab.


## Task 1: Database Setup

1. If you have not already done so, run the admin.sql and financial.sql scripts located in the `financial/sql` directory.


## Task 2: Option 1, Run Locally

1. Obtain the Oracle REST Data Services (ORDS) endpoint from the OCI console of your Autonomous Database instance. It will look something like this: `https://asdf-financialdb.adb.eu-frankfurt-1.oraclecloudapps.com/ords` 
2. Create a copy of the `financial/.env.example` file in the repo (eg `.env`)
3. Set the value of REACT_APP_ORDS_BASE_URL in the `.env` file to the ORDS endpoint obtained in step 1.
4. Run `./build_and_deploy.sh` to build and deploy the service to Kubernetes.
5. Open a browser and navigate to `http://localhost:3000/apis` . You should see the Financial API  page.

## Task 3: Option 2, Run On Kubernetes

1. Run `./build_and_deploy.sh`

# Scaling, Sizing, and Performance

See the following...
* [Cloud Scalability Using Customer Managed Oracle Rest Data Service with Autonomous JSON](https://medium.com/oracledevs/cloud-scalability-using-customer-managed-oracle-rest-data-service-with-autonomous-json-275fa06e8d22)
* [ORDS Best Practices](https://www.oracle.com/database/technologies/appdev/rest/best-practices/)


You may now proceed to the next lab.

## Learn More

* [Oracle Database](https://bit.ly/mswsdatabase)

## Acknowledgements
* **Authors** - Paul Parkinson, Architect and Developer Advocate
* **Last Updated By/Date** - Paul Parkinson, 2025
