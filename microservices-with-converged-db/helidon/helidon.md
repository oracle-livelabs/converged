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


## Task 1: Cd to project dir

1. Open Cloud Shell and make sure you're using X86_64 as your target architecture as was done during the setup lab

2. Cd to the following directory of the repos you cloned during setup. For example, if you cloned to your user's $HOME directory:

    ```
    <copy>   
    cd $HOME/microservices-datadriven/graalvm-nativeimage/helidon
    </copy>
    ``` 


## Task 2: Build and run

1. Edit (using `vi` or similar tool) `src/main/resources/META-INF/microprofile-config.properties` to provide appropriate values for URL, user, and password such as the following.
   Replace values with those found in the workshop `Reservation Information` page and the explicit (eg don't use "~") home directory path as appropriate...

   ```properties
   javax.sql.DataSource.example.connectionFactoryClassName=oracle.jdbc.pool.OracleDataSource
   javax.sql.DataSource.example.URL=jdbc:oracle:thin:@<tnsServiceName>_high?TNS_ADMIN=/home/<myhomedir>/myatpwallet
   javax.sql.DataSource.example.user=ADMIN
   javax.sql.DataSource.example.password=<password>
   ```


2. Build and run with Java command

    ```
    <copy>   
    mvn package ; java -jar target/com-oracle-helidon-datasource.jar
    </copy>
    ```  
    
   Open a second OCI console and Cloud Shell and find out the hostname.

    ```
    <copy>   
     echo $HOSTNAME
    </copy>
    ```  
  
   Then use that hostname to issue this curl command against the application
    ```
    <copy>   
    curl http://<HOSTNAME>:8080/tables
    </copy>
    ```  
    

3. Build and run native image

    ```
    <copy>   
    mvn -Pnative-image install -DskipTests -H:AdditionalSecurityProviders
    </copy>
    ```  
    
    ```
    <copy>   
    ./com-oracle-helidon-datasource
    </copy>
    ```  
    
    ```
    <copy>   
    curl http://<HOSTNAME>:8080/tables
    </copy>
    ```  

Congratulations on connecting your Helidon app to Oracle Autonomous Database!
Please explore the source code, configuration, and Oracle Database features to learn more about how to enhance this application.

## Acknowledgements
* **Author** - Paul Parkinson, Architect and Developer Advocate; Arjav Desai, Helidon Developer 
* **Last Updated By/Date** - Paul Parkinson, 2024
