# Teardown

## Introduction

In this lab, we will tear down the resources created on your development machine.

Estimated Time: 5 minutes

### Objectives

- Clean up workshop resources

### Prerequisites

- Have successfully completed the earlier labs

## **Task 1:** Delete the Workshop Resources

The following command stops the `oracledb` container, and then deletes it from your container runtime.

```bash
docker stop oracledb && docker rm oracledb
```

## Acknowledgements

- **Authors** - Anders Swanson, Developer Evangelist;
- **Contributors** - 
- **Last Updated By/Date** - Anders Swanson, Feb 2024
