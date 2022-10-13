# Run the community detection algorithm

## Introduction

In this lab, using the graphs which were created in the previous labs, we applied the community detection algorithm which identifies the communities within the graphs. The community detection algorithm takes the input graphs and identities strong connectivity within graphs and forms multiple smaller communities. Infomap is used for community detection in this lab.

Estimated Lab Time: 15 minutes

### Objectives

In this lab, you will:

* Create a graph in Graph Studio from the Graph Client.
* Detect the communities using the Infomap.

### Prerequisites

This lab assumes you have:

* All previous labs were completed successfully.

## Task 1: Navigate to DRAGraphClient project folder and change the database and graph properties 
1. Navigate to the project
   ~~~
   cd microservices-data-refactoring/DRAGraphClient
   ~~~
2. Update the src/main/resources/db-config.properties file.

	Update the value for the below properties.

	~~~
	tenant   - tenant OCID
	database - Name of the Database
	username - Username to login to database
	password - Password to login to database
	endpoint - Endpoint for connecting to Autonomous Database instance
	~~~~

3. Update the src/main/resources/graph-config.properties file.

 	Update the value for the below properties.

	~~~
	graph_name : Name of the graph created in Graph Studio.
	vertex_property_column : Column name of Tables
	edge_property_source_column : Source Column name of the Edge
	edge_property_destination_column : Destination Column name of the Edge
	edge_property_weight_column : Column name of Edge weight
	~~~~

## Task 2: Compile and Run the Community Detection

1. Compile the maven project

	~~~
 	mvn compile
 	~~~

2. Execute the project to see the identified clusters using the Infomap Algorithm

	~~~
	mvn exec:java -Dexec.mainClass=com.oracle.ms.app.InfomapGraphClient -Dexec.args="MaxNumberOfIterations"
	~~~

 	Where

   * com.oracle.ms.app.InfomapGraphClient - Main class which loads the graph and runs the Infomap to identify the Clusters.
   * MaxNumberOfIterations - Maximum number of Iterations, the stopping criteria for Infomap algorithm. A positive integer.

*Output*

Job Details: 
 ~~~
 name=Environment Creation - 18 GBstype= ENVIRONMENT_CREATION
 created_by= ADMIN
 Graph : PgxGraph[name=MED_REC_PG_OBJ_G, N=259, E=972, created=1664544333468]
