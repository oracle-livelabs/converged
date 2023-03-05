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

> **Note**: Unlike Java Transcation Architecture (JTA) where "in-doubt" tables are created automatically to keep track of pending transactions, LRA is only concerned with the orchestration of the API calls, so particpants need to track transactions themselves.  In this lab you will use the journal table both to store the transactions and to track the lRA.  Of course, this could also be done with separate tables if desired.

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

   Create a new Java file called `JournalRepository.java` in `src/main/java/com/example/accounts/repository` and define the JPA repository interface for the Journal.  You will need to add one JPA method `findJournalByLraIdAndJournalType()` to the interface.  Here is the code:

    ```java
    <copy>package com.example.accounts.repository;

    import com.example.accounts.model.Journal;
    import org.springframework.data.jpa.repository.JpaRepository;

    import java.util.List;

    public interface JournalRepository extends JpaRepository<Journal, Long> {
        Journal findJournalByLraIdAndJournalType(String lraId, String journalType);
    }</copy>
    ```

   That completes the JPA configuration.

## Task 4: Create the basic structure of the Deposit service

The Deposit service will process deposits into bank accounts.  In this task, you will create the basic structure for this service and learn about the endpoints required for an LRA participant, what HTTP Methods they process, the annotations used to define them and so on.  You will implement the actual business logic in a later task.

1. Create the Deposit service and scaffold methods

   Create a new directory in `src/main/java/com/example/accounts` called `services` and in that directory create a new Java file called `DepositService.java`.  This will be a Spring Boot component where you will implement the deposit operations.  Since the LRA library we are using only works with JAX-RS, you will be using JAX-RS annotations in this service, as opposed to the Spring Boot "web" REST annotations that you used in the previous lab.  You can mix and match these styles in a single Spring Boot microservice application.

   Start by setting up endpoints and methods with the appropriate annotations.  You will implement the logic for each of these methods shortly.  Here is the class definition and all the imports you will need in this section, plus the logger and a constant `DEPOSIT` you will use later.  Notice that the class has the `@RequestScoped` annotation which tells Spring to create an instance of this class for each HTTP request (as opposed to for a whole session for example), the Spring Boot `@Component` annotation which marks this class as a bean that Spring can inject as a dependency when needed, and the `@Path` annotation to set the URL path for these endpoints.

    ```java
    <copy>package com.example.accounts.services;

    import java.util.logging.Logger;

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
    
    import com.example.accounts.model.Account;
    import com.example.accounts.model.Journal;

    @RequestScoped
    @Path("/deposit")
    @Component
    public class DepositService {
         private static final Logger log = Logger.getLogger(DepositService.class.getName());
         private final static String DEPOSIT = "DEPOSIT";
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

    import javax.ws.rs.core.Response;

    import org.eclipse.microprofile.lra.annotation.ParticipantStatus;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;
    import org.springframework.stereotype.Component;

    import com.example.accounts.model.Account;
    import com.example.accounts.model.Journal;
    import com.example.accounts.repository.AccountRepository;
    import com.example.accounts.repository.JournalRepository;

    @Component
    public class AccountTransferDAO {
        private final Logger log = LoggerFactory.getLogger(this.getClass());

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
        log.info("saveAccount account" + account.getAccountId() + " account" + account.getAccountBalance());
        accountRepository.save(account);
    }</copy>
    ```

   Create a method to return the correct HTTP Status Code for an LRA status.

    ```java
    <copy>public Response status(String lraId, String journalType) throws Exception {
        Journal journal = getJournalForLRAid(lraId, journalType);
        if (AccountTransferDAO.getStatusFromString(journal.getLraState()).equals(ParticipantStatus.Compensated)) {
            return Response.ok(ParticipantStatus.Compensated).build();
        } else { 
            return Response.ok(ParticipantStatus.Completed).build();
        }
    }</copy>
    ```

