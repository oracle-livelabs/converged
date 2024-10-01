# Setup

## Introduction

In this lab, we will select

Estimates Time: 20 minutes

### Objectives

* Clone the setup and microservices code
* Execute setup


## Task 1: Launch the Cloud Shell

Cloud Shell is a small virtual machine running a "bash" shell which you access through the Oracle Cloud Console. Cloud Shell comes with a pre-authenticated command line interface connected to the tenancy. It also provides up-to-date tools and utilities.

   1. Click the Cloud Shell icon in the top-right corner of the Console.

      ![Open Cloud Shell](images/open-cloud-shell.png =50%x*)

      >**Note**: Cloud Shell uses websockets to communicate between your browser and the service. If your browser has websockets disabled or uses a corporate proxy that has websockets disabled you will see an error message ("An unexpected error occurred") when attempting to start Cloud Shell from the console. You also can change the browser cookies settings for a specific site to allow the traffic from *.oracle.com

## Task 2: Download the wallet of your pre-provisioned ATP instance 

   1. Copy the compartment-id and database name from the workshop reservation page described in the "Get Started" lab and issue the following command in the Cloud Shell using those values.

      oci db autonomous-database list --compartment-id <your-compartment-ocid> --display-name "<ATP_NAME>"

   2. This command should return the ocid of the database which you can use, along with an arbitrary `wallet-password` to run the following command to download the database wallet to the file location provided.

      oci db autonomous-database generate-wallet --autonomous-database-id <ATP_OCID> --file ~/myatpwallet.zip --password <wallet-password>

   2. Finally, unzip it the wallet file to a directory such as ~/myatpwallet (this wallet/directory will be used to make connections in the Java/GraalVM app)

   > **Note:** Cloud Shell sessions have a maximum length of 24 hours, and time out after 20 minutes of inactivity.


## Task 3: Exploore the ATP instance in OCI Console (Optional)

Your own Oracle Cloud Infrastructure compartment for running this workshop has been assigned to you. The name of the compartment appears on the Launch page.

1. Copy the compartment name (not OCID) from the workshop reservation page.

   ![Copy Comp Name](images/copy-comp-name.png " ")

2. Select the navigation menu from the top left corner of the Oracle Cloud Console and navigate to the ATP page in the Oracle Database section.

   ![Select component instances](images/select-compute-instances.png " ")

3. Search for compartment using the compartment name from step#1 in the "Compartment" field under "List Scope".

   ![Enter component name](images/enter-comp-name.png " ")

4. Select your compartment name from the drop down list.

   ![Enter component name](images/select-comp-name.png " ")

   ![Enter correct component name](images/correct-comp-name.png " ")

5. Select your database from the list and explore!


You may now proceed to the next lab.

## Learn More

* [Oracle Database](https://bit.ly/mswsdatabase)

## Acknowledgements
* **Authors** - Paul Parkinson, Architect and Developer Advocate
* **Last Updated By/Date** - Paul Parkinson, 2024

