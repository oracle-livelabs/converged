# Run community detection on medical records

## Introduction

Go through this lab only if you want to run community detection on the medical records data which is loaded in Lab 3, Task 3. In this lab, we run the community detection algorithm on the graphs created in the previous labs, which identifies the communities within the graphs. The community detection algorithm takes the input graphs, identifies strong connectivity within graphs, and forms multiple smaller communities. Infomap is used for community detection in this lab.

Estimated Time: 10 minutes

### Objectives

In this lab, you will:

* Create a graph in Graph Studio from the Graph Client.
* Detect the communities using the Infomap.

### Prerequisites

This lab assumes you have the following:

* You are running on Java 10+ in OCI Console.
* All previous labs were completed successfully.

## Task 1: Change the graph properties

1. Make sure you are on the same session of cloud shell. If not, set the required environment variables as we did in the setup.

    ```text
   <copy>
    export DRA_HOME=${HOME}/microservices-data-refactoring
   </copy>
   ```

2. Navigate to the project

    ```text
   <copy>
    cd ${HOME}/microservices-data-refactoring/dra-graph-client
   </copy>
   ```

3. Update the src/main/resources/db-config.properties file.

    ```text
   <copy>
    vi src/main/resources/db-config.properties
   </copy>
   ```

   Update the value for the below properties.

    ```text
    tenant   - tenant OCID
    database - Name of the Database
    username - Username to login into the database
    password - Password to login into the database
    endpoint - Endpoint for connecting to Autonomous Database instance
    ```

   Save and exit.

4. Update the src/main/resources/graph-config.properties file.

    ```text
   <copy>
    vi src/main/resources/graph-config.properties
   </copy>
   ```

    Update the value for the below properties.

    ```text
    graph_name: Name of the graph created in Graph Studio.
    vertex_property_column: Column name of Tables
    edge_property_source_column: Source Column name of the Edge
    edge_property_destination_column: Destination Column name of the Edge
    edge_property_weight_column: Column name of Edge weight

    ```

    Save and exit.

## Task 2: Compile and Run the Community Detection on medical records

Here, We are using the smaller graph created in Lab 5. You can run on the main graph, created in Lab 3 or any data you loaded through SQL Tuning Sets.

1. Compile the maven project

    ```text
   <copy>
    mvn compile
   </copy>
   ```

