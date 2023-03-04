# Manage Saga Transactions across Microservices

## Introduction

This lab walks you through implementing the [Saga pattern](https://microservices.io/patterns/data/saga.html) using a [Long Running Action](https://download.eclipse.org/microprofile/microprofile-lra-1.0-M1/microprofile-lra-spec.html) to manage transactions across microservices.

Estimated Time: 30 minutes

### Objectives

In this lab, you will:

* Learn about the Saga pattern
* Learn about the Long Running Action specification
* Add new endpoints to the Account service for deposits and withdrawals that act as LRA participants
* Create a Transfer service that will initiate the LRA

### Prerequisites

This lab assumes you have:

* An Oracle Cloud account
* All previous labs successfully completed

## Task 1: Learn about the Saga pattern

When you adopt microservices architecture and start to apply the patterns, you rapidly run into a situation where you have a business transaction that spans across multiple services.  

### Database per service

The [Database per service](https://microservices.io/patterns/data/database-per-service.html) pattern is a generally accepted best practice which dictates that each service must have its own "database" and that the only way other services can access its data is through its public API.  This helps to create loose coupling between services, which in turn makes it easier to evolve them independently and prevents the creation of a web of dependencies that make application changes increasingly difficult over time.  In reality, this pattern may be implemented with database containers, or even schema within one database with strong security isolation, to prevent the proliferation of database instances and the associated management and maintenance cost explosion. 

### Transactions that span services

The obvious challenge with the Database per service pattern is that a database transaction cannot span databases, or services.  So if you have a scenario where you need to perform operations in more than one service's database, you need a solution for this challenge.

A saga is a sequence of local transactions.  Each service performs local transactions and then triggers the next step in the saga.  If there is a failure due to violating a business rule (e.g. trying to withdraw more money than is in an account) then the saga executes a series of compensating transactions to undo the changes that were already made.

### Saga coordination

There are two ways to coordinate sagas:

* Choreography - each local transaction publishes domain events that trigger local transactions in other services
* Orchestration - an orchestrator (object) tells the participants what local transactions to execute

You will use the orchestration approach in this lab.

> **Note**: You can learn more about the saga pattern at [microservices.io](https://microservices.io/patterns/data/saga.html).

### The Cloud Cash Transfer Saga

In this lab you will implement a saga that will manage transferring funds from one user to another.  The CloudBank mobile application will have a feature called "Cloud Cash" that allows users to instantly transfer funds to anyone.  They will do this by choosing a source account and entering the email address of the person they wish to send funds to, and the amount.

![Cloud Cash screen](images/obaas-flutter-cloud-cash-screen-design.png)

When the user submits their request, a microservice will pick up the request and invoke the **Transfer** service (which you will write in this lab) to process the transfer.

The Transfer service will need to find the target customer using the provided email address, then perform a withdrawal and a deposit.  It will need to coordinaate these actions to make sure they all occur, and to perform compensation if there is a problem. 


## Task 2: Learn about Long Running Actions

There are different models that can be used to coordinate transactions across services.  Three of the most common are XA (Extended Architcture) which focuses on strong consistency, LRA (Long Running Action) which provides eventual consistency, and TCC (Try-Confirm/Cancel) which uses a reservation model.  Oracle Backend for Spring Boot includes [Oracle Transaction Manager for Microservices](https://www.oracle.com/database/transaction-manager-for-microservices/) which supports all three of these options. 

In this lab, you will explore the Long Running Action model.  In this model there is a logical coordinator and a number of participants.  Each participant is responsible for performing work and being able to compensate if necessary.  The coordinator essentially manages the lifecycle of the LRA, for example by telling participants when to cancel or complete.

![The Cloud Cash LRA](images/obaas-lra.png)

You will create the **Transfer service** in the diagram above, and the participant endpoints in the Account service (**deposit** and **withdraw**).  Oracle Transaction Manager for Microservices (also known as "MicroTx") will coordinate the LRA.

You will implement the LRA using the Eclipse Microprofile LRA library which provides an annotation-based approach to managing the LRA, which is very familiar for Spring Boot developers.  

> **Note**: The current version of the library (at the time of the Level Up 2023 event) uses JAX-RS, not Spring Boot's REST annotations provided by `spring-boot-starter-web`, so until a version of the library with better support for Spring is available, we will need to do a little extra work to use JAX-RS.

The main annotations used in an LRA application are as follows: 

* `@LRA` - Controls the life cycle of an LRA.
* `@Compensate` - Indicates that the method should be invoked if the LRA is cancelled.
* `@Complete` - Indicates that the method should be invoked if the LRA is closed.
* `@Forget` - Indicates that the method may release any resources that were allocated for this LRA.
* `@Leave` - Indicates that this class is no longer interested in this LRA.
* `@Status` - When the annotated method is invoked it should report the status.

If you would like to learn more, there is a lot of detail in the [Long Running Action](https://download.eclipse.org/microprofile/microprofile-lra-1.0-M1/microprofile-lra-spec.html) specification.

### Keeping track of local transactions made in an LRA

Microservices are often designed to be stateless, to push all the state into the datastore.  This makes it easier to scale by running more instances of services, and it makes it easier to debug issues because there is no state stored in process memory.  It also means you need a way to correlate transactions with the LRA they were performed by. 

You will add a `JOURNAL` table to the account microservice's database.  This table will contain the "bank account transactions" (deposits, withdrawals, interest payments, etc.) for this account (not to be confused with "database transactions" as in the two-phase commit protocol).  The account service will track LRA's associated with each journal entry (bank account transaction) in a column in the journal table.

As LRA is an eventual consistency model, the approach you will take in the account service will be to store bank account transactions as "pending" in the journal table.  Pending transactions will not be considered when calculating the account balance until they are finalized ("completed").  When the LRA reaches the "complete" phase, the pending transactions will be considered finalized and the account balance will be updated to reflect those transactions.

You will now start implementing the Cloud Cash Payment LRA.

## Task 3: Prepare to add LRA participant endpoints to the Account Service

You will update the Account service that you built in the previous lab to add some new endpoints to perform deposits and withdrawals.  These new endpoints will be LRA participants.

1. Add new dependencies to the Maven POM

  TODO explain what these are for

    ```xml
    <copy>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-jersey</artifactId>
    </dependency>
    <dependency>
        <groupId>org.eclipse.microprofile.lra</groupId>
        <artifactId>microprofile-lra-api</artifactId>
        <version>1.0</version>
    </dependency>
    <dependency>
        <groupId>org.jboss.narayana.rts</groupId>
        <artifactId>narayana-lra</artifactId>
        <version>5.13.1.Final</version>
    </dependency>
    <dependency>
        <groupId>jakarta.enterprise</groupId>
        <artifactId>jakarta.enterprise.cdi-api</artifactId>
        <version>2.0.2</version>
    </dependency>
    </copy>
    ```  

   TODO more explanation

1. Update the Spring Boot application configuration file

  Update your Account service's Spring Boot configuration file, `application.yaml` in `src/main/resources`.  You need to add the `jersey` section under `spring`, and also add a new `lra` section with the URL for the LRA coordinator.  The URL shown here is for the Oracle Transaction Manager for Microservices that was installed as part of the Oracle Backend for Spring Boot.  **Note**: This URL is from the point of view of a service running it the same Kubernetes cluster.  

    ```yaml
    <copy>
    spring:
      application:
        name: accounts
      jersey:
        type: filter
    lra:
      coordinator:
        url: http://otmm-tcs.otmm.svc.cluster.local:9000/api/v1/lra-coordinator
    </copy>
    ```  

1. Create the Jersey configuration

  Create a new Java file called `JerseyConfig.java` in `src/main/java/com/examples/accounts`.  In this file, you need to register the LRA filters, which will process the LRA annotations, create a binding, and configure the filters to forward on a 404 (Not Found).  Here is the code to perform this configuration:

    ```java
    <copy>
    package com.example.accounts;
     
    import javax.ws.rs.ApplicationPath;
    import org.glassfish.hk2.utilities.binding.AbstractBinder;
    import org.glassfish.jersey.server.ResourceConfig;
    import org.glassfish.jersey.servlet.ServletProperties;
    import org.springframework.stereotype.Component;
    import io.narayana.lra.client.internal.proxy.nonjaxrs.LRAParticipantRegistry;
    
    @Component
    @ApplicationPath("/")
    public class JerseyConfig extends ResourceConfig {
    
        public JerseyConfig()  {
            register(io.narayana.lra.filter.ServerLRAFilter.class);
            register(new AbstractBinder(){
                @Override
                protected void configure() {
                    bind(LRAParticipantRegistry.class)
                        .to(LRAParticipantRegistry.class);
                }
            });
            property(ServletProperties.FILTER_FORWARD_ON_404, true);
        }
    }
    </copy>
    ```

1. Create the Journal repository and model

   Create a new Java file called `Journal.java` in `src/main/com/example/accounts/model` to define the model for the journal table.  There are no new concepts in this class, so here is the code: 

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

        public Journal(String journalType, long accountId, long journalAmount, String lraId, String lraState) {
            this.journalType = journalType;
            this.accountId = accountId;
            this.lraId = lraId;
            this.lraState = lraState;
            this.journalAmount = journalAmount;
        }
    }</copy>
    ```

   Create a new Java file called `JournalRepository.java` in `src/main/java/com/example/accounts/repository` and define the JPA repository interface for the Journal.  You will need to add one JPA method `findJournalByLraId()` to the interface.  Here is the code:

    ```java
    <copy>package com.example.accounts.repository;

    import com.example.accounts.model.Journal;
    import org.springframework.data.jpa.repository.JpaRepository;

    import java.util.List;

    public interface JournalRepository extends JpaRepository<Journal, Long> {
        List<Journal> findJournalByLraId(String lraId);
    }</copy>
    ```

1. That thing

  TODO how.

## Task 4: Create the basic structure of the Deposit service

The Deposit service will process deposits into bank accounts.  In this task, you will create the basic structure for this service and learn about the endpoints required for an LRA participant, what HTTP Methods they process, the annotations used to define them and so on.  You will implement the actual business logic in a later task.

1. Create the Deposit service and scaffold methods

   Create a new directory in `src/main/java/com/example/accounts` called `services` and in that directory create a new Java file called `DepositService.java`.  This will be a Spring Boot component where you will implement the deposit operations.  Since the LRA library we are using only works with JAX-RS, you will be using JAX-RS annotations in this service, as opposed to the Spring Boot "web" REST annotations that you used in the previous lab.  You can mix and match these styles in a single Spring Boot microservice application.

   Start by setting up endpoints and methods with the appropriate annotations.  You will implement the logic for each of these methods shortly.  Here is the class definition and all the imports you will need in this section.  Notice that the class has the `@RequestScoped` annotation which tells Spring to create an instance of this class for each HTTP request (as opposed to for a whole session for example), the Spring Boot `@Component` annotation which marks this class as a bean that Spring can inject as a dependency when needed, and the `@Path` annotation to set the URL path for these endpoints.

    ```java
    <copy>package com.example.accounts.services;

    import static org.eclipse.microprofile.lra.annotation.ws.rs.LRA.LRA_HTTP_CONTEXT_HEADER;
    import static org.eclipse.microprofile.lra.annotation.ws.rs.LRA.LRA_HTTP_ENDED_CONTEXT_HEADER;
    import static org.eclipse.microprofile.lra.annotation.ws.rs.LRA.LRA_HTTP_PARENT_CONTEXT_HEADER;

    import javax.enterprise.context.RequestScoped;
    import javax.ws.rs.Consumes;
    import javax.ws.rs.GET;
    import javax.ws.rs.HeaderParam;
    import javax.ws.rs.POST;
    import javax.ws.rs.PUT;
    import javax.ws.rs.Path;
    import javax.ws.rs.Produces;
    import javax.ws.rs.QueryParam;
    import javax.ws.rs.core.MediaType;
    import javax.ws.rs.core.Response;

    import org.eclipse.microprofile.lra.annotation.AfterLRA;
    import org.eclipse.microprofile.lra.annotation.Compensate;
    import org.eclipse.microprofile.lra.annotation.Complete;
    import org.eclipse.microprofile.lra.annotation.Status;
    import org.eclipse.microprofile.lra.annotation.ws.rs.LRA;
    import org.springframework.stereotype.Component;
    import org.springframework.transaction.annotation.Transactional;

    @RequestScoped
    @Path("/deposit")
    @Component
    public class DepositService {

    }</copy>
    ``` 

1. Create the LRA entry point

   The first method you need will be the main entry point, the `deposit()` method.  This will have the `@POST` annotation so that it will respond to the HTTP POST method.  It will have the `@Produces` annotation with the value `MediaType.APPLICATION_JSON` so that the response will contain JSON data and have the HTTP `Content-Type: application/json` header.  It has the `@Transactional` annotation, which declares to Spring that this is a transaction boundary and tells Spring to inject various behaviors related to transaction management and rollback.  And finally, it has the `@LRA` annotation.

   In the `@LRA` annotation, which marks this as an LRA participant, the `value` property is set to `LRA.Type.MANDATORY` which means that this method will refuse to perform any work unless it is part of an LRA.  The `end` property is set to `false` which means that successful completion of this method does not in and of itself constitute successful completion of the LRA, in other words, this method expects that it will not be the only participant in the LRA.

   The LRA coordinator will pass the LRA ID to this method (and any other participants) in an HTTP header.  Notice that the first argument of the method extracts that header and maps it to `lraId`.  The other two arguments are mapped to HTTP Query parameters which identify the account and amount to deposit.  For now, this method will just return a response with the HTTP Status Code set to 200 (OK).  You will implement the actual business logic shortly.

    ```java
    <copy>
    /**
    * Write journal entry re deposit amount.
    * Do not increase actual bank account amount
    */
    @POST
    @Path("/deposit")
    @Produces(MediaType.APPLICATION_JSON)
    @LRA(value = LRA.Type.MANDATORY, end = false)
    @Transactional
    public Response deposit(@HeaderParam(LRA_HTTP_CONTEXT_HEADER) String lraId,
            @QueryParam("accountId") long accountId,
            @QueryParam("amount") long depositAmount) {
        return Response.ok().build();
    }
    </copy>
    ```

1. Create the LRA complete endpoint

   Each LRA participant needs a "complete" endpoint.  This `completeWork` method implements that endpoint, as declared by the `@Complete` annotation.  Note that this responds to the HTTP PUT method, and it produces JSON and extracts the LRA ID from an HTTP header as in the previous method.

    ```java
    <copy>
    /**
    * Increase balance amount as recorded in journal during deposit call.
    * Update LRA state to ParticipantStatus.Completed.
    */
    @PUT
    @Path("/complete")
    @Produces(MediaType.APPLICATION_JSON)
    @Complete
    public Response completeWork(@HeaderParam(LRA_HTTP_CONTEXT_HEADER) String lraId) throws Exception {
        return Response.ok().build();
    }
    </copy>
    ```

1. Create the LRA compensate endpoint

   Next, you need a compensate endpoint.  This `compensateWork` method is similar to the previous methods and is marked with the `@Compensate` annotation to mark it as the compensation handler for this participant.

    ```java
    <copy>
    /**
    * Update LRA state to ParticipantStatus.Compensated.
    */
    @PUT
    @Path("/compensate")
    @Produces(MediaType.APPLICATION_JSON)
    @Compensate
    public Response compensateWork(@HeaderParam(LRA_HTTP_CONTEXT_HEADER) String lraId) throws Exception {
        return Response.ok().build();
    }
    </copy>
    ```

1. Create the LRA status endpoint

   Next, you need to provide a status endpoint.  This must respond to the HTTP GET method.  It returns plain text TODO WHY PAUL?  Notice that it also extracts the parent LRA ID (if present Paul? why??) TODO

    ```java
    <copy>
    /**
    * Return status
    */
    @GET
    @Path("/status")
    @Produces(MediaType.TEXT_PLAIN)
    @Status
    public Response status(@HeaderParam(LRA_HTTP_CONTEXT_HEADER) String lraId,
            @HeaderParam(LRA_HTTP_PARENT_CONTEXT_HEADER) String parentLRA) throws Exception {
        return Response.ok().build();
    }
    </copy>
    ```

1. Create the "after" LRA endpoint

   Finally, you need an "after LRA" endpoint that implements any clean up logic that needs to be run after the completion of the LRA.  (TODO paul successful only or any outcome?)   This method must respond to the HTTP PUT method and is marked with the `@AfterLRA` annotation.

    ```java
    <copy>
    /**
    * Delete journal entry for LRA
    */
    @PUT
    @Path("/after")
    @AfterLRA
    @Consumes(MediaType.TEXT_PLAIN)
    public Response afterLRA(@HeaderParam(LRA_HTTP_ENDED_CONTEXT_HEADER) String lraId, String status) throws Exception {
        return Response.ok().build();
    }
    </copy>
    ```

  TODO now implement the business logic - probably need to do the util class first .. 

## Task 5: Create an Account/Transfer Data Access Object

The Data Access Object pattern is considered a best practice and it allows separation of business logic from the persistence layer.  In this task, you will create an Account Data Access Object (DAO) that hides the complexity of the persitence layer logic from the business layer services.  Additionally, it establishes methods that can be reused by each business layer service that needs to operate on accounts - in this lab there will be two such services - deposit and withdraw.

1. Create the DAO class

   Create a new Java file called `AccountTransferDAO.java` in `src/main/java/com/example/accounts/services`.  This class will contain common data access methods that are needed by multiple partipants.  You will implement this class using the singleton pattern so that there will only be one instance of this class.

   Here is the code to set up the class and implement the singleton pattern:

    ```java
    <copy>package com.example.accounts.services;

    import java.util.List;

    import javax.ws.rs.core.Response;

    import org.eclipse.microprofile.lra.annotation.ParticipantStatus;
    import org.springframework.stereotype.Component;

    import com.example.accounts.model.Account;
    import com.example.accounts.model.Journal;
    import com.example.accounts.repository.AccountRepository;
    import com.example.accounts.repository.JournalRepository;

    @Component
    public class AccountTransferDAO {

        private static AccountTransferDAO singleton;
        final AccountRepository accountRepository;
        final JournalRepository journalRepository;

        public AccountTransferDAO(AccountRepository accountRepository, JournalRepository journalRepository) {
            this.accountRepository = accountRepository;
            this.journalRepository = journalRepository;
            singleton = this;
            System.out.println(
                    "AccountTransferDAO accountsRepository = " + accountRepository + ", journalRepository = " + journalRepository);
        }

        public static AccountTransferDAO instance() {
            return singleton;
        }

    }</copy>
    ```

1. Create a method to get the LRA status as a String

   Create a `getStatusString` method which can be used to get a String representation of the LRA participant status.

    ```java
    <copy>public static String getStatusString(ParticipantStatus status) {
        switch (status) {
            case Compensated:
                return "Compensated";
            case Completed:
                return "Completed";
            case FailedToCompensate:
                return "Failed to Compensate";
            case FailedToComplete:
                return "Failed to Complete";
            case Active:
                return "Active";
            case Compensating:
                return "Compensating";
            case Completing:
                return "Completing";
            default:
                return "Unknown";
        }
    }</copy>
    ```

1. Create a method to get the LRA status from a String

   Create a `getStatusFromString` method to convert back from the String to the enum.

    ```java
    <copy>public static ParticipantStatus getStatusFromString(String statusString) {
        switch (statusString) {
            case "Compensated":
                return ParticipantStatus.Compensated;
            case "Completed":
                return ParticipantStatus.Completed;
            case "Failed to Compensate":
                return ParticipantStatus.FailedToCompensate;
            case "Failed to Complete":
                return ParticipantStatus.FailedToComplete;
            case "Active":
                return ParticipantStatus.Active;
            case "Compensating":
                return ParticipantStatus.Compensating;
            case "Completing":
                return ParticipantStatus.Completing;
            default:
                return null;
        }
    }</copy>
    ```

1. Create a method to save an account

   Create a method to save an account in the account repository.

    ```java
    <copy>public void saveAccount(Account account) {
        accountRepository.save(account);
    }</copy>
    ```

   Create a method to return the correct HTTP Status Code for an LRA status.

    ```java
    <copy>public Response status(String lraId) throws Exception {
        Journal journal = getJournalForLRAid(lraId);
        if (AccountTransferDAO.getStatusFromString(journal.getLraState()).equals(ParticipantStatus.Compensated))
            return Response.ok(ParticipantStatus.Compensated).build();
        else
            return Response.ok(ParticipantStatus.Completed).build();
    }</copy>
    ```

1. Create a method to update the LRA status in the journal

   Create a method to update the LRA status in the journal table during the "after LRA" phase.

    ```java
    <copy>public void afterLRA(String lraId, String status) throws Exception {
        Journal journal = getJournalForLRAid(lraId);
        journal.setLraState(status);
        journalRepository.delete(journal);
    }</copy>
    ```

1. Create methods to manage accounts

   Create a method to get the account that is related to a journal entry.

    ```java
    <copy>Account getAccountForJournal(Journal journal) throws Exception {
        Account account = accountRepository.findByAccountId(journal.getAccountId());
        if (account == null) throw new Exception("Invalid accountName:" + journal.getAccountId());
        return account;
    }</copy>
    ```

   Create a method to get the account for a given account name TODO paul update?? 

    ```java
    <copy> Account getAccountForAccountId(long accountId)  {
      Account account = accountRepository.findByAccountId(accountId);
      if (account == null) return null;
      return account;
    }</copy>
    ```

   Update `AccountRepository.java` in `src/main/java/com/example/accounts/repositories` to add this extra JPA method for `findByAccountId`.  Your updated file should look like this: 

    ```java
    <copy>package oracle.examples.cloudbank.repository;

    import oracle.examples.cloudbank.model.Account;
    import org.springframework.data.jpa.repository.JpaRepository;

    import java.util.List;

    public interface AccountRepository extends JpaRepository <Account, Long> {
        List<Account> findAccountsByAccountNameContains (String accountName);
        List<Account> findByAccountCustomerId(String customerId);
        Account findByAccountId(long accountId);
    }</copy>
    ```    

1. Create methods to manage the journal

   Create a method to get the journal entry for a given LRA.

    ```java
    <copy>Journal getJournalForLRAid(String lraId) throws Exception {
        Journal journal;
        List<Journal> journals = journalRepository.findJournalByLraId(lraId);
        if (journals.size() == 0) {
            journalRepository.save(new Journal("unknown", -1, 0, lraId,
                    AccountTransferDAO.getStatusString(ParticipantStatus.FailedToComplete)));
            throw new Exception("Journal entry does not exist for lraId:" + lraId);
        }
        journal = journals.get(0);
        return journal;
    }</copy>
    ```

   Create a method to save a journal entry.

    ```java
    <copy>public void saveJournal(Journal journal) {
        journalRepository.save(journal);
    }
    </copy>
    ```

   TODO something

## Task 6: Implement the deposit service's business logic

TODO

## Task 7: Create the Withdraw service

TODO what thing

1. This thing

  TODO how.

## Task 8: Create the Transfer Service

TODO what thing

1. This thing

  TODO how.

## Task 9: Run LRA test cases

TODO what thing

1. This thing

  TODO how.

## Learn More

* [Oracle Transaction Manager for Microservices](https://www.oracle.com/database/transaction-manager-for-microservices/)
* [Saga pattern](https://microservices.io/patterns/data/saga.html)
* [Long Running Action](https://download.eclipse.org/microprofile/microprofile-lra-1.0-M1/microprofile-lra-spec.html)
* [Oracle Backend for Spring Boot](https://oracle.github.io/microservices-datadriven/spring/)
* [Oracle Backend for Parse Platform](https://oracle.github.io/microservices-datadriven/mbaas/)

## Acknowledgements

* **Author** - Paul Parkinson, Mark Nelson, Developer Evangelists, Oracle Database
* **Contributors** - [](var:contributors)
* **Last Updated By/Date** - Mark Nelson, March 2023
