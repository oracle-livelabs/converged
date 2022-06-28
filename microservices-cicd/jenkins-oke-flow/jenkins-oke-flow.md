# Diagnosability and Debugging Use Case

## Introduction

This lab will show you how to determine when an exception/failure occurs in the system and allow you to diagnose and debug the issue.

Estimated Time: 20 minutes

### Objectives

-   Observe propagation health status
-   Induce propagation failure and notice `DOWN` health status.
-   Re-enable propagation and notice `UP` health status. 
  
### Prerequisites

This lab presumes you have already completed the earlier labs.

## Task 1: Jenkins Configuration

1. Retrieve Credentials and Setup accounts

  • A service account is needed to allow Jenkins to update the grabdish kubernetes cluster. Run apply on the service-account.yaml
 kubectl apply -f $DCMS_CICD_SETUP_DIR/kubernetes/service-account.yaml`
 • Retrieve secret and create Jenkins credentials
 kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep kube-cicd | awk '{print $1}')
 • Copy Token from the result above

2. Connect to Jenkins console

 • Retrieve Jenkins IP address - you can manually retrieve the IP address through the console:
 Check the public VM's public IP otherwise
 Check the Load Balancer jenkins-load-balancer's public IP if a load balancer was provisioned. 
 • Login into Jenkins console. The username defaults to admin, then provide the jenkins-password you supplied earlier.

3. For the Jenkins credentials
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


## Task 2: AppDev CI/CD Pipeline Walkthrough

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
