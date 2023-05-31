# Build the Check Processing Microservices

## Introduction

This lab walks you through the steps to build Spring Boot microservices that use Java Message Service (JMS) to send and receive aysnchronous messages.  This service will also use service discovery to lookup and use the previously built Account service.  In this lab, we will extend the Account microservice built in the previous lab, build a new "Check Processing" microservice and another "Test Runner" microservice to help with testing.

Estimated Time: 20 minutes

### Objectives

In this lab, you will:

* Create new Spring Boot projects in your IDE
* Plan your queues and message formats
* Use Spring JMS to allow your microservice to use JMS queues in the Oracle database
* Use OpenFeign to allow the Check Processing service to discover and use the Account service
* Create a "Test Runner" service to simulate the sending of messages 
* Deploy your microservices into the backend

### Prerequisites (Optional)

This lab assumes you have:

* An Oracle Cloud account
* All previous labs successfully completed

## Task 1: Learn about the scenario for this lab

In the previous lab, you created an Account service that includes endpoints to create and query accounts, lookup accounts for a given customer, and so on.  In this lab you will extend that service to add some new endpoints to allow recording bank transactions, in this case check deposits, in the account journal.

In this lab, we will assume that customers can deposit a check at an Automated Teller Machine (ATM) by typing in the check amount, placing the check into a deposit envelope and then inserting that envelope into the ATM.  When this occurs, the ATM will send a "deposit" message with details of the check deposit.  You will record this as a "pending" deposit in the account journal.

![Deposit check](images/deposit-check.png " ")

Later, imagine that the deposit envelop arrives at a back office check processing facility where a person checks the details are correct, and then "clears" the check.  When this occurs, a "clearance" message will be sent.  Upon receiving this message, you will change the "pending" transaction to a finalized "deposit" in the account journal. 

![Back office check clearing](images/clearances.png " ")

You will implement this using three microservices:

* The Account service you created in the previous lab will have the endpoints to manipulate journal entries
* A new "Check Processing" service will listen for messages and process them by calling calling the appropriate endpoints on the Account service
* A "Test Runner" service will simulate the ATM and the back office and allow you to send the "deposit" and "clearance" messages to test your other services

![The Check service](images/check-service.png " ")




## Task 2: Update the Account service to add the Journal

Starting with the account service that you built in the previous lab, you will the the JPA model and repository for the journal and some new endpoints.

1. Create the Journal model

   Create a new Java file in `src/main/java/com/example/accounts/model` called `JournalModel.java`.  In this class you can define the fields that make up the journal.  Note that you created the Journal table in the previous lab.  You will not use the `lraId` and `lraState` fields until the next lab.  To simplify this lab, create an additional constructor that defaults those feilds to suitable values.  Your new class should look like this: 

    ```java
    <copy>package com.example.accounts.model;

    import javax.persistence.Column;
    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.Table;

    import lombok.Data;
    import lombok.NoArgsConstructor;

    @Entity
    @Table(name = "JOURNAL")
    @Data
    @NoArgsConstructor
    public class Journal {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        @Column(name = "JOURNAL_ID")
        private long journalId;

        // type is withdraw or deposit
        @Column(name = "JOURNAL_TYPE")
        private String journalType;

        @Column(name = "ACCOUNT_ID")
        private long accountId;

        @Column(name = "LRA_ID")
        private String lraId;

        @Column(name = "LRA_STATE")
        private String lraState;

        @Column(name = "JOURNAL_AMOUNT")
        private long journalAmount;

        public Journal(String journalType, long accountId, long journalAmount) {
            this.journalType = journalType;
            this.accountId = accountId;
            this.journalAmount = journalAmount;
        }

        public Journal(String journalType, long accountId, long journalAmount, String lraId, String lraState) {
            this.journalType = journalType;
            this.accountId = accountId;
            this.lraId = lraId;
            this.lraState = lraState;
            this.journalAmount = journalAmount;
        }
    }</copy>
    ```   

1. Create the Journal repository

   Create a new Java file in `src/main/java/com/example/accounts/repository` called `JournalRepository.java`.  This should be an interface that extends `JpaRepository` and you will need to define a method to find journal entries by `accountId`.  Your interface should look like this: 

    ```java
    <copy>package com.example.accounts.repository;

    import java.util.List;

    import org.springframework.data.jpa.repository.JpaRepository;

    import com.example.accounts.model.Journal;

    public interface JournalRepository extends JpaRepository<Journal, Long> {
        List<Journal> findJournalByAccountId(long accountId);
    }</copy>
    ```   

1. Update the `AccountController` constructor

   Update the constructor for `AccountController` so that both the repositories are injected.  You will need to create a variable to hold each.  Your updated constructor should look like this:

    ```java
    <copy>final AccountRepository accountRepository;
    final JournalRepository journalRepository;

    public AccountController(AccountRepository accountRepository, JournalRepository journalRepository) {
        this.accountRepository = accountRepository;
        this.journalRepository = journalRepository;
    }</copy>
    ```

