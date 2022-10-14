# Construct a graph using the collected data

## Introduction

In this lab, we will create the graph model from the data which are extracted from the previous labs for which tables and the affinity the between the tables are calculated.

Estimated Lab Time: 15 minutes

### Objectives

In this lab :
- Using the Graph Studio, we create a model and the graph from the tables created in Lab 2


### Prerequisites (Optional)

This lab assumes you have:
* An Oracle account
* This lab requires an Autonomous Database - Shared Infrastructure or Autonomous Transaction Processing - Shared Infrastructure account.

## Task 1: Connect to the Database Actions for your Autonomous Database instance


1. Open the service detail page for your Autonomous Database instance in the OCI console.  

   Then click the **Database Actions** link to open it. 
   
   ![ALT text is not available for this image](images/create-user/open-database-actions.png " ")

## Task 2: Create the web access and graph-enabled user

This Task 2 is optional as we have already created the new user 'TKDRADATA' during the setup. Do this only if you want to create new user other than 'TKDRADATA'. 

1. Login as the ADMIN user for your Autonomous Database instance. 

    ![ALT text is not available for this image](./images/create-user/login.png " ")

2. Click  the **DATABASE USERS** tile under **Administration**. 
   
   ![ALT text is not available for this image](./images/create-user/db-actions-users.png " ")
   
3. Click the **+ Create User** icon.

    ![ALT text is not available for this image](./images/create-user/db-actions-create-user.png " ")

4. Enter the required details, i.e. user name and password. Turn on the **Graph Enable** and **Web Access** radio buttons. And select a quota, e.g. **UMLIMITED**,  to allocate on the `DATA` tablespace.   

   Note: The password should meet the following requirements:

   - The password must be between 12 and 30 characters long and must include at least one uppercase letter, one lowercase letter, and one numeric character.
   - The password cannot contain the username.
   - The password cannot contain the double quote (“) character.
   - The password must be different from the last 4 passwords used for this user.
   - The password must not be the same password that is set less than 24 hours ago.
   
   ![ALT text is not available for this image](images/create-user/db-actions-create-graph-user.png " ")

   **Note: Please do not Graph Enable the ADMIN user and do not login to Graph Studio as the ADMIN user. The ADMIN user has additional privileges by default. Create and use an account with only the necessary privileges for with with graph data and analytics.**

   Click the **Create User** button at the bottom of the panel to create the user with the specified credentials.

   The newly created user will now be listed.

   ![ALT text is not available for this image](./images/create-user/db-actions-user-created.png " ")   

## Task 3: Connect to your Autonomous Database using Graph Studio

1. If you have the Graph Studio URL then proceed to step 4. 

    Log in to the Oracle Cloud Console, choose the Autonomous Database instance, then Click the **Tools** tab on the details page menu on the left. 

   ![Oracle Cloud Console](./images/adw-console-tools-tab.png)


2. Click the **Open Graph Studio** card to open in a new page or tab in your browser.   
   
   If your tenancy administrator provided you the Graph Studio URL to connect directly then use that instead.


3. Enter your Autonomous Database account credentials (for example, `GRAPHUSER`) into the login screen:
 
    ![ALT text is not available for this image](./images/graphstudio-login-graphuser1.png " ")

4. Then click the **Sign In** button. You should see the studio home page.   

    ![ALT text is not available for this image](./images/gs-graphuser-home-page1.png " ") 
	
## Task 4: Create a graph of accounts and transactions from the corresponding tables

1. Click the **Models** icon to navigate to the start of the modeling workflow.  
   Then click **Create**.  
   ![ALT text is not available for this image](images/modeler-create-button1.png " ")  

   >**Note: If you clicked on `Start Modeling` button instead then you'll see the screen shown in the next step.**

2. Then select the `NODES` and `EDGES` tables.   
![ALT text is not available for this image](./images/select-tables1.png " ")

3. Move them to the right, that is, click the first icon on the shuttle control.   

   ![ALT text is not available for this image](./images/selected-tables1.png " ")

4.  Click **Next** to get a suggested model. We will edit and update this model to add an edge and a vertex label.  

    The suggested model has the `NODES` as a vertex table since there are foreign key constraints specified on `EDGES` that reference it.   

    And `EDGES` is a suggested edge table.

  ![ALT text is not available for this image](./images/create-graph-suggested-model1.png " ")    
  

5.  Since these are directed edges, a best practice is verifying that the direction is correct.  
    In this instance we want to **confirm** that the direction is from `table1` to `table2`.  

    Note the `Source Vertex` and `Destination Vertex` information on the left.  
 
    ![ALT text is not available for this image](images/wrong-edge-direction1.png " ")  

    **Notice** that the direction is wrong. The Source Key is `table2` instead of what we want, which is `table1`.  

    Click the swap edge icon on the right to swap the source and destination vertices and hence reverse the edge direction.  

   Note that the `Source Vertex` is now the correct one, i.e. the `TABLE1`.

   ![ALT text is not available for this image](images/reverse-edge-result1.png " ") 


   

6. Click the **Source** tab to verify that the edge direction, and hence the generated CREATE PROPERTY GRAPH statement, is correct.


   ![ALT text is not available for this image](images/generated-cpg-statement1.png " ")  
  
<!--- 
  **An alternate approach:** In the earlier Step 5 you could have just updated the CREATE PROPERTY GRAPH statement and saved the updates. That is, you could have just replaced the existing statement with the following one which specifies that the SOURCE KEY is  `table1`  and the DESTINATION KEY is `table2`.  

    ```
    -- This is not required if you used swap edge in UI to fix the edge direction.
    -- This is only to illustrate an alternate approach.
    <copy>
    CREATE PROPERTY GRAPH draft_1665739872150
	  VERTEX TABLES (
		tkdradata.nodes
		  KEY ( table_name )
		  PROPERTIES ( schema, tables_joined, table_id, table_name, table_set_name, total_executions, total_sql )
	  )
	  EDGE TABLES (
		tkdradata.edges
		  SOURCE KEY ( table1 ) REFERENCES nodes
		  DESTINATION KEY ( table2 ) REFERENCES nodes
		  PROPERTIES ( dynamic_coefficient, join_count, join_executions, static_coefficient, table1, table2, table_map_id, table_set_name, total_affinity, total_affinity_modified )
	  )
    </copy>
    ```

   ![ALT text is not available for this image](images/correct-ddl-save.png " " )  

   **Important:** Click the **Save** (floppy disk icon) to commit the changes.
--->

8. Click **Next** and then click **Create Graph** to move on to the next step in the flow.   

   Enter `DRA_MEDICAL_RECS_G` as the graph name.  
   That graph name is used throughout the next lab.  
   Do not enter a different name because then the queries and code snippets in the next lab will fail.  
   
   Enter a model name (for example, `DRA_MEDICAL_RECS_M`), and other optional information.  
   ![ALT text is not available for this image](./images/create-graph-dialog1.png " ")

9. Graph Studio modeler will now save the metadata and start a job to create the graph.  
   The Jobs page shows the status of this job. 

   ![ALT text is not available for this image](./images/23-jobs-create-graph1.png " ")  

   You can then interactively query and visualize the graph in a notebook after it's loaded into memory.


Please **proceed to the next lab** to do so.

## Acknowledgements
* **Author** - Praveen Hiremath, Developer Advocate
* **Contributors** -  Praveen Hiremath, Developer Advocate
* **Last Updated By/Date** - Praveen Hiremath, Developer Advocate, October 2022 

## Learn More


