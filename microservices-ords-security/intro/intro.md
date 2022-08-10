# Introduction

This lab will help you understand how to setup a standalone ORDS (Oracle REST Data Services) server on OCI in a secure way, protecting all the resources involved through bastion services, private end-point ADB-S database, API Gateway and monitoring with Oracle Data Safe.

You will deploy the infrastructure using Terraform (IaC), expose a table in the ATP-S database using REST. The Rest endpoint  will then be protected in 3 different ways:

* First Party AuthN
* Setup Third Party OAuth 2.0-Based AuthN
* Three-Legged OAuth 2.0-Based AuthN

Estimated Time: 2 hours

## Objectives

* Deploy the infrastructure with Terraform main architectural components
* Access through Bastion Services to ORDS (Oracle REST Data Services) server and ADB-S on a private endpoint
* Setup ORDS (Oracle REST Data Services) for an OAuth 2.0 authentication and authorization.
* Expose with API Gateway the ORDS (Oracle REST Data Services) server.
* Use Oracle Data Safe to monitor ADB-S suspicious access.

## Prerequisites

* OCI Tenant with administrator privileges

## Acknowledgements

* **Author** - Andy Tael, Developer Evangelist;
               Corrado De Bari, Developer Evangelist
* **Contributors** - John Lathouwers, Developer Evangelist
* **Last Updated By/Date** - Andy Tael, August 2022