1. Add new method to post entries to the journal

   Add a new HTTP POST endpoint that accepts a journal entry in the request body and saves it into the database.  Your new method should look like this:

    ```java
    <copy>@PostMapping("/account/journal")
    public ResponseEntity<Journal> postSimpleJournalEntry(@RequestBody Journal journalEntry) {
        try {
            Journal _journalEntry = journalRepository.saveAndFlush(journalEntry);
            return new ResponseEntity<>(_journalEntry, HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }</copy>
    ```

1. Add new method to get journal entries

   Add a new HTTP GET endpoint to get a list of journal entries for a given `accountId`.  Your new method should look like this:

    ```java
    <copy>@GetMapping("/account/{accountId}/journal")
    public List<Journal> getJournalEntriesForAccount(@PathVariable("accountId") long accountId) {
        return journalRepository.findJournalByAccountId(accountId);
    }</copy>
    ```

1. Add new method to update an existing journal entry

   Add a new HTTP POST endpoint to update and existing journal entry to a cleared deposit.  To do this, you set the `journalType` field to `DEPOSIT`.  Your method should accept the `journalId` as a path variable.  If the specified journal entry does not exist, return a 404 (Not Found).  Your new method should look like this:

    ```java
    <copy>@PostMapping("/account/journal/{journalId}/clear")
    public ResponseEntity<Journal> clearJournalEntry(@PathVariable long journalId) {
        try {
            Optional<Journal> data = journalRepository.findById(journalId);
            if (data.isPresent()) {
                Journal _journalEntry = data.get();
                _journalEntry.setJournalType("DEPOSIT");
                journalRepository.saveAndFlush(_journalEntry);
                return new ResponseEntity<Journal>(_journalEntry, HttpStatus.OK);
            } else {
                return new ResponseEntity<Journal>(new Journal(), HttpStatus.NOT_FOUND);
            }
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }</copy>
    ```   

1. Build a JAR file for deployment

   Run the following command to build the JAR file.  Note that you will need to skip tests now, since you updated the `application.yaml` and it no longer points to your local test database instance.

    ```shell
    $ <copy>mvn package -Dmaven.test.skip=true</copy>
    ```

   The service is now ready to deploy to the backend.

1. Prepare the backend for deployment

   The Oracle Backend for Spring Boot admin service is not exposed outside of the Kubernetes cluster by default. Oracle recommends using a **kubectl** port forwarding tunnel to establish a secure connection to the admin service.

   Start a tunnel using this command:

    ```shell
    $ <copy>kubectl -n obaas-admin port-forward svc/obaas-admin 8080:8080</copy>
    ```

   Start the Oracle Backend for Spring Boot CLI using this command:

    ```shell
    $ <copy>oractl</copy>
    _   _           __    _    ___
    / \ |_)  _.  _. (_    /  |   |
    \_/ |_) (_| (_| __)   \_ |_ _|_

    09:35:14.801 [main] INFO  o.s.s.cli.shell.ShellApplication - Starting AOT-processed ShellApplication using Java 17.0.5 with PID 29373 (/Users/atael/bin/oractl started by atael in /Users/atael)
    09:35:14.801 [main] DEBUG o.s.s.cli.shell.ShellApplication - Running with Spring Boot v3.0.0, Spring v6.0.2
    09:35:14.801 [main] INFO  o.s.s.cli.shell.ShellApplication - The following 1 profile is active: "obaas"
    09:35:14.875 [main] INFO  o.s.s.cli.shell.ShellApplication - Started ShellApplication in 0.097 seconds (process running for 0.126)
    oractl:>
    ```

   Connect to the Oracle Backend for Spring Boot admin service using this command.  Hit enter when prompted for a password.  **Note**: Oracle recommends changing the password in a real deployment.

    ```shell
    oractl> <copy>connect</copy>
    password (defaults to oractl):
    using default value...
    connect successful server version:0.3.0
    oractl:>
    ```

1. Redeploy the account service

  You will now redeploy your account service to the Oracle Backend for Spring Boot using the CLI.  Run this command to redeploy your service, make sure you provide the correct path to your JAR file.  **Note** that this command may take 1-3 minutes to complete:

    ```shell
    oractl:> <copy>deploy --app-name application --service-name account --artifact-path /path/to/accounts-0.0.1-SNAPSHOT.jar --image-version 0.0.1 --redeploy true</copy>
    uploading: account/target/accounts-0.0.1-SNAPSHOT.jarbuilding and pushing image...
    creating deployment and service... successfully deployed
    oractl:>
    ```

