# Deploy the full CloudBank Application using the CLI

## Introduction

Now that you know how to build a Spring Boot microservice and deploy it to the Oracle Backend for Spring Boot and Microservices, this lab will guide you through deploying the rest of the Cloud Bank services that we have already built for you and exploring the runtime and management capabilities of the platform.

Estimated Lab Time: 30 minutes

Quick walk through on how to deploy full CloudBank application.

[](videohub:1_3r1te1ii)

### Objectives

In this lab, you will:

* Deploy the full CloudBank sample application into your Oracle Backend for Spring Boot for Microservices instance

### Prerequisites

This lab assumes you have:

* An Oracle Cloud account
* Have all the necessary tools installed (kubectl, git, maven, oractl, sqlcl, curl, jq). All of them should be installed during Lab two (Setup your Development Environment)
* Git version control tool installed on your computer (optional)

## Task 1: Get a copy of the CloudBank sample application

Download a copy of the CloudBank sample application.

1. Clone the source repository

    Create a local clone of the CloudBank source repository using this command.

    ```shell
    <copy>git clone https://github.com/oracle/microservices-datadriven.git</copy>
    ```

    > **Note**: If you do not have **git** installed on your machine, you can download a zip file of the source code from [GitHub](https://github.com/oracle/microservices-datadriven) and unzip it on your machine instead.

    The source code for the CloudBank application will be in the `microservices-datadriven` directory you just created, in the `cloudbank-v32` subdirectory.

    ```shell
    <copy>cd microservices-datadriven/cloudbank-v32</copy>
    ```

## Task 2: Build the CloudBank application

1. Create application JAR files

    In the directory where you cloned (or unzipped) the application and build the application JARs using the following command:

    ```shell
    <copy>mvn clean package</copy>
    ```

    The output should be similar to this:

    ```text
    [INFO] ------------------------------------------------------------------------
    [INFO] Reactor Summary for cloudbank 0.0.1-SNAPSHOT:
    [INFO]
    [INFO] cloudbank .......................................... SUCCESS [  0.972 s]
    [INFO] account ............................................ SUCCESS [  2.877 s]
    [INFO] customer ........................................... SUCCESS [  1.064 s]
    [INFO] creditscore ........................................ SUCCESS [  0.922 s]
    [INFO] transfer ........................................... SUCCESS [  0.465 s]
    [INFO] testrunner ......................................... SUCCESS [  0.931 s]
    [INFO] checks ............................................. SUCCESS [  0.948 s]
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  8.480 s
    [INFO] Finished at: 2023-11-06T12:35:17-06:00
    [INFO] ------------------------------------------------------------------------
    ```

**NOTE**: You can optionally jump to Lab 7 to do the deployment through the Oracle Backend for Spring Boot VS Code plugin.

## Task 3: Install CloudBank in your Oracle Backend for Spring Boot and Microservices instance

1. Obtain the `obaas-admin` password.

    Execute the following command to get the `obaas-admin` password:

    ```shell
    <copy>kubectl get secret -n azn-server oractl-passwords -o jsonpath='{.data.admin}' | base64 -d</copy>
    ```

1. Start a tunnel to the backend service.

    The Oracle Backend for Spring Boot and Microservices admin service is not exposed outside of the Kubernetes cluster by default. Use kubectl to start a port forwarding tunnel to establish a secure connection to the admin service.

    Start a tunnel using this command:

    ```shell
    $ <copy>kubectl -n obaas-admin port-forward svc/obaas-admin 8080:8080</copy>
    Forwarding from 127.0.0.1:8080 -> 8080
    Forwarding from [::1]:8080 -> 8080
    ```

1. Start the Oracle Backend for Spring Boot and Microservices CLI *oractl*

    Open a new terminal Window or Tab and start the Oracle Backend for Spring Boot CLI using this command:

    ```shell
    $ <copy>oractl</copy>
     _   _           __    _    ___
    / \ |_)  _.  _. (_    /  |   |
    \_/ |_) (_| (_| __)   \_ |_ _|_
    =============================================================================================================================
    Application Name: Oracle Backend Platform :: Command Line Interface
    Application Version: (1.0.1)
    :: Spring Boot (v3.1.3) ::


    oractl:>
    ```

1. Connect to the Oracle Backend for Spring Boot and Microservices admin service called *obaas-admin*

    Connect to the Oracle Backend for Spring Boot and Microservices admin service using this command. Use thr password you obtained is Step 1.

    ```shell
    oractl> <copy>connect</copy>
    username: obaas-admin
    password: **************
    obaas-cli: Successful connected.
    oractl:>
    ```

1. Create Database Bindings

    Create database bindings for the applications by running the following commands in the CLI. You are going to create four different bindings for the account, checks, customer and testrunner services. **Note** The creditscore and transfer services are not using a database binding.

    > What happens when you use the oractl CLI **bind** command? When you run the `bind` command, the oractl tool does several things for you:

    * Asks for Database user credentials.
    * Creates or updates a k8s secret with the provided user credentials.
    * Creates a Database Schema with the provided user credentials.

    1. Create Binding for the *Account* Service

        Create a database "binding" by running this command. Enter the password (`Welcome1234##`) when prompted.  This will create a Kubernetes secret in the `application` namespace called `account-db-secrets` which contains the username (`account`), password, and URL to connect to the Oracle Autonomous Database instance associated with the Oracle Backend for Spring Boot and Microservices.

        ```shell
        oractl:> <copy>bind --app-name application --service-name account</copy>
        Database/Service Password: *************
        Schema {account} was successfully Created and Kubernetes Secret {application/account} was successfully Created.
        oractl:>
        ```

    1. Create Binding for the *Checks* Service

        Create a database "binding" by running this command. Enter the password (`Welcome1234##`) when prompted.  This will create a Kubernetes secret in the `application` namespace called `checks-db-secrets` which contains the username (`account`), password, and URL to connect to the Oracle Autonomous Database instance associated with the Oracle Backend for Spring Boot and Microservices.

        ```shell
        oractl:> <copy>bind --app-name application --service-name checks --username account</copy>
        Database/Service Password: *************
        Schema {account} was successfully Not_Modified and Kubernetes Secret {application/checks} was successfully Created.
        oractl:>
        ```

    1. Create binding for the *Customer* Service

        Create a database "binding" by running this command. Enter the password (`Welcome1234##`) when prompted.  This will create a Kubernetes secret in the `application` namespace called `customer-db-secrets` which contains the username (`customer`), password, and URL to connect to the Oracle Autonomous Database instance associated with the Oracle Backend for Spring Boot and Microservices.

        ```shell
        oractl:> <copy>bind --app-name application --service-name customer</copy>
        Database/Service Password: *************
        Schema {customer} was successfully Created and Kubernetes Secret {application/customer} was successfully Created.
        oractl:>
        ```

    1. Create Binding for the *Testrunner* Service

        Create a database "binding" by running this command. Enter the password (`Welcome1234##`) when prompted.  This will create a Kubernetes secret in the `application` namespace called `testrunner-db-secrets` which contains the username (`account`), password, and URL to connect to the Oracle Autonomous Database instance associated with the Oracle Backend for Spring Boot and Microservices.

        ```shell
        oractl:> <copy>bind --app-name application --service-name testrunner --username account</copy>
        Database/Service Password: *************
        Schema {account} was successfully Not_Modified and Kubernetes Secret {application/testrunner} was successfully Created.
        oractl:>
        ```

1. Liquibase Creates Database Objects

    The services are using [Liquibase](https://www.liquibase.org/). Liquibase is an open-source database schema change management solution which enables you to manage revisions of your database changes easily. When the service get's deployed the `tables` and sample `data` will be created and inserted by Liquibase. The SQL executed can be found in the source code directories of Cloudbank.

1. Deploy the services

    > What happens when you use the Oracle Backend for Spring Boot and Microservices CLI (*oractl*) **deploy** command? When you run the `deploy` command, *oractl* does several things for you:

    * Uploads the JAR file to server side
    * Builds a container image and push it to the OCI Registry
    * Inspects the JAR file and looks for bind resources (JMS)
    * Create the microservices deployment descriptor (k8s) with the resources supplied
    * Applies the k8s deployment and create k8s object service to microservice

    1. Deploy/Redeploy the *Account* Service

        You will now deploy your Account service to the Oracle Backend for Spring Boot and Microservices using the `oractl`. You will deploy into the `application` namespace, and the service name will be `account`. If you finished lab three (Build the Account Microservice) you need to use the *--redeploy* option to the *deploy* command. **Note** The `deploy` command have `--liquibas-db` parameter, this is beacuse Liquibase needsto run as the `ADMIN` user so the `account` user can get the right properties to create TXEventQ's.

        Run this command to deploy your account service, make sure you provide the correct path to your JAR file:

        ```shell
        oractl:> <copy>deploy --app-name application --service-name account --artifact-path /path/to/account-0.0.1-SNAPSHOT.jar --image-version 0.0.1 --liquibase-db admin</copy>
        uploading: account/target/account-0.0.1-SNAPSHOT.jar
        building and pushing image...

        creating deployment and service...
        obaas-cli [deploy]: Application was successfully deployed.
        oractl:>
        ```

        Re-deploy the accounts service. If you finished lab three, you can re-deploy the Account Service using the following command (notice the *--redeploy* option)

        ```shell
        oractl:> <copy>deploy --redeploy --app-name application --service-name account --artifact-path /path/to/account-0.0.1-SNAPSHOT.jar --image-version 0.0.1 --liquibase-db admin</copy>
        uploading: account/target/account-0.0.1-SNAPSHOT.jar
        building and pushing image...

        creating deployment and service...
        obaas-cli [deploy]: Application was successfully deployed.
        oractl:>
        ```

    1. Deploy/Redeploy the *Checks* Service

        You will now deploy your Checks service to the Oracle Backend for Spring Boot and Microservices using `oractl`.  You will deploy into the `application` namespace, and the service name will be `checks`. If you finished lab four (Build the Check Processing Microservices) you need to use the *--redeploy* option to the *deploy* command.

        Run this command to deploy your checks service, make sure you provide the correct path to your JAR file:

        ```shell
        oractl:> <copy>deploy --app-name application --service-name checks --artifact-path /path/to/checks-0.0.1-SNAPSHOT.jar --image-version 0.0.1</copy>
        uploading: checks/target/checks-0.0.1-SNAPSHOT.jar
        building and pushing image...

        creating deployment and service...
        obaas-cli [deploy]: Application was successfully deployed.
        oractl:>
        ```

        Re-deploy the checks service. If you finished lab four, you can re-deploy the Checks Service using the following command (notice the *--redeploy* option)

        ```shell
        oractl:> <copy>deploy --redeploy --app-name application --service-name checks --artifact-path /path/to/checks-0.0.1-SNAPSHOT.jar --image-version 0.0.1</copy>
        uploading: checks/target/checks-0.0.1-SNAPSHOT.jar
        building and pushing image...

        creating deployment and service...
        obaas-cli [deploy]: Application was successfully deployed.
        oractl:>
        ```

    1. Deploy the *Customer* Service

        You will now deploy your Customer service to the Oracle Backend for Spring Boot and Microservices using `oractl`. You will deploy into the `application` namespace, and the service name will be `customer`. Run this command to deploy your service, make sure you provide the correct path to your JAR file:

        ```shell
        oractl:> <copy>deploy --app-name application --service-name customer --artifact-path /path/to/customer-0.0.1-SNAPSHOT.jar --image-version 0.0.1 --liquibase-db admin</copy>
        uploading: customer/target/customer-0.0.1-SNAPSHOT.jar
        building and pushing image...

        creating deployment and service...
        obaas-cli [deploy]: Application was successfully deployed.
        oractl:>
        ```

    1. Deploy the *Creditscore* service

        You will now deploy your Creditscore service to the Oracle Backend for Spring Boot and Microservices using `oractl`.  You will deploy into the `application` namespace, and the service name will be `creditscore`. Run this command to deploy your service, make sure you provide the correct path to your JAR file:

        ```shell
        oractl:> <copy>deploy --app-name application --service-name creditscore --artifact-path /path/to/creditscore-0.0.1-SNAPSHOT.jar --image-version 0.0.1</copy>
        uploading: creditscore/target/creditscore-0.0.1-SNAPSHOT.jar
        building and pushing image...

        creating deployment and service...
        obaas-cli [deploy]: Application was successfully deployed.
        oractl:>
        ```

    1. Deploy/Redeploy the Testrunner Service

        You will now deploy your Testrunner service to the Oracle Backend for Spring Boot and Microservices using `oractl`. You will deploy into the `application` namespace, and the service name will be `testrunner`. If you finished lab four (Build the Check Processing Microservices) you need to use the *--redeploy* option to the *deploy* command.

        Run this command to deploy your testrunner service, make sure you provide the correct path to your JAR file:

        ```shell
        oractl:> <copy>deploy --app-name application --service-name testrunner --artifact-path /path/to/testrunner-0.0.1-SNAPSHOT.jar --image-version 0.0.1</copy>
        uploading: testrunner/target/testrunner-0.0.1-SNAPSHOT.jar
        building and pushing image...

        creating deployment and service...
        obaas-cli [deploy]: Application was successfully deployed.
        oractl:>
        ```

        Re-deploy the testrunner service. If you finished lab four, you can re-deploy the Checks Service using the following command (notice the *--redeploy* option)

        ```shell
        oractl:> <copy>deploy --redeploy --app-name application --service-name testrunner --artifact-path /path/to/testrunner-0.0.1-SNAPSHOT.jar --image-version 0.0.1</copy>
        uploading: testrunner/target/testrunner-0.0.1-SNAPSHOT.jar
        building and pushing image...

        creating deployment and service...
        obaas-cli [deploy]: Application was successfully deployed.
        oractl:>
        ```

    1. Deploy/Redeploy the Transfer service

        You will now deploy your transfer service to the Oracle Backend for Spring Boot and Microservices using `oractl`. You will deploy into the `application` namespace, and the service name will be `transfer`. If you finished lab five (Manage Saga Transactions across Microservices) you need to use the *--redeploy* option to the *deploy* command.

        Run this command to deploy your transfer service, make sure you provide the correct path to your JAR file:

        ```shell
        oractl:> <copy>deploy --app-name application --service-name transfer --artifact-path /path/to/transfer-0.0.1-SNAPSHOT.jar --image-version 0.0.1</copy>
        uploading: transfer/target/transfer-0.0.1-SNAPSHOT.jar
        building and pushing image...

        creating deployment and service...
        obaas-cli [deploy]: Application was successfully deployed.
        oractl:>
        ```

        Re-deploy the transfer service. If you finished lab five, you can re-deploy the Transfer Service using the following command (notice the *--redeploy* option)

        ```shell
        oractl:> <copy>deploy --redeploy --app-name application --service-name transfer --artifact-path /path/to/transfer-0.0.1-SNAPSHOT.jar --image-version 0.0.1</copy>
        uploading: testrunner/target/transfer-0.0.1-SNAPSHOT.jar
        building and pushing image...

        creating deployment and service...
        obaas-cli [deploy]: Application was successfully deployed.
        oractl:>
        ```

        You have now deployed all the services part of the Cloudbank application.

## Task 4: Verify the deployment of CloudBank

1. Verification of the services deployment

    Verify that the services are running properly by executing this command:

    ```shell
    <copy>kubectl get pods application</copy>
    ```

    The output should be similar to this, all pods should have `STATUS` as `Running`. If not then you need to look at the logs for the pods/service to determine what is wrong for example `kubectl logs -n application svc/customer`.

    ```text
    NAME                           READY   STATUS    RESTARTS   AGE
    account-65cdc68dd7-k5ntz       1/1     Running   0          8m2s
    checks-78c988bdcf-n59qz        1/1     Running   0          42m
    creditscore-7b89d567cd-nm4p6   1/1     Running   0          38m
    customer-6f4dc67985-nf5kz      1/1     Running   0          41s
    testrunner-78d679575f-ch4k7    1/1     Running   0          33m
    transfer-869d796755-gn9lf      1/1     Running   0          27m
    ```

## Task 5: Expose and test the services using APISIX Gateway and k8s tunnels

**NOTE:** The Transfer service is not exposed via the APISIX GW as it is an internal service.

1. Get APISIX Gateway Admin Key

    You are going to need the Admin Key for the APISIX Gateway to configure the route. It is stored in a k8s ConfigMap. Run the command and make a note of the admin key. The command will return a long YAML document, so you need to scroll up to find the Admin Key.

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

1. Start the tunnel to the APISIX Admin server using this command:

    ```shell
    $ <copy>kubectl -n apisix port-forward svc/apisix-admin 9180:9180</copy>
    Forwarding from 127.0.0.1:9180 -> 9180
    Forwarding from [::1]:9180 -> 9180
    ```

1. Create the routes

    In the `apisix-scripts` directory where you saved the code repository there are three scripts to create the routes. Run the commands to create the routes:

    1. Accounts Route:

        Run this command to create the accounts route, replace the `APIKEY` in the command with the key you got in Step 1

        ```shell
        <copy>source apisix-routes/create-accounts-route.sh APIKEY</copy>
        ```

        Output should be similar to this:

        ```text
        HTTP/1.1 201 Created
        Date: Wed, 19 Apr 2023 16:21:56 GMT
        Content-Type: application/json
        Transfer-Encoding: chunked
        Connection: keep-alive
        Server: APISIX/3.2.0
        Access-Control-Allow-Origin: *
        Access-Control-Allow-Credentials: true
        Access-Control-Expose-Headers: *
        Access-Control-Max-Age: 3600
        X-API-VERSION: v3

        {"key":"/apisix/routes/00000000000000000041","value":{"status":1,"uri":"/api/v1/account*","upstream":{"discovery_type":"kubernetes","scheme":"http","service_name":"application/account:spring","type":"roundrobin","pass_host":"pass","hash_on":"vars"},"name":"accounts","create_time":1681921315,"labels":{"version":"1.0"},"priority":0,"update_time":1681921315,"plugins":{"zipkin":{"sample_ratio":1,"endpoint":"http://jaegertracing-collector.observability.svc.cluster.local:9411/api/v2/spans","service_name":"APISIX","span_version":2,"disable":false}},"id":"00000000000000000041"}}
        ```

    1. Creditscore Route:

        Run this command to create the creditscore route, replace the `APIKEY` in the command with the key you got in Step 1

        ``` shell
        <copy>source apisix-routes/create-creditscore-route.sh APIKEY</copy>
        ```

        Output should be similar to this:

        ```text
        HTTP/1.1 201 Created
        Date: Wed, 19 Apr 2023 16:23:56 GMT
        Content-Type: application/json
        Transfer-Encoding: chunked
        Connection: keep-alive
        Server: APISIX/3.2.0
        Access-Control-Allow-Origin: *
        Access-Control-Allow-Credentials: true
        Access-Control-Expose-Headers: *
        Access-Control-Max-Age: 3600
        X-API-VERSION: v3

        {"key":"/apisix/routes/00000000000000000043","value":{"status":1,"uri":"/api/v1/creditscore*","upstream":{"discovery_type":"eureka","scheme":"http","service_name":"CREDITSCORE","type":"roundrobin","pass_host":"pass","hash_on":"vars"},"name":"creditscore","create_time":1681921436,"labels":{"version":"1.0"},"priority":0,"update_time":1681921436,"plugins":{"zipkin":{"sample_ratio":1,"endpoint":"http://jaegertracing-collector.observability.svc.cluster.local:9411/api/v2/spans","service_name":"APISIX","span_version":2,"disable":false}},"id":"00000000000000000043"}}
        ```

    1. Customer Route:

        Run this command to create the customer route, replace the `APIKEY` in the command with the key you got in Step 1

        ```shell
        <copy>source apisix-routes/create-customer-route.sh APIKEY</copy>
        ```

        Output should be similar to this:

        ```text
        HTTP/1.1 201 Created
        Date: Wed, 19 Apr 2023 16:24:54 GMT
        Content-Type: application/json
        Transfer-Encoding: chunked
        Connection: keep-alive
        Server: APISIX/3.2.0
        Access-Control-Allow-Origin: *
        Access-Control-Allow-Credentials: true
        Access-Control-Expose-Headers: *
        Access-Control-Max-Age: 3600
        X-API-VERSION: v3

        {"key":"/apisix/routes/00000000000000000045","value":{"status":1,"uri":"/api/v1/customer*","upstream":{"discovery_type":"eureka","scheme":"http","service_name":"CUSTOMERS","type":"roundrobin","pass_host":"pass","hash_on":"vars"},"name":"customer","create_time":1681921493,"labels":{"version":"1.0"},"priority":0,"update_time":1681921493,"plugins":{"zipkin":{"sample_ratio":1,"endpoint":"http://jaegertracing-collector.observability.svc.cluster.local:9411/api/v2/spans","service_name":"APISIX","span_version":2,"disable":false}},"id":"00000000000000000045"}}
        ```

1. Verify the routes in the APISIX Dashboard

    1. Get the password for the APISIX dashboard.

        Retrieve the password for the APISIX dashboard using this command:

        ```shell
        kubectl get secret apisix-dashboard -n apisix -o jsonpath='{.data.conf\.yaml}' | base64 --decode</copy>
        ```

    1. Start the tunnel in a new terminal window using this command.

        ```shell
        $ <copy>kubectl -n apisix port-forward svc/apisix-dashboard 7070:80</copy>
        Forwarding from 127.0.0.1:8080 -> 9000
        Forwarding from [::1]:8080 -> 9000
        ```

        Open a web browser to [http://localhost:7070](http://localhost:7070) to view the APISIX Dashboard web user interface.  It will appear similar to the image below.

        If prompted to login, login with username `admin` and the password you got from the k8s secret earlier. Note that Oracle strongly recommends that you change the password, even though this interface is not accessible outside the cluster without a tunnel.

        ![APISIX Dashboard Login](images/apisix-login.png " ")

        Click the routes menu item to see the routes you created in step three.

        ![APISIX Routes](images/apisix-route.png " ")

        Verify that you have three routes created

        ![APISIX Route Details](images/apisix-route-details.png " ")

1. Verify the all the Cloud Bank services deployed

   In the next few commands, you need to provide the correct IP address for the API Gateway in your backend environment. You can find the IP address using this command, you need the one listed in the `EXTERNAL-IP` column. In the example below the IP address is `100.20.30.40`

    1. Get external IP Address

        You can find the IP address using this command, you need the one listed in the `EXTERNAL-IP` column. In the example below the IP address is `100.20.30.40`

        ```shell
        $ <copy>kubectl -n ingress-nginx get service ingress-nginx-controller</copy>
        NAME                       TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
        ingress-nginx-controller   LoadBalancer   10.123.10.127   100.20.30.40  80:30389/TCP,443:30458/TCP   13d
        ```

    1. Test the create account REST endpoint with this command, use the external IP address for your API Gateway. Make a note of the `accountID` in the output:

        ```shell
        $ <copy>curl -i -X POST \
        -H 'Content-Type: application/json' \
        -d '{"accountName": "Sanjay''s Savings", "accountType": "SA", "accountCustomerId": "bkzLp8cozi", "accountOtherDetails": "Savings Account"}' \
        http://API-ADDRESS-OF-API-GW/api/v1/account</copy>
        HTTP/1.1 201
        Date: Wed, 01 Mar 2023 18:35:31 GMT
        Content-Type: application/json
        Transfer-Encoding: chunked
        Connection: keep-alive

        {"accountId":24,"accountName":"Sanjays Savings","accountType":"SA","accountCustomerId":"bkzLp8cozi","accountOpenedDate":null,"accountOtherDetails":"Savings Account","accountBalance":0}
        ```

    1. Test the get account REST endpoint with this command, use the IP address for your API Gateway and the `accountId` that was returned in the previous command:

        ```shell
        <copy>curl -s http://API-ADDRESS-OF-API-GW/api/v1/account/24 | jq .</copy>
        ```

        Output should be similar to this:

        ```json
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

    1. Test on of the customer REST endpoints with this command, use the IP Address for your API Gateway.

        ```shell
        <copy>curl -s http://API-ADDRESS-OF-API-GW/api/v1/customer | jq</copy>
        ```

        Output should be similar to this:

        ```json
        [
            {
                "customerId": "qwertysdwr",
                "customerName": "Andy",
                "customerEmail": "andy@andy.com",
                "dateBecameCustomer": "2023-11-06T20:06:19.000+00:00",
                "customerOtherDetails": "Somekind of Info",
                "customerPassword": "SuperSecret"
            },
            {
                "customerId": "aerg45sffd",
                "customerName": "Sanjay",
                "customerEmail": "sanjay@sanjay.com",
                "dateBecameCustomer": "2023-11-06T20:06:19.000+00:00",
                "customerOtherDetails": "Information",
                "customerPassword": "Welcome"
            },
            {
                "customerId": "bkzLp8cozi",
                "customerName": "Mark",
                "customerEmail": "mark@mark.com",
                "dateBecameCustomer": "2023-11-06T20:06:19.000+00:00",
                "customerOtherDetails": "Important Info",
                "customerPassword": "Secret"
            }
        ]
        ```

    1. Test the creditscore REST endpoint with this command

        ```shell
        <copy>curl -s http://API-ADDRESS-OF-API-GW/api/v1/creditscore | jq</copy>
        ```

        Output should be similar to this:

        ```json
        {
            "Date": "2023-11-06",
            "Credit Score": "686"
        }
        ```

    1. Test the check service

        1. Start a tunnel to the testrunner service.

            ```shell
            $ <copy>kubectl -n application port-forward svc/testrunner 8084:8080</copy>
            Forwarding from 127.0.0.1:8084 -> 8080
            Forwarding from [::1]:8084 -> 8080
            ```

        1. Deposit a check using the *deposit* REST endpoint

            Run this command to deposit a check, make sure you use the *accountId* from the account you created earlier.

            ```shell
            $ <copy>curl -i -X POST -H 'Content-Type: application/json' -d '{"accountId": 2, "amount": 256}' http://localhost:8084/api/v1/testrunner/deposit</copy>
            HTTP/1.1 201
            Content-Type: application/json
            Transfer-Encoding: chunked
            Date: Thu, 02 Nov 2023 18:02:06 GMT

            {"accountId":2,"amount":256}
            ```

        1. Check the log of the *check* service

            Execute this command to check the log file of the *check* service:

            ```shell
            <copy>kubectl -n application logs svc/checks</copy>
            ```

            The log file should contain something similar to this (with your accountId):

            ```log
            Received deposit <CheckDeposit(accountId=2, amount=256)>
            ```

        1. Check the Journal entries using the *journal* REST endpoint. Replace `API-ADDRESS-OF-API-GW` with your external IP Address.

            ```shell
            <copy>curl -i http://API-ADDRESS-OF-API-GW/api/v1/account/2/journal</copy>
            ```

            The output should be similar to this (with your AccountId). Note the *journalId*, you're going to need it in the next step.

            ```log
            HTTP/1.1 200 
            Content-Type: application/json
            Transfer-Encoding: chunked
            Date: Thu, 02 Nov 2023 18:06:45 GMT

            [{"journalId":1,"journalType":"PENDING","accountId":2,"lraId":"0","lraState":null,"journalAmount":256}]
            ```

        1. Clearance of a check using the *clear* REST endpoint using your *journalId*:

            ```shell
            <copy>curl -i -X POST -H 'Content-Type: application/json' -d '{"journalId": 1}' http://localhost:8084/api/v1/testrunner/clear</copy>
            ```

            ```logs
            HTTP/1.1 201 
            Content-Type: application/json
            Transfer-Encoding: chunked
            Date: Thu, 02 Nov 2023 18:09:17 GMT

            {"journalId":1}
            ```

        1. Check the logs of the *checks* service

            Execute this command to check the log file of the *check* service:

            ```shell
            <copy>kubectl -n application logs svc/checks</copy>
            ```

            The log file should contain something similar to this (with your journalId):

            ```log
            Received clearance <Clearance(journalId=1)>
            ```

        1. Check the *journal* REST endpoint

            Execute this command to check the Journal. Replace `API-ADDRESS-OF-API-GW` with your External IP Address and `ACCOUNT-ID` with your account id.

            ```shell
            <copy>curl -i http://API-ADDRESS-OF-API-GW/api/v1/account/ACCOUNT-ID/journal</copy>
            ```

            The output should look like this (with your accountId):

            ```log
            `HTTP/1.1 200
            Content-Type: application/json
            Transfer-Encoding: chunked
            Date: Thu, 02 Nov 2023 18:36:31 GMT

            [{"journalId":1,"journalType":"DEPOSIT","accountId":2,"lraId":"0","lraState":null,"journalAmount":256}]`
            ```

    1. Test Saga transactions across Microservices using the *transfer* service.

        1. Start a tunnel to the testrunner service.

            ```shell
            $ <copy>kubectl -n application port-forward svc/transfer 8085:8080</copy>
            Forwarding from 127.0.0.1:8085 -> 8080
            Forwarding from [::1]:8085 -> 8080
            ```

        1. Check the account balances for two accounts, in this example the account numbers are 20 and 21. Replace `API-ADDRESS-OF-API-GW` with your External IP Address

            ```shell
            <copy>curl -s http://API-ADDRESS-OF-API-GW/api/v1/account/1 | jq ; curl -s http://API-ADDRESS-OF-API-GW/api/v1/account/2 | jq</copy>
            ```

            The output should be similar to this. Make a note of the `accountBalance` values.

            ```json
            {
                "accountId": 1,
                "accountName": "Andy's checking",
                "accountType": "CH",
                "accountCustomerId": "qwertysdwr",
                "accountOpenedDate": "2023-11-06T19:58:58.000+00:00",
                "accountOtherDetails": "Account Info",
                "accountBalance": -20
                }
                {
                "accountId": 2,
                "accountName": "Mark's CCard",
                "accountType": "CC",
                "accountCustomerId": "bkzLp8cozi",
                "accountOpenedDate": "2023-11-06T19:58:58.000+00:00",
                "accountOtherDetails": "Mastercard account",
                "accountBalance": 1000
                }
            ```

        1. Perform a transfer between the accounts (transfer $100 from account 2 to account 1)

            ```shell
            $ <copy>curl -X POST "http://localhost:8085/transfer?fromAccount=2&toAccount=1&amount=100"</copy>
            transfer status:withdraw succeeded deposit succeeded
            ```

        1. Check that the transfer has been made.

            ```shell
            <copy>curl -s http://API-ADDRESS-OF-API-GW/api/v1/account/1 | jq ; curl -s http://API-ADDRESS-OF-API-GW/api/v1/account/2 | jq</copy>
            ```

            The output should be similar to this. Make a note of the `accountBalance` values.

            ```json
            {
                "accountId": 1,
                "accountName": "Andy's checking",
                "accountType": "CH",
                "accountCustomerId": "qwertysdwr",
                "accountOpenedDate": "2023-11-06T19:58:58.000+00:00",
                "accountOtherDetails": "Account Info",
                "accountBalance": 80
                }
                {
                "accountId": 2,
                "accountName": "Mark's CCard",
                "accountType": "CC",
                "accountCustomerId": "bkzLp8cozi",
                "accountOpenedDate": "2023-11-06T19:58:58.000+00:00",
                "accountOtherDetails": "Mastercard account",
                "accountBalance": 900
                }
            ```

This concludes the lab *Deploy the full CloudBank Application* using the `oractl` CLI interface.

## Learn More

* [Oracle Backend for Spring Boot](https://bit.ly/oraclespringboot)
* [Oracle Backend for Parse Platform](https://oracle.github.io/microservices-datadriven/mbaas/)
* [Kubernetes](https://kubernetes.io/docs/home/)
* [Apache APISIX](https://apisix.apache.org)
* [Oracle Cloud Infrastructure](https://docs.oracle.com/en-us/iaas/Content/home.htm)

## Acknowledgements

* **Author** - Andy Tael, Corrado De Bari, Mark Nelson, Developer Evangelists, Oracle Database
* **Contributors** - [](var:contributors)
* **Last Updated By/Date** - Andy Tael, January 2024
