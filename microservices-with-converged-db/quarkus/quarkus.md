# Develop with Oracle Database 23ai and GraalVM using Quarkus

## Introduction

This lab walks you through the steps to develop with Oracle Database 23ai and GraalVM using Quarkus
Estimated Time: 30 minutes

### Objectives

In this lab, you will:
- Develop with Oracle Database 23ai and GraalVM using Quarkus

### Prerequisites

This lab assumes you have:
- Provisioned environment with Git and Maven (Cloud Shell).


## Task 1: Clone the repos

## Task 1: Cd to project dir and build the project

1. Open Cloud Shell and make sure you're using X86_64 as your target architecture as was done during the setup lab

2. Cd to the following directory of the repos you cloned during setup. For example, if you cloned to your user's $HOME directory:

    ```
    <copy>   
    cd $HOME/microservices-datadriven/graalvm-nativeimage/quarkus
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

   *Note that the values of the password and path to wallet are those that were collected during setup.

2. Build and run

    ```
    <copy>   
    mvn clean package exec:java -Dexec.mainClass="com.oracle.jdbc.graalvm.App"
    </copy>
    ```  


3. Now build and run the native image. This will take some time (up to 10 minutes)

    ```
    <copy>   
    mvn -Pnative packagemvn -Pnative package
    </copy>
    ```  


    ```
    <copy>   
    target/jdbc-driver-graalvm-nativeimage
    </copy>
    ```  



## Acknowledgements
* **Author** - Paul Parkinson, Architect and Developer Advocate; Juarez Barbosa, Sr. Principal Java Developer Evangelist, Java Database Access
* **Last Updated By/Date** - Paul Parkinson, 2024