~~~
~~~
The table names with the same community Ids formed the clusters below.
 +----------------------------------------+
 | Community | TABLE_NAME                 |
 +----------------------------------------+
 | 0         | PRSNL_RELTN_ACTIVITY       |
 | 0         | CLINICAL_SERVICE_RELTN     |
 | 0         | ENCNTR_PRSNL_RELTN         |
 | 0         | PE_STATUS_REASON           |
 | 0         | PCT_CARE_TEAM              |
 | 0         | PERSON_PERSON_RELTN        |
 | 0         | PERSON_INFO                |
 | 0         | DEPT_ORD_STAT_SECURITY     |
 | 0         | PERSON_PRSNL_RELTN         |
 | 0         | PRSNL_ORG_RELTN            |
 | 0         | ENCOUNTER                  |
 | 0         | ORD_RQSTN_ORD_R            |
 | 0         | PRSNL_RELTN                |
 | 0         | ORG_ALIAS_POOL_RELTN       |
 | 0         | LOCATION                   |
 | 0         | ORGANIZATION               |
 | 0         | CODE_VALUE_EXTENSION       |
 | 0         | SCH_APPT                   |
 | 0         | ENCNTR_INFO                |
 | 0         | PRSNL_ALIAS                |
 | 0         | SCH_EVENT                  |
 | 0         | SCH_EVENT_ALIAS            |
 | 1         | PROC_CLASSIFICATION        |
 | 2         | OCS_FACILITY_R             |
 | 3         | SYNONYM_ITEM_R             |
 | 4         | SHARED_VALUE_GTTD          |
 | 5         | RAD_REPORT_DETAIL          |
 | 6         | IMAGE_CLASS_TYPE           |
 | 7         | RAD_FOLLOW_UP_CONTROL      |
 | 8         | DRC_PREMISE                |
 | 9         | ORG_ORG_RELTN              |
 | 10        | PENDING_COLLECTION         |
 | 10        | PERSON_COMBINE_DET         |
 | 10        | OE_FORMAT_FIELDS           |
 | 10        | COLLECTION_PRIORITY        |
 | 10        | ORDER_LABORATORY           |
 | 10        | ACCESSION                  |
 | 10        | ACCESSION_ORDER_R          |
 | 10        | ORDERS                     |
 | 10        | ORDER_REVIEW               |
 | 10        | UCM_CASE_STEP              |
 | 10        | UCMR_CASE_TYPE             |
 | 10        | ORDER_CONTAINER_R          |
 | 10        | ORDER_ENTRY_FIELDS         |
 | 10        | ORDER_DETAIL               |
 | 10        | ORDER_SUPPLY_REVIEW        |
 | 10        | UCM_CASE                   |
 | 10        | ORDER_TASK                 |
 | 10        | ORDER_ACTION               |
 | 10        | TASK_ACTIVITY              |
 | 10        | SCH_EVENT_ATTACH           |
 | 10        | NETTING                    |
 | 10        | TRACKING_EVENT             |
 | 10        | ORDER_TASK_RESPONSE        |
 | 10        | PRICE_SCHED                |
 | 10        | TASK_RELTN                 |
 | 10        | PERSON_COMBINE             |
 | 10        | SERVICE_DIRECTORY          |
 | 10        | OUTPUT_DEST                |
 | 10        | SHARED_LIST_GTTD           |
 | 10        | ACTIVITY_DATA_RELTN        |
 | 10        | TRACK_EVENT                |
 | 10        | ENCNTR_LOC_HIST            |
 | 11        | PRIVILEGE                  |
 | 12        | TRACKING_PRSNL_REF         |
 | 13        | ORDER_PRODUCT              |
 | 13        | WARNING_LABEL              |
 | 13        | MED_INGRED_SET             |
 | 13        | ALT_SEL_CAT                |
 | 13        | RX_CURVE                   |
 | 13        | MED_PACKAGE_TYPE           |
 | 13        | MEDICATION_DEFINITION      |
 | 13        | MED_DEF_FLEX               |
 | 13        | WARNING_LABEL_XREF         |
 | 13        | MED_DISPENSE               |
 | 13        | LONG_TEXT                  |
 | 13        | ITEM_DEFINITION            |
 | 13        | MED_FLEX_OBJECT_IDX        |
 | 13        | MED_OE_DEFAULTS            |
 | 13        | ALT_SEL_LIST               |
 | 13        | ORDER_CATALOG_ITEM_R       |
 | 14        | QUANTITY_ON_HAND           |
 | 15        | ROUTE_FORM_R               |
 | 16        | RES_SIGN_ACT_SUBTYPE       |
 | 17        | OUTBOUND_FIELD_PROCESSING  |
 | 18        | BILL_ITEM_MODIFIER         |
 | 19        | PROXY_GROUP                |
 | 20        | EXPEDITE_COPY              |
 | 21        | ORG_TYPE_RELTN             |
 | 22        | CODE_SET_EXTENSION         |
 | 23        | DCP_ENTITY_RELTN           |
 | 24        | PRINTER                    |
 | 25        | PFT_ENCNTR                 |
 | 26        | RAD_INIT_READ              |
 | 27        | CODE_VALUE_ALIAS           |
 | 27        | MATCH_TAG_PARMS            |
 | 27        | DEVICE                     |
 | 27        | SCH_LOCATION               |
 | 27        | ESI_LOG                    |
 | 27        | TRACKING_ITEM              |
 | 27        | DCP_SHIFT_ASSIGNMENT       |
 | 27        | PERSON_PRSNL_ACTIVITY      |
 | 27        | SCD_STORY                  |
 | 27        | MRU_LOOKUP_ED_DOC          |
 | 27        | V500_EVENT_SET_CODE        |
 | 27        | BLOB_REFERENCE             |
 | 27        | NOMENCLATURE               |
 | 27        | CMT_CONCEPT_EXTENSION      |
 | 27        | NURSE_UNIT                 |
 | 27        | LONG_BLOB                  |
 | 27        | PM_WAIT_LIST_STATUS        |
 | 27        | PPR_CONSENT_STATUS         |
 | 27        | PERSON_NAME                |
 | 27        | ORG_BARCODE_ORG            |
 | 27        | SIGN_LINE_FORMAT_DETAIL    |
 | 27        | PROC_PRSNL_RELTN           |
 | 27        | CREDENTIAL                 |
 | 27        | CODE_VALUE_SET             |
 | 27        | CONTAINER                  |
 | 27        | DCP_FORMS_ACTIVITY         |
 | 27        | PCS_DEMOGRAPHIC_FIELD      |
 | 27        | CHARGE_EVENT_ACT           |
 | 27        | ALLERGY_COMMENT            |
 | 27        | DCP_CARE_TEAM_PRSNL        |
 | 27        | DCP_FORMS_ACTIVITY_COMP    |
 | 27        | PERSON_CODE_VALUE_R        |
 | 27        | CLINICAL_EVENT             |
 | 27        | PSN_PPR_RELTN              |
 | 27        | PROBLEM_PRSNL_R            |
 | 27        | RAD_REPORT_PRSNL           |
 | 27        | PHONE                      |
 | 27        | MLTM_NDC_MAIN_DRUG_CODE    |
 | 27        | BILL_ITEM                  |
 | 27        | WORKING_VIEW_FREQ_INTERVAL |
 | 27        | TRACKING_CHECKIN           |
 | 27        | SCH_EVENT_ACTION           |
 | 27        | CODE_VALUE_GROUP           |
 | 27        | LOGICAL_DOMAIN             |
 | 27        | PERSON_ALIAS               |
 | 27        | CE_EVENT_PRSNL             |
 | 27        | FILL_CYCLE_BATCH           |
 | 27        | RAD_PROTOCOL_DEFINITION    |
 | 27        | TRACKING_PRSNL             |
 | 27        | DIAGNOSIS                  |
 | 27        | RAD_TECH_CMT_DATA          |
 | 27        | PAT_ED_DOC_ACTIVITY        |
 | 27        | CHARGE_EVENT_ACT_PRSNL     |
 | 27        | SCD_TERM_DATA              |
 | 27        | HM_EXPECT_MOD              |
 | 27        | CE_MED_RESULT              |
 | 27        | SCH_LOCK                   |
 | 27        | DISPENSE_CATEGORY          |
 | 27        | RAD_RES_INFO               |
 | 27        | SIGN_LINE_FORMAT           |
 | 27        | ENCNTR_ALIAS               |
 | 27        | CODE_CDF_EXT               |
 | 27        | PM_TRANSACTION             |
 | 27        | TRACKING_PRV_RELN          |
 | 27        | LOCATION_GROUP             |
 | 27        | PROBLEM_COMMENT            |
 | 27        | ESO_TRIGGER                |
 | 27        | PRSNL_GROUP                |
 | 27        | PRSNL_GROUP_RELTN          |
 | 27        | TRACKING_EVT_CMT           |
 | 27        | TRACKING_EVENT_HISTORY     |
 | 27        | DCP_FORMS_ACTIVITY_PRSNL   |
 | 27        | CMT_CONCEPT                |
 | 27        | ALLERGY                    |
 | 27        | PAT_ED_SHORTCUT            |
 | 27        | TRACKING_LOCATOR           |
 | 27        | SCH_ENTRY                  |
 | 27        | RAD_PROTOCOL_ACT           |
 | 27        | PAT_ED_RELTN               |
 | 27        | PREDEFINED_PREFS           |
 | 27        | ORG_BARCODE_FORMAT         |
 | 27        | REACTION                   |
 | 27        | PAT_ED_FAVORITES           |
 | 27        | TASK_ACTIVITY_ASSIGNMENT   |
 | 27        | CHARGE_EVENT               |
 | 27        | PPR_CONSENT_POLICY         |
 | 27        | SCR_PATTERN                |
 | 27        | CE_EVENT_ACTION            |
 | 27        | TRACK_GROUP                |
 | 27        | TRACK_REFERENCE            |
 | 27        | PROBLEM                    |
 | 27        | STICKY_NOTE                |
 | 27        | V500_EVENT_SET_EXPLODE     |
 | 27        | PRIV_LOC_RELTN             |
 | 27        | CODE_VALUE                 |
 | 27        | PERSON                     |
 | 27        | PRSNL                      |
 | 27        | HM_EXPECT_MOD_HIST         |
 | 27        | DOSE_CALCULATOR_UOM        |
 | 28        | TRACKING_EVENT_ORD         |
 | 29        | DISCRETE_TASK_ASSAY        |
 | 30        | DEVICE_XREF                |
 | 31        | MED_COST_HX                |
 | 31        | TEMPLATE_NONFORMULARY      |
 | 31        | PACKAGE_TYPE               |
 | 31        | MED_PRODUCT                |
 | 31        | MANUFACTURER_ITEM          |
 | 31        | ITEM_LOCATION_COST         |
 | 31        | FILL_PRINT_ORD_HX          |
 | 31        | MED_IDENTIFIER             |
 | 32        | ORDER_TASK_XREF            |
 | 33        | RAD_PROCEDURE_GROUP        |
 | 33        | ORDER_SENTENCE             |
 | 33        | SCH_SIMPLE_ASSOC           |
 | 33        | PATHWAY                    |
 | 33        | ORDER_NOTIFICATION         |
 | 33        | RAD_RPT_LOCK               |
 | 33        | REGIMEN_CAT_SYNONYM        |
 | 33        | PW_CAT_SYNONYM             |
 | 33        | ORDER_COMMENT              |
 | 33        | ORDER_PRODUCT_DOSE         |
 | 33        | ECO_QUEUE                  |
 | 33        | RAD_REPORT                 |
 | 33        | RAD_FOL_UP_FIELD           |
 | 33        | RAD_INT_CASE_R             |
 | 33        | TRACKABLE_OBJECT           |
 | 33        | ORDER_RADIOLOGY            |
 | 33        | RAD_PRIOR_PREFS            |
 | 33        | CODE_VALUE_EVENT_R         |
 | 33        | MAMMO_STUDY                |
 | 33        | PW_CAT_FLEX                |
 | 33        | FILM_USAGE                 |
 | 33        | FILM_EXAM                  |
 | 33        | MEDIA_EXAM                 |
 | 33        | ORDER_THERAP_SBSTTN        |
 | 33        | ORDER_IV_INFO              |
 | 33        | CS_COMPONENT               |
 | 33        | EXAM_DATA                  |
 | 33        | BILL_ONLY_PROC_RELTN       |
 | 33        | SCH_EVENT_PATIENT          |
 | 33        | IMAGE_CLASS                |
 | 33        | RAD_INT_CASE               |
 | 33        | ORDER_CATALOG              |
 | 33        | SCH_APPT_ORD               |
 | 33        | SIGN_LINE_DTA_R            |
 | 33        | REGIMEN_CATALOG            |
 | 33        | IM_STUDY_PARENT_R          |
 | 33        | ORDER_INGREDIENT           |
 | 33        | ORDER_DISPENSE             |
 | 33        | ICLASS_PERSON_RELTN        |
 | 33        | ACT_PW_COMP                |
 | 33        | PATHWAY_CATALOG            |
 | 33        | PROCEDURE_SPECIMEN_TYPE    |
 | 33        | ORDER_INGREDIENT_DOSE      |
 | 33        | RAD_FILM_ADJUST            |
 | 33        | RAD_PROCEDURE_ASSOC        |
 | 33        | PHARMACY_NOTES             |
 | 33        | SCH_APPT_OPTION            |
 | 33        | RAD_FOLLOW_UP_RECALL       |
 | 33        | ORDER_CATALOG_SYNONYM      |
 | 33        | TASK_DISCRETE_R            |
 | 33        | IM_STUDY                   |
 | 33        | MAMMO_FOLLOW_UP            |
 | 33        | RAD_EXAM                   |
 | 33        | RENEW_NOTIFICATION_PERIOD  |
 ------------------------------------------
 ~~~
