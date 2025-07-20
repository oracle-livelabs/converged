# Fraud alerts on credit card purchase

## Introduction


[](youtube:qHVYXagpAC0?start=703)

*Watch the tutorial video above*

This lab focuses on money laundering detection using Oracle Database's graph capabilities. The application demonstrates how to identify suspicious circular payment patterns that may indicate money laundering activities through an intuitive visual interface.

The demonstration allows you to generate transactions dynamically and observe them rendered in real-time using the open-source Cytoscape library. As transactions accumulate over time, the graph visualization reveals circular patterns in the money flow - a key indicator of potential money laundering schemes. These circular patterns become apparent as the application processes more transactions, making it easy to spot suspicious activities that would be difficult to detect in traditional tabular data views.

The application showcases the simplicity of creating graph visualizations with Oracle Database. The Cytoscape integration provides powerful graph plotting capabilities for edges and nodes, while the underlying Oracle Graph database handles complex relationship queries efficiently. Developers can leverage multiple programming languages including SQL, Java, and PGX (Parallel Graph AnalytiX) to work with graph data, providing flexibility in how they implement graph analytics.

For deeper analysis, users can access the developer interface and navigate to Graph Studio, where they can explore various graph analysis prompts and execute sophisticated graph queries. This integration demonstrates how Oracle's converged database platform seamlessly combines transactional processing with advanced graph analytics, enabling financial institutions to detect complex fraud patterns without requiring separate specialized systems.

### Prerequisites

This lab only requires that you have completed the setup lab.

## Task 1: Build and deploy the service

Run `./build_and_deploy.sh` at [this location](https://github.com/paulparkinson/oracle-ai-for-sustainable-dev/tree/main/financial/graph-circular-payments).

1. Follow [Graph Studio: Find Circular Payment Chains with Graph Queries in Autonomous Database workshop](https://apexapps.oracle.com/pls/apex/r/dbpm/livelabs/run-workshop?p210_wid=770)

## Task 2: Run the application

1. Follow the steps in the README.md in `financial/circular-payments-graph` directory of the Github repos to add the graph and Jupyter notebook to your application


You may now proceed to the next lab.

## Learn More

* [Oracle Database](https://bit.ly/mswsdatabase)
* [Find Circular Payment Chains with Graph Queries in Autonomous Database](https://livelabs.oracle.com/pls/apex/r/dbpm/livelabs/run-workshop?p210_wid=770)
* [Certegy fights payment fraud with Oracle Cloud](https://www.oracle.com/customers/certegy/)

## Acknowledgements
* **Authors** - Paul Parkinson, Architect and Developer Advocate
* **Last Updated By/Date** - Paul Parkinson, 2025
