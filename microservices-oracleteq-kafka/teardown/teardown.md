# Teardown

## Introduction

In this lab, we will tear down the resources created in your tenancy and the directory in the Oracle cloud shell.

Estimates Time: 10 minutes

### Objectives

- Clean up your tenancy

### Prerequisites

- Have successfully completed the earlier labs

## **Task 1:** Delete the Workshop Resources

1. Run the following command to delete the resources created in you tenancy. It will delete all resources except the compartment.

    It will take some minutes to finish. The script will delete the GraalVM installation, the Object Storage bucket and the Oracle Autonomous Database.

    ```bash
        <copy>
        source $LAB_HOME/cloud-setup/destroy.sh
        </copy>
    ```

    In shell, it will print the following lines

    ```bash
    Executing java/graalvm-uninstall.sh in the background
    Executing objstore-destroy.sh in the background
    Executing terraform-destroy.sh in the background
    ```

2. Check Destroy script logs

    The following command help you check the object store deletion.

    ```bash
    <copy>cat $LAB_LOG/objstore-destroy.log</copy>
    ```

    ```bash
    Deleting Object Store
    ```

    The following command show the terraform destroy command result.

    ```bash
    <copy>cat $LAB_LOG/terraform-destroy.log</copy>
    ```

    ```bash
    Running terraform destroy

    Initializing the backend...

    Initializing provider plugins...
    - Reusing previous version of hashicorp/oci from the dependency lock file
    - Reusing previous version of hashicorp/random from the dependency lock file
    - Using previously-installed hashicorp/oci v4.68.0

    ........

    Terraform used the selected providers to generate the following execution
    plan. Resource actions are indicated with the following symbols:
    - destroy

    Terraform will perform the following actions:

    # oci_database_autonomous_database.autonomous_database_atp will be destroyed

    ........

    Plan: 0 to add, 0 to change, 3 to destroy.
    random_string.autonomous_database_wallet_password: Destroying... [id=6[H_fZKsDX88A&tK]
    random_string.autonomous_database_wallet_password: Destruction complete after 0s
    oci_database_autonomous_database.autonomous_database_atp: Destroying... [id=ocid1.autonomousdatabase.oc1.iad.....m4iaq]

    .........

    oci_database_autonomous_database.autonomous_database_atp: Still destroying... [id=ocid1.autonomousdatabase.oc1.iad.....m4iaq, 1m50s elapsed]
    oci_database_autonomous_database.autonomous_database_atp: Destruction complete after 1m52s
    random_password.database_admin_password: Destroying... [id=none]
    random_password.database_admin_password: Destruction complete after 0s

    Destroy complete! Resources: 3 destroyed.

    ```

3. Clean the Docker local registry

    The lab deploys some containers and images referring to the Kafka platform and also to microservices. You have to cleanup the local registry. The following command you present the current Containers and images deployed.

    ```bash
    <copy>kafka-undeploy</copy>
    ```

    >**Note:** The above command removes all containers from lab including confluentinc v7.0.1 (used by lab), don't use it if you want use the containers and don't want to delete them.

4. Clean **.bashrc** lab setup

    You should clean the Laboratory setup inside the .bashrc file. Use the following command to delete the lines for LiveLabs setup.

    ```shell
    <copy>bash-cleanup</copy>
    ```


## **Task 2:** Delete the Directory

1. Delete the directory in your cloud shell where you installed the workshop.

    ```bash
     <copy>rm -rf <directory name, e.g. teqodb></copy>
    ```

## **Task 3:** Delete the Compartment

In the Oracle Cloud Infraestructure Console navigate to the Compartments screen in the Identity section. Select the compartment that was created for the workshop and delete it. Important, even when the script in step 1 has completed, it can take some time for Oracle Cloud Infrastructure to fully remove all the resources. It will not be possible to delete the compartment until this has completed.

## Acknowledgements

- **Authors** - Paulo Simoes, Developer Evangelist; Paul Parkinson, Developer Evangelist; Richard Exley, Consulting Member of Technical Staff, Oracle MAA and Exadata
- **Contributors** - Mayank Tayal, Developer Evangelist; Andy Tael, Developer Evangelist; Corrado De Bari, Developer Evangelist; Sanjay Goil, VP Microservices and Oracle Database
- **Last Updated By/Date** - Paulo Simoes, Aug 2022