## Task 4 : Analysis of nelwy formed clusters

* There are 63 Nodes in this below Cluster :
* Main Table for foraming a cluster is PRSNL where major number of tables are connected with this table.

* All the tables related to Personal and tracking of those personal details has formed the formed one cluster.

* The Person will have the Problems and He consults the Doctor. Doctor will diagnoise the Patient. And the tracking of the patient is carried out
If you see below the Below tables are related to Person who is a patient. Here the Person, his Diagnosis, Tracking the activity of the Person has formed one community. Similarly there are other communities formed as well.

 ~~~
 ALLERGY
 ALLERGY_COMMENT
 CE_EVENT_ACTION
 CE_EVENT_PRSNL
 CE_MED_RESULT
 CHARGE_EVENT
 CHARGE_EVENT_ACT
 CHARGE_EVENT_ACT_PRSNL
 CLINICAL_EVENT
 CONTAINER
 DCP_CARE_TEAM_PRSNL
 DCP_FORMS_ACTIVITY
 DCP_FORMS_ACTIVITY_PRSNL
 DCP_SHIFT_ASSIGNMENT
 DIAGNOSIS
 ESI_LOG
 HM_EXPECT_MOD
 HM_EXPECT_MOD_HIST
 LOGICAL_DOMAIN
 LONG_BLOB
 MRU_LOOKUP_ED_DOC
 NOMENCLATURE
 PAT_ED_DOC_ACTIVITY
 PAT_ED_FAVORITES
 PAT_ED_RELTN
 PAT_ED_SHORTCUT
 PERSON
 PERSON_COMBINE_DET
 PERSON_NAME
 PM_TRANSACTION
 PM_WAIT_LIST_STATUS
 PPR_CONSENT_POLICY
 PPR_CONSENT_STATUS
 PRIV_LOC_RELTN
 PROBLEM
 PROBLEM_COMMENT
 PROBLEM_PRSNL_R
 PROC_PRSNL_RELTN
 PRSNL
 RAD_PROTOCOL_ACT
 RAD_PROTOCOL_DEFINITION
 RAD_REPORT_PRSNL
 RAD_RES_INFO
 RAD_TECH_CMT_DATA
 REACTION
 SCD_STORY
 SCD_TERM_DATA
 SCH_ENTRY
 SCH_EVENT_ACTION
 SCH_LOCATION
 SCH_LOCK
 SCR_PATTERN
 STICKY_NOTE
 TASK_ACTIVITY_ASSIGNMENT
 TRACKING_CHECKIN
 TRACKING_EVENT_HISTORY
 TRACKING_EVT_CMT
 TRACKING_ITEM
 TRACKING_LOCATOR
 TRACKING_PRSNL
 TRACKING_PRV_RELN
 TRACK_REFERENCE
 V500_EVENT_SET_EXPLODE

 ~~~
Below are the 16 tables which formed a cluster on Medication Deatils and also medical dispense.
~~~
 ORDER_PRODUCT              
 WARNING_LABEL              
 MED_INGRED_SET             
 ALT_SEL_CAT                
 RX_CURVE                   
 MED_PACKAGE_TYPE           
 MEDICATION_DEFINITION      
 MED_DEF_FLEX               
 WARNING_LABEL_XREF         
 MED_DISPENSE               
 LONG_TEXT                  
 ITEM_DEFINITION            
 MED_FLEX_OBJECT_IDX        
 MED_OE_DEFAULTS            
 ALT_SEL_LIST               
 ORDER_CATALOG_ITEM_R       
~~~
There are single node clusters as well. If we analyse and can say that these nodes should be part of any cluster, we can do move a node to target cluster. Its explained in the next lab.

## Learn More

## Acknowledgements

* **Author** - Praveen Hiremath, Developer Advocate
* **Contributors** -  Praveen Hiremath, Developer Advocate
* **Last Updated By/Date** - Praveen Hiremath, Developer Advocate, October 2022
