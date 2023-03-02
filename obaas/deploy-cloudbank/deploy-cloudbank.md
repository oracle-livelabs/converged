# Deploy the full CloudBank Application

## Introduction

Now that you know how to build a Spring Boot microservice and deploy it to the Oracle Backend for Spring Boot, this lab will guide you through deploying the rest of the Cloud Bank services that we have already built for you and exploring the runtime and management capabilities of the platform.

Estimated Lab Time: 20 minutes

### Objectives

In this lab, you will:

* Deploy the full CloudBank sample application into your Oracle Backend for Spring Boot instance

### Prerequisites

This lab assumes you have:

* An Oracle Cloud account
* All previous labs successfully completed
* Git version control tool installed on your computer (optional)

## Task 1: Get a copy of the CloudBank sample application

Download a copy of the CloudBank sample application.

1. Clone the source repository

	Create a local clone of the CloudBank source repository using this command. **NOTE** If you did Lab three (Build the Account Microservice) you can skip this step as you already have the source code.

    ```shell
    $ <copy>git clone TODO:TODO</copy>
    ```

    > **Note**: If you do not have **git** installed on your machine, you can download a zip file of the source code from TODO and unzip it on your machine instead.

## Task 2: Build the CloudBank application

1. Create application JAR files

	Go to the directory where you cloned (or unzipped) the application and create the applications using the following command:
	TODO: parent pom.xml needs to work

	```shell
	$ <copy>mvn package -Dmaven.test.skip=true</copy>
	```

## Task 3: Install CloudBank in your Oracle Backend for Spring Boot instance

1. Prepare the backend for deployment

 	The Oracle Backend for Spring Boot admin service is not exposed outside of the Kubernetes cluster by default. Oracle recommends using a kubectl port forwarding tunnel to establish a secure connection to the admin service.

	Start a tunnel using this command:

	```shell
	$ <copy>kubectl -n obaas-admin port-forward svc/obaas-admin 8080:8080</copy>
	Forwarding from 127.0.0.1:8080 -> 8080
	Forwarding from [::1]:8080 -> 8080
	```

2. Start the Oracle Backend for Spring Boot CLI

	Open a new terminal Window or Tab and start the Oracle Backend for Spring Boot CLI using this command:

	```shell
    $ <copy>oractl</copy>
     _   _           __    _    ___
    / \ |_)  _.  _. (_    /  |   |
    \_/ |_) (_| (_| __)   \_ |_ _|_

    2023-03-02T12:41:01.794-06:00  INFO 36886 --- [           main] o.s.s.cli.OracleSpringCLIApplication     : Starting AOT-processed OracleSpringCLIApplication using Java 17.0.5 with PID 36886 (/Users/atael/bin/oractl started by atael in /Users/atael/Oracle)
	2023-03-02T12:41:01.796-06:00  INFO 36886 --- [           main] o.s.s.cli.OracleSpringCLIApplication     : No active profile set, falling back to 1 default profile: "default"
	2023-03-02T12:41:01.898-06:00  INFO 36886 --- [           main] o.s.s.cli.OracleSpringCLIApplication     : Started OracleSpringCLIApplication in 0.186 seconds (process running for 0.255)
    oractl:>
    ```

3. Connect to the Oracle Backend for Spring Boot admin service

	Connect to the Oracle Backend for Spring Boot admin service using this command.  Hit enter when prompted for a password.  **Note**: Oracle recommends changing the password in a real deployment.

    ```shell
    oractl> <copy>connect</copy>
    password (defaults to oractl):
    using default value...
    connect successful server version:011223
    ```

4. Create Database Bindings

	Create database bindings for the applications by running the following commands in the CLI. You are going to create two different bindings. **NOTE**: If you have finished Lab three (Build the Account Microservice) you have already created the binding for the Accounts Service and you only need to create the Customer Service binding.

	1. Account Service

		Create a database "binding" by tunning this command. Enter the password (`Welcome1234##`) when prompted.  This will create a Kubernetes secret in the `application` namespace called `account-db-secrets` which contains the username (`account`), password, and URL to connect to the Oracle Autonomous Database instance associated with the Oracle Backend for Spring Boot.

		```shell
    	oractl:> <copy>bind --appName application --serviceName account --springBindingPrefix spring.db</copy>
    	database password/servicePassword (defaults to Welcome12345): 
    	database secret created successfully and schema already exists for account
    	```

	2. Customer Service

		Create a database "binding" by tunning this command. Enter the password (`Welcome1234##`) when prompted.  This will create a Kubernetes secret in the `application` namespace called `customer-db-secrets` which contains the username (`customer`), password, and URL to connect to the Oracle Autonomous Database instance associated with the Oracle Backend for Spring Boot.

		```shell
    	oractl:> <copy>bind --appName application --serviceName customer --springBindingPrefix spring.db</copy>
    	database password/servicePassword (defaults to Welcome12345): 
    	database secret created successfully and schema already exists for customer
		```
  
5. Create Database Objects

	TODO: Liquibase, overwrite whatever is already in there? Does it matter?

	TODO: Verify data using SQLcl?

