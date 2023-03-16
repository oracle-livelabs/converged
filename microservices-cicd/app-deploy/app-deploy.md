# Deploy and Test Data-centric Microservices Application

## Introduction

This lab will show you how to deploy the microservices on your Kubernetes cluster, walk through the functionality and explain how it works.

Estimated Time:  10 minutes

Quick walk through on how to deploy the microservices on your Kubernetes cluster.

[](youtube:8gMmjbXSR68)

### Objectives

* Deploy and access the microservices
* Learn how they work

### Prerequisites

* The OKE cluster and the Autonomous Transaction Processing databases that you created in Lab 1

## Task 1: Deploy all the microservices and the FrontEnd UI

1. Run the deploy script. This will create the deployment and pod for all the java images in the OKE cluster `msdataworkshop` namespace:

    ```bash
    <copy>cd $GRABDISH_HOME;./deploy.sh</copy>
    ```

   ![Deploy All](images/deploy-all.png " ")

2. Once successfully created, check that the services are running:

    ```bash
    <copy>kubectl get pods --all-namespaces</copy>
    ```

    ![Pods All After Deploy](images/pods-all-after-deploy.png " ")

    Or, you can execute the `pods` shortcut command.

3. Check that the **ingress-nginx-controller** load balancer service is running, and write down the external IP address.

    ```bash
    <copy>kubectl get services --all-namespaces</copy>
    ```

    ![Ingress](images/ingress-nginx-loadbalancer-externalip.png " ")

  Or, you can execute the `services` shortcut command.

## Task 2: Access the FrontEnd UI

1. Open a new browser tab and enter the external IP URL:

    `https://<EXTERNAL-IP>`

2. Note that for convenience a self-signed certificate is used to secure this https address and so it is likely you will be prompted by the browser to allow access.

3. You will be prompted to authenticate to access the Front End microservices. The user is `grabdish` and the password is the one you entered in Lab 1.

    ![FrontEnd](images/frontend-auth-login.png " ")

4. You should then see the Front End home page. You've now accessed your first microservice of the lab!

    ![UI Home Page](images/ui-home-page.png " ")

## Task 3: Verify the Order and Inventory functionality of GrabDish store

1. Click **Transactional** under **Labs**.

    ![Tx Select](images/tx-select.png " ")

2. Check the inventory of a given item such as sushi, by typing `sushi`
    in the `food` field and clicking **Get Inventory**. You should see the inventory
    count result 0.

   ![Get Inventory](images/tx-get-inventory.png " ")

3. (Optional) If for any reason you see a different count, click **Remove Inventory** to bring back the count to 0.

4. Let’s try to place an order for sushi by clicking **Place Order**.

   ![Place Order](images/tx-place-order-66.png " ")

5. To check the status of the order, click **Show Order**. You should see a failed
    order status.

   ![Show Order](images/tx-show-order-66.png " ")

   This is expected, because the inventory count for sushi was 0.

6. Click **Add Inventory** to add the sushi in the inventory. You
    should see the outcome being an incremental increase by 1.

   ![Add Inventory](images/tx-add-inventory.png " ")

7. Go ahead and place another order by increasing the order ID by 1 (67) and then clicking **Place Order**. Next click **Show Order** to check the order status.

   ![Place Order](images/tx-place-order-67.png " ")

   ![Show Order](images/tx-show-order-67.png " ")

   The order should have been successfully placed, which is shown by the order status showing success.

 You may now **proceed to the next lab.**

## Acknowledgements

* **Authors** - Irina Granat, Consulting Member of Technical Staff, Oracle MAA and Exadata; Paul Parkinson, Developer Evangelist; Richard Exley, Consulting Member of Technical Staff, Oracle MAA and Exadata
* **Last Updated By/Date** - Irina Granat, June 2022
