# Integrate GitHub with Jenkins for Liquibase with SQLcl Use Case

## Introduction

This lab will demonstrate how to integrate Jenkins and GitHub Repository using Github Branch Source Plugin for Liquibase with SQLcl Use Case.

Estimated Time:  10 minutes

Watch the video below for a quick walk-through of the lab.
[Integrate GitHub with Jenkins for Liquibase with SQLcl Use Case](videohub:1_sbsuqto9)

### Objectives

* Complete GitHub Configuration
* Complete Jenkins Configuration
* Configure a Multibranch Pipeline
  
### Prerequisites

* This lab presumes you have already completed Lab 1 and all the required resources like Oracle ATP database, Jenkins and Kubernetes were successfully installed.
* As this is a demonstration of Jenkins/GitHub integration for CI/CD, **you must use your own GitHub account to run it.** We assume you completed this step in Setup lab.

## Task 1: Check Jenkins Console Access Details

1. Navigate to Oracle Cloud Console and click the Navigation Menu in the upper left, navigate to Compute and select Instances.

   ![Instances](images/oci-instances.png " ")

2. Check Jenkins VM Public IP and, copy and record it in your note for later configuration steps.

   ![Jenkins IP](images/jenkins-vm-ip.png " ")
   
## Task 2: Generate the GitHub Personal Access Token (PAT)

1. Login into your GitHub account your GitHub Account and click on your profile photo in the upper-right corner, then click Settings.

   ![GitHub Settings](images/repo-settings.png " ")

2. In the left sidebar, scroll down and click on Developer settings.

   ![GitHub Developer Settings](images/repo-dev-sets.png " ")

3. Under Developer Settings, navigate to Personal access tokens, and click on Generate new token.

   ![GitHub Repo PAT](images/repo-gen-token.png " ")

   In creating a new personal access token, you can add a Note to help you remember what the token is for.

   ![GitHub Repo PAT](images/repo-pat.png " ")

   ![GitHub Repo PAT](images/repo-gen-pat.png " ")

   > **Note:** Do select `repo` option for scope.

4. Personal access tokens function like ordinary OAuth access tokens. They can be used instead of a password for Git over HTTPS. In creating a new personal access token, you can add a Note to help you remember what the token is for. For example, you can set:

    ```bash
    <copy>
    repo-access
    </copy>
    ```

5. At the bottom of the page, click Generate token to complete the step and generate the token.

   > **Note:**  Copy and record your GitHub Personal Access Token in your note for later configuration steps.

## Task 3: Create the GitHub App

1. In your Github account, navigate to Settings -> Developer settings -> GitHub Apps.

   ![GitHub Settings](images/repo-settings.png " ")

2. In the left sidebar, scroll down and click on Developer setting -> New Github App. 

   ![GitHub Developer Settings](images/repo-dev-sets.png " ")

3. Select `New GitHub App` (Confirm Password, if prompted).

   ![New GitHub App](images/new-githubapp.png " ")

4. Register a new GitHub Application and, unless other specified below, leave the defaults.

   1. Set GitHub App name to `Jenkins - < Github Account Name >`

   2. Update Homepage URL with link to your GitHub Page
     
      ![GitHub Name](images/githubapp-name-url.png " ")

   3. Update Webhook URL with link to your Jenkins Server

      > **Note:** Replace `jenkins.example.com` with public IP address of the Jenkins Compute Instance recorded from Task 1 above. **The trailing slash is important** (for example: `http://XXX.XX.XX.XXX/github-webhook/`).
     
      ![Repository Permissions](images/webhook-url.png " ")

   4. Update the following Repository permissions:

     * Commit statuses - Read and Write

     * Contents: Read-only

       ![Repository Permissions](images/repo-perm1.png " ")

     * Pull requests: Read-only

       ![Repository Permissions](images/repo-perm2.png " ")

   5. Set Subscribe to events options and Select All

      ![Events](images/events-subscribe.png " ")

   6. For `Where can this GitHub App be installed?` setting, check `Only on this account` option and click on `Create GitHub App`

      ![Save GitHubApp](images/save-githubapp.png " ")

      > **Note:** Record the App ID  in your note for later configuration steps.

5. Scroll down to `Private keys` and generate a private key by clicking `Generate a private key` button (will be prompted to save, save it to a safe location).

   ![Webhook URL](images/generate-privatekey.png " ")

6. Scroll back up the page and click `Install App` and click `Install` next to your GitHub account name.

   ![Install GitHubApp](images/install-githubapp.png " ")

   On the next screen, choose `Only select repositories` options and pick `<your GitHub Repository Name>/microservices-datadriven` from the drop-down list.

   ![Install GitHubApp Repo](images/install-github-repo.png " ")

7. On the next screen, click "App settings" and record the App ID for later use.

## Task 4: Convert the Private Key

1. Jenkins uses the private key which was saved in the previous step, convert it using the following command (replace the key name with the key name you saved):

    ```bash
    <copy>
    openssl pkcs8 -topk8 -inform PEM -outform PEM -in <key-in-your-downloads-folder.pem> -out converted-github-app.pem -nocrypt
    </copy>
    ```

    > **Note:** If openssl is not installed on your local machine, you can use OCI Cloud Shell to convert.

