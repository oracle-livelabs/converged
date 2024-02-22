
# Using WebLogic and Helidon Microservices

## Introduction

This lab walks you through the steps for deploying and testing the interoperability between Weblogic Bank Application and Helidon Microservice for Credit Verification.

*Estimated Lab Time:* 90 minutes

### Objectives
* Writing Helidon Microservice
* Deploying WebLogic Application
* Interoperability between Weblogic and Helidon

### Prerequisites
This lab assumes you have:
* A Free Tier, Paid or LiveLabs Oracle Cloud account
* You have completed:
    - Lab: Prepare Setup (*Free-tier* and *Paid Tenants* only)
    - Lab: Initialize Environment

### Lab Description

The very purpose of writing microservices is to do a small piece of job efficiently and re-use it multiple times in different applications. Helidon SE enables us to write one such microservice in this lab.
BestBank, a hypothetical bank has an application. As part of that application, the bank’s credit division wants to build a simple UI which showcases the details of top 15 customers with their SSN number and IBAN number.  The team wants to have a microservice which provides credit score of the customer as output taking the user details like IBAN/SSN numbers as input.
The IT developers create a CreditScore Microservice in Helidon and consume it in the current UI application listing the top 15 customers.

### Implementation Details and Assumptions
* The sample application UI is built to showcase JSF and CDI using XHTML
* The user data is not coming from database
* The Helidon Microservice written in the lab can be deployed on Docker/Kubernetes, but in this lab, we only run it from the JVM locally

### Lab Flow
This lab is designed for people with no prior experience with Kubernetes, Docker, WebLogic, Helidon and want to learn the core concepts and basics of how to run WebLogic JEE and Helidon microservices application.
* Setup Lab Environment
* Verify Basic Bank Application Code and working application
* Develop new Credit Score function as microservice using Helidon SE and deploy on local JVM
* Modify Bank Web Application to use Credit Score microservice and deploy on WebLogic
 
## Task 1: Develop new Credit Score Function
Proceed to Develop new Credit Score Function as microservice using Helidon SE and deploy on local JVM

1. Copy and paste the below command in the terminal to setup the required environment. This command download the required JDK 21 and Maven 3.8.3. Later it setup the environment variable PATH and JAVA_HOME. This setup is required to create Helidon microservice.

    ```
    <copy>wget https://archive.apache.org/dist/maven/maven-3/3.8.3/binaries/apache-maven-3.8.3-bin.tar.gz
    tar -xvf apache-maven-3.8.3-bin.tar.gz
    wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz
    tar -xzvf jdk-21_linux-x64_bin.tar.gz
    PATH=~/jdk-21.0.2/bin:~/apache-maven-3.8.3/bin:$PATH
    JAVA_HOME=~/jdk-21.0.2</copy>
    ```

2. Copy and paste the following command to verify the environment in the terminal.
    ```bash
    <copy>mvn -v</copy>
    ```

    You will have output similar to the below.
    ```bash
    $ mvn -v
    Apache Maven 3.8.3 (ff8e977a158738155dc465c6a97ffaf31982d739)
    Maven home: /home/oracle/apache-maven-3.8.3
    Java version: 21.0.2, vendor: Oracle Corporation, runtime: /home/oracle/jdk-21.0.2
    Default locale: en_US, platform encoding: UTF-8
    OS name: "linux", version: "4.14.35-2047.518.4.2.el7uek.x86_64", arch: "amd64", family: "unix"
    ```
2.	Create a directory called “microservice” under `/u01/middleware_demo/wls-helidon` and navigate to `/u01/middleware_demo/wls-helidon/microservice`

    ```
    <copy>
    mkdir /u01/middleware_demo/wls-helidon/microservice
    cd /u01/middleware_demo/wls-helidon/microservice
    </copy>
    ```

3.	Generate the project sources using Helidon SE Maven archetypes. The result is a simple project that shows the basics of configuring the WebServer and implementing basic routing rule

    ```
    <copy>
    mvn archetype:generate -DinteractiveMode=false \
    	-DarchetypeGroupId=io.helidon.archetypes \
    	-DarchetypeArtifactId=helidon-quickstart-se \
    	-DarchetypeVersion=4.0.5 \
    	-DgroupId=io.helidon.bestbank \
    	-DartifactId=helidon-creditscore-se \
    	-Dpackage=io.helidon.bestbank.creditscore
    </copy>
    ```

