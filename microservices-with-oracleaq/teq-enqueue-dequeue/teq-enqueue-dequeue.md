# Understand Transactional Event Queues(TxEventQ)

## Introduction

Transactional Event Queues(TxEventQ) samples to create queues using different payloads, Enqueue, dequeue, and cleanups using PL/SQL.

- Estimated Time: 10 minutes

### Objectives

- Create Transactional Event Queue
- Enqueue Transactional Event Queue
- Dequeue Transactional Event Queue

### Prerequisites

- This workshop assumes you have an Oracle cloud account and configured setup in Lab 1.

## Task 1: Create TxEventQ

1. Below are the code samples to create TxEventQ

    ![teqCreate](./images/create-teq.png " ")

    - Multi-consumer TxEventQ with Payload as RAW using PL/SQL.

    - Multi-Consumer TxEventQ with Payload as Object Type using PL/SQL.

    - Multi-Consumer TxEventQ with Payload as JSON Type using PL/SQL.

2. Execute the following sequence of commands into cloud shell

    ```bash
    <copy>cd $ORACLEAQ_PLSQL_TxEventQ; source createTxEventQ.sh;
    </copy>
    ```

## Task 2: Enqueue in TxEventQ

1. Below are the code samples to enqueue TxEventQ

    ![enqueueTEQ](./images/enqueue-teq.png " ")

    - Enqueue for multi-consumer TxEventQ with Payload as RAW using PL/SQL.

    - Enqueue for multi-Consumer TxEventQ with Payload as Object Type using PL/SQL.

    - Enqueue for multi-Consumer TxEventQ with Payload as JSON Type using PL/SQL.

1. Execute the following sequence of commands into cloud shell

    ```bash
    <copy>cd $ORACLEAQ_PLSQL_TxEventQ; source enqueueTxEventQ.sh;
    </copy>
    ```

## Task 3: Dequeue in TxEventQ

1. Below are the code samples to dequque TxEventQ

    ![dequeueTEQ](./images/dequeue-teq.png " ")

    - Enqueue for multi-consumer TxEventQ with Payload as RAW using PL/SQL.

    - Enqueue for multi-Consumer TxEventQ with Payload as Object Type using PL/SQL.

    - Enqueue for multi-Consumer TxEventQ with Payload as JSON Type using PL/SQL.

2. Execute the following sequence of commands into cloud shell

    ```bash
    <copy>cd $ORACLEAQ_PLSQL_TxEventQ; source dequeueTxEventQ.sh;
    </copy>
    ```

## Task 4: TxEventQ Enqueue and Dequeue using Java

1. Execute the following sequence of commands into cloud shell

    ```bash
    <copy> curl http://localhost:8081/oracleAQ/pubSubTxEventQ | jq </copy>
    ```

    You can view the source code for this lab [here.](https://github.com/oracle/microservices-datadriven/tree/main/workshops/oracleAQ/qJava/src/main/java/com/examples/enqueueDequeueTxEventQ/EnqueueDequeueTxEventQ.java)

## Task 5: Drop TxEventQ

1. Below are the code samples to cleanup TxEventQ

    ![cleanupTEQ](./images/cleanup-teq.png " ")

    - Stop classic Queues

    - Drop classic Queues

2. Execute the following sequence of commands into cloud shell

    ```bash
    <copy>cd $ORACLEAQ_PLSQL_TxEventQ; source cleanupTxEventQ.sh;
    </copy>
    ```

 You may now **proceed to the next lab.**

## Acknowledgements

- **Author** - Mayank Tayal, Developer Advocate
- **Contributors** - Shivani Karnewar, Senior Member Technical Staff
- **Last Updated By/Date** - Mayank Tayal, March 2023
