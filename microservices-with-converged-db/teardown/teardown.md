# Teardown

## Introduction

In this lab, we will tear down the resources created in your tenancy and the directory in the Oracle cloud shell.

Estimates Time: 10 minutes

Quick walk through to tear down the resources created in your tenancy and the directory in cloud shell.

[](youtube:vfj_hCDnp7g)

### Objectives

* Teardown the setup

### Prerequisites

* Have successfully or partially completed lab 1

## Task 1: Delete the Workshop Resources

1. Run the following command to delete the resources created in you tenancy. It will delete everything except the compartment. It will take several minutes to run. The script will delete the Object Storage bucket, 'Oracle Cloud Infrastructure Registry repositories, OKE cluster, listeners, VCN and databases.

    ```
    <copy>teardown</copy>
    ```

## Task 2: Delete the Directory

1. Delete the directory in your cloud shell where you installed the workshop.

    ```
    <copy>rm -rf <directory name></copy>
    ```

## Task 3: Delete the Compartment

1. In the Oracle Cloud Console navigate to the Compartments screen in the Identity section. Select the compartment that was created for the workshop and delete it. Note, even when the script in step 1 has completed, it can take some time for Oracle Cloud Infrastructure to fully remove all the resources. It will not be possible to delete the compartment until this has completed.

You may now proceed to the next lab.

## Learn More

* [Oracle Database](https://bit.ly/mswsdatabase)

## Acknowledgements
* **Authors** - Paul Parkinson, Architect and Developer Advocate
* **Last Updated By/Date** - Paul Parkinson, 2024