4.	When the project generation is ready open the Main.java for edit:

    ```
    <copy>vi helidon-creditscore-se/src/main/java/io/helidon/bestbank/creditscore/Main.java</copy>
    ```

5.	Register the creditscore route after line 58 by adding `".register("/creditscore", new CreditscoreService())"` as indicated below. This basically the context path for the service endpoint.

    ![](./images/register-creditscore-route.png " ")  

6.	Now create a new class called CreditscoreService in the same package where the Main.java is located.  Simply run the following to create the class file

    ```
    <copy>vi helidon-creditscore-se/src/main/java/io/helidon/bestbank/creditscore/CreditscoreService.java</copy>
    ```

7. Copy and paste the below code to the class file.
    ```bash
    <copy>package io.helidon.bestbank.creditscore;

    import io.helidon.webserver.http.HttpRules;
    import io.helidon.webserver.http.HttpService;
    import io.helidon.webserver.http.ServerRequest;
    import io.helidon.webserver.http.ServerResponse;

    import jakarta.json.Json;
    import jakarta.json.JsonObject;

    import static java.lang.System.Logger.Level.INFO;

    public class CreditscoreService implements HttpService {

        private static final System.Logger logger = System.getLogger(CreditscoreService.class.getName());

        private static final int SCORE_MAX = 800;
        private static final int SCORE_MIN = 550;

        /**
        * A service registers itself by updating the routine rules.
        *
        * @param rules the routing rules.
        */
        @Override
        public final void routing(HttpRules rules) {
            rules
                    .get("/healthcheck", this::getHealthCheck)
                    .post("/", this::postMethodCreditScore);
        }

        /**
        * Return a health check message.
        *
        * @param request  the server request
        * @param response the server response
        */
        private void getHealthCheck(final ServerRequest request, final ServerResponse response) {
            JsonObject returnObject = Json.createObjectBuilder()
                    .add("message", "The credit score provider is running.")
                    .build();

            response.send(returnObject);
        }

        /**
        * POST method to return a customer data including credit score value, using the data that was provided.
        * Examples:
        *
        * <pre>{@code
        * curl -s --json '{"first-name":"Frank","last-name":"Helidon","date-of-birth":"15-09-2018","ssn":"1"}' localhost:8080/credit-score | jq
        * {
        *   "first-name": "Frank",
        *   "last-name": "Helidon",
        *   "date-of-birth": "15-09-2018",
        *   "ssn": "00000001",
        *   "score": 552
        * }
        * }</pre>
        *
        * @param request  the server request
        * @param response the server response
        */
        private void postMethodCreditScore(final ServerRequest request, final ServerResponse response) {
            JsonObject reqJson = request.content()
                    .as(JsonObject.class);

            logger.log(INFO, "Request: {0}", reqJson);

            int creditScore = calculateCreditScore(reqJson.getString("firstname"),
                                                reqJson.getString("lastname"),
                                                reqJson.getString("dateofbirth"),
                                                reqJson.getString("ssn"));

            JsonObject resJson = Json.createObjectBuilder(reqJson)
                    .add("score", creditScore)
                    .build();

            response.send(resJson);
        }

        /**
        * Calculate credit score based on customer's properties.
        *
        * @param firstName   first name
        * @param lastName    last name
        * @param dateOfBirth date of birth
        * @param ssn         social security number
        * @return calculated credit score
        */
        private int calculateCreditScore(String firstName, String lastName, String dateOfBirth, String ssn) {

            int score = Math.abs(firstName.hashCode() + lastName.hashCode() + dateOfBirth.hashCode() + ssn.hashCode());

            score = score % SCORE_MAX;

            while (score < SCORE_MIN) {
                score = score + 100;
            }
            return score;
        }

    }</copy>
    ```
    >> Please note the code above accepts a GET for healthcheck and POST method to calculate the credit score value based on the account owner's details which passed using JSON.

7. Build the project:

    ```
    <copy>cd /u01/middleware_demo/wls-helidon/microservice/helidon-creditscore-se/
    mvn package</copy>
    ```

    This will create the executable jar file of the Helidon Microservice under the folder “target”

    ```
    <copy>
    cd /u01/middleware_demo/wls-helidon/microservice/helidon-creditscore-se/target
    ls -alrt helidon-creditscore-se.jar
    </copy>
    ```

## Task 2: Modify Bank Web Application
Proceed to Modify Bank Web Application To Use Credit Score Microservice & Deploy On WebLogic

