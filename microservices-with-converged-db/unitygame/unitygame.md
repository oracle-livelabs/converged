# Build a video game using Unity, Kubernetes, and Oracle Database

## Introduction

This lab provides an example of a very different use case, a retro-themed video game. 

While the use case is different, it (re) uses the same Kubernetes, etc. setup cloud native architecture 
as well as all of the data types, patterns, etc. of the Oracle converged database.

The entire game, including various game assets and source code, are open source for you to study and re-use as you like.

### Objectives

-   Clone the `Pods of Kon` game repos.  
-   Follow the instructions in the repos to build and deploy the Unity frontend, Kubernetes backend, and Oracle Database.

### Prerequisites

This lab assumes you have already completed the setup lab (and optionally the deploy/walkthrough, and observability lab).


## Task 1: Make a Clone of the Pods Of Kon git repos

1. CD to your root or other directory * and make a clone from the GitHub repository using the following command.

      ```
      <copy>
      cd ~/ ; git clone https://github.com/paulparkinson/podsofkon.git
      </copy>
      ```
      You should now see the directory `podsofkon` in the directory that you created.
      * Note the `Pods Of Kon` game has options for the amount/level of integration starting with a very basic standalone implementation

2. Follow the directions in the `podsofkon/doc/build.md` file.

You may now proceed to the next lab.

## Learn More

* [Oracle Database](https://bit.ly/mswsdatabase)

## Acknowledgements
* **Authors** - Paul Parkinson, Architect and Developer Advocate
* **Last Updated By/Date** - Paul Parkinson, 2024

