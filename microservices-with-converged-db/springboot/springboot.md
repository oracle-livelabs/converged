# Develop with Oracle Database 23ai and GraalVM using Spring Boot

## Introduction

This lab walks you through the steps to develop with Oracle Database 23ai and GraalVM using Spring Boot
Estimated Time: 30 minutes

### Objectives

In this lab, you will:
- Develop with Oracle Database 23ai and GraalVM using Spring Boot

### Prerequisites

This lab assumes you have:
- Provisioned environment with Git and Maven (Cloud Shell).


## Task 1: Cd to project dir and build the project

1. Open Cloud Shell and make sure you're using X86_64 as your target architecture as was done during the setup lab

2. Cd to the following directory of the repos you cloned during setup. For example, if you cloned to your user's $HOME directory:

    ```
    <copy>   
    cd $HOME/microservices-datadriven/graalvm-nativeimage/springboot
    </copy>
    ```   

## Task 2: Build and run

1. Edit src/main/java/com/oracle/jdbc/graalvm/GraalVMNativeImageJDBCDriver.java to include appropriate values for URL, user, and password such as the following. 
   Replace values with those found in the workshop `Reservation Information` page and the explicit home directory path as appropriate...


   ```java
        //notice the servicename suffix appended, which can be _high, _low, ...
		ods.setURL("jdbc:oracle:thin:@${ATP Name}_high?TNS_ADMIN=/home/${MY_HOME_DIR}/myatpwallet");
        ods.setUser("ADMIN");
        ods.setPassword("[ATP Admin Password]");
   ```

   *Again note that the values of the password and path to wallet are those that were collected during setup.

2. Build and run the following and notice the `Hello World!` output after startup, indicating a connection has been made to the ATP instance

    ```
    <copy>   
    mvn clean package exec:java -Dexec.mainClass="com.oracle.jdbc.graalvm.GraalVMNativeImageJDBCDriver"
    </copy>
    ```  


3. Now build and run the native image. This will take some time (up to 10 minutes)

    ```
    <copy>   
    mvn -Pnative package
    </copy>
    ```  
    This will take a bit of time to complete. On the order of 10 or 15 minutes.  When complete, run the native image generated...

    ```
    <copy>   
    target/jdbc-driver-graalvm-nativeimage
    </copy>
    ```  



## Acknowledgements
* **Author** - Paul Parkinson, Architect and Developer Advocate; Juarez Barbosa, Sr. Principal Java Developer Evangelist, Java Database Access
* **Last Updated By/Date** - Paul Parkinson, 2024