Before the deployment of the Bank Web Application to consume Microservice, the following changes will be made:
  -	Modify the User Interface. Create View button which opens Account Owner details window. This detail window will show the credit score value of the Account Owner.
  -	Modify the server side bean to invoke Credit Score Microservices Application.
  -	Configure the endpoint for the Bank Web Application.
  -	Deploy new web application

### Modify user Interface

1. Open a new tab in the terminal, so we use preview tab for building and running the helidon application.

2. Open for edit the `/u01/middleware_demo/wls-helidon/src/main/webapp/index.xhtml` HTML file.

    ```
    <copy>vi /u01/middleware_demo/wls-helidon/src/main/webapp/index.xhtml</copy>
   	```

3. Find and delete all the lines which contain REMOVE THIS LINE comment.
Only that one`(!)`, but that full line of comment which contains. (4 lines needs to be removed.) Save the file.
If you are familiar with JSF to check what has changed in the code.

### Modify Server Side Bean
4. Open for edit `/u01/middleware_demo/wls-helidon/src/main/java/com/oracle/oow19/wls/bestbank/AccountOwnerBean.java` class file.

    ```
    <copy>vi /u01/middleware_demo/wls-helidon/src/main/java/com/oracle/oow19/wls/bestbank/AccountOwnerBean.java</copy>
    ```

6. Find and delete the 4 lines which contain the *REMOVE THIS LINE* comment. Save the file and Check what has changed in the code.

    - The postConstruct method modified to read the end point URL from the property file.
    - New getCreditScore method created to calculate the credit score value of the Account Owner.
    - Finally include the new method invocation in getSelectedAccountOwner method which is triggered by the View button on the User Interface.

### Configure End-Point
1. The last file to modify is the `/u01/middleware_demo/wls-helidon/src/main/resources/app.properties` file.

    The Bank Web Application reads this properties file to know the endpoint's URL. Obviously this solution is just for demo purposes, because in real microservices architecture the best practice is to use additional tools for better service/API management.

    ```
    <copy>vi /u01/middleware_demo/wls-helidon/src/main/resources/app.properties</copy>
   	```

2. Replace the URL to your given value and save: `creditscore.url=http://cvgdb.oraclevcn.com:8080/creditscore`

### Deploy Modified Web Application

1. Source the `setWLS14Profile.sh` and `setBankAppEnv.sh` to set the environment variables required to start the WebLogic 14c Admin server and run commands to build Helidon and Bank applications

    ```
    <copy>cd /u01/middleware_demo/scripts/
    . ./setWLS14Profile.sh
    . ./setBankAppEnv.sh</copy>
    ```

2. Change the directory to wls-helidon where the Bank Application code reside

    ```
    <copy>cd /u01/middleware_demo/wls-helidon/</copy>
    ```

3. Run the following Maven command:

    ```
    <copy>mvn clean package</copy>
    ```

    When the build is complete and successful, open the browser and access the new bank application using the URL *`http://cvgdb.oraclevcn.com:7101/bestbank2020_01`*

4. Select an Account Owner and click the new View button. A pop-up window with no information about the credit score of the user is seen. This is because the microservice is not yet started !!!

### Start The Helidon Microservice
1. Go back to the tab, where you have set Maven and JDK 21..
2. Navigate to `/u01/middleware_demo/wls-helidon/microservice/helidon-creditscore-se/target/`

    ```
    <copy>cd /u01/middleware_demo/wls-helidon/microservice/helidon-creditscore-se/target/</copy>
    ```

3. Start the Microservice application as a standalone Java Program using the command:

    ```
    <copy>java -jar helidon-creditscore-se.jar &</copy>
    ```

    ![](./images/start-microservice.png " ")  

4. In the browser, check if the CreditScore Microservice application is running by checking the health check url `http://cvgdb.oraclevcn.com:8080/creditscore/healthcheck`
5. Open the browser and access the new bank application using the URL `http://cvgdb.oraclevcn.com:7101/bestbank2020_01` or refresh the existing browser window with the above URL
6. Select an Account Owner and click the new View button.	A pop-up window with CreditScore information of the user is seen.  

    ![](./images/creditscore.png " ")  

*Congratulations! You have successfully completed the workshop*

## Acknowledgements
* **Author** - Srinivas Pothukuchi, Pradeep Chandramouli, Chethan BR, AppDev & Integration Team, Oracle, October 2020
* **Contributors** - Meghana Banka, Rene Fontcha
* **Last Updated By/Date** - Ankit Pandey, February 2024
