
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

> Your updated file should be same as shown below
    ```bash
    <html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:ui="http://java.sun.com/jsf/facelets"
      xmlns:h="http://java.sun.com/jsf/html"
      xmlns:f="http://java.sun.com/jsf/core"
      xmlns:p="http://primefaces.org/ui">

    <ui:composition template="template.xhtml">
        <ui:define name="head">
        
	</ui:define>
        <ui:define name="title">
            <h:outputText value="BestBank Webapp"></h:outputText>
        </ui:define>

        <ui:define name="header">
            <div>
                <h2>BestBank Webapp</h2>
                <p class="lead">This project shows a basic example of a web application working with JSF and CDI to simulate some functionality of bank system.</p>
            </div>
        </ui:define>

        <ui:define name="body">
            <div class="well">
                <h:form id="form" styleClass="form">
                    <legend>Account Owners</legend>
                    
                    <p:dataTable id="singleDT" var="owner" value="#{accountOwnerBean.accountOwnerList}" 
                    selectionMode="single" selection="#{accountOwnerBean.selectedAccountOwner}" rowKey="#{owner.id}">
			            <p:column headerText="IBAN">
			                <h:outputText value="#{owner.id}"/>
			            </p:column>
			
			            <p:column headerText="First Name">
			                <h:outputText value="#{owner.firstname}"/>
			            </p:column>
			            
			            <p:column headerText="Last Name">
			                <h:outputText value="#{owner.lastname}"/>
			            </p:column>
			
			            <p:column headerText="Date of Birth">
			                <h:outputText value="#{owner.dateofbirth}"/>
			            </p:column>
			
			            <p:column headerText="SSN">
			                <h:outputText value="#{owner.ssn}"/>
			            </p:column>
			           
			            <f:facet name="footer">
			            	<p:commandButton process="singleDT" update=":form:ownerDetail" icon="pi pi-search" value="View" oncomplete="PF('ownerDialog').show()" />
			        	</f:facet>
			        	
			        </p:dataTable>

                    <br/>
					
	                <p:dialog header="Account Owner Info" widgetVar="ownerDialog" modal="true" showEffect="fade" hideEffect="fade" resizable="false">
				        <p:outputPanel id="ownerDetail" style="text-align:center;">
				            <p:panelGrid  columns="2" rendered="#{not empty accountOwnerBean.selectedAccountOwner}" columnClasses="label,value">
				                 
				                 <f:facet name="header">
				                    <p:graphicImage name="images/person.details.png"/> 
				                </f:facet>
				                 
				                <h:outputText value="IBAN:" />
				                <h:outputText value="#{accountOwnerBean.selectedAccountOwner.id}" />
				 
				                <h:outputText value="First Name:" />
				                <h:outputText value="#{accountOwnerBean.selectedAccountOwner.firstname}" />

				                <h:outputText value="Last Name:" />
				                <h:outputText value="#{accountOwnerBean.selectedAccountOwner.lastname}" />
				                				 
				                <h:outputText value="Date of Birth:" />
				                <h:outputText value="#{accountOwnerBean.selectedAccountOwner.dateofbirth}" />
				             
				                <h:outputText value="SSN:" />
				                <h:outputText value="#{accountOwnerBean.selectedAccountOwner.ssn}" />
				                
				                <h:outputText value="Credit Score" />
				                <h:outputText value="#{accountOwnerBean.selectedAccountOwner.score}" style="color:#{(accountOwnerBean.selectedAccountOwner.score lt 600) ? 'Red' : 'Green'}"/>
				                
				 		
				            </p:panelGrid>
				        </p:outputPanel>
				    </p:dialog>
				
                </h:form>
            </div>
        </ui:define>

        <ui:define name="footer">   
            <footer>
                <p>BestBank Limited</p>
            </footer>
        </ui:define>
    </ui:composition>
</html>

    ```


### Modify Server Side Bean
4. Open for edit `/u01/middleware_demo/wls-helidon/src/main/java/com/oracle/oow19/wls/bestbank/AccountOwnerBean.java` class file.

    ```
    <copy>vi /u01/middleware_demo/wls-helidon/src/main/java/com/oracle/oow19/wls/bestbank/AccountOwnerBean.java</copy>
    ```

6. Find and delete the lines which contain the *REMOVE THIS LINE* comment. Save the file and Check what has changed in the code.

    - The postConstruct method modified to read the end point URL from the property file.
    - New getCreditScore method created to calculate the credit score value of the Account Owner.
    - Finally include the new method invocation in getSelectedAccountOwner method which is triggered by the View button on the User Interface.

