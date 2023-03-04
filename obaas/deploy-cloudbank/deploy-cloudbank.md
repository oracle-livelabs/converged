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
* Have all the necessary tools installed (kubectl, git, maven, oractl, sqlcl). All of them should be installed during Lab two (Setup your Development Environment)
* Git version control tool installed on your computer (optional)

## Task 1: Get a copy of the CloudBank sample application

Download a copy of the CloudBank sample application.

1. Clone the source repository

	Create a local clone of the CloudBank source repository using this command.

    ```shell
    $ <copy>git clone https://github.com/oracle/microservices-datadriven.git TODO:TODO</copy>
    ```

    > **Note**: If you do not have **git** installed on your machine, you can download a zip file of the source code from TODO and unzip it on your machine instead.

## Task 2: Build the CloudBank application

1. Create application JAR files

	Go to the directory where you cloned (or unzipped) the application and build the application JARs using the following command:

	```shell
	$ <copy>mvn package -Dmaven.test.skip=true</copy>
	```

	The output should be similar to this:

	```text
	[INFO] -------------------< com.example:sample-spring-apps >-------------------
	[INFO] Building cloudbank 0.0.1-SNAPSHOT                                  [4/4]
	[INFO]   from pom.xml
	[INFO] --------------------------------[ pom ]---------------------------------
	[INFO] ------------------------------------------------------------------------
	[INFO] Reactor Summary for cloudbank 0.0.1-SNAPSHOT:
	[INFO]
	[INFO] account ............................................ SUCCESS [  2.990 s]
	[INFO] customer ........................................... SUCCESS [  1.210 s]
	[INFO] creditscore ........................................ SUCCESS [  0.154 s]
	[INFO] cloudbank .......................................... SUCCESS [  0.033 s]
	[INFO] ------------------------------------------------------------------------
	[INFO] BUILD SUCCESS
	[INFO] ------------------------------------------------------------------------
	[INFO] Total time:  4.640 s
	[INFO] Finished at: 2023-03-04T11:14:00-06:00
	[INFO] ------------------------------------------------------------------------
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

	Create database bindings for the applications by running the following commands in the CLI. You are going to create two different bindings. **Note** The creditscore service is not using a database binding.

	> What happens when you use the Oracle Backend for Spring Boot CLI **bind** command?
	When you run the `bind` command, the Oracle Backend for Spring Boot CLI does several things for you:
	
	- Asks for Database user credentials
	- Creates a k8s secret with the provided user credentials
	- Creates a Database Schema with the provided user credentials
	
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

	The services are using LiquiBase [LiquiBase](https://www.liquibase.org/. Liquibase is an open-source database schema change management solution which enables you to manage revisions of your database changes easily. When the service get's deployed the `tables` and sample `data` will be created and inserted by LiquiBase.

6. Deploy the services

	**NOTE**: If you have finished Lab three (Build the Account Microservice) and Lab four (Manage Transactions across Microservices) you can skip step one (Deploy/Redeploy the Account Service) below and deploy the other services. << DOES THIS MATTER EG WHAT HAPPENS IF YOU DO BIND AGAIN >>

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
		deploy --isRedeploy true --appName application --serviceName account --jarLocation /path/to/account/target/accounts-0.0.1-SNAPSHOT.jar --imageVersion 0.0.1</copy>
		uploading... upload successful
		building and pushing image... docker build and push successful	
		creating deployment and service... create deployment and service  = account, appName = application, isRedeploy = true successful
    	successfully deployed
    	```

	2. Deploy the Customer Service

		You will now deploy your Customer service to the Oracle Backend for Spring Boot using the CLI.  You will deploy into the `application` namespace, and the service name will be `customer`. Run this command to deploy your service, make sure you provide the correct path to your JAR file:

    	```shell
    	oractl> <copy>
		deploy --isRedeploy false --appName application --serviceName customer --jarLocation /path/to/customer/target/customers-0.0.1-SNAPSHOT.jar --imageVersion 0.0.1</copy>
		uploading... upload successful
		building and pushing image... docker build and push successful	
		creating deployment and service... create deployment and service  = customer, appName = application, isRedeploy = false successful
    	successfully deployed
    	```

	3. Deploy the Credit Score service

		You will now deploy your Customer service to the Oracle Backend for Spring Boot using the CLI.  You will deploy into the `application` namespace, and the service name will be `creditscore`. Run this command to deploy your service, make sure you provide the correct path to your JAR file:

    	```shell
    	oractl> <copy>
		deploy --isRedeploy false --appName application --serviceName customer --jarLocation /path/to/creditscore/target/creditscore-0.0.1-SNAPSHOT.jar --imageVersion 0.0.1</copy>
		uploading... upload successful
		building and pushing image... docker build and push successful	
		creating deployment and service... create deployment and service  = creditscore, appName = application, isRedeploy = false successful
    	successfully deployed
    	```

	> What happens when you use the Oracle Backend for Spring Boot CLI **deploy** command?
    When you run the `deploy` command, the Oracle Backend for Spring Boot CLI does several things for you:

	- Uploads the JAR file to server side
	- Builds a container image and push it to the OCI Registry
	- Inspects the JAR file and looks for bind resources (JMS)
	- Create the microservices deployment descriptor (k8s) with the resources supplied
	- Applies the k8s deployment and create k8s object service to microservice

