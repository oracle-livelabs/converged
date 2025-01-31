# Workshop setup

## Introduction

In this lab, you'll set up the resources to run the workshop on your local development machine.

Estimated Time: 5 minutes

### Objectives

- Start an Oracle Database Free Container

### Prerequisites

- This lab requires access to development machine with at least 8 GB of RAM, 2 CPUs, and a docker compatible container runtime. 

## **Task 1:** Pull the Oracle Database Free Container Image

```bash
docker pull gvenzl/oracle-free:23.6-slim-faststart
```

## **Task 2:** Run the Oracle Database Free Container Instance

The following docker command starts a `oracledb` container, forwarding port `1521` to the container's database port, `1521`. Before running this command, replace `<YOUR ORACLE ADMIN PASSWORD>` with a secure password of your choice.

```bash
docker run --name oracledb -d -p 1521:1521 \
  -e ORACLE_PASSWORD=<YOUR ORACLE ADMIN PASSWORD> \
  gvenzl/oracle-free:23.6-slim-faststart
```

## **Task 3:** Log in to the Oracle Database Container

The following command opens a bash shell on the `oracledb` container.

```bash
docker exec -it oracledb bash
```

From the container's bash shell, you may run commands like `sqlplus`.

```bash
$ sqlplus / as sysdba

SQL*Plus: Release 23.0.0.0.0 - for Oracle Cloud and Engineered Systems on Fri Jan 31 21:20:31 2025
Version 23.6.0.24.10

Copyright (c) 1982, 2024, Oracle.  All rights reserved.


Connected to:
Oracle Database 23ai Free Release 23.0.0.0.0 - Develop, Learn, and Run for Free
Version 23.6.0.24.10

SQL>
```

You may now **proceed to the next lab**

## Acknowledgements

- **Authors** - Anders Swanson, Developer Evangelist;
- **Contributors** - 
- **Last Updated By/Date** - Anders Swanson, Feb 2024
