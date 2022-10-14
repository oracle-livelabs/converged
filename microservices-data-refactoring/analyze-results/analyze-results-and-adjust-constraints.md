# Analyze the sub-graphs and adjust constraints

## Introduction

In this lab, We will analyze the communities formed and we will move the single node cluster or any other node to target cluster which we find it suitable.

Estimated Lab Time: 15 minutes

### Objectives

In this lab, you will:
* Move node from one cluster to another cluster.

### Prerequisites

This lab assumes you have:

* All previous labs were completed successfully.

## Task 1: Find the Node to move to the target cluster

1. For Example, Here we are consider the node named 'RAD_REPORT_DETAIL' from Single Node Cluster .
	
2. Get the Ids of the Nodes of cluster to which we wanna move the single node cluster/or any Nodes of other clusters. Get the Matched Ids and update the TOTAL_AFFINITY to 1. 
NOTE : We must have an edge from Node to be moved to the Nodes in the Target Cluster. 
	~~~
	UPDATE MED_RECS_AD_TABLE_MAP SET TOTAL_AFFINITY = 1 WHERE TABLE_MAP_ID IN 
	(SELECT DISTINCT(TABLE_MAP_ID) AS MATCHED_IDS_OF_EDGES_TO_BE_UPDATED FROM MED_RECS_AD_TABLE_MAP
	WHERE (TABLE1 = 'RAD_REPORT_DETAIL' AND TABLE2 IN (#{COMMA_SEPARATED_NODES_OF_TARGET_CLUSTER}))
	OR (TABLE2 = 'RAD_REPORT_DETAIL' AND TABLE1 IN (#{COMMA_SEPARATED_NODES_OF_TARGET_CLUSTER})))
	~~~

3. Run the Infomap again on the updated data . Follow the same steps from Lab 4(Detect Communities Lab, Task 2) and check that the required is moved to the intended clusters.
## Learn More

## Acknowledgements
* **Author** - Praveen Hiremath, Developer Advocate
* **Contributors** -  Praveen Hiremath, Developer Advocate
* **Last Updated By/Date** - Praveen Hiremath, Developer Advocate, October 2022