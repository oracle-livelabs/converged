# Develop with Oracle Database 23ai and GraalVM using Micronaut

## Introduction

This lab walks you through the steps to develop with Oracle Database 23ai and GraalVM using Micronaut.

Micronaut is an open-source JVM-based framework for building Java microservices. It is designed to avoid reflection, thus reducing memory consumption and improving start times. Features are pre-computed at compile time with Ahead of Time (AOT) compilation instead of doing so at runtime as with other Java frameworks.

Micronaut Data is a database access toolkit that uses Ahead of Time (AOT) compilation to pre-compute queries for repository interfaces. A thin, lightweight runtime layer executes those queries. That’s a killer feature if positioned in combination with GraalVM!

Micronaut Data JDBC is a Micronaut extension, part of the Micronaut Data project, which comprises other options like Reactive, JPA, and so on. However, Micronaut Data JDBC focuses on data access and persistence using the Java Database Connectivity (JDBC) API.

At last but not least, GraalVM is a high-performance Java runtime that provides significant improvements in application performance and efficiency by integrating a state-of-the-art just-in-time (JIT) compiler and an ahead-of-time (AOT) compiler as well, being a great complement to Micronaut.
It allows developers to compile Java applications into native executables, resulting in faster startup times and lower memory utilization. This makes it an ideal choice for modern, cloud-native applications.

Estimated Time: 30 minutes

### Objectives

In this lab, you will:
- Develop with Oracle Database 23ai and GraalVM using Spring Boot

### Prerequisites

This lab assumes you have:
- Provisioned environment with Git and Maven (Cloud Shell).


## Task 1: Download and install the Micronaut CLI

1. Open Cloud Shell and make sure you're using X86_64 as your target architecture as was done during the setup lab

2. To install the Micronaut CLI on Linux, open a terminal and run:

    ```
    <copy>   
    sdk install micronaut  
    </copy>
    ```

    If everything goes well, you will see confirmation messages as shown below.

    ![micronaut cli](images/micronaut-cli.png)

    You can now verify your instalation and the installed Micronaut CLI version:

    ```
    <copy>   
    mn --version    
    </copy>
    ```    
    You should see `Micronaut Version: 4.6.2` as the installed Micronaut CLI version.



## Task 2: Configure Micronaut Data with your Oracle ADB instance details

1.  Edit (using `vi` or similar tool) the `application.properties` file under `$HOME//micronaut-graalvm-oracledb/micronaut-guide/src/main/resources`:  

    ```
    <copy>
    datasources.default.username=ADMIN
    datasources.default.password=<password>
    datasources.default.URL=jdbc:oracle:thin:@<tnsServiceName>_high?TNS_ADMIN=/home/<myhomedir>/myatpwallet
    datasources.default.walletPassword=<YOUR_WALLET_PASSWORD>
    </copy>
    ```  
    
    *Again note that the values of the password and path to wallet are those that were collected during setup.

## Task 3: Build and run with Java

1. Build and run the following and notice the `Hello World!` output after startup, indicating a connection has been made to the ATP instance.

    ```
    <copy>
    cd $HOME/microservices-datadriven/graalvm-nativeimage/micronaut         
    mvn clean package -DskipTests
    mvn mn:run
   
    </copy>
    ```

Congratulations on connecting your Micronaut app to Oracle Autonomous Database!

You can learn more about Micronaut and native image builds at https://micronaut.io/ (in order to build and run with `mvn package -DskipTests -Dpackaging=native-images` etc.)

Please try it out in your favorite development environment and explore the source code, configuration, and Oracle Database features to learn more about how to enhance this application.

## Acknowledgements
* **Author** - Paul Parkinson, Architect and Developer Advocate; Juarez Barbosa, Sr. Principal Java Developer Evangelist, Java Database Access
* **Last Updated By/Date** - Paul Parkinson, 2024
