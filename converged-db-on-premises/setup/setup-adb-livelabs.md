# Load ADB and Start Application

## Introduction
In this lab you will run a script to import data from Object Store into your Autonomous Database using Oracle Data Pump.  Your data was previously in various other types of databases.  In this lab we will show you how to centralize your data onto one database that your application can read from.

*Estimated time:* 20 Minutes

Watch the video below for an overview of Lab 3: Load ADB and Start Application
[](youtube:S3jL1y-ZAbc)

### Objectives
- Create auth token and Oracle Wallet 
- Login to SQL Developer
- Load ATP Instance with eShop data
- Connect application to ADB

### Prerequisites
- Lab: Generate SSH Keys
- Lab: Verify Setup of Compute Instance

## Task 1: Create Oracle Wallet
Verify for ATP Instance created by LiveLabs Green Button by selecting the allocated compartment, region, and workload type ATP, This information is also available in LiveLabs My Reservation screen as seen in Lab 2

![](./images/checkforatp.png " ")

There are multiple ways to create an Oracle Wallet for ADB.  We will be using Oracle Cloud Shell as this is not the focus of this workshop.  To learn more about Oracle Wallets and use the interface to create one, please refer to the lab in this workshop: [Analyzing Your Data with ADB - Lab 6](https://apexapps.oracle.com/pls/apex/dbpm/r/livelabs/view-workshop?p180_id=553)

1.  Before starting this section make sure you have exited out of your compute instance and are back in your cloudshell home.  
   
      ````
      exit
      ````
      ![](./images/em-cloudshell-exit-ssh.png " ")

2. Select the hamburger menu and **Autonomous Transaction Processing**.

      Copy the OCID of Autonomous ATP by clicking on the Display Name link  

      ![](./images/autonomous-atp-ocid.png " ")

1.  Use your autonomous\_database\_ocid to create the Oracle Wallet. You will be setting the wallet password to the same value as the ADB admin password for ease of use. This is not a recommended practice and just used for the purposes of this lab. *WElcome123##*. Fill in the autonomous database ocid that is listed in the output section of your terraform.
   
      ````
      <copy>
      cd ~
      oci db autonomous-database generate-wallet --password WElcome123## --file converged-wallet.zip --autonomous-database-id </copy> ocid1.autonomousdatabase.oc1.iad.xxxxxxxxxxxxxxxxxxxxxx
      ````

      ![](./images/generate-wallet2.png " ")

2.  The wallet file will be downloaded to your cloud shell file system in /home/yourtenancyname

3.  Enter the list command in your cloudshell below to verify the *converged-wallet.zip* was created
   
      ````
      ls
      ```` 

4.  Transfer this wallet file to your application compute instance.  Replace the instance below with your instance 

    ````
    sftp -i ~/.ssh/<sshkeyname> opc@<Your Compute Instance Public IP Address> <<< $'mput converged-wallet*' 
    ````
      ![](./images/converged-wallet.png " ")

## Task 2: Create Auth Token
There are multiple ways to create an Oracle Wallet for ADB.  We will be using Oracle Cloud Shell as this is not the focus of this workshop.  To learn more about Oracle Wallets and use the interface to create one, please refer to the lab in this workshop: [Analyzing Your Data with ADB - Lab 6](https://apexapps.oracle.com/pls/apex/dbpm/r/livelabs/view-workshop?p180_id=553)

1.  Click on the person icon in the upper right corner.
2.  Select **User Settings**
      ![](./images/select-user.png " ")

3.  Under the **User Information** tab, click the **Copy** button to copy your User OCID.
      ![](./images/copy-user-ocid.png " ")

4.  Create your auth token using the command below substituting your actual *user id* for the userid below.
   
      ````
      <copy>
       oci iam auth-token create --description ConvergedDB --user-id </copy> ocid1.user.oc1..axxxxxxxxxxxxxxxxxxxxxx
      ````
      ![](./images/token.png " ")

5.  Identify the line in the output that starts with "token".
6.  Copy the value for the token somewhere safe, you will need it for the next step.


## Task 3: Connect to SQL Developer and Create Credentials
1.  Go back to your ATP screen by clicking on the Hamburger Menu -> **Autonomous Transaction Processing**
      ![](https://oracle-livelabs.github.io/common/images/console/database-atp.png " ")

2.  Click on the **Display Name** to go to your ADB main page.
      ![](./images/display-name.png " ")

3.  Click on the **Tools** tab, select **SQL Developer Web**, a new browser will open up
      ![](./images/sql.png " ")

4.  Login with the *admin* user and the password *WElcome123##* 
      ![](./images/sql-signin.png " ")

5.  In the worksheet, enter the following command to create your credentials.  Replace the password below with your token. Make sure you do *not* copy the quotes.
   
    ````
    <copy>
    begin
      DBMS_CLOUD.create_credential(
        credential_name => 'DEF_CRED_NAME',
        username => 'admin',
        password => '************REPLACE THIS WITH TOKEN VALUE*****************'
      );
    end;
    /
    </copy>
    ````
    ![](./images/sql-run.png " ")

## Task 4:  Load ATP Instance with Application Schemas
1. Go back to your cloud shell and start the cloud shell if it isn't already running
2. Enter the command below to login to your compute instance.    

    ````
    ssh -i ~/.ssh/<sshkeyname> opc@<Your Compute Instance Public IP Address>
    ````
      ![](./images/ssh.png " ")

3. Execute the following commands on your compute instance to move and extract your wallet file in the /home/oracle/wallet directory. This should run as the *opc* user. 

      ````
      <copy>
      sudo cp converged-wallet.zip /home/oracle
      sudo su - oracle
      mkdir wallet
      cd wallet
      unzip ../converged-wallet*
      </copy>
      ````
      ![](./images/sudo.png " ")

4. Make sure you are the *oracle* user, run the next command to set your oracle environment.  If you are not, run the sudo su - oracle command to become oracle.  When prompted enter *convergedcdb*

      ````
      <copy>. oraenv</copy>
      ORACLE_SID = [oracle] ? convergedcdb
      ````

      ![](./images/oraenv.png " ")
   
5.  Run this command to download the .sh script that will load your ADB.

      ````
      <copy>
      cd $HOME
      pwd
      wget https://c4u04.objectstorage.us-ashburn-1.oci.customer-oci.com/p/EcTjWk2IuZPZeNnD_fYMcgUhdNDIDA6rt9gaFj_WZMiL7VvxPBNMY60837hu5hga/n/c4u04/b/livelabsfiles/o/developer-library/load-atp.sh
      </copy>
      ````

6.   Run the load script passing in two arguments, your admin password and the name of your ATP's database's name.

      ![](./images/adb-db-name.png " ")

      This script will import all the data into your ATP instance for your application and set up SQL Developer Web for each schema.  This script runs as the opc user.  Your ATP name should be the name of your ATP's database's instance name like *cvgad01*.  This load script takes approximately 2 minutes to run. 
   
      ``` 
      <copy> 
      chmod +x load-atp.sh
      ./load-atp.sh WElcome123## <database name> 2>&1 > load-atp.out</copy>
     
      ```
      ![](./images/load-atp.png " ")

7.  As the script is running, you will note several failures on the DBA role. The DBA role is not available in Autonomous Database, the DWROLE is used instead. This error is expected. 
   
8.  Test to ensure that your data has loaded by logging into SQL Developer Web and issuing the command below. *Note* The Username and Password for SQL Developer Web are admin/WElcome123##. You should get 1 row.  

      ````
      <copy>
      export TNS_ADMIN=/home/oracle/wallet
      sqlplus admin/WElcome123##@<database name>_high
      select count(*) from appnodejs.orders;
      </copy>
      ````
      ![](./images/export-tns.png " ")

9. Exit the sql prompt

    ````
    exit
    ````
    ![](./images/exit.png " ")

## Task 5:  Connect Docker Instance to ATP

1.  Run the script env\_setup\_script\_adb.sh, this will download the docker application from OKE (Oracle Kubernetes engine) start the eshop application. This script will take 2-5 minutes to run.

      ````
      <copy>cd /u01/script
      wget https://c4u04.objectstorage.us-ashburn-1.oci.customer-oci.com/p/EcTjWk2IuZPZeNnD_fYMcgUhdNDIDA6rt9gaFj_WZMiL7VvxPBNMY60837hu5hga/n/c4u04/b/livelabsfiles/o/developer-library/env_script_setup_atp.sh
      chmod +x env_script_setup_atp.sh
      ./env_script_setup_atp.sh</copy>
      ````
   ![](./images/app-available.png " ")

2.  Verify that your two applications in your docker container are now in ONLINE status.

You now have a docker container running the eShop application and all the data in multiple schemas in an autonomous database across multiple modalities, JSON, Analytical data, XML, Spatial and Graph in an autonomous database.  A true converged database.

You may now [proceed to the next lab](#next).

## Acknowledgements
* **Authors** - Kay Malcolm, Ashish Kumar
* **Contributors** - Ashish Kumar, Madhusudhan Rao, Yaisah Granillo, Kay Malcolm
* **Last Updated By/Date** - Kamryn Vinson, January 2021


