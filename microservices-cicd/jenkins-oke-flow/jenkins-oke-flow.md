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

As this is a demonstration of Jenkins/GitHub integration for CI/CD, **you must use your own GitHub account to run it. Please fork or copy the microservices repository into your own GitHub account before continuing https://github.com/oracle/microservices-datadriven**.

## Task 1: CI/CD Workflow Walkthrough

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
