# Use workflow with TxEventQ (Second-factor Authentication)

## Introduction

This workflow relies on a secure and verified delivery from an Application to the User. The Application will share a secure four-digit OTP with the User; the User will share 4-digit OTP to the Deliverer. The Deliverer will verify the User's identity with the help of OTP and hand over the order to the User.

- Estimated Time: 15 minutes

### Objectives

This Lab will help you understand OTP workflow (one-time-password)/ Second-Factor Authentication/ 2FA based on order delivery with multiconsumer TxEventQ.

![workflow](./images/workflow.png " ")

### Prerequisites

- This workshop assumes you have an Oracle cloud account and configured setup in Lab 1.

## Task 1: Create queues

1. Below are the code samples to create required queues

    ![createWoekflow queues](./images/workflow-create-teq.png " ")

2. Execute the following sequence of commands into cloud shell:

    ```bash

    <copy>cd $ORACLEAQ_PLSQL_TxEventQ; source workflowCreateTxEventQ.sh;

    </copy>

    ```

## Task 2: The user places the order, and the Application generates a 4-digit OTP

Below are the code samples to create the workflow

  ![workflowTxEventQ](./images/workflow-teq.png " ")

  1. User places an order

      - Message(OrderId, username,  0   , deliveryLocation, "PENDING")

  2. Application accepts the order; Application updates the OTP and share OTP as four-digit unique/one-time pin to User.

      - Message(OrderId, username, 9707 , deliveryLocation, "PENDING")

  3. Application adds the order details in records Table.

      - Message(OrderId, username, 9707 , deliveryLocation, "PENDING")

  4. Application shares order details to Deliverer with OTP as 0.

      - Message(OrderId, username,   0  , deliveryLocation, "PENDING")

## Task 3: Deliverer meets User

  1. User shares OTP to Deliverer.

      - Message(OrderId, username, 9707 , deliveryLocation, "PENDING")

  2. Deliverer requests Application to validate user's OTP.

      - Message(OrderId, username, 9707 , deliveryLocation, "PENDING")

## Task 4: OTP verfication

- **Application verfication for OTP is successful:**

    1. Application updates DELIVERY STATUS as "DELIVERED" in the exiting record.

    2. Application shares the DELIVERY STATUS as "DELIVERED" to Deliverer.

        - Message(OrderId, username, 9707 , deliveryLocation, "DELIVERED")

    3. Application shares the DELIVERY STATUS as "DELIVERED" to User.

        - Message(OrderId, username, 9707 , deliveryLocation, "DELIVERED")

    4. Deliverer handover the order to User.

- **Application verfication for OTP is failed:**

    1. Application updates DELIVERY STATUS as "FAILED" in the Database.

    2. Application shares the DELIVERY STATUS as "FAILED" to Deliverer.

        - Message(OrderId, username, 9707 , deliveryLocation, "FAILED")

    3. Application shares the DELIVERY STATUS as "FAILED" to User.

        - Message(OrderId, username, 9707 , deliveryLocation, "FAILED")

    4. Deliverer declines delivery to User.

- Execute the following sequence of commands into cloud shell:

    ```bash

    <copy>cd $ORACLEAQ_PLSQL_TxEventQ; source workflowEnqueueDequeueTxEventQ.sh;

    </copy>

    ```

     You can view the source code for this lab [here.](https://github.com/oracle/microservices-datadriven/tree/main/workshops/oracleAQ)

## Task 5: Workflow using Java

1. Execute the following sequence of commands into cloud shell:

    ```bash

    <copy> curl http://localhost:8081/oracleAQ/workflowTxEventQ | jq </copy>

    ```

    You can view the java source code for this lab [here.](https://github.com/oracle/microservices-datadriven/tree/main/workshops/oracleAQ/qJava/src/main/java/com/examples/workflowTxEventQ/WorkflowTxEventQ.java)

## Task 6: Drop queues

1. Below are the code samples to cleanup workflow Queues

    ![cleanupWorkflow](./images/workflow-cleanup-teq.png " ")

    - Stop User, Deliverer, Application Queues

    - Drop User, Deliverer, Application Queues

2. Execute the following sequence of commands into cloud shell:

    ```bash

    <copy>cd $ORACLEAQ_PLSQL_TxEventQ; source workflowCleanupTxEventQ.sh;

    </copy>

    ```

You may now **proceed to the next lab.**

## Acknowledgements

- **Author** - Mayank Tayal, Developer Advocate
- **Contributors** - Shivani Karnewar, Senior Member Technical Staff
- **Last Updated By/Date** - Mayank Tayal, March 2023