2. Execute the project to see the identified clusters using the Infomap Algorithm

    ```text
   <copy>
   mvn exec:java -Dexec.mainClass=com.oracle.ms.app.InfomapGraphClient -Dexec.args="5"
   </copy>
   ```

   Where
   * com.oracle.ms.app.InfomapGraphClient - The main class which loads the graph and runs the Infomap to identify the Clusters.
   * 5 is MaxNumberOfIterations for Infomap Algorithm. You can change it to any positive integer.

   Output

   Job Details:

    ```text
   name=Environment Creation - 18 GBstype= ENVIRONMENT_CREATION created_by= ADMIN
   Graph : PgxGraph[name=MED_REC_PG_OBJ_974_G, N=974, E=3499, created=1664544333468]
   ```

    The output of Infomap will have the Community Ids with the nodes in that community. Every node will fall under one or the other cluster. Out of 974 nodes, just for the understanding shown, the clusters related to Patient Details, Medications, and Orders. The complete output can be seen in the file `dra-output-medical-records-974-nodes.txt`

	- The nodes in the cluster with community 104 are related to Orders.
	- The nodes in the cluster with community 121 are related to Medications.
	- The nodes in the cluster with community 221 are related to Patient Details.
	

     ```text
	+--------------------------------------------+
    | Community | TABLE_NAME                     |
	+--------------------------------------------+
	| 121       | ORDER_CATALOG_ITEM_R           |
	| 121       | WARNING_LABEL                  |
	| 121       | WARNING_LABEL_XREF             |
	| 121       | MED_OE_DEFAULTS                |
	| 121       | PACKAGE_TYPE                   |
	| 121       | MED_PACKAGE_TYPE               |
	| 121       | QUANTITY_ON_HAND               |
	| 121       | MED_IDENTIFIER                 |
	| 121       | MED_INGRED_SET                 |
	| 121       | MEDICATION_DEFINITION          |
	| 121       | MED_PRODUCT                    |
	| 121       | MED_COST_HX                    |
	| 121       | MANUFACTURER_ITEM              |
	| 121       | MED_FLEX_OBJECT_IDX            |
	| 121       | MED_DISPENSE                   |
	| 121       | ITEM_LOCATION_COST             |
	| 121       | MED_DEF_FLEX                   |
	| 121       | RX_CURVE                       |
	| 204       | ACTIVITY_DATA_RELTN            |
	| 204       | SCH_APPT_ORD                   |
	| 204       | ORDER_CATALOG_SYNONYM          |
	| 204       | RENEW_NOTIFICATION_PERIOD      |
	| 204       | RAD_FOLLOW_UP_RECALL           |
	| 204       | ORDER_NOTIFICATION             |
	| 204       | FILM_USAGE                     |
	| 204       | RAD_PROCEDURE_ASSOC            |
	| 204       | ORDER_ACTION                   |
	| 204       | RAD_PRIOR_PREFS                |
	| 204       | ORDER_REVIEW                   |
	| 204       | ORDER_IV_INFO                  |
	| 204       | ORDERS                         |
	| 204       | ECO_QUEUE                      |
	| 204       | BILL_ONLY_PROC_RELTN           |
	| 204       | ORDER_CATALOG                  |
	| 204       | ORDER_INGREDIENT               |
	| 221       | PROC_PRSNL_RELTN               |
	| 221       | PSN_PPR_RELTN                  |
	| 221       | CODE_VALUE_EXTENSION           |
	| 221       | PERSON_PRSNL_RELTN             |
	| 221       | DEPT_ORD_STAT_SECURITY         |
	| 221       | ENCNTR_PRSNL_RELTN             |
	| 221       | PROBLEM_COMMENT                |
	| 221       | PRSNL_RELTN_ACTIVITY           |
	| 221       | DOSE_CALCULATOR_UOM            |
	| 221       | PERSON_CODE_VALUE_R            |
	| 221       | CLINICAL_SERVICE_RELTN         |
	| 221       | CMT_CONCEPT                    |
	| 221       | CODE_CDF_EXT                   |
	| 221       | CREDENTIAL                     |
	| 221       | PE_STATUS_REASON               |
	| 221       | PRSNL_RELTN                    |
	| 221       | CMT_CONCEPT_EXTENSION          |
	| 221       | PRSNL                          |
	| 221       | MATCH_TAG_PARMS                |
	| 221       | FILL_CYCLE_BATCH               |
	| 221       | CODE_VALUE_SET                 |
	| 221       | PRSNL_ORG_RELTN                |
	| 221       | SCH_LOCK                       |
	| 221       | TRACKING_EVENT_HISTORY         |
	+--------------------------------------------+
     ```

## Task 3: Analysis of newly formed clusters on medical records

* There are 28 Nodes in the below cluster :
* Main Table for forming a cluster is PRSNL, where a significant number of tables are connected with this table.

* Patient and his details, allergies, tracking and schedules, and diagnosis details formed a cluster.