1. Verify the new endpoints in the account service

   In the next three commands, you need to provide the correct IP address for the API Gateway in your backend environment.  You can find the IP address using this command, you need the one listed in the `EXTERNAL-IP` column:

    ```shell
    $ <copy>kubectl -n ingress-nginx get service ingress-nginx-controller</copy>
    NAME                       TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
    ingress-nginx-controller   LoadBalancer   10.123.10.127   100.20.30.40  80:30389/TCP,443:30458/TCP   13d
    ```

   Test the create journal entry endpoint with this command, use the IP address for your API Gateway:

    ```shell
    $ <copy>curl -i -X POST \
          -H 'Content-Type: application/json' \
          -d '{"journalType": "PENDING", "accountId": 2, "journalAmount": 100.00, "lraId": "0", "lraState": ""}' \
          http://100.20.30.40/api/v1/account/journal</copy>
    HTTP/1.1 201
    Date: Wed, 31 May 2023 13:02:10 GMT
    Content-Type: application/json
    Transfer-Encoding: chunked
    Connection: keep-alive

    {"journalId":21,"journalType":"PENDING","accountId":2,"lraId":"0","lraState":"","journalAmount":100}
    ```

   Notice that the response contains a `journalId` which you will need in a later command, and that the `journalType` is `PENDING`.

   Test the get journal entries endpoint with this command, use the IP address for your API Gateway.  Your output may be different:

    ```shell
    $ <copy>curl -i http://100.20.30.40/api/v1/account/2/journal</copy>
    HTTP/1.1 200
    Date: Wed, 31 May 2023 13:03:22 GMT
    Content-Type: application/json
    Transfer-Encoding: chunked
    Connection: keep-alive

    [{"journalId":3,"journalType":"PENDING","accountId":2,"lraId":"0","lraState":null,"journalAmount":100},{"journalId":4,"journalType":"DEPOSIT","accountId":2,"lraId":"0","lraState":null,"journalAmount":100},{"journalId":5,"journalType":"PENDING","accountId":2,"lraId":"0","lraState":null,"journalAmount":222},{"journalId":21,"journalType":"PENDING","accountId":2,"lraId":"0","lraState":null,"journalAmount":100},{"journalId":2,"journalType":"DEPOSIT","accountId":2,"lraId":"0","lraState":null,"journalAmount":100}]
    ```

   Test the update/clear journal entriy endpoint with this command, use the IP address for your API Gateway and the `journalId` from the first command's response:

    ```shell
    $ <copy>curl -i -X POST http://100.20.30.40/api/v1/account/journal/2/clear</copy>
    HTTP/1.1 200
    Date: Wed, 31 May 2023 13:04:36 GMT
    Content-Type: application/json
    Transfer-Encoding: chunked
    Connection: keep-alive

    {"journalId":2,"journalType":"DEPOSIT","accountId":2,"lraId":"0","lraState":null,"journalAmount":100}
    ```

   That completes the updates for the Account service.

## Task 3: Create the queues in the database

1. Create the queues

   Connect to the database as the `ADMIN` user and execute the following statements to give the `account` user the necessary permissions to use queues.  **Note**: Lab 2, Task 9 provided details on how to connect to the database.

    ```sql
    grant execute on dbms_aq to account;
    grant execute on dbms_aqadm to account;
    grant execute on dbms_aqin to account;
    grant execute on dbms_aqjms_internal to account;
    commit;
    ```

   Now connect as the `account` user and create the queues by executing these statements:

    ```sql
    connect account/Welcome12345;

    begin
        -- deposits
        dbms_aqadm.create_queue_table(
            queue_table        => 'deposits_qt',
            queue_payload_type => 'SYS.AQ$_JMS_TEXT_MESSAGE');
        dbms_aqadm.create_queue(
            queue_name         => 'deposits',
            queue_table        => 'deposits_qt');
        dbms_aqadm.start_queue(
            queue_name         => 'deposits');
        -- clearances 
        dbms_aqadm.create_queue_table(
            queue_table        => 'clearances_qt',
            queue_payload_type => 'SYS.AQ$_JMS_TEXT_MESSAGE');
        dbms_aqadm.create_queue(
            queue_name         => 'clearances',
            queue_table        => 'clearances_qt');
        dbms_aqadm.start_queue(
            queue_name         => 'clearances');
    end;
    /
    ```

   You have created two queues named `deposits` and `clearances`.  Both of them use the JMS `TextMessage` format for the payload.

## Task 4: Create the Check Processing microservice

1. Do the thing

   The thing about the thing


## Learn More

* [Oracle Backend for Spring Boot](https://oracle.github.io/microservices-datadriven/spring/)


## Acknowledgements

* **Author** - Mark Nelson, Developer Evangelist, Oracle Database
* **Contributors** - [](var:contributors)
* **Last Updated By/Date** - Mark Nelson, June 2023
