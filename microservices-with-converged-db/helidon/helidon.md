# Develop with Oracle Database 23ai and GraalVM using Helidon

## Introduction

This lab walks you through the steps to develop with Oracle Database 23ai and GraalVM using Helidon.

Helidon is a cloud-native, open‑source set of Java libraries for writing microservices that run on a fast web core powered by Java virtual threads.

Helidon also supports MicroProfile, a platform definition that uses Java EE and Jakarta EE technologies.

Estimated Time: 30 minutes

### Objectives

In this lab, you will:
- Develop with Oracle Database 23ai and GraalVM using Helidon


### Prerequisites

This lab assumes you have:
- Provisioned environment with Git and Maven (Cloud Shell).


## Task 1: Clone the repos

1. Clone the following repos:

    ```
    <copy>   
    git clone https://github.com/paulparkinson/microservices-datadriven-devrel.git
    </copy>
    ```


## Task 2: Build and run

1. To ensure that the sample application is configured to talk to the
   Oracle ATP database running in OCI, verify that the
   following lines (among others) are set to correct values in
   `src/main/resources/META-INF/microprofile-config.properties`:

   ```properties
   javax.sql.DataSource.example.connectionFactoryClassName=oracle.jdbc.pool.OracleDataSource
   javax.sql.DataSource.example.URL=jdbc:oracle:thin:@<tnsServiceName>?TNS_ADMIN=/path/to/wallet
   javax.sql.DataSource.example.user=ADMIN
   javax.sql.DataSource.example.password=<password>
   ```


2. Build and run

    ```
    <copy>   
    mvn package ; java -jar target/com-oracle-helidon-datasource.jar
    </copy>
    ```  
    
    ```
    <copy>   
    curl http://localhost:8080/tables
    </copy>
    ```  
    

3. Build and run native image

    ```
    <copy>   
    mvn -Pnative-image install -DskipTests
    </copy>
    ```  
    
    ```
    <copy>   
    ./com-oracle-helidon-datasource
    </copy>
    ```  
    
    ```
    <copy>   
    curl http://localhost:8080/tables
    </copy>
    ```  
    

## Acknowledgements
* **Author** - Paul Parkinson, Architect and Developer Advocate; Arjav Desai, Helidon Developer 
* **Last Updated By/Date** - Paul Parkinson, 2024