6. Deploy the services

	**NOTE**: If you have finished Lab three (Build the Account Microservice) and Lab four (Manage Transactions across Microservices) you can skip step one (Deploy/Redploy the Account Service) below and only create the Customer Service binding (step two).

	1. Deploy/Redeploy the Account Service

		You will now deploy your Account service to the Oracle Backend for Spring Boot using the CLI.  You will deploy into the `application` namespace, and the service name will be `account`. Run this command to deploy your service, make sure you provide the correct path to your JAR file:

    	```shell
    	oractl> <copy>
		deploy --isRedeploy false --appName application --serviceName account --jarLocation /path/to/accounts/target/accounts-0.0.1-SNAPSHOT.jar --imageVersion 0.0.1</copy>
		uploading... upload successful
		building and pushing image... docker build and push successful	
		creating deployment and service... create deployment and service  = account, appName = application, isRedeploy = false successful
    	successfully deployed
    	```

		If you'd like to re-deploy the accounts service (if you didn't finish lab 4) you cana re-deploy the Account Service using the following command, make sure you provide the correct path to your JAR file:

		```shell
    	oractl> <copy>
		deploy --isRedeploy true --appName application --serviceName account --jarLocation /path/to/accounts/target/accounts-0.0.1-SNAPSHOT.jar --imageVersion 0.0.1</copy>
		uploading... upload successful
		building and pushing image... docker build and push successful	
		creating deployment and service... create deployment and service  = account, appName = application, isRedeploy = true successful
    	successfully deployed
    	```

	2. Deploy the Customer Service

	You will now deploy your Customer service to the Oracle Backend for Spring Boot using the CLI.  You will deploy into the `application` namespace, and the service name will be `customer`. Run this command to deploy your service, make sure you provide the correct path to your JAR file:

    	```shell
    	oractl> <copy>
		deploy --isRedeploy false --appName application --serviceName customer --jarLocation /path/to/accounts/target/customers-0.0.1-SNAPSHOT.jar --imageVersion 0.0.1</copy>
		uploading... upload successful
		building and pushing image... docker build and push successful	
		creating deployment and service... create deployment and service  = customer, appName = application, isRedeploy = false successful
    	successfully deployed
    	```

## Task 3: Verify the deployment

TODO: Some kind of verification perhaps curl to account, customer and transaction?

## Task 4: Expose the services using APISIX Gateway

1. Get APISIX Gateway Admin Key

	```shell
	<copy>kubectl .....</copy>
	```

2. Start the tunnel using this command:

	```shell
	$ <copy>kubectl -n apisix port-forward svc/apisix-admin 9180:9180</copy>
	Forwarding from 127.0.0.1:9180 -> 9180
	Forwarding from [::1]:9180 -> 9180
	```

3. Create the routes

	In the `scripts` directory where you saved the code repository there are 3 scripts to create the routes. Run the commands:

	```shell
	$ <copy>source apisix-routes/create-accounts-route.sh APIKEY</copy>
	```

	``` shell
	$ <copy>source apisix-routes/create-creditscore-route.sh APIKEY</copy>
	```

	```shell
	$ <copy>source apisix-routes/create-customer-route.sh APIKEY</copy>
	```

3. Verify the account service

   In the next two commands, you need to provide the correct IP address for the API Gateway in your backend environment.  You can find the IP address using this command, you need the one listed in the `EXTERNAL-IP` column. In the example below the IP address is `100.20.30.40`
   
    ```shell
    $ <copy>kubectl -n ingress-nginx get service ingress-nginx-controller</copy>
    NAME                       TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
    ingress-nginx-controller   LoadBalancer   10.123.10.127   100.20.30.40  80:30389/TCP,443:30458/TCP   13d
	```

	Test the create account endpoint with this command, use the IP address for your API Gateway:

    ```shell
    $ <copy>curl -i -X POST \
      -H 'Content-Type: application/json' \
      -d '{"accountName": "Sanjay''s Savings", "accountType": "SA", "accountCustomerId": "bkzLp8cozi", "accountOtherDetails": "Savings Account"}' \
      http://100.20.30.40/api/v1/account</copy>
    HTTP/1.1 201
    Date: Wed, 01 Mar 2023 18:35:31 GMT
    Content-Type: application/json
    Transfer-Encoding: chunked
    Connection: keep-alive

    {"accountId":24,"accountName":"Sanjays Savings","accountType":"SA","accountCustomerId":"bkzLp8cozi","accountOpenedDate":null,"accountOtherDetails":"Savings Account","accountBalance":0}
    ```

	Test the get account endpoint with this command, use the IP address for your API Gateway and the `accountId` that was returned in the previous command:

    ```shell
    $ <copy>curl -s http://100.20.30.40/api/v1/account/24 | jq .</copy>
    {
      "accountId": 24,
      "accountName": "Sanjay's Savings",
      "accountType": "SA",
      "accountCustomerId": "bkzLp8cozi",
      "accountOpenedDate": null,
      "accountOtherDetails": "Savings Account",
      "accountBalance": 1040
    }
    ```

## Task 5: Mobile application

TODO: verify ???

**TDDO - make sure we created some users and accounts, including in parse for the mobile app**

## Learn More

* [Oracle Backend for Spring Boot](https://oracle.github.io/microservices-datadriven/spring/)
* [Oracle Backend for Parse Platform](https://oracle.github.io/microservices-datadriven/mbaas/m)

## Acknowledgements

* **Author** - Andy Tael, Developer Evangelist, Oracle Database
* **Contributors** - [](var:contributors)
* **Last Updated By/Date** - Andy Tael, February 2023
