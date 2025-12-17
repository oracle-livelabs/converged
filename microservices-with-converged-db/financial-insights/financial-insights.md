# Bank Account Statement and Portfolio Analysis

## Introduction



<br />


Goal: Generate a basic PDF report analyzing Oracle's recent stock data for a generic institutional client.


Flow:

Data Ingestion (RAG Agent focusing on Web Data):
- Action: The RAG Agent will be primarily focused on fetching the latest stock data directly (eg from Yahoo Finance) or True Cache. 

Basic Prompt-Driven Analysis (Analytic Agent):
- Action: The Analytic Agent will take the raw stock data fetched by the RAG Agent and analyze it based on a predefined prompt.
- Example Prompt: "Analyze the recent stock data for CompanyXYZ (XYZ) from Yahoo Finance. Identify key trends like the latest closing price, daily change, and any significant volume changes. Provide a brief summary of these observations."

Minimal Narrative Generation (Narrative Generation Agent - Basic PDF Output):
- Action: The Narrative Generation Agent will take the output of the Analytic Agent and generate a very basic PDF report.
- PDF Structure: The PDF will have a title (e.g., "XYZ Stock Analysis"), a section for the raw data (maybe a small table of the fetched information), and a section for the analysis summary provided by the Analytic Agent. Keep formatting extremely basic.

Elementary Output/Consumption (Personalization Agent - Very Basic):
- Action: The report will be geared towards a generic institutional client interested in high-level XYZ stock information. The "personalization" is simply focusing the analysis on Oracle.

Direct Delivery (Client Communication Agent - Packaging):
- Action: The output PDF from the Narrative Generation Agent will be the deliverable. "Packaging and delivery" is simply saving the PDF to a designated location.

Accuracy Check (Integrated into Analytic Agent):
- Action: Accuracy and Quality Assurance Agent's role is be very basic and likely integrated into the Analytic Agent. The prompt could include instructions for the Analytic Agent to double-check the fetched data (e.g., ensuring the date is current) and the analysis for logical consistency. A quick manual review is also recommended.

Agents and their Roles:
- RAG Agent: Fetch Oracle stock ticker data from Yahoo Finance (web).
- Data Ingestion Agents (One and Two): Their roles are merged into the RAG Agent for fetching web data. 
- Analytic Agent: Analyze the fetched stock data based on predefined prompt.
- Accuracy and Quality Assurance Agent: Basic checks integrated into the Analytic Agent and a quick manual review.
- Narrative Generation Agent: Generate a very basic PDF report with raw data and analysis summary.
- Personalization Agent: Focus analysis on Oracle for a generic institutional client (minimal personalization).
- Client Communication Agent: Save the generated PDF as the final deliverable.


[](youtube:qHVYXagpAC0?start=933)

*Watch the tutorial video above*

This lab demonstrates personal financial insights generation using Oracle Database Vector Search, AI agents, and Model Context Protocol (MCP). The application provides intelligent financial advisory services by leveraging multiple AI agents working together to analyze your financial situation.

The system allows you to ask questions about your financial situation, with the default query being "advise as to my financial situation." Behind the scenes, multiple specialized AI agents collaborate to provide comprehensive analysis: a planning agent acts as an investment assistant, research agents gather information from various sources, reasoning agents draw clear conclusions, and synthesis agents produce the final recommendations in various formats including text responses, PDF reports, APIs, and Jupyter notebooks.

The research agents are particularly sophisticated, gathering information from three distinct sources to provide well-rounded financial advice. First, they perform vector searches on compliance documents that have been vectorized as PDFs, providing regulatory compliance in all recommendations. Second, they access private financial data stored directly in your database - this includes all the transaction history you've generated throughout the other application modules, such as stock purchases, real estate investments from the Kafka examples, and other financial activities. Finally, they connect to an MCP server that streams real-time financial market information.

This multi-source approach creates a comprehensive view of your financial situation by combining regulatory guidelines, your personal transaction history, and current market conditions. The AI agents can then provide personalized investment advice that considers your actual spending patterns, investment preferences (such as your technology stock purchases), and real estate holdings, all while providing compliance with financial regulations.

The backend architecture demonstrates how Oracle's converged database platform seamlessly integrates vector search capabilities for unstructured document analysis with traditional transactional data, creating a unified foundation for AI-powered financial advisory services.

### Objectives

-  Understand AI Agents, MCP, and Oracle AI Database 26ai Vector Search, etc. capabilities


### Prerequisites

This lab only requires that you have completed the setup lab.

## Task 1: Build and deploy the service

Run `./build_and_deploy.sh` at [this location](https://github.com/paulparkinson/oracle-ai-for-sustainable-dev/tree/main/financial/graph-circular-payments).

You may now proceed to the next lab.

## Learn More

* [Oracle Database](https://bit.ly/mswsdatabase)
* https://www.oracle.com/artificial-intelligence/build-multiagent-rag-solutionon-oci/ https://github.com/oracle-devrel/devrel-labs/tree/update/agentic_rag
* https://blogs.oracle.com/developers/post/agentic-rag-enterprisescale-multiagent-ai-system-on-oracle-cloud-infrastructure
* [python-oracledb 3.0 Data Frames — a new way to query data](https://medium.com/oracledevs/python-oracledb-3-0-data-frames-a-new-way-to-query-data-4139418bef82)
* [Writing to Parquet and Delta Lake files from Oracle Database using Python](https://levelup.gitconnected.com/writing-to-parquet-and-delta-lake-files-from-oracle-database-using-python-5f7382bfcdc6)


## Acknowledgements
* **Authors** - Paul Parkinson, Architect and Developer Advocate
* **Last Updated By/Date** - Paul Parkinson, 2025

