# Construct a graph using the collected data

## Introduction

In this lab, we will create the graph model from the data extracted from the previous labs for which tables and the affinity between the tables are calculated.

Estimated Time: 15 minutes

### Objectives

In this lab :

* Using Graph Studio, we create a model and the graph from the tables created in Lab 2

### Prerequisites (Optional)

This lab assumes you have the following:

* An Oracle account
* This lab requires an Autonomous Database - Shared Infrastructure or Autonomous Transaction Processing - Shared Infrastructure account.

## Task 1: Connect to your Autonomous Database using Graph Studio

1. If you have the Graph Studio URL, proceed to step 4.

    Log in to the Oracle Cloud Console, choose the Autonomous Database instance, then Click the **Tools** tab on the details page menu on the left.

   ![Oracle Cloud Console](./images/adw-console-tools-tab.png)

2. Click the **Open Graph Studio** card to open a new page or tab in your browser.

   If your tenancy administrator provided you with the Graph Studio URL to connect directly, then use that instead.

3. Enter your Autonomous Database account credentials (for example, `TKDRADATA`) into the login screen:

    ![Oracle Graph Studio Login](./images/graphstudio-login-graphuser1.png " ")

4. Then click the **Sign In** button. You should see the studio home page.

    ![Oracle Graph Studio Home Page](./images/gs-graphuser-home-page1.png " ")

## Task 2: Create a graph of nodes and edges from the corresponding tables

1. Click the **Models** icon to navigate to the start of the modeling workflow.  
   Then click **Create**.  
   ![Model Create Button](images/modeler-create-button1.png " ")  

   >**Note: If you click on the `Start Modeling` button instead, you'll see the screen shown in the next step.**

2. Then select the `NODES` and `EDGES` tables.
   ![Select tables to create graph](./images/select-tables1.png " ")

3. Move them to the right i,e., click the first icon on the shuttle control.

   ![Selected tables for graph creation](./images/selected-tables1.png " ")

   Select Graph Type as `PG Objects` and Click **Next** to get a suggested model. We will edit and update this model to add an edge and a vertex label.  

   The suggested model has the `NODES` as a vertex table since foreign key constraints are specified on `EDGES` that reference it.

   And `EDGES` is a suggested edge table.

   ![Select Edge table to see details](./images/create-graph-suggested-model1.png " ")
  
4. Since these are directed edges, a best practice is verifying that the direction is correct.  
    In this instance, we want to **confirm** that the direction is from `table1` to `table2`.  

    Note the `Source Vertex` and `Destination Vertex` information on the left.  

    ![Change the edge directions](images/wrong-edge-direction1.png " ")  

    **Notice** that the direction is wrong. The Source Key is `table2` instead of what we want, which is `table1`.  

    Click the swap edge icon on the right to swap the source and destination vertices and reverse the edge direction.  

   Note that the `Source Vertex` is now the correct one, i.e., the `TABLE1`.

   ![Reversed edge directions](images/reverse-edge-result1.png " ")

5. Click the **Source** tab to verify that the edge direction, and hence the generated CREATE PROPERTY GRAPH statement, is correct.

   ![Source of graph properties](images/generated-cpg-statement1.png " ")  
  
6. Click **Next** and then click **Create Graph** to move on to the next step in the flow.

   Enter `DRA_MEDICAL_RECS_G` as the graph name.  
   The above graph name will be used throughout the labs.  
   Do not enter a different name because the queries and code snippets in the next lab will fail.  

   Enter a model name (for example, `DRA_MEDICAL_RECS_M`) and other optional information.  
   ![Create graph dialog](./images/create-graph-dialog1.png " ")

7. Graph Studio modeler will now save the metadata and start a job to create the graph.  
   The Jobs page shows the status of this job.

   ![Jobs list page](./images/23-jobs-create-graph1.png " ")  

Once this has been completed, you are ready to **proceed to the next lab**.

## Acknowledgements

* **Author** - Praveen Hiremath, Developer Advocate
* **Contributors** -  Praveen Hiremath, Developer Advocate
* **Last Updated By/Date** - Praveen Hiremath, Developer Advocate, October 2022