1. Create a method to update the LRA status in the journal

   Create a method to update the LRA status in the journal table during the "after LRA" phase.

    ```java
    <copy>public void afterLRA(String lraId, String status) throws Exception {
        Journal journal = getJournalForLRAid(lraId);
        journal.setLraState(status);
        journalRepository.save(journal);
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

   Update `AccountRepository.java` in `src/main/java/com/example/accounts/repositories` to add these extra JPA methods.  Your updated file should look like this: 

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
            journalRepository.save(
                new Journal(
                    "unknown", 
                    -1, 
                    0, 
                    lraId,
                    AccountTransferDAO.getStatusString(ParticipantStatus.FailedToComplete)
                )
            );
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

1. Implement the business logic for the **deposit** method.

   This method should write a journal entry for the deposit, but should not update the account balance.  Here is the code for this method:

    ```java
    <copy>@POST
    @Path("/deposit")
    @Produces(MediaType.APPLICATION_JSON)
    @LRA(value = LRA.Type.MANDATORY, end = false)
    public Response deposit(@HeaderParam(LRA_HTTP_CONTEXT_HEADER) String lraId,
                            @QueryParam("accountId") long accountId,
                            @QueryParam("amount") long depositAmount) {
        log.info("...deposit " + depositAmount + " in account:" + accountId +
                " (lraId:" + lraId + ") finished (in pending state)");
        Account account = AccountTransferDAO.instance().getAccountForAccountId(accountId);
        if (account == null) {
            log.info("deposit failed: account does not exist");
            AccountTransferDAO.instance().saveJournal(
                new Journal(
                    DEPOSIT, 
                    accountId, 
                    0, 
                    lraId,
                    AccountTransferDAO.getStatusString(ParticipantStatus.Active)
                )
            );
            return Response.ok("deposit failed: account does not exist").build();
        }
        AccountTransferDAO.instance().saveJournal(
            new Journal(
                DEPOSIT, 
                accountId, 
                depositAmount, 
                lraId,
                AccountTransferDAO.getStatusString(ParticipantStatus.Active)
            )
        );
        return Response.ok("deposit succeeded").build();
    }</copy>
    ```

1. Implement the **complete** method

  This method should update the LRA status to **completing**, update the account balance, change the bank transaction (journal entry) status from pending to complteted and the set the LRA status to **completed**.  Here is the code for this method: 

    ```java
    <copy>@PUT
    @Path("/complete")
    @Produces(MediaType.APPLICATION_JSON)
    @Complete
    public Response completeWork(@HeaderParam(LRA_HTTP_CONTEXT_HEADER) String lraId) throws Exception {
        log.info("deposit complete called for LRA : " + lraId);

        // get the journal and account...
        Journal journal = AccountTransferDAO.instance().getJournalForLRAid(lraId, DEPOSIT);
        Account account = AccountTransferDAO.instance().getAccountForJournal(journal);

        // set this LRA participant's status to completing...
        journal.setLraState(AccountTransferDAO.getStatusString(ParticipantStatus.Completing));
        
        // update the account balance and journal entry...
        account.setAccountBalance(account.getAccountBalance() + journal.getJournalAmount());
        AccountTransferDAO.instance().saveAccount(account);
        journal.setLraState(AccountTransferDAO.getStatusString(ParticipantStatus.Completed));
        AccountTransferDAO.instance().saveJournal(journal);
        
        // set this LRA participant's status to complete...
        return Response.ok(ParticipantStatus.Completed.name()).build();
    }</copy>
    ```  

1. Implement the **compensate** method

   This method should update both the deposit record in the journal and the LRA status to **compensated**.  Here is the code for this method:

    ```java
    <copy>
    @PUT
    @Path("/compensate")
    @Produces(MediaType.APPLICATION_JSON)
    @Compensate
    public Response compensateWork(@HeaderParam(LRA_HTTP_CONTEXT_HEADER) String lraId) throws Exception {
        log.info("deposit compensate called for LRA : " + lraId);
        Journal journal = AccountTransferDAO.instance().getJournalForLRAid(lraId, DEPOSIT);
        journal.setLraState(AccountTransferDAO.getStatusString(ParticipantStatus.Compensated));
        AccountTransferDAO.instance().saveJournal(journal);
        return Response.ok(ParticipantStatus.Compensated.name()).build();
    }
    </copy>
    ```

1. Implement the **status** method

   This method returns the LRA status.  Here is the code for this method: 

    ```java
    <copy>@GET
    @Path("/status")
    @Produces(MediaType.TEXT_PLAIN)
    @Status
    public Response status(@HeaderParam(LRA_HTTP_CONTEXT_HEADER) String lraId,
                           @HeaderParam(LRA_HTTP_PARENT_CONTEXT_HEADER) String parentLRA) throws Exception {
        return AccountTransferDAO.instance().status(lraId, DEPOSIT);
    }</copy>
    ```

1. Implement the **after LRA** method

   This method should perform any steps necessary to finalize or clean up after the LRA.  In this case, all you need to do is update the status of the deposit entry in the journal.  Here is the code for this method:

    ```java
    <copy> @PUT
    @Path("/after")
    @AfterLRA
    @Consumes(MediaType.TEXT_PLAIN)
    public Response afterLRA(@HeaderParam(LRA_HTTP_ENDED_CONTEXT_HEADER) String lraId, String status) throws Exception {
        log.info("After LRA Called : " + lraId);
        AccountTransferDAO.instance().afterLRA(lraId, status, DEPOSIT);
        return Response.ok().build();
    }</copy>
    ```

   That completes the implementation of the deposit service.

## Task 7: Create the Withdraw service

Next, you need to implement the withdraw service, which will be the second participant in the transfer LRA.

1. Implement the withdraw service

  Create a new Java file called `WithdrawService.java` in `src/main/java/com/example/accounts/services`.  This service is very similar to the deposit service, and no new concepts are introduced here.  Here is the code for this service:

    ```java
    <copy>package com.example.accounts.services;

    import static org.eclipse.microprofile.lra.annotation.ws.rs.LRA.LRA_HTTP_CONTEXT_HEADER;
    import static org.eclipse.microprofile.lra.annotation.ws.rs.LRA.LRA_HTTP_ENDED_CONTEXT_HEADER;
    import static org.eclipse.microprofile.lra.annotation.ws.rs.LRA.LRA_HTTP_PARENT_CONTEXT_HEADER;

    import java.util.logging.Logger;

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
    import org.eclipse.microprofile.lra.annotation.ParticipantStatus;
    import org.eclipse.microprofile.lra.annotation.Status;
    import org.eclipse.microprofile.lra.annotation.ws.rs.LRA;
    import org.springframework.stereotype.Component;

    import com.example.accounts.model.Account;
    import com.example.accounts.model.Journal;

    @RequestScoped
    @Path("/withdraw")
    @Component
    public class WithdrawService {
        private static final Logger log = Logger.getLogger(WithdrawService.class.getName());
        public static final String WITHDRAW = "WITHDRAW";

        /**
        * Reduce account balance by given amount and write journal entry re the same.
        * Both actions in same local tx
        */
        @POST
        @Path("/withdraw")
        @Produces(MediaType.APPLICATION_JSON)
        @LRA(value = LRA.Type.MANDATORY, end = false)
        public Response withdraw(@HeaderParam(LRA_HTTP_CONTEXT_HEADER) String lraId,
                @QueryParam("accountId") long accountId,
                @QueryParam("amount") long withdrawAmount) {
            log.info("withdraw " + withdrawAmount + " in account:" + accountId + " (lraId:" + lraId + ")...");
            Account account = AccountTransferDAO.instance().getAccountForAccountId(accountId);
            if (account == null) {
                log.info("withdraw failed: account does not exist");
                AccountTransferDAO.instance().saveJournal(
                        new Journal(
                                WITHDRAW,
                                accountId,
                                0,
                                lraId,
                                AccountTransferDAO.getStatusString(ParticipantStatus.Active)));
                return Response.ok("withdraw failed: account does not exist").build();
            }
            if (account.getAccountBalance() < withdrawAmount) {
                log.info("withdraw failed: insufficient funds");
                AccountTransferDAO.instance().saveJournal(
                        new Journal(
                                WITHDRAW,
                                accountId,
                                0,
                                lraId,
                                AccountTransferDAO.getStatusString(ParticipantStatus.Active)));
                return Response.ok("withdraw failed: insufficient funds").build();
            }
            log.info("withdraw current balance:" + account.getAccountBalance() +
                    " new balance:" + (account.getAccountBalance() - withdrawAmount));
            account.setAccountBalance(account.getAccountBalance() - withdrawAmount);
            AccountTransferDAO.instance().saveAccount(account);
            AccountTransferDAO.instance().saveJournal(
                    new Journal(
                            WITHDRAW,
                            accountId,
                            withdrawAmount,
                            lraId,
                            AccountTransferDAO.getStatusString(ParticipantStatus.Active)));
            return Response.ok("withdraw succeeded").build();
        }

        /**
        * Update LRA state. Do nothing else.
        */
        @PUT
        @Path("/complete")
        @Produces(MediaType.APPLICATION_JSON)
        @Complete
        public Response completeWork(@HeaderParam(LRA_HTTP_CONTEXT_HEADER) String lraId) throws Exception {
            log.info("withdraw complete called for LRA : " + lraId);
            Journal journal = AccountTransferDAO.instance().getJournalForLRAid(lraId, WITHDRAW);
            journal.setLraState(AccountTransferDAO.getStatusString(ParticipantStatus.Completed));
            AccountTransferDAO.instance().saveJournal(journal);
            return Response.ok(ParticipantStatus.Completed.name()).build();
        }

        /**
        * Read the journal and increase the balance by the previous withdraw amount
        * before the LRA
        */
        @PUT
        @Path("/compensate")
        @Produces(MediaType.APPLICATION_JSON)
        @Compensate
        public Response compensateWork(@HeaderParam(LRA_HTTP_CONTEXT_HEADER) String lraId) throws Exception {
            log.info("Account withdraw compensate() called for LRA : " + lraId);
            Journal journal = AccountTransferDAO.instance().getJournalForLRAid(lraId, WITHDRAW);
            journal.setLraState(AccountTransferDAO.getStatusString(ParticipantStatus.Compensating));
            Account account = AccountTransferDAO.instance().getAccountForAccountId(journal.getAccountId());
            if (account != null) {
                account.setAccountBalance(account.getAccountBalance() + journal.getJournalAmount());
                AccountTransferDAO.instance().saveAccount(account);
            }
            journal.setLraState(AccountTransferDAO.getStatusString(ParticipantStatus.Compensated));
            AccountTransferDAO.instance().saveJournal(journal);
            return Response.ok(ParticipantStatus.Compensated.name()).build();
        }

        @GET
        @Path("/status")
        @Produces(MediaType.TEXT_PLAIN)
        @Status
        public Response status(@HeaderParam(LRA_HTTP_CONTEXT_HEADER) String lraId,
                @HeaderParam(LRA_HTTP_PARENT_CONTEXT_HEADER) String parentLRA) throws Exception {
            return AccountTransferDAO.instance().status(lraId, WITHDRAW);
        }

        /**
        * Delete journal entry for LRA
        */
        @PUT
        @Path("/after")
        @AfterLRA
        @Consumes(MediaType.TEXT_PLAIN)
        public Response afterLRA(@HeaderParam(LRA_HTTP_ENDED_CONTEXT_HEADER) String lraId, String status) throws Exception {
            log.info("After LRA Called : " + lraId);
            AccountTransferDAO.instance().afterLRA(lraId, status, WITHDRAW);
            return Response.ok().build();
        }

    }</copy>
    ```  

1. TODO TODO TODO
 
   update the jersey config and create the appconfig class


## Task 8: Create the Transfer Service

Now, you will create another new Spring Boot microservice application and implement the Transfer Service.  This service will initiate the LRA and act as the logical coordinator - it will call the deposit and withdraw services you just implemented to effect the transfer to process the Cloud Cash Payment.

1. Create the project

  Create a new directory called `transfer` in your `cloudbank` directory, i.e. the same directory where your `accounts` project is located.  In this new `transfer` directory, create a new file called `pom.xml` for your Maven POM.  This project is similar to the accounts project, there are no new concepts introduced here.  Here is the content for the POM file: 

    ```xml
    <copy><?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <parent>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-parent</artifactId>
            <version>2.7.8</version>
            <relativePath/>
        </parent>
        <groupId>com.exmaple</groupId>

        <artifactId>transfer</artifactId>
        <version>1.0.0-SNAPSHOT</version>
        <name>transfer</name>
        <description>Transfer Service</description>

        <properties>
            <java.version>17</java.version>
            <spring-cloud.version>2021.0.5</spring-cloud.version>
            <oracle.jdbc.version>21.8.0.0</oracle.jdbc.version>
        </properties>

        <dependencies>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-web</artifactId>
            </dependency>
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
            <dependency>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
                <optional>true</optional>
            </dependency>
        </dependencies>

        <build>
            <finalName>${project.name}</finalName>
            <plugins>
                <plugin>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-maven-plugin</artifactId>
                </plugin>
            </plugins>
        </build>
    </project></copy>
    ```

1. Create the Spring Boot application configuration

   In the `transfer` project, create new directories `src/main/resources` and in that directory create a new file called `appliction.yaml`.  This will be the Spring Boot application configuration file.  In this file you need to configure the endpoints for the LRA participants and coordinator.

   TODO paul what is the mp.lra stuff for?  need to explain

    ```yaml
    <copy>
    server:
      port: 8080

    mp.lra:
      coordinator.url: http://otmm-tcs.otmm.svc.cluster.local:9000/api/v1/lra-coordinator
      propagation.active: true
      participant.url: http://localhost:8080
      coordinator.headers-propagation.prefix: ["x-b3-", "oracle-tmm-", "authorization", "refresh-"]

    deposit:
      account:
        service:
          url: http://account.application:8080/deposit
    withdraw:
      account:
        service:
          url: http://account.application:8080/withdraw

    lra:
      coordinator:
        url: http://otmm-tcs.otmm.svc.cluster.local:9000/api/v1/lra-coordinator
    </copy>
    ```   

1. Create the Spring Boot Application class

   Create a new directory called `src/main/java/com/example/transfer` and in that directory, create a new Java file called `TransferApplciation.java`.  This will be the main application file for the Spring Boot application.  This is a standard application class, there are no new concepts introduced.  Here is the content for this file: 

    ```java
    <copy>package com.example.transfer;

    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;

    @SpringBootApplication
    public class TransferApplication {

        public static void main(String[] args) {
            SpringApplication.run(TransferApplication.class, args);
        }
    }</copy>
    ```

1. Create the Application Configuration class

   The ApplicationConfig class reads configuration from `application.yaml` and injects the LRA client bean into the application.

   TODO paul - why doesn't it read the other config?   need to explain why this nrayana client fits in


    ```java
    <copy>package com.example.transfer;

    import io.narayana.lra.client.NarayanaLRAClient;
    import org.springframework.beans.factory.annotation.Value;
    import org.springframework.context.annotation.Bean;
    import org.springframework.context.annotation.Configuration;

    import java.net.URISyntaxException;
    import java.util.logging.Logger;

    @Configuration
    public class ApplicationConfig {
        private static final Logger log = Logger.getLogger(ApplicationConfig.class.getName());

        public ApplicationConfig(@Value("${lra.coordinator.url}") String lraCoordinatorUrl) {
            log.info(NarayanaLRAClient.LRA_COORDINATOR_URL_KEY + " = " + lraCoordinatorUrl);
            System.getProperties().setProperty(NarayanaLRAClient.LRA_COORDINATOR_URL_KEY, lraCoordinatorUrl);
        }

        @Bean
        public NarayanaLRAClient NarayanaLRAClient() throws URISyntaxException {
            return new NarayanaLRAClient();
        }

    }</copy>
    ```

1. Create the Jersey Config

   TODO 

    ```java
    <copy>package com.example.transfer;

    import io.narayana.lra.client.internal.proxy.nonjaxrs.LRAParticipantRegistry;
    import org.glassfish.hk2.utilities.binding.AbstractBinder;
    import org.glassfish.jersey.server.ResourceConfig;
    import org.glassfish.jersey.servlet.ServletProperties;
    import org.springframework.stereotype.Component;

    import javax.ws.rs.ApplicationPath;

    @Component
    @ApplicationPath("/")
    public class JerseyConfig extends ResourceConfig {

        public JerseyConfig()  {
            register(TransferService.class);
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

    }</copy>
    ```

1. Create the Transfer service

   TODO the thing

    ```java
    <copy>package com.example.transfer;

    import io.narayana.lra.Current;
    import org.eclipse.microprofile.lra.annotation.ws.rs.LRA;

    import javax.annotation.PostConstruct;
    import javax.enterprise.context.ApplicationScoped;

    import javax.ws.rs.*;
    import javax.ws.rs.client.ClientBuilder;
    import javax.ws.rs.client.Entity;
    import javax.ws.rs.client.WebTarget;
    import javax.ws.rs.container.ContainerRequestContext;
    import javax.ws.rs.core.Context;
    import javax.ws.rs.core.MediaType;
    import javax.ws.rs.core.Response;
    import javax.ws.rs.core.UriInfo;
    import java.net.URI;
    import java.net.URISyntaxException;
    import java.util.logging.Logger;

    import static org.eclipse.microprofile.lra.annotation.ws.rs.LRA.LRA_HTTP_CONTEXT_HEADER;

    @ApplicationScoped
    @Path("/")
    public class TransferService {

        private static final Logger log = Logger.getLogger(TransferService.class.getSimpleName());
        public static final String TRANSFER_ID = "TRANSFER_ID";
        private URI withdrawUri;
        private URI depositUri;
        private URI transferCancelUri;
        private URI transferConfirmUri;
        private URI transferProcessCancelUri;
        private URI transferProcessConfirmUri;
        @PostConstruct
        private void initController() {
            try { //todo get from config/env
                withdrawUri = new URI("http://account.application:8080/withdraw/withdraw");
                depositUri = new URI("http://account.application:8080/deposit/deposit");
                transferCancelUri = new URI("http://transfer.application:8080/cancel");
                transferConfirmUri = new URI("http://transfer.application:8080/confirm");
                transferProcessCancelUri = new URI("http://transfer.application:8080/processcancel");
                transferProcessConfirmUri = new URI("http://transfer.application:8080/processconfirm");
            } catch (URISyntaxException ex) {
                throw new IllegalStateException("Failed to initialize " + TransferService.class.getName(), ex);
            }
        }

        @POST
        @Path("/transfer")
        @Produces(MediaType.APPLICATION_JSON)
        @LRA(value = LRA.Type.REQUIRES_NEW, end = false)
        public Response transfer(@QueryParam("fromAccount") long fromAccount,
                                @QueryParam("toAccount") long toAccount,
                                @QueryParam("amount") long amount,
                                @Context UriInfo uriInfo,
                                @HeaderParam(LRA_HTTP_CONTEXT_HEADER) String lraId,
                                @Context ContainerRequestContext containerRequestContext)
        {
            if (lraId == null) {
                return Response.serverError().entity("Failed to create LRA").build();
            }
            log.info("Started new LRA/transfer Id: " + lraId);
            boolean isCompensate = false;
            String returnString = "";
            returnString += withdraw(fromAccount, amount);
            log.info(returnString);
            if (returnString.contains("succeeded")) {
                returnString += " " + deposit(toAccount, amount);
                log.info(returnString);
                if (returnString.contains("failed")) isCompensate = true; //deposit failed
            } else isCompensate = true; //withdraw failed
            log.info("LRA/transfer action will be " + (isCompensate?"cancel":"confirm"));
            WebTarget webTarget = ClientBuilder.newClient().target(isCompensate?transferCancelUri:transferConfirmUri);
            webTarget.request().header(TRANSFER_ID, lraId)
                    .post(Entity.text("")).readEntity(String.class);
            return Response.ok("transfer status:" + returnString).build();

        }

        private String withdraw(long accountId, long amount) {
            log.info("withdraw accountId = " + accountId + ", amount = " + amount);
            WebTarget webTarget =
                    ClientBuilder.newClient().target(withdrawUri).path("/")
                            .queryParam("accountId", accountId)
                            .queryParam("amount", amount);
            URI lraId = Current.peek();
            log.info("withdraw lraId = " + lraId);
            String withdrawOutcome =
                    webTarget.request().header(LRA_HTTP_CONTEXT_HEADER,lraId)
                            .post(Entity.text("")).readEntity(String.class);
            return withdrawOutcome;
        }
        private String deposit(long accountId, long amount) {
            log.info("deposit accountId = " + accountId + ", amount = " + amount);
            WebTarget webTarget =
                    ClientBuilder.newClient().target(depositUri).path("/")
                            .queryParam("accountId", accountId)
                            .queryParam("amount", amount);
            URI lraId = Current.peek();
            log.info("deposit lraId = " + lraId);
            String depositOutcome =
                    webTarget.request().header(LRA_HTTP_CONTEXT_HEADER,lraId)
                            .post(Entity.text("")).readEntity(String.class);;
            return depositOutcome;
        }




        @POST
        @Path("/processconfirm")
        @Produces(MediaType.APPLICATION_JSON)
        @LRA(value = LRA.Type.MANDATORY)
        public Response processconfirm(@HeaderParam(LRA_HTTP_CONTEXT_HEADER) String lraId) throws NotFoundException {
            log.info("Process confirm for transfer : " + lraId);
            return Response.ok().build();
        }

        @POST
        @Path("/processcancel")
        @Produces(MediaType.APPLICATION_JSON)
        @LRA(value = LRA.Type.MANDATORY, cancelOn = Response.Status.OK)
        public Response processcancel(@HeaderParam(LRA_HTTP_CONTEXT_HEADER) String lraId) throws NotFoundException {
            log.info("Process cancel for transfer : " + lraId);
            return Response.ok().build();
        }


        // The following two methods could be in an external client.
        // They are included here for convenience.
        // The transfer method makes a Rest call to confirm or commit.
        // The confirm or commit method suspends the LRA (via NOT_SUPPORTED)
        // The confirm or commit method then proceeds to make a Rest call to the "processconfirm" or "processcommit" method
        // The "processconfirm" and "processcommit" methods import the LRA (via MANDATORY)
        //  and end the LRA implicitly accordingly upon return.
        @POST
        @Path("/confirm")
        @Produces(MediaType.APPLICATION_JSON)
        @LRA(value = LRA.Type.NOT_SUPPORTED)
        public Response confirm(@HeaderParam(TRANSFER_ID) String transferId) throws NotFoundException {
            log.info("Received confirm for transfer : " + transferId);
            String confirmOutcome =
                    ClientBuilder.newClient().target(transferProcessConfirmUri).request()
                            .header(LRA_HTTP_CONTEXT_HEADER, transferId)
                            .post(Entity.text("")).readEntity(String.class);
            return Response.ok(confirmOutcome).build();
        }

        @POST
        @Path("/cancel")
        @Produces(MediaType.APPLICATION_JSON)
        @LRA(value = LRA.Type.NOT_SUPPORTED, cancelOn = Response.Status.OK)
        public Response cancel(@HeaderParam(TRANSFER_ID) String transferId) throws NotFoundException {
            log.info("Received cancel for transfer : " + transferId);
            String confirmOutcome =
                    ClientBuilder.newClient().target(transferProcessCancelUri).request()
                            .header(LRA_HTTP_CONTEXT_HEADER, transferId)
                            .post(Entity.text("")).readEntity(String.class);
            return Response.ok(confirmOutcome).build();
        }

    }</copy>
    ```

1. TODO TODO TODO 

   build it 


## Task 9: Deploy the Account and Transfer services to the backend

TODO that

1.  TODO this

   this and that


## Task 10: Run LRA test cases

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
