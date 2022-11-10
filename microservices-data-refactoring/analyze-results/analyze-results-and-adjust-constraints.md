# Analyze the sub-graphs and adjust constraints

## Introduction

In this lab, we will analyze the communities formed and will move the single-node cluster or any other node to the target cluster which we find suitable.

Estimated Time: 15 minutes

### Objectives

In this lab, you will:

* Move node from one cluster to another cluster.

### Prerequisites

This lab assumes you have the following:

* All previous labs were completed successfully.

## Task: Find the Node to move to the target cluster

1. For example, we consider the node named `RAD_REPORT_DETAIL` from Single Node Cluster.

2. Get the Ids of the Nodes of the cluster to which we want to move the single node cluster/or any Nodes of other clusters. Get the Matched Ids and update the `TOTAL_AFFINITY` to 1.

    NOTE: We must have an edge from the node to be moved to the Nodes in the Target Cluster.

    Go to SQL developer and execute the below query.

    ```text
   <copy>
   UPDATE MED_RECS_AD_TABLE_MAP SET TOTAL_AFFINITY = 1 WHERE TABLE_MAP_ID IN 
   (SELECT DISTINCT(TABLE_MAP_ID) AS MATCHED_IDS_OF_EDGES_TO_BE_UPDATED FROM MED_RECS_AD_TABLE_MAP
   WHERE (TABLE1 = 'RAD_REPORT_DETAIL' AND TABLE2 IN (#{COMMA_SEPARATED_NODES_OF_TARGET_CLUSTER}))
   OR (TABLE2 = 'RAD_REPORT_DETAIL' AND TABLE1 IN (#{COMMA_SEPARATED_NODES_OF_TARGET_CLUSTER})))
    </copy>
    ```

3. Run the Infomap algorithm again on the updated data. Follow the same steps from Lab 6, Task 2, and verify whether the required is moved to the intended clusters.

## Acknowledgements

* **Author** - Praveen Hiremath, Developer Advocate
* **Contributors** -  Praveen Hiremath, Developer Advocate
* **Last Updated By/Date** - Praveen Hiremath, Developer Advocate, October 2022
