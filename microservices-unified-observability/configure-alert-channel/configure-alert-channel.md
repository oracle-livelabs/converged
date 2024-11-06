# Configure Alert Channel

## Introduction

This lab will show you how to setup alert channels in order to be notified when certain monitoring criteria are hit.


Estimated Time:  5 minutes


### Objectives

-   Setup alert channel to receive these notifications. 
  

### Prerequisites

- This lab presumes you have already completed the earlier labs.

## Task 1: Create a Slack account and obtain the Webhook for it.

*The following flow is essentially the same as that found in the Grafana docs found 
    [here](https://grafana.com/blog/2020/02/25/step-by-step-guide-to-setting-up-prometheus-alertmanager-with-slack-pagerduty-and-gmail/). 
    
* Note that the concept is the same for all channel types such as Prometheus Alert Manager, Email, etc. Slack is used here just as an example. 
    
1. If you do not have admin privileges on a Slack workspace, create a workspace using the simple directions found [here](https://slack.com/create#email).  The following are some screen shot examples of the process.

     ![Slack Channel Setup 1](images/slackalertchannelsetup1.png " ")
     ![Slack Channel Setup 2](images/slackalertchannelsetup2.png " ")
     ![Slack Channel Setup 3](images/slackalertchannelsetup3.png " ")
     ![Slack Channel Setup 4](images/slackalertchannelsetup4.png " ")

2.  Obtain the Webhook URL from Slack.

     In Slack, select the `Settings & administration` menu and `Manage apps`.

     ![Slack Manage Apps](images/slack-manageapps.png " ")

     Search for `Incoming WebHooks` and select it.

     ![Slack Search Webhooks](images/searchincomingwebhooks.png " ")
     
     Click the `Add To Slack` button
     
     ![Add To Slack](images/addtoslack.png " ")
     
     Select `#general` from the `Post to Channel` drop down and click the `Add incoming WebHooks integration` button
     
     ![Add Webhook](images/addincomingwebhooksintegration.png " ")
     
     Copy the `Webhook URL` 
     
     ![Copy Webhook URL](images/copythewebhookurl.png " ")
     

## Task 2: Configure Contact Points for Slack notifications

1. Add a Slack Notification Contact Point in Grafana and configure it with the webhook URL.

   Select the alarm bell icon on the left-hand side of Grafana and select `Contact points` under the `Alerting` menu.

     ![Contact Points](images/contactpoints.png " ")

   Click `New contact point`

     ![Click Add Contact Point](images/newcontactpoint.png " ")
     
   Name the channel, select `Slack` from the dropdown 
   
     ![New Contact Point](images/contactpointtypeslack.png " ")
     
   Paste the Webhook URL in the appropriate textfield. 
   
     ![Enter WebHook](images/webhookurlinslack.png " ")

   Save Contact Point.

2. Test Slack contact point

      Click `Send test notification` button and notice test notification sent to Slack.
     
     ![Test Alert](images/testalertinslack.png " ")

3. Set Slack as default contact point

   On the main `Alerting` page, select the `Notification polices` tab, select `Slack contact point` in the  `Default contact point` drop down list, and click `Save` button.

   ![Test Alert](images/notificationpolicies.png " ")
    
You may now **proceed to the next lab.**.

## Learn More

* [Oracle Database](https://www.oracle.com/database)

## Acknowledgements
* **Author** - Paul Parkinson, Architect and Developer Advocate;
* **Last Updated By/Date** - Paul Parkinson, 2024
