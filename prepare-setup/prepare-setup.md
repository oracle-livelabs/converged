# Prepare Setup

## Introduction
This lab will show you how to download the Oracle Resource Manager (ORM) stack zip file needed to setup the resource needed to run this workshop. This workshop requires a compute instance and a Virtual Cloud Network (VCN).

*Estimated Lab Time:* 15 minutes

### Objectives
- Download ORM stack
- Configure an existing Virtual Cloud Network (VCN)

### Prerequisites
This lab assumes you have:
- An Oracle Free Tier or Paid Cloud account

## Task 1: Download Oracle Resource Manager (ORM) stack zip file
1.  Click on the link below to download the Resource Manager zip file you need to build your environment:

<if type="modernize">
    - [cvgdb-mkplc-modernize.zip](https://objectstorage.us-ashburn-1.oraclecloud.com/p/xBVHfPMqJXoE6K-e1xR_8wRkhSsLfm-WHzDDyk66Nqi60MTz-IQog1mzu-tIFQiI/n/c4u02/b/hosted_workshops/o/stacks/cvgdb-mkplc-modernize.zip)
</if>
<if type="modernize-coherence">
    - [cvgdb-mkplc-modernize-coherence.zip](https://objectstorage.us-ashburn-1.oraclecloud.com/p/IdaKhqVfQWFPygcM39qupjAdzUV-cn1hwAlenS6xxNUDuQygR9yDuwe3DgBbXUSK/n/c4u02/b/hosted_workshops/o/stacks/cvgdb-mkplc-modernize-coherence.zip)
</if>
<if type="modernize-helidon">
    - [cvgdb-mkplc-modernize-helidon.zip](https://objectstorage.us-ashburn-1.oraclecloud.com/p/W_fB-NuyMLp1RZAtbaCKsA3s2y-SkS5DBMIkNTUIIvUvGa09sNTyKigyO2TInX7S/n/c4u02/b/hosted_workshops/o/stacks/cvgdb-mkplc-modernize-helidon.zip)
</if>
<if type="on-premises">
    - [cvgdb-mkplc-on-premises.zip](https://objectstorage.us-ashburn-1.oraclecloud.com/p/U5e61NYK9vz-WCQWnV-vKaXLfrIuuB-uaG3eE36H2hX3lviHw8CKAxBhEKzrRpA_/n/c4u02/b/hosted_workshops/o/stacks/cvgdb-mkplc-on-premises.zip)
</if>
<if type="with-ml">
    - [cvgdb-mkplc-with-ml.zip](https://objectstorage.us-ashburn-1.oraclecloud.com/p/jnn8XeLNIli0IJvHnf9Olg624ysQefA3AqM1J4GNDjhxzQjmhFrfLL7MdGOa0-tF/n/c4u02/b/hosted_workshops/o/stacks/cvgdb-mkplc-with-ml.zip)
</if>
<if type="with-oas">
    - [cvgdb-mkplc-with-oas.zip](https://objectstorage.us-ashburn-1.oraclecloud.com/p/NW10k42LvJ1aUuy4L5ZTEeuN4J2so6UeMN56VK468t3s5zpMAJrREKJZAeTlbztr/n/c4u02/b/hosted_workshops/o/stacks/cvgdb-mkplc-with-oas.zip)
</if>
<if type="with-wls">
    - [cvgdb-mkplc-with-wls.zip](https://objectstorage.us-ashburn-1.oraclecloud.com/p/jASmvjzWmFsN9DK7igzPPFircJXfLIIACbYzxYHVq_QJmqXjehcKD-WlwNixOomS/n/c4u02/b/hosted_workshops/o/stacks/cvgdb-mkplc-with-wls.zip)
</if>

2.  Save in your downloads folder.

We strongly recommend using this stack to create a self-contained/dedicated VCN with your instance(s). Skip to *Step 3* to follow our recommendations. If you would rather use an exiting VCN then proceed to the next step as indicated below to update your existing VCN with the required Egress rules.

## Task 2: Adding Security Rules to an Existing VCN   
This workshop requires a certain number of ports to be available, a requirement that can be met by using the default ORM stack execution that creates a dedicated VCN. In order to use an existing VCN the following ports should be added to Egress rules

| Port           |Description                            |
| :------------- | :------------------------------------ |
| 22             | SSH                                   |
| 80             | NGINX proxy for NoVNC                 |
| 1521           | Database Listener                     |
| 3000           | Node JS Application                   |
| 3001           | Node JS Application                   |
| 3003           | Node JS Application                   |
| 6080           | noVNC Remote Desktop                  |
| 7007           | Graph UI                              |
| 7101           | WebLogic Admin Console                |
| 7102           | WebLogic Admin Console                |
| 8080           | Other Apps on Docker                  |
| 9090           | ORDS                                  |
| 9502           | OAS Presentation service              |

1.  Go to *Networking >> Virtual Cloud Networks*
2.  Choose your network
3.  Under Resources, select Security Lists
4.  Click on Default Security Lists under the Create Security List button
5.  Click Add Ingress Rule button
6.  Enter the following:  
    - Source CIDR: 0.0.0.0/0
    - Destination Port Range: *Refer to above table*
7.  Click the Add Ingress Rules button

## Task 3: Setup Compute   
Using the details from the two steps above, proceed to the lab *Environment Setup* to setup your workshop environment using Oracle Resource Manager (ORM) and one of the following options:
  -  Create Stack:  *Compute + Networking*
  -  Create Stack:  *Compute only* with an existing VCN where security lists have been updated as per *Step 2* above

You may now [proceed to the next lab](#next).

## Acknowledgements

* **Author** - Rene Fontcha, Master Principal Solutions Architect, NA Technology
* **Contributors** - Kay Malcolm, Product Manager, Database Product Management
* **Last Updated By/Date** - Rene Fontcha, LiveLabs Platform Lead, NA Technology, October 2021
