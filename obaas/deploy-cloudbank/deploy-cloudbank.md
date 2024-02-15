# Deploy the full CloudBank Application using the CLI

## Introduction

Now that you know how to build a Spring Boot microservice and deploy it to the Oracle Backend for Spring Boot and Microservices, this lab will guide you through deploying all of the CloudBank services and exploring the runtime and management capabilities of the platform. **NOTE:** The full CloudBank leverages more features than you have built so far such as monitoring, tracing etc. You will see those features in the lab "Explore The Backend Platform".

Estimated Lab Time: 30 minutes

Quick walk through on how to deploy full CloudBank application.

[](videohub:1_3r1te1ii)

### Objectives

In this lab, you will:

* Deploy the full CloudBank sample application into your Oracle Backend for Spring Boot and Microservices Microservices instance

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

    This directory will be referred to as the `root` directory for CloudBank in this lab.

## Task 2: Build the CloudBank application

1. Create application JAR files

    In the directory (root) where you cloned (or unzipped) the application and build the application JARs using the following command:

    ```shell
    <copy>mvn clean package</copy>
    ```

    The output should be similar to this:

    ```text
    [INFO] ------------------------------------------------------------------------
    [INFO] Reactor Summary for CloudBank 0.0.1-SNAPSHOT:
    [INFO]
    [INFO] CloudBank .......................................... SUCCESS [  0.916 s]
    [INFO] account ............................................ SUCCESS [  2.900 s]
    [INFO] checks ............................................. SUCCESS [  1.127 s]
    [INFO] customer ........................................... SUCCESS [  1.106 s]
    [INFO] creditscore ........................................ SUCCESS [  0.908 s]
    [INFO] transfer ........................................... SUCCESS [  0.455 s]
    [INFO] testrunner ......................................... SUCCESS [  0.942 s]
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  9.700 s
    [INFO] Finished at: 2024-01-18T15:52:56-06:00
    [INFO] ------------------------------------------------------------------------
    ```

## Task 3: Deploy CloudBank to your Oracle Backend for Spring Boot and Microservices instance

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

    Open a new terminal Window or Tab and start the Oracle Backend for Spring Boot and Microservices CLI (*oractl*) using this command:

    ```shell
    $ <copy>oractl</copy>
     _   _           __    _    ___
    / \ |_)  _.  _. (_    /  |   |
    \_/ |_) (_| (_| __)   \_ |_ _|_
    ========================================================================================
      Application Name: Oracle Backend Platform :: Command Line Interface
      Application Version: (1.1.1)
      :: Spring Boot (v3.2.1) ::

      Ask for help:
      - Slack: https://oracledevs.slack.com/archives/C03ALDSV272
      - email: obaas_ww@oracle.com

    oractl:>
    ```

1. Connect to the Oracle Backend for Spring Boot and Microservices admin service called *obaas-admin*

    Connect to the Oracle Backend for Spring Boot and Microservices admin service using this command. Use thr password you obtained is Step 1.

    ```shell
    oractl> <copy>connect</copy>
    username: obaas-admin
    password: **************
    Credentials successfully authenticated! obaas-admin -> welcome to OBaaS CLI.
    oractl:>
    ```

