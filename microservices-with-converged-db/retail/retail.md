# Simplify Microservices with Oracle AI Database - Retail (GrabDish)

## Introduction

This lab walks you through the setup and deployment of a microservices-based retail application (GrabDish) using Oracle Kubernetes Engine (OKE) and Oracle Autonomous Database (ADB). You'll deploy multiple microservices and configure them to work together.

If you are interested in other features, such as MongoDB API, Kafka API, MicroTx and Lock-free Reservations, Agentic AI, MCP, Vector Search, and Select AI/NL2SQL, see the next lab where a microservices-based financial application  

### Objectives

In this lab, you will:
- Create and configure Oracle Kubernetes Engine (OKE) and Autonomous Database (ADB)
- Clone and deploy the retail application source code
- Set up and deploy frontend, supplier, order, and inventory microservices
- Configure database secrets in Kubernetes
- Verify the application deployment and functionality

### Prerequisites

This lab assumes you have:
- Completed the setup lab
- Access to Oracle Cloud Infrastructure (OCI)
- kubectl installed and configured
- Basic familiarity with Kubernetes and microservices architecture

## Task 1: Create OKE and ADB

1. Create an Oracle Kubernetes Engine (OKE) cluster in your OCI tenancy.

2. Create an Autonomous Database (ADB) instance.

## Task 2: Clone the Source Code

1. Clone the retail application repository:

    ```bash
    <copy>
    git clone https://github.com/paulparkinson/oracle-ai-for-sustainable-dev
    </copy>
    ```

2. Create the Kubernetes namespace:

    ```bash
    <copy>
    kubectl create ns msdataworkshop
    </copy>
    ```

## Task 3: Setup Frontend Microservice

1. Apply the frontend admin secret:

    ```bash
    <copy>
    applyFrontendAdminSecret.sh
    </copy>
    ```

2. Apply the frontend Helidon deployment:

    ```bash
    <copy>
    kubectl apply -f frontend-helidon-deployment.yaml -n msdataworkshop
    </copy>
    ```

3. Create the frontend apply secret:

    ```bash
    <copy>
    createOsApplyIssSecret.sh
    </copy>
    ```

4. Apply the frontend service YAML:

    ```bash
    <copy>
    kubectl apply -f frontend-service.yaml -n msdataworkshop
    </copy>
    ```

5. Apply the frontend service YAML:

    ```bash
    <copy>
    kubectl apply -f frontend-service-monitor.yaml -n msdataworkshop
    </copy>
    ```

6. Get the services to obtain the IP address:

    ```bash
    <copy>
    kubectl get services -n msdataworkshop
    </copy>
    ```

    Note the external IP address and try it out.

7. You can also try the spatial operations in the **Transactional** tab.

## Task 4: Do Database Setup

All scripts are in the `sql` directory.

1. Login as admin and run:

    ```bash
    <copy>
    createusers.sql
    </copy>
    ```

    and

    ```bash
    <copy>
    createQueues.sql
    </copy>
    ```

2. Login as inventoryuser and run:

    ```bash
    <copy>
    inventoryTable.sql
    </copy>
    ```

3. Login as orderuser and run:

    ```bash
    <copy>
    orderCollection.sql
    </copy>
    ```

## Task 5: Setup Database Secrets in Kubernetes

1. Run the script:

    ```bash
    <copy>
    run setupDataSourcesInsecret.sh
    </copy>
    ```

    Use the suggested example values in the prompt (e.g., grabdish-wallet and msdataworkshop), and the directory location of the wallet.

2. Apply the secret from wallet:

    ```bash
    <copy>
    applySecretFromWallet.sh
    </copy>
    ```

## Task 6: Setup Supplier Microservice

1. Change to the supplier Helidon directory:

    ```bash
    <copy>
    cd supplier-helidon-se
    </copy>
    ```

2. Apply the supplier Helidon deployment template YAML:

    ```bash
    <copy>
    cp kubectl apply -f supplier-helidon-se-deployment_template.yaml supplier-helidon-se-deployment.yaml
    </copy>
    ```

3. Modify the URL in the yaml to use your database servicename instead of `financialdb_high`.

4. Apply the supplier deployment:

    ```bash
    <copy>
    kubectl apply -f supplier-helidon-se-deployment.yaml -n msdataworkshop
    </copy>
    ```

5. Apply the supplier service YAML:

    ```bash
    <copy>
    kubectl apply -f supplier-helidon-se-service.yaml -n msdataworkshop
    </copy>
    ```

6. You should be able to get, add, and remove inventory on the **Transactional** tab.

## Task 7: Setup Order Microservice

1. Change to the order Helidon directory:

    ```bash
    <copy>
    cd order-helidon
    </copy>
    ```

2. Apply the order deployment template:

    ```bash
    <copy>
    cp order-helidon-deployment_template.yaml order-helidon-deploy.yaml
    </copy>
    ```

3. Modify the URL in the yaml to use your database servicename instead of `financialdb_high`.

4. Apply the order deployment:

    ```bash
    <copy>
    kubectl apply -f order-helidon-deployment.yaml -n msdataworkshop
    </copy>
    ```

5. Apply the order service YAML:

    ```bash
    <copy>
    kubectl apply -f order-service.yaml -n msdataworkshop
    </copy>
    ```

6. Apply the order service monitor YAML:

    ```bash
    <copy>
    kubectl apply -f order-service-monitor.yaml -n msdataworkshop
    </copy>
    ```

## Task 8: Setup Inventory Microservice

1. Change to the inventory Helidon directory:

    ```bash
    <copy>
    cd inventory-helidon
    </copy>
    ```

2. Apply the inventory deployment template:

    ```bash
    <copy>
    cp inventory-helidon-deployment_template.yaml inventory-helidon-deploy.yaml
    </copy>
    ```

3. Modify the URL in the yaml to use your database servicename instead of `financialdb_high`.

4. Apply the inventory deployment:

    ```bash
    <copy>
    kubectl apply -f inventory-helidon-deployment.yaml -n msdataworkshop
    </copy>
    ```

5. Apply the inventory service YAML:

    ```bash
    <copy>
    kubectl apply -f inventory-service.yaml -n msdataworkshop
    </copy>
    ```

6. Apply the inventory service monitor YAML:

    ```bash
    <copy>
    kubectl apply -f inventory-service-monitor.yaml -n msdataworkshop
    </copy>
    ```

7. You should now be able to place and show orders.

## Acknowledgements
* **Author** - Paul Parkinson, Architect and Developer Advocate
* **Last Updated By/Date** - Paul Parkinson, 2025

