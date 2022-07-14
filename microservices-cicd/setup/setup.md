# Setup

## Introduction

In this lab, we will provision and setup the reference architecture.

In this reference architecture, Jenkins is hosted on Oracle Cloud Infrastructure to centralize build automation and scale the deployment by using Oracle Cloud Infrastructure Registry, Oracle Kubernetes and Oracle Converged Database. GitHub is used to manage source code. 

Estimated Time: 25 minutes

### Objectives

* Clone the setup and microservices code
* Execute setup

### Prerequisites

* This lab requires completion of the Get Started section in the Contents menu on the left.
* As this is a demonstration of Jenkins/GitHub integration for CI/CD, **you must use your own GitHub account to run it. Please fork or copy [Oracle Microservices GiHub repository](https://github.com/oracle/microservices-datadriven) into your own GitHub account**.

## Task 1: Copy the workshop microservices repository into your own GitHub account

1. Open a browser and navigate to [Oracle GitHub Microservices repository](https://github.com/oracle/microservices-datadriven).

   * Fork `https://github.com/oracle/microservices-datadriven` into your own GitHub account.

     ![Main Repository](images/main_repo.png " ")

## Task 2: Log in to the Oracle Cloud Console

1. If you haven't already, sign in to your Oracle Cloud Infrastructure account.

## Task 3: Select the Home Region

1. Be sure to select the **home region** of your tenancy. Setup will only work in the home region.

  ![Oracle Cloud Infrastructure Home Region](images/home-region.png " ")

## Task 4: Create group and IAM policies for a user

> **Note:** If you have admin privileges in your Free Tier or Paid account, you can skip Task #4 steps. Otherwise, please continue.

If you are not an administrator on your tenancy, you must insure that additional policies have been added to the group you are a member of or ask your admin to create a separate group for you with additional policies. This group will have IAM policies for creating and managing the resources within the compartment that will be created by workshop setup scripts.

A user's permissions to access services comes from the groups to which they belong. The permissions for a group are defined by policies. Policies define what actions members of a group can perform, and in which compartments. Users can access services and perform operations based on the policies set for the groups of which they are members.

Here are the steps for creating a new group and assigning security policy required for this workshop (only a user with the admin account will be able to perform the below steps):

1. Click the Navigation Menu in the upper left, navigate to Identity & Security and select Groups.

   ![Oracle Cloud Infrastructure Identity & Security Groups Screen](images/id-groups.png " ")

2. Click Create Group.

   ![Create Oracle Cloud Infrastructure Identity & Security Group Screen](images/create-group.png " ")

3. In the Create Group dialog box, enter the following:
 - **Name**: Enter a unique name for your group, such as "MicroservicesAdmin”. Note that the group name cannot contain spaces.
 - **Description**: Enter a description (for example, “New group for microservices workshop”).
 - Click **Create**.

   ![Create a New Group](images/new-group.png " ")

   ![Review a New Group](images/get-new-group.png " ")

 4. Now, create a security policy that gives the group permissions to execute the setup steps for this workshop, entering a name, such as "Microservices-Policies".

   ![Create a New Securiry Policy](images/create-policy.png " ")

   Using **Edit Policy Statement** option, add the below statements to the policy created above.

   ```
   <copy>
   Allow group MicroservicesAdmin to use cloud-shell in tenancy
   Allow group MicroservicesAdmin to manage users in tenancy
   Allow group MicroservicesAdmin to manage all-resources in tenancy

   Allow group MicroservicesAdmin to manage vaults in tenancy
   Allow group MicroservicesAdmin to manage buckets in tenancy
   Allow group MicroservicesAdmin to manage objects in tenancy

   </copy>
   ```

  ![Policy Statements](images/policy-statements.png " ")

5. And finally, make sure your user account has been added to the group created in step#2.  

## Task 5: Check Your Tenancy Service Limits

If you have a **fresh** free trial account with credits then you can be sure that you have enough quota and you can proceed to the next step.

If, however, you have already used up some quota on your tenancy, perhaps while completing other workshops, there may be insufficient quota left to run this workshop. The most likely quota limits you may reach are summarized in the following table.

| Service          | Scope  | Resource                                             | Available | Free Account Limit |
|------------------|:------:|------------------------------------------------------|:---------:|:------------------:|
| Compute          | AD-1   | Cores for Standard.E2 based VM and BM Instances      | **3**     | 6                  |
| Container Engine | Region | Cluster Count                                        | **1**     | 1                  |
| Database         | Region | Autonomous Transaction Processing Total Storage (TB) | **2**     | 2                  |
|                  | Region | Autonomous Transaction Processing OCPU Count         | **4**     | 8                  |
| LbaaS            | Region | 100Mbps Load Balancer Count                           | **3**     | 3                  |

1. Quota usage and limits can be check through the console: **Limits, Quotas and Usage** in the **Governance & Administration** section , For example:

    ![Oracle Cloud Infrastructure Service Limit Example](images/service-limit-example.png " ")

2. The Tenancy Explorer is used to locate existing resources: **Governance & Administration** --> **Governance** --> **Tenancy Explorer**. Use the "Show resources in subcompartments" feature to locate all the resources in your tenancy:

  ![Oracle Cloud Infrastructure Show Subcompartments](images/show-subcompartments.png " ")

  It may be necessary to delete some resources to make space to run the workshop. Once you have enough space you may proceed to the next step.

## Task 6: Launch Cloud Shell

Cloud Shell is a small virtual machine running a "bash" shell which you access through the Oracle Cloud Console. Cloud Shell comes with a pre-authenticated command line interface in the tenancy region. It also provides up-to-date tools and utilities.

1. Click the Cloud Shell icon in the top-right corner of the Console.

  ![Oracle Cloud Infrastructure Cloud Shell Opening](images/open-cloud-shell.png " ")

  > **Note:** Cloud Shell uses websockets to communicate between your browser and the service. If your browser has websockets disabled or uses a corporate proxy that has websockets disabled you will see an error message ("An unexpected error occurred") when attempting to start Cloud Shell from the console. You also can change the browser cookies settings for a specific site to allow the traffic from *.oracle.com

## Task 7: Create a Folder to Contain the Workshop Code

1. Create a directory to contain the workshop code. The directory name is used to create a compartment of the same name in your tenancy. The directory name must have between 1 and 13 characters, contain only letters or numbers, and start with a letter. Make sure that a compartment of the same name does not already exist in your tenancy or the setup will fail. For example:

    ```bash
    <copy>
    mkdir ~/grabdish
    </copy>
    ```

   All the resources created by the setup are created in this compartment. This will let you to quickly delete and cleanup afterward.  

2. Change directory to the directory that you have created. The setup will fail if you do not complete this step. For example:

    ```bash
    <copy> 
    cd ~/grabdish
    </copy>
    ```

## Task 8: Make a Clone of the Workshop Setup Script and Source Code

1. To work with the application code, you need to make a clone from the GitHub repository you copiedor forked into your own GitHub account in the previous setup step.

   ```bash
   <copy>
   git clone -b 22.7.2 --single-branch https://github.com/oracle/microservices-datadriven.git
   </copy>
   ```
 
     You should now see the directory `microservices-datadriven` in the directory that you created.

## Task 9: Start the Setup

1. Execute the following sequence of commands to start the setup.  

    ```bash
    <copy>
    source microservices-datadriven/workshops/dcms-oci/source.env
    setup
    </copy>
    ```

    > **Note:** Cloud shell may disconnect after a period of inactivity. If that happens, you can reconnect and then run the command to resume the setup.

    The setup process will typically take around 20 minutes to complete.  

2. (Conditional) The setup may ask you to confirm that there are no other un-terminated OKE clusters exist in your tenancy:

    ```bash
    You are limited to only one OKE cluster in this tenancy. This workshop will create one additional OKE cluster and so any other OKE clusters must be terminated.
    Please confirm that no other un-terminated OKE clusters exist in this tenancy and then hit [RETURN]?
    ```

    To confirm that there are no other un-terminated OKE clusters, click the Navigation Menu in the upper left of Oracle Cloud Console, navigate to Developer Services and click on Kubernetes Clusters (OKE).

    ![Oracle Cloud Infrastructure Developer Services Screen](images/dev-services-menu.png " ")

    ![Navigate to Oracle Cloud Infrastructure OKE Screen](images/get-oke-info.png " ")

    If there are any un-terminated OKE clusters, please delete them and continue with setup steps.

    ![Review Oracle Cloud Infrastructure Kubernetes Cluster Details](images/get-oke-details.png " ")

3. The setup will create the workshop resources in a compartment within your tenancy. You will be prompted to enter the compartment information.  You may choose to use an existing compartment or create a new one.

    To use an existing compartment, enter the OCID of the compartment.

    To create a new compartment, enter the name you would like to use.

    If you chose to create a new compartment, you will also be asked to enter the OCID of the parent compartment in which the new compartment is to be created.  Enter the parent compartment OCID or hit enter to use the root compartment of your tenancy.

    To get the OCID of an existing compartment, click on the Navigation Menu in the upper left of Cloud Console, navigate to **Identity & Security** and click on **Compartments**:

    ![Navigate to Oracle Cloud Infrastructure Compartments Screen](images/compartments.png " ")

    Click on the link in the **OCID column** of the compartment, and click **Copy**:

    ![Obtain Oracle Cloud Infrastructure Compartment OCID](images/compartment-ocid.png " ")

4. The setup will ask for you to enter your user's OCID.  

    Be sure to provide the user OCID and not the user name or tenancy OCID. The user OCID will look something like:

    `ocid1.user.oc1....<unique_ID>`

    > **Note:** Notice the format of "ocid1.user" prefix.

    Locate your menu bar in the Cloud Console and click the person icon at the far upper right. From the drop-down menu, select your user's name. Note, sometimes the name link is missing in which case select the **User Settings** link. Do not select the **Tenancy** link.

    ![Obtain Oracle Cloud Infrastructure User OCID](images/get-user-ocid.png " ")

    Click Show to see the details and then click Copy to copy the user OCID to the clipboard, paste in the copied data in console.

    ![Oracle Cloud Infrastructure User OCID Example](images/example-user-ocid.png " ")

5. (Conditional) The setup will automatically upload an Auth Token to your tenancy so that docker can log in to the Oracle Cloud Infrastructure Registry. If there is no space for a new Auth Token, the setup will ask you to remove an existing token to make room. This is done through the Oracle Cloud Console.

    Locate your menu bar and click the person icon at the far upper right. From the drop-down menu, select your user's name.

    ![Obtain Oracle Cloud Infrastructure User Name](images/get-user-ocid.png " ")

    On the User Details console, click Auth Tokens under Resources.

    ![Review Oracle Cloud Infrastructure User Auth Token Screen](images/auth-token.png " ")

    On the Auth Tokens screen, highlight the existing token(s) and delete by clicking Delete from the drop-down menu.

    ![Delete Oracle Cloud Infrastructure User Auth Token](images/delete-auth-token.png " ")

6. The setup will ask you to enter an admin password for the databases. For simplicity, the same password will be used for both the order and inventory databases. Database passwords must be 12 to 30 characters and contain at least one uppercase letter, one lowercase letter, and one number. The password cannot contain the double quote (") character or the word "admin".

7. The setup will also ask you to enter a UI password that will be used to enter the microservice frontend user interface. Make a note of the password as you will need it later.  The UI password must be 8 to 30 characters.

8. The status of the builds can be monitored with this command:

    ```bash
    <copy>
    status
    </copy>
    ```

9. Upon grabdish infra setup completion, you can start the setup for CI/CD components. Using your existing Cloud Shell connection, run the following command to start the setup:  

    ```bash
    <copy>
    cd ~/grabdish
    source microservices-datadriven/workshops/dcms-cicd/source.env
    jenkins-setup
    </copy>
    ```

    > **Note:** Cloud shell may disconnect after a period of inactivity. If that happens, you can reconnect and then run the command to resume the setup.

10. The setup will ask for you to enter your region value (conditional), a value for deployment type and create a password for Jenkins admin user and run type.

    * (Conditional) Please enter the name of the region that you are connected to: `OCI_REGION`
    * Please select Jenkins deployment type: `1`
    * Enter the password to be used for Jenkins Console admin user login: `<ADMIN_PASSWORD>`

    The setup process will typically take around 5 minutes to complete.

## Task 10: Monitor the Setup

The setup will provision the following resources in your tenancy:

| Resources              | Oracle Cloud Console Navigation                                               |
|------------------------|-------------------------------------------------------------------------------|
| Object Storage Buckets | Storage --> Object Storage --> Buckets                                        |
| Databases (2)          | Oracle Database -- Autonomous Database -- Autonomous Transaction Processing   |
| OKE Cluster            | Developer Services -- Containers -- Kubernetes Clusters (OKE)                 |
| Registry Repositories  | Developer Services -- Containers -- Container Registry                        |

1. You should monitor the setup progress from a different browser window or tab.  It is best not to use the original browser window or not to refresh it as this may disturb the setup or you might lose your shell session. Most browsers have a "duplicate" feature that will allow you to quickly created a second window or tab.

    ![Duplicate Browser](images/duplicate-browser-tab.png " ")

2. From the new browser window or tab, navigate around the console to view the resources within the new compartment. The table includes the console navigation for each resource. For example, here we show the database resources:

    ![Database Resources](images/db-example.png " ")

    > **Note:** Cloud Shell sessions have a maximum length of 24 hours, and time out after 20 minutes of inactivity.

## Task 9: Complete the Setup

1. The setup will provide a summary of the setup status as it proceeds. Once everything has completed you will see the message: **SETUP COMPLETED**.

2. While the background setup jobs are running you can monitor their progress with the following command.

    ```bash
    <copy>
    ps -ef
    </copy>
    ```

3. You can monitor log files located in the $DCMS_CICD_LOG_DIR directory.

    ```bash
    <copy>
    ls -al $DCMS_CICD_LOG_DIR
    </copy>
    ```

    Once the setup has completed you are ready to [move on to Lab 2](#next).

    > **Note:** Builds may continue to run even after the setup has completed.

4. The status of the builds can be monitored with this command:

    Grabdish:

    ```bash
    <copy>
    status
    </copy>
    ```

    CI/CD:

    ```bash
    <copy>
    jenkins-status
    </copy>
    ```

 You may now **proceed to the next lab.**

## Acknowledgements

* **Authors** - Irina Granat, Consulting Member of Technical Staff, Oracle MAA and Exadata; Paul Parkinson, Developer Evangelist; Richard Exley, Consulting Member of Technical Staff, Oracle MAA and Exadata
* **Last Updated By/Date** - Irina Granat, June 2022