1. Deploy CloudBank

    CloudBank will be deployed using a script into the namespace `application`. The script does the following:

    * Executes the `bind` command for the services that requires database access.
    * Deploys the CloudBank services.

    > What happens when you use the oractl CLI **bind** command? When you run the `bind` command, the oractl tool does several things for you:

    * Asks for Database user credentials.
    * Creates or updates a k8s secret with the provided user credentials.
    * Creates a Database Schema with the provided user credentials.

    > What happens when you use the Oracle Backend for Spring Boot and Microservices CLI  (*oractl*) **deploy** command? When you run the `deploy` command, *oractl* does several things for you:

    * Uploads the JAR file to server side
    * Builds a container image and push it to the OCI Registry
    * Inspects the JAR file and looks for bind resources (JMS)
    * Create the microservices deployment descriptor (k8s) with the resources supplied
    * Applies the k8s deployment and create k8s object service to microservice

    The services are using [Liquibase](https://www.liquibase.org/). Liquibase is an open-source database schema change management solution which enables you to manage revisions of your database changes easily. When the service get's deployed the `tables` and sample `data` will be created and inserted by Liquibase. The SQL executed can be found in the source code directories of CloudBank.

    Run the following command to deploy CloudBank. When asked for `Database/Service Password:` enter the password `Welcome1234##`. You need to do this multiple times. **NOTE:** The deployment of CloudBank will take a few minutes.

    ```text
    oractl:>script --file deploy-cmds/deploy-cb.txt
    ```

    The output should look similar to this:

    ```text
    Database/Service Password: *************
    Schema {account} was successfully Created and Kubernetes Secret {application/account} was successfully Created.
    Database/Service Password: *************
    Schema {account} was successfully Not_Modified and Kubernetes Secret {application/checks} was successfully Created.
    Database/Service Password: *************
    Schema {customer} was successfully Created and Kubernetes Secret {application/customer} was successfully Created.
    Database/Service Password: *************
    Schema {account} was successfully Not_Modified and Kubernetes Secret {application/testrunner} was successfully Created.
    uploading: account/target/account-0.0.1-SNAPSHOT.jar
    building and pushing image...

    creating deployment and service...
    obaas-cli [deploy]: Application was successfully deployed.
    NOTICE: service not accessible outside K8S
    uploading: checks/target/checks-0.0.1-SNAPSHOT.jar
    building and pushing image...

    creating deployment and service...
    obaas-cli [deploy]: Application was successfully deployed.
    NOTICE: service not accessible outside K8S
    uploading: customer/target/customer-0.0.1-SNAPSHOT.jar
    building and pushing image...

    creating deployment and service...
    obaas-cli [deploy]: Application was successfully deployed.
    NOTICE: service not accessible outside K8S
    uploading: creditscore/target/creditscore-0.0.1-SNAPSHOT.jar
    building and pushing image...

    creating deployment and service...
    obaas-cli [deploy]: Application was successfully deployed.
    NOTICE: service not accessible outside K8S
    uploading: testrunner/target/testrunner-0.0.1-SNAPSHOT.jar
    building and pushing image...

    creating deployment and service...
    obaas-cli [deploy]: Application was successfully deployed.
    NOTICE: service not accessible outside K8S
    uploading: transfer/target/transfer-0.0.1-SNAPSHOT.jar
    building and pushing image...

    creating deployment and service...
    obaas-cli [deploy]: Application was successfully deployed.
    NOTICE: service not accessible outside K8S
    ```

## Task 4: Create Apache APISIX routes to the deployed CloudBank services

To be able to access the CLoudBank services from the public internet we need expose the services via the Apache APISIX gateway. We're going to do that using scripts.

1. Get APISIX Gateway Admin Key

    You are going to need the Admin Key for the APISIX Gateway to configure the route. It is stored in a k8s ConfigMap. Run the command and make a note of the admin key.

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

1. Create tunnel to APISIX

    ```shell
    kubectl port-forward -n apisix svc/apisix-admin 9180
    ```

1. Create the routes

    In the `root` directory run the following command. *NOTE*, you must add your API-KEY to the command:

    ```shell
    (cd apisix-routes; source ./create-all-routes.sh <YOUR-API-KEY>)
    ```

    The script will create the following routes:

    | CloudBank Service | URI |
    | ------------------| ----|
    | ACCOUNT | /api/v1/account* |
    | CREDITSCORE | /api/v1/creditscore* |
    | CUSTOMER | /api/v1/customer* |
    | TESTRUNNER |  /api/v1/testrunner* |
    | TRANSFER |  /transfer* |

1. Verify the routes in the APISIX Dashboard

    1. Get the password for the APISIX dashboard.

        Retrieve the password for the APISIX dashboard using this command:

        ```shell
        kubectl get secret apisix-dashboard -n apisix -o jsonpath='{.data.conf\.yaml}' | base64 --decode</copy>
        ```

    1. Start the tunnel in a new terminal window using this command.

        ```shell
        $ <copy>kubectl -n apisix port-forward svc/apisix-dashboard 7070:80</copy>
        Forwarding from 127.0.0.1:7070 -> 9000
        Forwarding from [::1]:7070 -> 9000
        ```

        Open a web browser to [http://localhost:7070](http://localhost:7070) to view the APISIX Dashboard web user interface.  It will appear similar to the image below.

        If prompted to login, login with username `admin` and the password you got from the k8s secret earlier. Note that Oracle strongly recommends that you change the password, even though this interface is not accessible outside the cluster without a tunnel.

        ![APISIX Dashboard Login](images/apisix-login.png " ")

        Click the routes menu item to see the routes you created in step three.

        ![APISIX Routes](images/apisix-route.png " ")

        Verify that you have three routes created

        ![APISIX Route Details](images/apisix-route-details.png " ")

## Task 5: Verify the deployment of CloudBank

1. Verification of the services deployment

    Verify that the services are running properly by executing this command:

    ```shell
    <copy>kubectl get pods -n application</copy>
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

## Task 6: Verify the deployment of CloudBank services

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
        <copy>curl -s http://API-ADDRESS-OF-API-GW/api/v1/account/<accountId> | jq .</copy>
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

        1. Check the account balances for two accounts, in this example the account numbers are 1 and 2. Replace `API-ADDRESS-OF-API-GW` with your External IP Address

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

* [Oracle Backend for Spring Boot and Microservices](https://bit.ly/oraclespringboot)
* [Oracle Backend for Parse Platform](https://oracle.github.io/microservices-datadriven/mbaas/)
* [Kubernetes](https://kubernetes.io/docs/home/)
* [Apache APISIX](https://apisix.apache.org)
* [Oracle Cloud Infrastructure](https://docs.oracle.com/en-us/iaas/Content/home.htm)

## Acknowledgements

* **Author** - Andy Tael, Corrado De Bari, Mark Nelson, Developer Evangelists, Oracle Database
* **Contributors** - [](var:contributors)
* **Last Updated By/Date** - Andy Tael, February 2024
