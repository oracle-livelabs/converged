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


## Task 1: Install GraalVM 22 and dd to project dir

1. Open Cloud Shell and make sure you're using X86_64 as your target architecture as was done during the setup lab

2. Cd to the following directory of the repos you cloned during setup. For example, if you cloned to your user's $HOME directory:

    ```
    <copy>   
    sdk list java
    sdk install java 22.0.2-graal
    sdk use java 22.0.2-graal
    sdk current
    csruntimectl java list
    csruntimectl java set graalvmjdk-17
    </copy>
    ```   


3. Cd to the following directory of the repos you cloned during setup. For example, if you cloned to your user's $HOME directory:

    ```
    <copy>   
    cd $HOME/microservices-datadriven/graalvm-nativeimage/helidon
    </copy>
    ```   


## Task 2: Build and run

1. To ensure that the sample application is configured to talk to the
   Oracle ATP database running in OCI, verify that the
   following lines (among others) are set to correct values in
   `src/main/resources/META-INF/microprofile-config.properties`:

   ```properties
   javax.sql.DataSource.example.connectionFactoryClassName=oracle.jdbc.pool.OracleDataSource
   javax.sql.DataSource.example.URL=jdbc:oracle:thin:@<tnsServiceName>_high?TNS_ADMIN=/home/<myhomedir>/myatpwallet
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
