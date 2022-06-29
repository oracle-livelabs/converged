# Build CI/CD Pipeline by Using Jenkins and Oracle Cloud Infrastracture

## Introduction

This lab will demonstrate how to integrate Jenkins with Oracle Kubernetes and build a pipeline.

GitHub provides web hook integration, so Jenkins starts running automated builds and tests after each code check-in. A sample web application Grabdish is modified and re-deployed as part of CI/CD pipeline, which end users can access from the Container Engine for Kubernetes cluster. 

Estimated Time: 20 minutes

### Objectives

* Execute GitHub Configuration
* Execute Jenkins Configuration
* Configure a Pipeline
* CI/CD Workflow Walkthrough
  
### Prerequisites

This lab presumes you have already completed the earlier labs.

As this is a demonstration of Jenkins/GitHub integration for CI/CD, you must use your own GitHub account to run it. Please fork or copy the microservices repository into your own GitHub account before continuing https://github.com/oracle/microservices-datadriven.

## Task 1: Configure Jenkins Pipeline

1. Retrieve Credentials and Setup Accounts

  - A service account is needed to allow Jenkins to update the grabdish kubernetes cluster. Run apply on the service-account.yaml. Connect to cloud shell and run the following statement:
    
     ```
     <copy>
     kubectl apply -f $DCMS_CICD_SETUP_DIR/kubernetes/service-account.yaml
     </copy>
     ```

   - Retrieve secret and create Jenkins credentials:

     ```
     <copy>
     kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep kube-cicd | awk '{print $1}')
     </copy>
     ```
     - Copy token from the result above

2. Connect to Jenkins Console

    - Retrieve Jenkins IP address - you can manually retrieve the IP address through the console:
    - Check the public VM's public IP otherwise
    - Check the Load Balancer jenkins-load-balancer's public IP if a load balancer was provisioned. 
   - Login into Jenkins console. The username defaults to admin, then provide the jenkins-password you supplied earlier.

3. Add Jenkins Credentials
  Select Secret Text
  Paste the secret
  Add and copy the credentials ID
  Retrieve docker auth token through logs

4. For the Jenkins credentials
  Select Username with Password
  Paste auth token as password
  Set Username
  Add and copy the credentials ID

5. Add Maven tool configuration
  Go to Manage Jenkins > Global Tools Configuration
  Under Maven, click Maven Installations... and Add Maven with name maven3
  Press Save

6. Create new pipeline
  Create a new pipeline
  Under Build Triggers, Select GitHub hook trigger for GITScm polling
  Copy and Paste Jenkinsfile from the repository workshops/dcms-cicd/jenkins/Jenkinsfile
  Supply the missing values under environment
  Add GitHub WebHook
  On GitHub settings - add a WebHook with the IP address of Jenkins console: http://<ip-address>/github-webhook/


## Task 2: CI/CD Workflow Walkthrough

1. Connect to cloud shell
 kubectl get pods --all-namespaces
 kubectl get services --all-namespaces

@cloudshell:grabdish (us-sanjose-1)$ kubectl get pods --all-namespaces

 You are ready to access the frontend page. Open a new browser tab and enter the external IP URL:
 https://<EXTERNAL-IP>
 Note: For convenience a self-signed certificate is used to secure this https address and so it is likely you will be prompted by the browser to allow access.
 You will be prompted to authenticate to access the Front End microservices. The user is grabdish and the password is the one you entered in Lab 1.
 Make Application Changes (DevOps experience)
  Open Visual Studio Code
  Navigate to grabdish/frontend-helidon/...spatial.html
 <p class="oj-text-color-secondary oj-typography-subheading-xs">Data-driven Microservices with Converged Oracle Databases</p>
 </div>
 
2. Update the grabdish/frontend-helidon/...version.txt
3. Save all
4. Open Github Desktop
5. Check Repository Setting - https://github.com/renagranat/microservices-datadriven.git
6. Save and Push to github Repository
7. Check Jenkins pipeline, observe Jenkins job created – review the log

  
You may now **proceed to the next lab.**.

## Acknowledgements
* **Authors** - Irina Granat, Consulting Member of Technical Staff, Oracle MAA and Exadata
* **Last Updated By/Date** - Irina Granat, June 2022