* The Person will have problems, and He consults the Doctor. The Doctor will diagnose the patient. And the tracking of the patient is carried out.

  If you see, the below tables are related to a Person who is a patient. Here the Person, his Diagnosis, Tracking the activity of the Person has formed one community. Similarly, there are other communities formed as well.
    
     ```text
	ESO_TRIGGER
	PRSNL_ORG_RELTN
	PROBLEM_COMMENT
	MATCH_TAG_PARMS
	CODE_CDF_EXT
	CREDENTIAL
	FILL_CYCLE_BATCH
	DEPT_ORD_STAT_SECURITY
	WORKING_VIEW_FREQ_INTERVAL
	PRSNL_RELTN
	PE_STATUS_REASON
	PERSON_CODE_VALUE_R
	CMT_CONCEPT
	SCH_LOCK
	PROC_PRSNL_RELTN
	TRACKING_EVENT_HISTORY
	CODE_VALUE_SET
	PERSON_PRSNL_RELTN
	DOSE_CALCULATOR_UOM
	CLINICAL_SERVICE_RELTN
	ENCNTR_PRSNL_RELTN
	PREDEFINED_PREFS
	PSN_PPR_RELTN
	CODE_VALUE_EXTENSION
	PRSNL
	CODE_VALUE
	PRSNL_RELTN_ACTIVITY
	CMT_CONCEPT_EXTENSION       
     ```
  
  Below are the 18 tables that formed a cluster on Medication details and medical dispense.

    ```text
	ORDER_CATALOG_ITEM_R
	WARNING_LABEL_XREF
	PACKAGE_TYPE
	MED_IDENTIFIER
	MED_PACKAGE_TYPE
	MED_PRODUCT
	MANUFACTURER_ITEM
	WARNING_LABEL
	MED_FLEX_OBJECT_IDX
	MED_DEF_FLEX
	ITEM_LOCATION_COST
	QUANTITY_ON_HAND
	MED_DISPENSE
	MEDICATION_DEFINITION
	MED_COST_HX
	MED_INGRED_SET
	MED_OE_DEFAULTS
	RX_CURVE      
     ```

	Below are the 17 tables which formed a cluster based on Orders and Billing related information.
	
	```text
	RENEW_NOTIFICATION_PERIOD
	ORDER_REVIEW
	BILL_ONLY_PROC_RELTN
	FILM_USAGE
	ORDER_CATALOG_SYNONYM
	ORDERS
	ORDER_INGREDIENT
	ORDER_CATALOG
	SCH_APPT_ORD
	ORDER_ACTION
	ORDER_IV_INFO
	RAD_PROCEDURE_ASSOC
	ORDER_NOTIFICATION
	RAD_PRIOR_PREFS
	RAD_FOLLOW_UP_RECALL
	ACTIVITY_DATA_RELTN
	ECO_QUEUE
	```

## Task 4: Adjust constraints and reform the communities of medical records

1. For example, we consider the node named `ORDER_CATALOG_ITEM_R` to move from `Medications` to the `Orders` Cluster.

2. Get the nodes of the target cluster(Orders) to which we want to move node `ORDER_CATALOG_ITEM_R`. And check for the edges from `ORDER_CATALOG_ITEM_R` to nodes of the target cluster and update the `TOTAL_AFFINITY` of those edges to 1.

    NOTE: We must have an edge from the source node of any one of the nodes of the target cluster to move.

    Go to SQL developer using the `TKDRADATA` user and execute the below query.

    ```text
   <copy>
	UPDATE EDGES SET TOTAL_AFFINITY = 1 WHERE TABLE_MAP_ID IN 
	(SELECT DISTINCT(TABLE_MAP_ID) FROM EDGES
	WHERE (TABLE2 = 'ORDER_CATALOG_ITEM_R' AND TABLE1 IN ('RENEW_NOTIFICATION_PERIOD','ORDER_REVIEW','BILL_ONLY_PROC_RELTN','FILM_USAGE','ORDER_CATALOG_SYNONYM','ORDERS','ORDER_INGREDIENT','ORDER_CATALOG','SCH_APPT_ORD','ORDER_ACTION','ORDER_IV_INFO','RAD_PROCEDURE_ASSOC','ORDER_NOTIFICATION','RAD_PRIOR_PREFS','RAD_FOLLOW_UP_RECALL','ACTIVITY_DATA_RELTN','ECO_QUEUE'))
	OR (TABLE1 = 'ORDER_CATALOG_ITEM_R' AND TABLE2 IN ('RENEW_NOTIFICATION_PERIOD','ORDER_REVIEW','BILL_ONLY_PROC_RELTN','FILM_USAGE','ORDER_CATALOG_SYNONYM','ORDERS','ORDER_INGREDIENT','ORDER_CATALOG','SCH_APPT_ORD','ORDER_ACTION','ORDER_IV_INFO','RAD_PROCEDURE_ASSOC','ORDER_NOTIFICATION','RAD_PRIOR_PREFS','RAD_FOLLOW_UP_RECALL','ACTIVITY_DATA_RELTN','ECO_QUEUE')));
    </copy>
    ```

3. Rerun the Infomap algorithm on the updated data. Follow the same steps from Task 2, and verify whether the required is moved to the intended clusters. Iterate the process until you are convinced with the final clusters.

Please **proceed to the next lab** if you want to extract and analyze data into smaller ones.

## Acknowledgements

* **Author** - Praveen Hiremath, Developer Advocate
* **Contributors** -  Praveen Hiremath, Developer Advocate
* **Last Updated By/Date** - Praveen Hiremath, Developer Advocate, October 2022