> Your updated code should be same as shown below:
    ```bash
    package com.oracle.oow19.wls.bestbank;

    import java.io.IOException;
    import java.io.Serializable;
    import java.text.SimpleDateFormat;
    import java.util.ArrayList;
    import java.util.List;
    import java.util.Properties;
    import java.util.Random;
    import java.util.logging.Logger;

    import javax.annotation.PostConstruct;
    import javax.faces.bean.ManagedBean;
    import javax.faces.bean.SessionScoped;
    import javax.ws.rs.client.ClientBuilder;
    import javax.ws.rs.client.Entity;
    import javax.ws.rs.client.WebTarget;
    import javax.ws.rs.core.MediaType;
    import javax.ws.rs.core.Response;

    import com.github.javafaker.Faker;

    @ManagedBean
    @SessionScoped
    public class AccountOwnerBean implements Serializable {

        private static final long serialVersionUID = 4417676256979648115L;
        
        private static final Logger logger = Logger.getLogger(AccountOwnerBean.class.getName());

        private List<AccountOwner> accountOwnerList = new ArrayList<>();

        private AccountOwner selectedAccountOwner;
        
        private String creditScoreUrl;

        @PostConstruct
        private void postConstruct () {
            Random random = new Random();
            Faker faker = new Faker();
            for (int i = 1; i < 15; i++) {
                AccountOwner owner = new AccountOwner();
                owner.setId(faker.finance().iban("DE"));
                owner.setFirstname(faker.name().firstName());
                owner.setLastname(faker.name().lastName());
                owner.setDateofbirth(new SimpleDateFormat("MM/dd/yyyy").format(faker.date().birthday()));
                owner.setSsn(String.format("%s-%s-%s", random.nextInt((999 - 100) + 1) + 100, 
                        random.nextInt((99 - 10) + 1) + 10, 
                        random.nextInt((9999 - 1000) + 1) + 1000));
                accountOwnerList.add(owner);
            }
            
        
            Properties props = new Properties();
            try {
                props.load(this.getClass().getResourceAsStream("/app.properties"));
            } catch (IOException e) {
                e.printStackTrace();
            }
            this.creditScoreUrl = props.getProperty("creditscore.url");
            
        }

        public List<AccountOwner> getAccountOwnerList() {
            return accountOwnerList;
        }
        
        public void setSelectedAccountOwner(AccountOwner selectedOwner) {
            this.selectedAccountOwner = selectedOwner;
        }

            
        public AccountOwner getSelectedAccountOwner() {
            
            if (this.selectedAccountOwner != null) {
                this.selectedAccountOwner = getCreditScore(this.selectedAccountOwner);
            }
            
            return this.selectedAccountOwner;
        }

        private AccountOwner getCreditScore (AccountOwner owner) {
            
            WebTarget webTarget = ClientBuilder.newClient().target(this.creditScoreUrl);

            Response response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.entity(owner, MediaType.APPLICATION_JSON));
            
            if (response.getStatus() != 200) {
                logger.warning("Failed : HTTP error code : " + response.getStatus() + ", " + response.readEntity(String.class));
                return owner;
            }
    
            owner = response.readEntity(AccountOwner.class);
            
            response.close();
    
            return owner;
        }
        

    }
    ```

### Configure End-Point
1. The last file to modify is the `/u01/middleware_demo/wls-helidon/src/main/resources/app.properties` file.

    The Bank Web Application reads this properties file to know the endpoint's URL. Obviously this solution is just for demo purposes, because in real microservices architecture the best practice is to use additional tools for better service/API management.

    ```
    <copy>vi /u01/middleware_demo/wls-helidon/src/main/resources/app.properties</copy>
   	```

2. Replace the URL to your given value and save: `creditscore.url=http://cvgdb.oraclevcn.com:8080/creditscore`

> Your updated code should be same as shown below:
    ```bash
    creditscore.url=http://cvgdb.oraclevcn.com:8080/creditscore
    ```

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

    When the build is complete and successful, open the browser and access the new bank application using the URL *`http://cvgdb.oraclevcn.com:7101/bestbank2020_01/`*

4. Select an Account Owner and click the new View button. A pop-up window with no information about the credit score of the user is seen. This is because the microservice is not yet started !!!
    ![modify webapp](./images/modify-webapp.png)

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
    ![check microservice](./images/check-microservice.png)

5. Open the browser and access the new bank application using the URL `http://cvgdb.oraclevcn.com:7101/bestbank2020_01/` or refresh the existing browser window with the above URL

6. Select an Account Owner and click the new View button.	A pop-up window with CreditScore information of the user is seen.  

    ![](./images/creditscore.png " ")  

*Congratulations! You have successfully completed the workshop*

## Acknowledgements
* **Author** - Srinivas Pothukuchi, Pradeep Chandramouli, Chethan BR, AppDev & Integration Team, Oracle, October 2020
* **Contributors** - Meghana Banka, Rene Fontcha
* **Last Updated By/Date** - Ankit Pandey, February 2024