## Task 4: Verify the deployment

TODO: Some kind of verification perhaps curl to account, customer, transaction and creditscore?

## Task 5: Expose the services using APISIX Gateway

1. Get APISIX Gateway Admin Key

	You are going to need the Admin Key for the APISIX Gateway to configure the route. It is stored in a COnfigMap. Run the command and make a note of the admin key. The command will return a long YAML document so you need to scroll up to find the Admin Key.

	```shell
	<copy>kubectl -n apisix get configmap apisix -o yaml</copy>
	```

	Look for the `key:` information in the `admin_key` section and save it. You'll be needing it later in this lab.

	```yaml
	admin_key:
        # admin: can everything for configuration data
        - name: "admin"
          key: edd1c9f03...........
          role: admin
	```

2. Start the tunnel using this command:

	```shell
	$ <copy>kubectl -n apisix port-forward svc/apisix-admin 9180:9180</copy>
	Forwarding from 127.0.0.1:9180 -> 9180
	Forwarding from [::1]:9180 -> 9180
	```

3. Create the routes

	In the `scripts` directory where you saved the code repository there are three scripts to create the routes. Run the commands to create the routes:

	 a. Accounts Route:

	 Run this command to create the accounts route, replace the `APIKEY` in the command with the key you got in Step 1

	```shell
	$ <copy>source apisix-routes/create-accounts-route.sh APIKEY</copy>
	```
	
	Output should be similar to this:
	
	```text
	HTTP/1.1 201 Created
	Date: Thu, 02 Mar 2023 21:57:08 GMT
	Content-Type: application/json
	Transfer-Encoding: chunked
	Connection: keep-alive
	Server: APISIX/2.15.1
	Access-Control-Allow-Origin: *
	Access-Control-Allow-Credentials: true
	Access-Control-Expose-Headers: *
	Access-Control-Max-Age: 3600

	{"action":"create","node":{"key":"\/apisix\/routes\/00000000000000000035","value":{"priority":0,"update_time":1677794228,"id":"00000000000000000035","create_time":1677794228,"uri":"\/api\/v1\/account*","plugins":{"zipkin":{"span_version":2,"disable":false,"sample_ratio":1,"service_name":"APISIX","endpoint":"http:\/\/jaegertracing-collector.observability.svc.cluster.local:9411\/api\/v2\/spans"}},"labels":{"version":"1.0"},"status":1,"name":"accounts","upstream":{"type":"roundrobin","hash_on":"vars","pass_host":"pass","discovery_type":"eureka","service_name":"ACCOUNTS","scheme":"http"}}}}
	```

	b. Creditscore Route:

	Run this command to create the creditscore route, replace the `APIKEY` in the command with the key you got in Step 1

	``` shell
	$ <copy>source apisix-routes/create-creditscore-route.sh APIKEY</copy>
	```

	Output should be similar to this:

	```text
	HTTP/1.1 201 Created
	Date: Thu, 02 Mar 2023 21:59:18 GMT
	Content-Type: application/json
	Transfer-Encoding: chunked
	Connection: keep-alive
	Server: APISIX/2.15.1
	Access-Control-Allow-Origin: *
	Access-Control-Allow-Credentials: true
	Access-Control-Expose-Headers: *
	Access-Control-Max-Age: 3600

	{"action":"create","node":{"key":"\/apisix\/routes\/00000000000000000037","value":{"priority":0,"update_time":1677794358,"id":"00000000000000000037","create_time":1677794358,"uri":"\/api\/v1\/creditscore*","plugins":{"zipkin":{"span_version":2,"disable":false,"sample_ratio":1,"service_name":"APISIX","endpoint":"http:\/\/jaegertracing-collector.observability.svc.cluster.local:9411\/api\/v2\/spans"}},"labels":{"version":"1.0"},"status":1,"name":"creditscore","upstream":{"type":"roundrobin","hash_on":"vars","pass_host":"pass","discovery_type":"eureka","service_name":"CREDITSCORE","scheme":"http"}}}}
	```

	c. Customer Route:

	Run this command to create the customer route, replace the `APIKEY` in the command with the key you got in Step 1

	```shell
	$ <copy>source apisix-routes/create-customer-route.sh APIKEY</copy>
	```

	Output should be similar to this:

	```text
	HTTP/1.1 201 Created
	Date: Thu, 02 Mar 2023 22:00:44 GMT
	Content-Type: application/json
	Transfer-Encoding: chunked
	Connection: keep-alive
	Server: APISIX/2.15.1
	Access-Control-Allow-Origin: *
	Access-Control-Allow-Credentials: true
	Access-Control-Expose-Headers: *
	Access-Control-Max-Age: 3600

	{"action":"create","node":{"key":"\/apisix\/routes\/00000000000000000039","value":{"priority":0,"update_time":1677794444,"id":"00000000000000000039","create_time":1677794444,"uri":"\/api\/v1\/customer*","plugins":{"zipkin":{"span_version":2,"disable":false,"sample_ratio":1,"service_name":"APISIX","endpoint":"http:\/\/jaegertracing-collector.observability.svc.cluster.local:9411\/api\/v2\/spans"}},"labels":{"version":"1.0"},"status":1,"name":"customer","upstream":{"type":"roundrobin","hash_on":"vars","pass_host":"pass","discovery_type":"eureka","service_name":"CUSTOMERS","scheme":"http"}}}}
	```