2. Open Cloud Shell from the OCI Console and change the directory to your home directory.

   ![Oracle Cloud Infrastructure Cloud Shell Opening](images/open-cloud-shell.png " ")

3. Either drag and drop the file from your local machine into the Cloud Shell window, or use the `Upload` button from the Cloud Shell hamburger menu.

   ![Cloud Shell File Upload](images/cloud-shell-file.png " ")

4. Run the above openssl command in the Cloud Shell - it will create a converted private key converted-github-app.pem in your home directory you can use later for configuring Jenkins.

## Task 5: Add Jenkins Credentials

1. Open a new browser tab and login into your Jenkins console as ADMIN user using Jenkins Public IP from Task 1 and the password you supplied during Jenkins setup run: `https://jenkins.example.com`

   ![Jenkins Login](images/jenkins-login.png " ")

2. Navigate to the Jenkins credentials store to create credentials

   1. From the Home page, click on `Manage Jenkins`.

      ![Jenkins Credentials](images/jenkins-creds.png " ")

   2. From the Manage Jenkins page, Under Security, click `Manage Credentials`.

   3. Hover over (`global`), the domain for the Jenkins Store (under Stores scoped to Jenkins).

   4. Click on the dropdown.

   5. Click on `Add Credentials` and add the credentials for GitHub App.

      ![Jenkins Credentials](images/jenkins-store.png " ")

      ![GitHubApp Demo Credentials](images/githubapp-demo-creds.png " ")

     * Kind: `GitHub App`
     * ID: `GitHubAppDemo`
     * App ID: < App ID > (Enter App ID recorded above in the Task 3: Create the GitHub App )
     * Key: < Contents of converted-github-app.pem created above >

3. Click `Test Connection` which should be successful.

   ![GitHubAppDemo Connection Test](images/githubapp-creds-test.png " ")

4. Click `OK`.

## Task 6: Add Database Credentials

1. Navigate to the Jenkins credentials store to create credentials

   1. From the Home page, click on `Manage Jenkins`.

      ![Jenkins Credentials](images/jenkins-creds.png " ")

   2. From the Manage Jenkins page, Under Security, click `Manage Credentials`.

   3. Hover over (`global`), the domain for the Jenkins Store (under Stores scoped to Jenkins).

   4. Click on the dropdown.

   5. Click on `Add Credentials` and add the database credentials.

      ![Jenkins Credentials](images/jenkins-store.png " ")

      ![Database Credentials](images/db-creds.png " ")

     * Kind: `Username with password`
     * Username: `ADMIN`
     * Password: `<Password for ADB Admin Account>`
      > **Note:** this is the DB password you supplied and recorded in Lab 1 during infra setup
     * ID: `ADB_ADMIN`

2. Click `Create`.

## Task 7: Add Global Variable for Database

1. Sign in to OCI Console with Oracle Cloud credentials and navigate to Oracle Database -> Autonomous Database

   ![OCI DB](images/oci-dbs.png " ")

2. Click on "DB2" and record the value of the "Database name:"

   ![DB Name Comp](images/db-comp.png " ")

   ![DB Name](images/db-name.png " ")

3. Back, on Jenkins dashboard, navigate to `Manage Jenkins` and click on `Configure System`

   ![Jenkins System Config](images/jenkins-system-config.png " ")

4. Scroll down to "Global Properties", check the "Environment variables" box, and click "Add"

   ![Jenkins Global Properties](images/jenkins-global-props.png " ")

    * Name:  ADB_NAME
    * Value: `<DB Name as found in OCI>`

5. Click "Apply"

## Task 8: Add a Multibranch Pipeline

1. Navigate back to Jenkins dashboard, click on `New Item` and enter the name for the item: `Demonstration`.

2. Select `Multibranch Pipeline` and click `OK`.

     ![New Item](images/jenkins-new-item.png " ")

3. Configure the following.

     ![Demo Item Configuration](images/jenkins-demo-item.png " ")

     * Display Name: `Demonstration`
     * Branch Source: `GitHub`
     * Credentials: `GitHubAppDemo`
     * Repository HTTPS URL: < Link to GitHub Repo; example: `https://github.com/<your GitHub Repository Name>/microservices-datadriven`

4. Click `Validate` under the `Repository HTTPS URL` field.

5. Response should be: `Credentials ok. Connected to <GitHub Repo>.`

6. Under "Build Configuration" update:
     * Script Path: workshops/dcms-cicd/jenkins/jenkinslab2/Jenkinsfile

7. Scroll down and `Save`.

8. A `Scan Repository Log` screen will appear with `Finished: SUCCESS`.

You may now **proceed to the next lab.**.

## Acknowledgements

* **Authors** - John Lathouwers, Developer Evangelist; Irina Granat, Consulting Member of Technical Staff, Oracle MAA and Exadata
* **Last Updated By/Date** - Irina Granat, July 20th, 2022