4. Verify the routes in the APISIX Dashboard

	Start the tunnel using this command.  You can run this in the background if you prefer.

    ```shell
    $ <copy>kubectl -n apisix port-forward svc/apisix-dashboard 8080:80</copy>
	Forwarding from 127.0.0.1:8080 -> 9000
	Forwarding from [::1]:8080 -> 9000
    ```

   Open a web browser to [http://localhost:8080](http://localhost:8080) to view the APISIX Dashboard web user interface.  It will appear similar to the image below.

   If prompted to login, login with user name `admin` and password `admin`.  Note that Oracle strongly recommends that you change the password, even though this interface is not accessible outside the cluster without a tunnel.

    ![APISIX Dashboard Login](images/apisix-login.png " ")

	Click the routes menu item to see the routes you created in step three.

	![APISIX Routes](images/apisix-route.png " ")

	Verify that you have three routes created

	![APISIX Route Details](images/apisix-route-details.png " ")

5. Verify the account service

   In the next two commands, you need to provide the correct IP address for the API Gateway in your backend environment.  You can find the IP address using this command, you need the one listed in the `EXTERNAL-IP` column. In the example below the IP address is `100.20.30.40`
   
    ```shell
    $ <copy>kubectl -n ingress-nginx get service ingress-nginx-controller</copy>
    NAME                       TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
    ingress-nginx-controller   LoadBalancer   10.123.10.127   100.20.30.40  80:30389/TCP,443:30458/TCP   13d
	```

	Test the create account endpoint with this command, use the IP address for your API Gateway. Make a note of the `accountID` in the output:

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


**TODO - make sure we created some users and accounts, including in parse for the mobile app**

## Learn More

* [Oracle Backend for Spring Boot](https://oracle.github.io/microservices-datadriven/spring/)
* [Oracle Backend for Parse Platform](https://oracle.github.io/microservices-datadriven/mbaas/)

## Acknowledgements

* **Author** - Andy Tael, Mark Nelson, Developer Evangelists, Oracle Database
* **Contributors** - [](var:contributors)
* **Last Updated By/Date** - Andy Tael, February 2023
